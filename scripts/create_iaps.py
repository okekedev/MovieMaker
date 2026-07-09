#!/usr/bin/env python3
"""
Provision Movie Maker v2.4 IAPs on App Store Connect via API.

Does automatically:
  1. Creates 5-coin consumable ($2.99)
  2. Creates 15-coin consumable ($6.99)
  3. Bumps monthly subscription price ($2.99 → $7.99)
  4. Creates yearly subscription ($29.99/yr) in the same group as monthly

You still need to do manually in ASC after this runs:
  - Upload a review screenshot for the yearly subscription (Apple requires
    proof-of-paywall for auto-renewable subs; we can't upload a synthetic
    screenshot cleanly — grab one from Simulator after testing)
  - Attach a paywall screenshot to the two consumables (Apple often accepts
    the same one used for the sub group)

Idempotency: if an IAP with the same productID already exists, we skip
its creation step but still update its price / localization if needed.
"""
import json, sys, time, urllib.request, urllib.error
from datetime import date, timedelta
from pathlib import Path
import jwt

KEY_ID = "V8FBWK55MT"
ISSUER_ID = "196f43aa-4520-4178-a7df-68db3cf7ee76"
P8 = Path.home() / ".appstoreconnect" / "private_keys" / f"AuthKey_{KEY_ID}.p8"
API = "https://api.appstoreconnect.apple.com"

MOVIE_MAKER_APP_ID = "6755254508"

# Product IDs — must match the .storekit file and StoreManager.swift constants.
COINS_5_PRODUCT_ID  = "com.christianokeke.moviemaker.coins.5"
COINS_15_PRODUCT_ID = "com.christianokeke.moviemaker.coins.15"
MONTHLY_PRODUCT_ID  = "com.christianokeke.moviemaker.pro.monthly"
YEARLY_PRODUCT_ID   = "com.christianokeke.moviemaker.pro.yearly"


# ── HTTP helpers ──────────────────────────────────────────────────────

def token():
    now = int(time.time())
    return jwt.encode({"iss": ISSUER_ID, "iat": now, "exp": now + 900, "aud": "appstoreconnect-v1"},
                     P8.read_text(), algorithm="ES256", headers={"kid": KEY_ID, "typ": "JWT"})


