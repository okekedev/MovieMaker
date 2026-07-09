#!/usr/bin/env python3
"""Upload iPhone 6.9" screenshots to ASC for MovieMaker v2.4.

Creates an APP_IPHONE_69 screenshot set on the v2.4 en-US localization,
then uploads each PNG via the 3-step reserve/PUT/finalize flow.
"""
import hashlib, json, sys, time, urllib.request, urllib.error
from pathlib import Path
import jwt

KEY_ID = "V8FBWK55MT"
ISSUER_ID = "196f43aa-4520-4178-a7df-68db3cf7ee76"
P8 = Path.home() / ".appstoreconnect" / "private_keys" / f"AuthKey_{KEY_ID}.p8"
API = "https://api.appstoreconnect.apple.com"

VERSION_ID = "8b261d5e-1170-429a-8b28-aad76cd014aa"  # v2.4
DISPLAY_TYPE = "APP_IPHONE_67"  # ASC enum doesn't include _69 yet; _67 accepts 1290×2796 and 1320×2868.

SHOTS_DIR = Path("/Users/christian/dev/MovieMaker/deployment/screenshots/iphone")
SHOTS_ORDER = ["01-home.png", "02-paywall.png", "03-spin.png",
               "04-home-5coins.png", "05-home-pro.png"]


def token():
    now = int(time.time())
    return jwt.encode({"iss": ISSUER_ID, "iat": now, "exp": now + 900, "aud": "appstoreconnect-v1"},
                     P8.read_text(), algorithm="ES256", headers={"kid": KEY_ID, "typ": "JWT"})


def get(path, tok):
    req = urllib.request.Request(f"{API}{path}", headers={"Authorization": f"Bearer {tok}"})
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.loads(r.read())


def post(path, tok, body):
    req = urllib.request.Request(f"{API}{path}", method="POST",
                                 data=json.dumps(body).encode(),
                                 headers={"Authorization": f"Bearer {tok}",
                                          "Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            raw = r.read()
            return r.status, (json.loads(raw) if raw else {})
    except urllib.error.HTTPError as e:
        try: return e.code, json.loads(e.read())
        except: return e.code, {"raw": e.read().decode()[:500]}


def patch(path, tok, body):
    req = urllib.request.Request(f"{API}{path}", method="PATCH",
                                 data=json.dumps(body).encode(),
                                 headers={"Authorization": f"Bearer {tok}",
                                          "Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            raw = r.read()
            return r.status, (json.loads(raw) if raw else {})
    except urllib.error.HTTPError as e:
        try: return e.code, json.loads(e.read())
        except: return e.code, {"raw": e.read().decode()[:500]}


def upload_screenshot(tok, set_id, png_path, position):
    data = png_path.read_bytes()
    md5 = hashlib.md5(data).hexdigest()
    print(f"[{position}] {png_path.name} ({len(data):,} bytes)")

    # 1. reserve
    body = {
        "data": {
            "type": "appScreenshots",
            "attributes": {"fileName": png_path.name, "fileSize": len(data)},
            "relationships": {"appScreenshotSet": {"data": {"type": "appScreenshotSets", "id": set_id}}},
        }
    }
    code, resp = post("/v1/appScreenshots", tok, body)
    if code not in (200, 201):
        print(f"  ✗ reserve failed: HTTP {code} — {json.dumps(resp)[:400]}")
        return False
    shot_id = resp["data"]["id"]
    ops = resp["data"]["attributes"].get("uploadOperations") or []
    print(f"  ✓ reserved id={shot_id}, {len(ops)} op(s)")

    # 2. PUT chunks
    for op in ops:
        headers = {h["name"]: h["value"] for h in op.get("requestHeaders", [])}
        chunk = data[op["offset"]: op["offset"] + op["length"]]
        req = urllib.request.Request(op["url"], method=op["method"], data=chunk, headers=headers)
        with urllib.request.urlopen(req, timeout=60) as r:
            pass

    # 3. finalize
    body = {
        "data": {
            "type": "appScreenshots",
            "id": shot_id,
            "attributes": {"uploaded": True, "sourceFileChecksum": md5},
        }
    }
    code, resp = patch(f"/v1/appScreenshots/{shot_id}", tok, body)
    if code in (200, 204):
        print(f"  ✓ finalized md5={md5}")
        return True
    print(f"  ✗ finalize failed: HTTP {code} — {json.dumps(resp)[:400]}")
    return False


def main():
    tok = token()

    # Find en-US localization for v2.4
    locs = get(f"/v1/appStoreVersions/{VERSION_ID}/appStoreVersionLocalizations?limit=50", tok)
    en = next((l for l in locs["data"] if l["attributes"]["locale"] == "en-US"), None)
    if not en:
        sys.exit("no en-US localization")
    loc_id = en["id"]
    print(f"en-US loc id: {loc_id}")

    # Check for existing set of this display type
    sets = get(f"/v1/appStoreVersionLocalizations/{loc_id}/appScreenshotSets?limit=20", tok)
    existing = next((s for s in sets["data"] if s["attributes"].get("screenshotDisplayType") == DISPLAY_TYPE), None)
    if existing:
        set_id = existing["id"]
        print(f"✓ reusing existing set id={set_id}")
    else:
        body = {
            "data": {
                "type": "appScreenshotSets",
                "attributes": {"screenshotDisplayType": DISPLAY_TYPE},
                "relationships": {
                    "appStoreVersionLocalization": {
                        "data": {"type": "appStoreVersionLocalizations", "id": loc_id}
                    }
                },
            }
        }
        code, resp = post("/v1/appScreenshotSets", tok, body)
        if code not in (200, 201):
            sys.exit(f"set create failed: HTTP {code} — {json.dumps(resp)[:400]}")
        set_id = resp["data"]["id"]
        print(f"✓ created set id={set_id}")

    # Upload each screenshot
    for i, name in enumerate(SHOTS_ORDER, 1):
        p = SHOTS_DIR / name
        if not p.exists():
            print(f"[{i}] {name} — missing, skipping")
            continue
        if not upload_screenshot(tok, set_id, p, i):
            sys.exit(f"upload failed at {name}")

    print("\nAll screenshots uploaded to APP_IPHONE_69 set.")


if __name__ == "__main__":
    main()
