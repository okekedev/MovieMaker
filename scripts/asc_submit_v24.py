#!/usr/bin/env python3
"""Submit MovieMaker v2.4 for App Review.

Steps 5-8 of the playbook's submission flow (steps 1-4 already done during
build + metadata push).
"""
import json, sys, time, urllib.request, urllib.error
from pathlib import Path
import jwt

KEY_ID = "V8FBWK55MT"
ISSUER_ID = "196f43aa-4520-4178-a7df-68db3cf7ee76"
P8 = Path.home() / ".appstoreconnect" / "private_keys" / f"AuthKey_{KEY_ID}.p8"
API = "https://api.appstoreconnect.apple.com"

APP_ID = "6755254508"
VERSION_ID = "8b261d5e-1170-429a-8b28-aad76cd014aa"  # v2.4
BUILD_ID = "e7bdbab5-3aaa-497d-94aa-16f19e32a054"     # build 4

# Reviewer contact — carried over from MovieMaker v2.3 pattern.
CONTACT_FIRST = "Christian"
CONTACT_LAST = "Okeke"
CONTACT_PHONE = "+18325550100"
CONTACT_EMAIL = "christian@okeke.us"

REVIEW_NOTES = (
    "v2.4 changes:\n"
    "• Aspect ratio picker (16:9 / 1:1 / 9:16) for YouTube, Instagram, Reels/TikTok/Shorts.\n"
    "• Share sheet after export supports YouTube, TikTok, Reels via iOS share extensions.\n"
    "• Free tier reworked as a coin economy: new users get 1 coin at install, +2 more from a\n"
    "  guaranteed first Daily Spin (visible at launch on the home screen).\n"
    "  Every video export costs 1 coin.\n"
    "• New IAPs: two consumable coin packs (5 coins for $2.99, 15 coins for $6.99) and a new\n"
    "  yearly subscription ($29.99/yr) in the same group as the existing monthly ($7.99).\n"
    "  Subscribers get unlimited exports.\n"
    "• Daily Spin: slot-machine style, ~6% chance of +2, ~19% chance of +1, otherwise nothing.\n"
    "  First spin per Apple ID is guaranteed to win.\n"
    "\n"
    "To test the paywall on the reviewer device:\n"
    "  1. Open the app.\n"
    "  2. Tap the coin badge in the top-right corner.\n"
    "  3. The buy sheet shows both coin packs and both subscription tiers.\n"
    "\n"
    "No account required, no login, no age gate. Standard StoreKit purchase flow."
)


def token():
    now = int(time.time())
    return jwt.encode({"iss": ISSUER_ID, "iat": now, "exp": now + 900, "aud": "appstoreconnect-v1"},
                     P8.read_text(), algorithm="ES256", headers={"kid": KEY_ID, "typ": "JWT"})