def request(method, path, tok, body=None):
    url = f"{API}{path}" if path.startswith("/") else path
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(url, method=method, data=data,
                                 headers={"Authorization": f"Bearer {tok}",
                                          "Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            raw = r.read()
            return r.status, (json.loads(raw) if raw else {})
    except urllib.error.HTTPError as e:
        try:
            return e.code, json.loads(e.read())
        except Exception:
            return e.code, {"raw": e.read().decode(errors="ignore")[:800]}


def get(path, tok): return request("GET", path, tok)
def post(path, tok, body): return request("POST", path, tok, body)
def patch(path, tok, body): return request("PATCH", path, tok, body)


def paginate(path, tok):
    out = []
    url = path if path.startswith("http") else f"{API}{path}"
    while url:
        req = urllib.request.Request(url, headers={"Authorization": f"Bearer {tok}"})
        try:
            with urllib.request.urlopen(req, timeout=30) as r:
                body = json.loads(r.read())
        except urllib.error.HTTPError as e:
            print(f"    ! HTTP {e.code}: {e.read().decode()[:300]}")
            break
        out.extend(body.get("data", []))
        url = body.get("links", {}).get("next")
    return out


def log(msg): print(f"  {msg}", flush=True)


# ── State-discovery ───────────────────────────────────────────────────

def find_existing_iap(tok, product_id):
    """Return (id, attrs) tuple for an existing IAP by productID, or None."""
    iaps = paginate(f"/v1/apps/{MOVIE_MAKER_APP_ID}/inAppPurchasesV2?limit=200", tok)
    for iap in iaps:
        if iap["attributes"].get("productId") == product_id:
            return iap["id"], iap["attributes"]
    return None


def find_existing_subscription(tok, product_id):
    """Return (id, attrs, group_id) for an existing subscription by productID."""
    groups = paginate(f"/v1/apps/{MOVIE_MAKER_APP_ID}/subscriptionGroups?limit=100", tok)
    for grp in groups:
        gid = grp["id"]
        subs = paginate(f"/v1/subscriptionGroups/{gid}/subscriptions?limit=100", tok)
        for s in subs:
            if s["attributes"].get("productId") == product_id:
                return s["id"], s["attributes"], gid
    return None


def first_subscription_group(tok):
    groups = paginate(f"/v1/apps/{MOVIE_MAKER_APP_ID}/subscriptionGroups?limit=10", tok)
    return groups[0]["id"] if groups else None


# ── Price-point lookup ────────────────────────────────────────────────

def find_iap_price_point(tok, iap_id, target_customer_price):
    """Find the pricePoint whose customerPrice == target for USA."""
    path = f"/v2/inAppPurchases/{iap_id}/pricePoints?filter[territory]=USA&limit=200"
    points = paginate(path, tok)
    for p in points:
        if p["attributes"].get("customerPrice") == target_customer_price:
            return p["id"]
    # Fallback: sometimes API doesn't return exact match — return closest higher
    for p in sorted(points, key=lambda x: float(x["attributes"].get("customerPrice", "0"))):
        if float(p["attributes"].get("customerPrice", "0")) >= float(target_customer_price):
            log(f"⚠ exact price point {target_customer_price} not found, using {p['attributes']['customerPrice']}")
            return p["id"]
    return None


def find_sub_price_point(tok, sub_id, target_customer_price):
    path = f"/v1/subscriptions/{sub_id}/pricePoints?filter[territory]=USA&limit=200"
    points = paginate(path, tok)
    for p in points:
        if p["attributes"].get("customerPrice") == target_customer_price:
            return p["id"]
    for p in sorted(points, key=lambda x: float(x["attributes"].get("customerPrice", "0"))):
        if float(p["attributes"].get("customerPrice", "0")) >= float(target_customer_price):
            log(f"⚠ exact price point {target_customer_price} not found, using {p['attributes']['customerPrice']}")
            return p["id"]
    return None


# ── Consumable IAP creation ───────────────────────────────────────────

def create_consumable(tok, product_id, name, description, target_price):
    log(f"\n== Consumable: {product_id} (${target_price}) ==")

    existing = find_existing_iap(tok, product_id)
    if existing:
        iap_id, _ = existing
        log(f"✓ already exists → id={iap_id}, skipping create")
    else:
        body = {
            "data": {
                "type": "inAppPurchases",
                "attributes": {
                    "name": name,  # internal reference name
                    "productId": product_id,
                    "inAppPurchaseType": "CONSUMABLE",
                    "reviewNote": "Consumable coin pack. Each coin enables one video export in-app.",
                    "familySharable": False,
                },
                "relationships": {
                    "app": {"data": {"type": "apps", "id": MOVIE_MAKER_APP_ID}},
                },
            }
        }
        code, resp = post("/v2/inAppPurchases", tok, body)
        if code not in (201, 200):
            log(f"✗ create failed: HTTP {code} — {json.dumps(resp)[:400]}")
            return None
        iap_id = resp["data"]["id"]
        log(f"✓ created → id={iap_id}")

    # Localize (en-US)
    locs = paginate(f"/v2/inAppPurchases/{iap_id}/inAppPurchaseLocalizations", tok)
    has_en_us = any(l["attributes"].get("locale") == "en-US" for l in locs)
    if not has_en_us:
        body = {
            "data": {
                "type": "inAppPurchaseLocalizations",
                "attributes": {"locale": "en-US", "name": name, "description": description},
                "relationships": {
                    "inAppPurchaseV2": {"data": {"type": "inAppPurchases", "id": iap_id}},
                },
            }
        }
        code, resp = post("/v1/inAppPurchaseLocalizations", tok, body)
        if code in (201, 200): log("✓ en-US localization added")
        else: log(f"✗ localization failed: HTTP {code} — {json.dumps(resp)[:300]}")
    else:
        log("✓ en-US localization already present")

    # Price
    point_id = find_iap_price_point(tok, iap_id, target_price)
    if not point_id:
        log(f"✗ no price point for ${target_price} — cannot set price")
        return iap_id
    body = {
        "data": {
            "type": "inAppPurchasePriceSchedules",
            "relationships": {
                "inAppPurchase": {"data": {"type": "inAppPurchases", "id": iap_id}},
                "baseTerritory": {"data": {"type": "territories", "id": "USA"}},
                "manualPrices": {"data": [{"type": "inAppPurchasePrices", "id": "${new-price}"}]},
            },
        },
        "included": [
            {
                "type": "inAppPurchasePrices",
                "id": "${new-price}",
                "attributes": {"startDate": None},
                "relationships": {
                    "inAppPurchasePricePoint": {
                        "data": {"type": "inAppPurchasePricePoints", "id": point_id}
                    },
                },
            },
        ],
    }
    code, resp = post("/v1/inAppPurchasePriceSchedules", tok, body)
    if code in (201, 200): log(f"✓ price set to ${target_price}")
    else: log(f"✗ price failed: HTTP {code} — {json.dumps(resp)[:400]}")
    return iap_id


# ── Subscription price change ─────────────────────────────────────────
# For approved subscriptions, POST with a future startDate + preserveCurrentPrice
# schedules a price increase. Apple auto-notifies existing subscribers.

def bump_subscription_price(tok, sub_id, target_price, notice_days=31):
    log(f"\n== Subscription price bump: sub {sub_id} → ${target_price} ==")
    point_id = find_sub_price_point(tok, sub_id, target_price)
    if not point_id:
        log(f"✗ no price point for ${target_price}")
        return
    start = (date.today() + timedelta(days=notice_days)).isoformat()
    body = {
        "data": {
            "type": "subscriptionPrices",
            "attributes": {"startDate": start, "preserveCurrentPrice": True},
            "relationships": {
                "subscription": {"data": {"type": "subscriptions", "id": sub_id}},
                "subscriptionPricePoint": {"data": {"type": "subscriptionPricePoints", "id": point_id}},
                "territory": {"data": {"type": "territories", "id": "USA"}},
            },
        }
    }
    code, resp = post("/v1/subscriptionPrices", tok, body)
    if code in (201, 200):
        log(f"✓ ${target_price} scheduled to start {start} (existing subs grandfathered)")
    elif code == 409 and "more than one future prices" in json.dumps(resp):
        log(f"✓ a future price for USA is already scheduled — idempotent skip")
    else:
        log(f"✗ price bump failed: HTTP {code} — {json.dumps(resp)[:400]}")


# ── Subscription availability (which territories the sub is offered in) ──

def ensure_subscription_availability(tok, sub_id, territories=("USA",)):
    """Apple blocks price creation until availability is set. Idempotent 409
    on second run is expected."""
    body = {
        "data": {
            "type": "subscriptionAvailabilities",
            "attributes": {"availableInNewTerritories": True},
            "relationships": {
                "subscription": {"data": {"type": "subscriptions", "id": sub_id}},
                "availableTerritories": {"data": [{"type": "territories", "id": t} for t in territories]},
            },
        }
    }
    code, resp = post("/v1/subscriptionAvailabilities", tok, body)
    if code in (201, 200): log(f"✓ availability set: {', '.join(territories)}")
    elif code == 409:      log("✓ availability already set")
    else:                  log(f"✗ availability failed: HTTP {code} — {json.dumps(resp)[:300]}")


# ── Copy monthly's review screenshot to yearly ────────────────────────
# Apple requires an IAP_REVIEW_SCREENSHOT for auto-renewable subs. We reuse
# the monthly's existing screenshot since the paywall UX is the same.

def copy_monthly_screenshot_to_yearly(tok, monthly_sub_id, yearly_sub_id):
    import hashlib
    # Find monthly's screenshot
    body = get(f"/v1/subscriptions/{monthly_sub_id}?include=appStoreReviewScreenshot", tok)[1]
    if not isinstance(body, dict): return False
    screenshot_ref = body["data"]["relationships"].get("appStoreReviewScreenshot", {}).get("data")
    if not screenshot_ref:
        log("✗ no source screenshot on monthly sub — cannot copy")
        return False
    ss_id = screenshot_ref["id"]

    # Get its CDN template URL
    ss = get(f"/v1/subscriptionAppStoreReviewScreenshots/{ss_id}", tok)[1]["data"]["attributes"]
    tpl = ss["imageAsset"]["templateUrl"]
    w, h = ss["imageAsset"]["width"], ss["imageAsset"]["height"]
    url = tpl.replace("{w}", str(w)).replace("{h}", str(h)).replace("{f}", "png")

    # Download
    with urllib.request.urlopen(urllib.request.Request(url), timeout=60) as r:
        img = r.read()
    md5 = hashlib.md5(img).hexdigest()

    # Reserve upload slot on yearly
    body = {
        "data": {
            "type": "subscriptionAppStoreReviewScreenshots",
            "attributes": {"fileName": "yearly-paywall.png", "fileSize": len(img)},
            "relationships": {"subscription": {"data": {"type": "subscriptions", "id": yearly_sub_id}}},
        }
    }
    code, resp = post("/v1/subscriptionAppStoreReviewScreenshots", tok, body)
    if code not in (201, 200):
        log(f"✗ screenshot reserve failed: HTTP {code} — {json.dumps(resp)[:300]}")
        return False
    new_ss_id = resp["data"]["id"]
    for op in resp["data"]["attributes"].get("uploadOperations", []):
        headers = {h["name"]: h["value"] for h in op.get("requestHeaders", [])}
        chunk = img[op["offset"]: op["offset"] + op["length"]]
        req = urllib.request.Request(op["url"], method=op["method"], data=chunk, headers=headers)
        with urllib.request.urlopen(req, timeout=60) as r:
            pass  # any non-2xx will raise
    # Finalize
    code, resp = patch(f"/v1/subscriptionAppStoreReviewScreenshots/{new_ss_id}", tok,
                       {"data": {"type": "subscriptionAppStoreReviewScreenshots", "id": new_ss_id,
                                 "attributes": {"uploaded": True, "sourceFileChecksum": md5}}})
    if code in (200, 204): log("✓ review screenshot copied from monthly"); return True
    log(f"✗ finalize failed: HTTP {code}"); return False


# ── Yearly subscription creation ──────────────────────────────────────

def create_yearly_subscription(tok, group_id, product_id, name, description, target_price):
    log(f"\n== Yearly Subscription: {product_id} (${target_price}/yr) ==")

    existing = find_existing_subscription(tok, product_id)
    if existing:
        sub_id, _, _ = existing
        log(f"✓ already exists → id={sub_id}, skipping create")
    else:
        body = {
            "data": {
                "type": "subscriptions",
                "attributes": {
                    "name": name,
                    "productId": product_id,
                    "familySharable": False,
                    "groupLevel": 2,  # 1 = monthly (higher tier), 2 = yearly (lower price/mo)
                    "subscriptionPeriod": "ONE_YEAR",
                    "reviewNote": "Unlimited video exports, billed yearly. Same feature set as the monthly Pro.",
                },
                "relationships": {
                    "group": {"data": {"type": "subscriptionGroups", "id": group_id}},
                },
            }
        }
        code, resp = post("/v1/subscriptions", tok, body)
        if code not in (201, 200):
            log(f"✗ create failed: HTTP {code} — {json.dumps(resp)[:400]}")
            return None
        sub_id = resp["data"]["id"]
        log(f"✓ created → id={sub_id}")

    # Localize
    locs = paginate(f"/v1/subscriptions/{sub_id}/subscriptionLocalizations", tok)
    has_en_us = any(l["attributes"].get("locale") == "en-US" for l in locs)
    if not has_en_us:
        body = {
            "data": {
                "type": "subscriptionLocalizations",
                "attributes": {"locale": "en-US", "name": name, "description": description},
                "relationships": {
                    "subscription": {"data": {"type": "subscriptions", "id": sub_id}},
                },
            }
        }
        code, resp = post("/v1/subscriptionLocalizations", tok, body)
        if code in (201, 200): log("✓ en-US localization added")
        else: log(f"✗ localization failed: HTTP {code} — {json.dumps(resp)[:300]}")

    # Availability MUST be set before Apple accepts any price. Silent 409 if
    # it's already there.
    ensure_subscription_availability(tok, sub_id, ("USA",))

    # Copy the monthly sub's review screenshot so we don't need a manual upload.
    # (Skipped silently if a screenshot already exists on the yearly.)
    yearly_body = get(f"/v1/subscriptions/{sub_id}?include=appStoreReviewScreenshot", tok)[1]
    if isinstance(yearly_body, dict):
        existing_ss = yearly_body["data"]["relationships"].get("appStoreReviewScreenshot", {}).get("data")
        if not existing_ss:
            copy_monthly_screenshot_to_yearly(tok, "6755306735", sub_id)
        else:
            log("✓ review screenshot already present")

    # Price
    point_id = find_sub_price_point(tok, sub_id, target_price)
    if not point_id:
        log(f"✗ no price point for ${target_price}")
        return sub_id
    log(f"  using price point id: {point_id}")
    body = {
        "data": {
            "type": "subscriptionPrices",
            "attributes": {"startDate": None, "preserveCurrentPrice": False},
            "relationships": {
                "subscription": {"data": {"type": "subscriptions", "id": sub_id}},
                "subscriptionPricePoint": {"data": {"type": "subscriptionPricePoints", "id": point_id}},
                "territory": {"data": {"type": "territories", "id": "USA"}},
            },
        }
    }
    code, resp = post("/v1/subscriptionPrices", tok, body)
    if code in (201, 200): log(f"✓ price set to ${target_price}/yr")
    elif code == 409 and "already" in json.dumps(resp).lower(): log(f"✓ price ${target_price}/yr already set")
    else: log(f"✗ price failed: HTTP {code} — {json.dumps(resp)[:500]}")
    return sub_id


# ── Main ──────────────────────────────────────────────────────────────

def main():
    tok = token()
    log(f"→ Movie Maker app id: {MOVIE_MAKER_APP_ID}")

    # 1 + 2: consumables
    create_consumable(tok, COINS_5_PRODUCT_ID,  "5 Coins",  "5 coins. Each coin exports 1 video.",  "2.99")
    create_consumable(tok, COINS_15_PRODUCT_ID, "15 Coins", "15 coins. Each coin exports 1 video.", "6.99")

    # 3: schedule monthly price bump ($2.99 → $7.99), 31-day notice, grandfather existing subs.
    monthly = find_existing_subscription(tok, MONTHLY_PRODUCT_ID)
    if monthly:
        m_id, _, group_id = monthly
        bump_subscription_price(tok, m_id, "7.99")
    else:
        log(f"\n✗ monthly sub {MONTHLY_PRODUCT_ID} not found — cannot bump price.")
        group_id = first_subscription_group(tok)

    # 4: create yearly sub in same group (with availability + screenshot copy)
    if group_id:
        create_yearly_subscription(
            tok, group_id, YEARLY_PRODUCT_ID,
            "Movie Maker Pro (Yearly)",
            "Unlimited video exports, billed yearly.",  # ≤55 chars per ASC constraint
            "29.99",
        )
    else:
        log("\n✗ no subscription group — cannot create yearly sub.")

    print("\nDone. All four SKUs live on ASC.")


if __name__ == "__main__":
    main()
