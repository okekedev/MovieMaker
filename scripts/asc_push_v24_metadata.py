#!/usr/bin/env python3
"""
Push MovieMaker v2.4 metadata to App Store Connect via API.

Reads copy from deployment/metadata/*.txt, then:
  1. Creates the v2.4 appStoreVersion (or finds it if it already exists)
  2. PATCHes its en-US localization: keywords, whatsNew, description, promoText
  3. Finds the editable appInfo (auto-created when v2.4 was made) and
     PATCHes its en-US localization: name, subtitle

Idempotent: safe to re-run. Does NOT attach a build or submit for review;
those happen after the build is uploaded and locally-verified per the
Apple Developer playbook's rule about testing subs locally first.

Pattern adapted from ~/dev/LeaseAPR/scripts/asc_set_metadata.py.
"""
import json, sys, time, urllib.request, urllib.error
from pathlib import Path
import jwt

REPO = Path(__file__).parent.parent
META = REPO / "deployment" / "metadata"

KEY_ID    = "V8FBWK55MT"
ISSUER_ID = "196f43aa-4520-4178-a7df-68db3cf7ee76"
P8        = Path.home() / ".appstoreconnect" / "private_keys" / f"AuthKey_{KEY_ID}.p8"
API       = "https://api.appstoreconnect.apple.com"
APP_ID    = "6755254508"      # Movie Maker
NEW_VER   = "2.4"


def read(name):
    """Read a metadata file, strip trailing whitespace."""
    return (META / name).read_text().rstrip()


NAME        = read("app-store-title.txt")
SUBTITLE    = read("subtitle.txt")
KEYWORDS    = read("keywords.txt")
DESCRIPTION = read("description.txt")
PROMO       = read("promotional-text.txt")
WHATS_NEW   = read("whats-new.txt")


def token():
    now = int(time.time())
    return jwt.encode({"iss": ISSUER_ID, "iat": now, "exp": now + 900, "aud": "appstoreconnect-v1"},
                     P8.read_text(), algorithm="ES256", headers={"kid": KEY_ID, "typ": "JWT"})


def call(method, path, tok, body=None):
    url = f"{API}{path}"
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(url, method=method, data=data,
                                 headers={"Authorization": f"Bearer {tok}",
                                          **({"Content-Type": "application/json"} if body else {})})
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            raw = r.read()
            return json.loads(raw) if raw else {}
    except urllib.error.HTTPError as e:
        body_err = e.read().decode(errors="ignore")[:800]
        print(f"  ! HTTP {e.code} on {method} {path}", file=sys.stderr)
        print(f"    {body_err}", file=sys.stderr)
        raise


def log(msg): print(f"  {msg}", flush=True)


# ── STEP 1: Create or find v2.4 ────────────────────────────────────

def get_or_create_v24(tok):
    versions = call("GET", f"/v1/apps/{APP_ID}/appStoreVersions?limit=20", tok)
    for v in versions["data"]:
        if v["attributes"].get("versionString") == NEW_VER:
            log(f"✓ v{NEW_VER} already exists → id={v['id']}, state={v['attributes'].get('appStoreState')}")
            return v["id"]

    log(f"→ Creating v{NEW_VER}")
    body = {
        "data": {
            "type": "appStoreVersions",
            "attributes": {
                "platform": "IOS",
                "versionString": NEW_VER,
                "copyright": "2026 Christian Okeke",
                "releaseType": "AFTER_APPROVAL",
            },
            "relationships": {
                "app": {"data": {"type": "apps", "id": APP_ID}},
            },
        }
    }
    resp = call("POST", "/v1/appStoreVersions", tok, body)
    ver_id = resp["data"]["id"]
    log(f"✓ v{NEW_VER} created → id={ver_id}")
    return ver_id


# ── STEP 2: Patch en-US version localization ──────────────────────

def patch_version_localization(tok, version_id):
    locs = call("GET", f"/v1/appStoreVersions/{version_id}/appStoreVersionLocalizations?limit=50", tok)
    loc = next((l for l in locs["data"] if l["attributes"]["locale"] == "en-US"), None)
    if not loc:
        log("! no en-US version localization found")
        return
    loc_id = loc["id"]
    body = {
        "data": {
            "type": "appStoreVersionLocalizations",
            "id": loc_id,
            "attributes": {
                "description": DESCRIPTION,
                "keywords": KEYWORDS,
                "promotionalText": PROMO,
                "whatsNew": WHATS_NEW,
            },
        }
    }
    call("PATCH", f"/v1/appStoreVersionLocalizations/{loc_id}", tok, body)
    log(f"✓ version en-US: description ({len(DESCRIPTION)}), keywords ({len(KEYWORDS)}), whatsNew ({len(WHATS_NEW)}), promo ({len(PROMO)})")


# ── STEP 3: Patch app info localization (name + subtitle) ─────────

def patch_app_info_localization(tok):
    # Find the appInfo in an editable state. On update versions, Apple
    # auto-creates a new appInfo in PREPARE_FOR_SUBMISSION when the version
    # is created. Fallback: use whatever appInfo exists.
    infos = call("GET", f"/v1/apps/{APP_ID}/appInfos?limit=10", tok)
    editable_states = {"PREPARE_FOR_SUBMISSION", "WAITING_FOR_REVIEW",
                       "DEVELOPER_REJECTED", "REJECTED", "METADATA_REJECTED",
                       "REPLACED_WITH_NEW_INFO"}
    info = next((i for i in infos["data"] if i["attributes"].get("state") in editable_states), None)
    if not info:
        # Fall back to the READY_FOR_DISTRIBUTION one — read-only, but
        # PATCH may still succeed on an update version.
        info = infos["data"][0] if infos["data"] else None
    if not info:
        log("! no appInfo found — cannot set name/subtitle")
        return

    info_id = info["id"]
    info_state = info["attributes"].get("state")
    log(f"→ using appInfo id={info_id}, state={info_state}")

    locs = call("GET", f"/v1/appInfos/{info_id}/appInfoLocalizations?limit=50", tok)
    loc = next((l for l in locs["data"] if l["attributes"]["locale"] == "en-US"), None)
    if not loc:
        log("! no en-US appInfo localization found")
        return
    loc_id = loc["id"]

    body = {
        "data": {
            "type": "appInfoLocalizations",
            "id": loc_id,
            "attributes": {"name": NAME, "subtitle": SUBTITLE},
        }
    }
    call("PATCH", f"/v1/appInfoLocalizations/{loc_id}", tok, body)
    log(f"✓ appInfo en-US: name={NAME!r}, subtitle={SUBTITLE!r}")


def main():
    tok = token()
    log(f"MovieMaker → v{NEW_VER} metadata push")
    log(f"  name:     {NAME!r} ({len(NAME)} chars)")
    log(f"  subtitle: {SUBTITLE!r} ({len(SUBTITLE)} chars)")
    log(f"  keywords: {len(KEYWORDS)} chars")
    log(f"  whatsNew: {len(WHATS_NEW)} chars")
    log(f"  promo:    {len(PROMO)} chars")

    ver_id = get_or_create_v24(tok)
    patch_version_localization(tok, ver_id)
    patch_app_info_localization(tok)

    print("\nDone. v2.4 metadata is on ASC. Attach a build + submit when ready.")


if __name__ == "__main__":
    main()