def call(method, path, tok, body=None):
    url = f"{API}{path}"
    data = json.dumps(body).encode() if body is not None else None
    headers = {"Authorization": f"Bearer {tok}"}
    if body: headers["Content-Type"] = "application/json"
    req = urllib.request.Request(url, method=method, data=data, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            raw = r.read()
            return r.status, (json.loads(raw) if raw else {})
    except urllib.error.HTTPError as e:
        try: return e.code, json.loads(e.read())
        except: return e.code, {"raw": e.read().decode()[:500]}


def log(msg): print(f"  {msg}", flush=True)


def main():
    tok = token()
    print(f"Submitting Movie Maker v2.4 (version={VERSION_ID}, build={BUILD_ID})")

    # Step 5: Review details (contact info + notes).
    # PLAYBOOK LESSON: on update versions, reviewDetail is auto-created —
    # GET first, PATCH; only POST for first-version apps.
    print("\n[5] Review details (contact + notes)")
    code, resp = call("GET", f"/v1/appStoreVersions/{VERSION_ID}/appStoreReviewDetail", tok)
    if resp.get("data"):
        rd_id = resp["data"]["id"]
        code, resp = call("PATCH", f"/v1/appStoreReviewDetails/{rd_id}", tok, {
            "data": {
                "type": "appStoreReviewDetails",
                "id": rd_id,
                "attributes": {
                    "contactFirstName": CONTACT_FIRST,
                    "contactLastName": CONTACT_LAST,
                    "contactPhone": CONTACT_PHONE,
                    "contactEmail": CONTACT_EMAIL,
                    "notes": REVIEW_NOTES,
                },
            }
        })
        if code in (200, 204): log(f"✓ review detail patched (id={rd_id})")
        else: sys.exit(f"✗ patch failed HTTP {code} — {json.dumps(resp)[:400]}")
    else:
        code, resp = call("POST", "/v1/appStoreReviewDetails", tok, {
            "data": {
                "type": "appStoreReviewDetails",
                "attributes": {
                    "contactFirstName": CONTACT_FIRST,
                    "contactLastName": CONTACT_LAST,
                    "contactPhone": CONTACT_PHONE,
                    "contactEmail": CONTACT_EMAIL,
                    "notes": REVIEW_NOTES,
                },
                "relationships": {
                    "appStoreVersion": {"data": {"type": "appStoreVersions", "id": VERSION_ID}},
                },
            }
        })
        if code in (200, 201):
            rd_id = resp["data"]["id"]
            log(f"✓ review detail created (id={rd_id})")
        else:
            sys.exit(f"✗ create failed HTTP {code} — {json.dumps(resp)[:400]}")

    # Step 6: Create the reviewSubmission.
    print("\n[6] Create reviewSubmission")
    code, resp = call("POST", "/v1/reviewSubmissions", tok, {
        "data": {
            "type": "reviewSubmissions",
            "attributes": {"platform": "IOS"},
            "relationships": {"app": {"data": {"type": "apps", "id": APP_ID}}},
        }
    })
    if code in (200, 201):
        sub_id = resp["data"]["id"]
        log(f"✓ reviewSubmission created (id={sub_id})")
    else:
        sys.exit(f"✗ create failed HTTP {code} — {json.dumps(resp)[:500]}")

    # Step 7: Attach the appStoreVersion as a submission item.
    print("\n[7] Attach version to submission")
    code, resp = call("POST", "/v1/reviewSubmissionItems", tok, {
        "data": {
            "type": "reviewSubmissionItems",
            "relationships": {
                "reviewSubmission": {"data": {"type": "reviewSubmissions", "id": sub_id}},
                "appStoreVersion":  {"data": {"type": "appStoreVersions",  "id": VERSION_ID}},
            },
        }
    })
    if code in (200, 201): log("✓ version attached as submission item")
    else: sys.exit(f"✗ attach failed HTTP {code} — {json.dumps(resp)[:500]}")

    # Step 8: Submit.
    print("\n[8] Submit")
    code, resp = call("PATCH", f"/v1/reviewSubmissions/{sub_id}", tok, {
        "data": {
            "type": "reviewSubmissions",
            "id": sub_id,
            "attributes": {"submitted": True},
        }
    })
    if code in (200, 204): log(f"✓ SUBMITTED — reviewSubmission id={sub_id}")
    else: sys.exit(f"✗ submit failed HTTP {code} — {json.dumps(resp)[:500]}")

    # Confirm final state.
    print("\nFinal state:")
    code, ver = call("GET", f"/v1/appStoreVersions/{VERSION_ID}", tok)
    print(f"  v2.4: {ver['data']['attributes']['appStoreState']}")
    code, s = call("GET", f"/v1/reviewSubmissions/{sub_id}", tok)
    print(f"  submission: {s['data']['attributes'].get('state')}")
    print(f"  submission id: {sub_id}")
    print("\n🚀 v2.4 is now in Apple's review queue.")


if __name__ == "__main__":
    main()
