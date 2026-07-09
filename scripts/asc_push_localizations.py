#!/usr/bin/env python3
"""
Push the 17-locale ASC listing translations for Movie Maker.

READS the translated markdown files at
  ~/dev/MovieMaker/deployment/localization/strings_inventory_<locale>.md
PARSES each into a dict of translation keys.
ASSEMBLES the description from its ~30 sub-keys.
VALIDATES every hard character limit (subtitle 30, keywords 100, promo 170).
PUSHES to ASC via /v1/appStoreVersionLocalizations and /v1/appInfoLocalizations.

Usage:
  python3 asc_push_localizations.py --dry-run       # parse + validate + print
  python3 asc_push_localizations.py --execute       # actually POST/PATCH

Locale mapping:
  ASC uses IETF-style codes. Some of ours ("nb", "nl") need mapping to the
  ASC-canonical form ("no", "nl-NL"). Table below.

State handling:
  v2.4 is WAITING_FOR_REVIEW right now — locale creation on that state 409s.
  Once v2.4 is APPROVED, this script will target the appInfo tied to v2.5
  (a metadata-only version we'll create alongside). Do NOT run before v2.4
  APPROVED — you'll get errors and waste API calls.
"""
import argparse, json, re, sys, time, urllib.request, urllib.error
from pathlib import Path
import jwt

# ── Config ────────────────────────────────────────────────────────────

KEY_ID    = "V8FBWK55MT"
ISSUER_ID = "196f43aa-4520-4178-a7df-68db3cf7ee76"
P8        = Path.home() / ".appstoreconnect" / "private_keys" / f"AuthKey_{KEY_ID}.p8"
API       = "https://api.appstoreconnect.apple.com"
APP_ID    = "6755254508"
VERSION_ID = "8b261d5e-1170-429a-8b28-aad76cd014aa"  # v2.4 — will retarget if needed
LOCALIZATION_DIR = Path.home() / "dev/MovieMaker/deployment/localization"

# Map our inventory filenames → ASC locale codes.
LOCALE_MAP = {
    "ar":    "ar-SA",
    "bs":    "bs",
    "cs":    "cs",
    "de-DE": "de-DE",
    "es-MX": "es-MX",
    "fa":    "fa",       # some ASC accounts show "fa-IR"; try "fa" first
    "fr-FR": "fr-FR",
    "hr":    "hr",
    "it":    "it",
    "ja":    "ja",
    "ko":    "ko",
    "nb":    "no",       # ASC uses "no" for Norwegian
    "nl":    "nl-NL",
    "pt-BR": "pt-BR",
    "sv":    "sv",
    "tr":    "tr",
    "uz":    "uz",
}

CHAR_LIMITS = {
    "asc_app_name": 30,
    "asc_subtitle": 30,
    "asc_keywords": 100,
    "asc_promotional_text": 170,
}

# ── JWT + HTTP ────────────────────────────────────────────────────────

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
        except: return e.code, {"raw": e.read().decode()[:400]}


# ── Markdown parser ───────────────────────────────────────────────────

# The table rows come in two shapes depending on the section:
#   3-col: | `key` | translated | notes |
#   2-col: | `key` | translated |
# Match either.
TABLE_ROW = re.compile(r"^\|\s*`([^`]+)`\s*\|\s*(.*?)\s*\|(?:\s*(.*?)\s*\|)?\s*$")

def parse_locale_file(path: Path) -> dict:
    """Extract every key → translated value from the markdown tables."""
    out = {}
    for line in path.read_text().splitlines():
        m = TABLE_ROW.match(line)
        if not m: continue
        key = m.group(1)
        translated = m.group(2)
        out[key] = translated
    return out


# ── Description assembler ─────────────────────────────────────────────

def assemble_description(d: dict) -> str:
    """Reconstruct the full description text from the ~30 desc_* keys.

    Follows the same section structure as the English source at
    ~/dev/MovieMaker/deployment/metadata/description.txt.
    """
    def g(k): return d.get(k, "").strip()

    what_bullets = [g(f"desc_what_{k}") for k in ("merge","combine","trim","reorder","mute","export")]
    how_steps    = [g(f"desc_how_{i}") for i in (1,2,3)]
    perfect      = [g(f"desc_perfect_{k}") for k in ("travel","family","events","social","slideshow")]
    pro          = [g(f"desc_pro_{k}") for k in ("music","slowmo","longer","trial")]

    parts = [
        g("desc_headline"),
        "",
        g("desc_hook"),
        "",
        g("desc_section_what"),
        *[f"• {b}" for b in what_bullets if b],
        "",
        g("desc_section_how"),
        *[f"{i+1}. {s}" for i, s in enumerate(how_steps) if s],
        "",
        g("desc_section_perfect_for"),
        *[f"• {b}" for b in perfect if b],
        "",
        g("desc_section_pro"),
        *[f"• {b}" for b in pro if b],
        "",
        g("desc_section_privacy"),
        g("desc_privacy_body"),
        "",
        g("desc_privacy_url_line"),
        g("desc_terms_url_line"),
    ]
    return "\n".join(parts).strip()


# ── Validation ────────────────────────────────────────────────────────

def validate(locale: str, data: dict) -> list[str]:
    errors = []
    for key, limit in CHAR_LIMITS.items():
        v = data.get(key, "")
        if len(v) > limit:
            errors.append(f"  ! {locale} {key} = {len(v)}/{limit} chars (OVER)")
    desc = assemble_description(data)
    if len(desc) > 4000:
        errors.append(f"  ! {locale} description = {len(desc)}/4000 chars (OVER)")
    for k in ("asc_app_name", "asc_subtitle", "asc_keywords", "asc_promotional_text",
              "asc_whats_new", "desc_headline", "desc_hook"):
        if not data.get(k):
            errors.append(f"  ! {locale} MISSING required key: {k}")
    return errors


