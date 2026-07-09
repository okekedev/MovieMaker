# Suspicious install activity report — Movie Maker

**Submit at:** https://developer.apple.com/contact/app-store/ → "Report a concern" → "Concerns about App Store data or installs"

**Subject:** Suspected fraudulent installs — Movie Maker (app ID 6755254508)

---

Hi Apple Team,

I'd like to report a pattern of suspicious install activity on my app **Movie Maker - Merge Videos** (Apple ID: 6755254508, bundle: com.christianokeke.moviemaker) that I believe may be inauthentic installs affecting my algorithm ranking signals.

## The pattern

On **2026-07-01 (single day)**, I received **32 downloads from Kuwait (KW territory)** — all iPhone, all product type `3F`, no promo codes.

This is anomalous for these reasons:

1. **My 30-day Kuwait baseline is 3 total downloads across all 9 of my apps.** All 3 were on different days (Jun 4, Jun 13, Jun 14), spread across different apps under the previous "Movie Maker - Video Editor" branding. A sudden 32-download burst from Kuwait to a single SKU is >10× the normal signal.

2. **No other of my 9 apps received any Kuwait downloads on 2026-07-01.** A legitimate Kuwaiti audience discovering my catalog would likely download 2+ apps; this looks tightly targeted at Movie Maker specifically.

3. **No marketing or ad campaign is active in Kuwait**, and no promo codes were used.

4. **The pattern correlates precisely with a ranking drop** for the keyword `merge videos` on my app (from position #28 on 2026-06-28 to #98 on 2026-07-03) — consistent with the algorithm demotion that would follow a burst of low-engagement installs.

## What I'd like

If Apple's fraud detection can confirm these 32 installs are inauthentic, please invalidate them from ranking signals. I'm not asking for revenue action (they were free installs); just for the ranking impact to be corrected.

## Evidence available

- Sales & Trends daily reports for the period 2026-06-01 through 2026-07-02 (already in my account)
- ApplyRA rank tracking history showing the correlated keyword drop
- Cross-app comparison confirming Kuwait has no other download activity

Happy to provide anything further. Thank you for looking into this.

Christian Okeke
christian@okeke.us
Team ID: TUG3BHLSM4

---

**Attachments to include on the form:**
- The `sales_daily.csv` slice for 2026-07-01 KW rows (see `~/dev/Apple Developer/app_metrics/sales_daily.csv`)
- Optional: screenshot of the ApplyRA rank chart for `merge videos` showing the crash timing