# ── ASC push ──────────────────────────────────────────────────────────

def upsert_version_localization(tok, version_id, asc_locale, data):
    """PATCH if the locale localization exists, else POST it."""
    # GET existing localizations for the version
    _, existing = call("GET", f"/v1/appStoreVersions/{version_id}/appStoreVersionLocalizations?limit=100", tok)
    match = next((l for l in existing.get("data", []) if l["attributes"]["locale"] == asc_locale), None)

    attrs = {
        "description":     assemble_description(data),
        "keywords":        data["asc_keywords"],
        "promotionalText": data["asc_promotional_text"],
        "whatsNew":        data["asc_whats_new"],
    }

    if match:
        loc_id = match["id"]
        body = {"data": {"type": "appStoreVersionLocalizations", "id": loc_id, "attributes": attrs}}
        code, resp = call("PATCH", f"/v1/appStoreVersionLocalizations/{loc_id}", tok, body)
        return "patched" if code in (200, 204) else f"patch failed {code}: {json.dumps(resp)[:200]}"

    body = {
        "data": {
            "type": "appStoreVersionLocalizations",
            "attributes": {**attrs, "locale": asc_locale},
            "relationships": {"appStoreVersion": {"data": {"type": "appStoreVersions", "id": version_id}}},
        }
    }
    code, resp = call("POST", "/v1/appStoreVersionLocalizations", tok, body)
    return "created" if code in (200, 201) else f"create failed {code}: {json.dumps(resp)[:200]}"


def upsert_app_info_localization(tok, app_id, asc_locale, data):
    """PATCH name+subtitle if an appInfoLocalization exists for this locale
    on the editable appInfo, else POST it."""
    _, infos = call("GET", f"/v1/apps/{app_id}/appInfos?limit=10", tok)
    editable_states = {"PREPARE_FOR_SUBMISSION", "READY_FOR_REVIEW", "WAITING_FOR_REVIEW",
                       "DEVELOPER_REJECTED", "REJECTED", "METADATA_REJECTED"}
    info = next((i for i in infos["data"] if i["attributes"].get("state") in editable_states), None)
    if not info:
        return f"skipped — no editable appInfo (states: {[i['attributes']['state'] for i in infos['data']]})"
    info_id = info["id"]

    _, locs = call("GET", f"/v1/appInfos/{info_id}/appInfoLocalizations?limit=100", tok)
    match = next((l for l in locs.get("data", []) if l["attributes"]["locale"] == asc_locale), None)
    attrs = {"name": data["asc_app_name"], "subtitle": data["asc_subtitle"]}

    if match:
        loc_id = match["id"]
        body = {"data": {"type": "appInfoLocalizations", "id": loc_id, "attributes": attrs}}
        code, resp = call("PATCH", f"/v1/appInfoLocalizations/{loc_id}", tok, body)
        return "patched" if code in (200, 204) else f"patch failed {code}: {json.dumps(resp)[:200]}"

    body = {
        "data": {
            "type": "appInfoLocalizations",
            "attributes": {**attrs, "locale": asc_locale},
            "relationships": {"appInfo": {"data": {"type": "appInfos", "id": info_id}}},
        }
    }
    code, resp = call("POST", "/v1/appInfoLocalizations", tok, body)
    return "created" if code in (200, 201) else f"create failed {code}: {json.dumps(resp)[:200]}"


# ── Main ──────────────────────────────────────────────────────────────

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true", help="parse + validate only, no API calls")
    ap.add_argument("--execute", action="store_true", help="actually push to ASC")
    ap.add_argument("--locale", help="only process this one locale (debug)")
    ap.add_argument("--version-id", default=VERSION_ID, help="target appStoreVersion id")
    args = ap.parse_args()

    if not args.dry_run and not args.execute:
        ap.error("must pass --dry-run or --execute")

    # Load and validate every locale file.
    locales = {}
    all_errors = []
    for src, asc in sorted(LOCALE_MAP.items()):
        if args.locale and src != args.locale: continue
        p = LOCALIZATION_DIR / f"strings_inventory_{src}.md"
        if not p.exists():
            all_errors.append(f"  ! {src}: file missing at {p}")
            continue
        data = parse_locale_file(p)
        errors = validate(src, data)
        all_errors.extend(errors)
        locales[src] = (asc, data)
        # Print quick stats
        print(f"  {src:>5} → {asc:>6}  keys={len(data):3}  "
              f"sub={len(data.get('asc_subtitle',''))}/30  "
              f"kw={len(data.get('asc_keywords',''))}/100  "
              f"promo={len(data.get('asc_promotional_text',''))}/170  "
              f"desc={len(assemble_description(data))}/4000")

    if all_errors:
        print("\nValidation errors:")
        for e in all_errors: print(e)
        if args.execute:
            sys.exit(1)
        print("\n(dry-run — continuing to summary despite errors)")

    print(f"\nParsed {len(locales)} locale(s).")

    if args.dry_run:
        print("Dry run complete. No API calls made.")
        return

    # ── EXECUTE ────────────────────────────────────────────────────────
    tok = token()
    print(f"\nPushing to appStoreVersion {args.version_id}...")

    for src, (asc, data) in sorted(locales.items()):
        vlr = upsert_version_localization(tok, args.version_id, asc, data)
        ilr = upsert_app_info_localization(tok, APP_ID, asc, data)
        print(f"  {src:>5} → {asc:>6}  version-loc: {vlr:<20}  app-info-loc: {ilr}")

    print("\nDone. Verify at appstoreconnect.apple.com → Movie Maker → App Store → each locale.")


if __name__ == "__main__":
    main()
