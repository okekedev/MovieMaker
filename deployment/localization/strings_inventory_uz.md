# Movie Maker — Uzbek (uz) Strings Inventory

**Locale:** `uz` — Uzbek (Uzbekistan), **Latin script** (Yangi Alifbo, post-1993)
**RTL:** no
**Plural forms:** 2 (one: n = 1; other: everything else) — Unicode CLDR `uz`

**Scope:** every user-visible string in Movie Maker v2.4, localized for Uzbek (Latin).

**Brand terms kept in English:** Movie Maker, Pro, Reels, YouTube, TikTok, Shorts, Instagram, iPhone, iPad, Photos.

---

## MediaSelectionView.swift (home)

| Key | Uzbek | Notes |
|---|---|---|
| `media_home_title` | Movie Maker | Main title on empty home state |
| `media_home_cta` | Video va rasm tanlash uchun bosing | Helper text below pulse button |
| `media_header_back` | Orqaga | Button to deselect all media |
| `media_header_spin` | Aylantirish | Daily spin button label |
| `media_section_title` | Lahzalaringizni tanlang | Section headline when media selected |
| `media_section_subtitle` | Tahrirlash uchun bosing  \|  Joyini oʻzgartirish uchun ushlab turing | Instruction text |
| `media_coin_balance_singular` | {count} tanga qoldi — har bir eksport 1 tanga | count == 1 (one) |
| `media_coin_balance_plural` | {count} tanga qoldi — har bir eksport 1 tanga | count != 1 (other) |
| `media_grid_add_more` | Yana qoʻshish | Button below media grid |
| `media_button_continue` | Davom etish | Primary CTA at bottom |
| `media_permission_alert_title` | Rasmlar uchun ruxsat kerak | Alert title |
| `media_permission_alert_open_settings` | Sozlamalarni ochish | Alert button |
| `media_permission_alert_cancel` | Bekor qilish | Alert cancel button |
| `media_permission_alert_message` | Videolar tuzish uchun Movie Maker'ga sozlamalardan video va rasmlarga ruxsat bering. | Alert message |

---

## SettingsView.swift (export options)

| Key | Uzbek | Notes |
|---|---|---|
| `settings_header_back` | Orqaga | Back button |
| `settings_aspect_ratio_label` | Nisbat (aspect ratio) | Section title |
| `settings_aspect_ratio_for_hint` | {platform} uchun | Subtext |
| `settings_title_screen_label` | Sarlavha ekrani | Section title |
| `settings_title_required_label` | Sarlavha (majburiy) | Field label |
| `settings_title_placeholder` | Sarlavhani kiriting | TextField placeholder |
| `settings_subtitle_label` | Kichik sarlavha (ixtiyoriy) | Field label |
| `settings_subtitle_placeholder` | Kichik sarlavhani kiriting | TextField placeholder |
| `settings_title_screen_hint` | Qora fonda oq matn • 3 soniya | Instruction/note |
| `settings_title_screen_no_title` | Sarlavha yoʻq | Status when title empty |
| `settings_transition_style_label` | Oʻtish uslubi | Section title |
| `settings_transition_color_label` | Oʻtish rangi | ColorPicker label |
| `settings_photo_duration_label` | Rasm davomiyligi | Section title |
| `settings_photo_duration_value` | {value} son. | Duration picker (soniya abbreviation) |
| `settings_background_music_label` | Fon musiqasi | Section title |
| `settings_music_select_button` | Musiqa tanlash | Button to open music picker |
| `settings_music_volume_label` | Tovush balandligi | Slider label |
| `settings_music_volume_percentage` | {value}% | Volume display |
| `settings_music_background_only_toggle` | Faqat fon musiqasi | Toggle label |
| `settings_music_remove_button` | Musiqani olib tashlash | Button to clear selection |
| `settings_music_loop_hint` | Musiqa video davomida takrorlanadi | Note about looping |
| `settings_music_none_indicator` | Yoʻq | Status when no music |
| `settings_preview_section_label` | Koʻrib chiqish | Section title |
| `settings_preview_total_length` | Umumiy davomiyligi: {duration} | Formatted duration |
| `settings_preview_item_count_singular` | {count} ta element | count == 1 (one) |
| `settings_preview_item_count_plural` | {count} ta element | count != 1 (other, identical structure) |
| `settings_create_button` | Video yaratish | Primary button |
| `settings_warning_alert_title` | Ogohlantirish | Alert title for validation warnings |
| `settings_warning_long_videos_singular` | Sizda 5 daqiqadan uzun 1 ta video bor. Fayl juda katta boʻlishi mumkin. | count == 1 (one) |
| `settings_warning_long_videos_plural` | Sizda 5 daqiqadan uzun {count} ta video bor. Fayl juda katta boʻlishi mumkin. | count != 1 (other) |
| `settings_warning_many_items_message` | Sizda {count} ta element bor. Yaratish bir necha daqiqa vaqt olishi mumkin. | Warning about many items |
| `settings_warning_create_anyway` | Baribir yaratish | Alert button to proceed |
| `settings_warning_cancel` | Bekor qilish | Alert cancel button |
| `settings_pro_badge` | PRO | Pro tier badge |
| `settings_duration_min_sec` | {minutes} daq. {seconds} son. | Duration format for minutes > 0 |
| `settings_duration_sec_only` | {seconds} son. | Duration format for < 1 min |

---

## VideoCreationView.swift (export progress)

| Key | Uzbek | Notes |
|---|---|---|
| `video_creation_title` | Videongiz yaratilmoqda… | Main title during export |
| `video_creation_status_preparing` | Tayyorlanmoqda… | Initial status |
| `video_creation_status_adding` | Videolar qoʻshilmoqda… | Progress status (early) |
| `video_creation_status_composing` | Video jamlanmoqda… | Progress status (mid) |
| `video_creation_status_almost_done` | Deyarli tayyor… | Progress status (late) |
| `video_creation_status_saving` | Photos'ga saqlanmoqda… | Status during save |
| `video_creation_helper_text` | Ilovani yopishingiz mumkin — tayyor boʻlganda xabar beramiz | Reassurance text |
| `video_creation_error_alert_title` | Xato | Alert title |
| `video_creation_error_alert_ok` | OK | Error alert button |

---

## CompletionView.swift (success screen)

| Key | Uzbek | Notes |
|---|---|---|
| `completion_title` | Video tayyor! | Success title |
| `completion_subtitle` | Videongiz rasmlaringizga saqlandi. | Confirmation text |
| `completion_button_share` | Video ulashish | Share sheet button |
| `completion_button_open_photos` | Photos'ni ochish | Button to open Photos app |
| `completion_button_create_another` | Yangi video yaratish | Button to reset and start over |

---

## PaywallView.swift (buy sheet)

| Key | Uzbek | Notes |
|---|---|---|
| `paywall_hero_unlimited` | Cheksiz | Pro badge on hero |
| `paywall_hero_current_coins_label` | Joriy tangalar: | Free-tier label |
| `paywall_hero_coin_ratio` | 1 tanga = 1 video | Explanation of coin model |
| `paywall_feature_music_title` | Fon musiqasi | Feature row |
| `paywall_feature_music_desc` | Oʻz soundtrack'ingizni qoʻshing | |
| `paywall_feature_slowmo_title` | Sekin harakat | Feature row |
| `paywall_feature_slowmo_desc` | Har qanday klipda kinodagi kabi sekin harakat | |
| `paywall_feature_watermark_title` | Suv belgisi yoʻq | Feature row |
| `paywall_feature_watermark_desc` | Toʻliq sifatda eksport | |
| `paywall_coins_section_title` | Tanga sotib olish | Section header |
| `paywall_coins_tier_label` | {count} tanga | Tier button |
| `paywall_coins_tag_best_value` | Eng foydali | Badge on 15-coin tier |
| `paywall_subscription_section_title` | Yoki cheksizga oʻting | Section header |
| `paywall_subscription_monthly_title` | Oylik | Subscription tier |
| `paywall_subscription_monthly_badge` | 43% tejang | Discount badge |
| `paywall_subscription_yearly_title` | Yillik | Subscription tier |
| `paywall_subscription_yearly_badge` | 68% tejang | Discount badge |
| `paywall_subscription_monthly_price` | {price} / oy | |
| `paywall_subscription_yearly_price` | {price} / yil | |
| `paywall_restore_purchases` | Xaridlarni tiklash | Button |
| `paywall_link_privacy` | Maxfiylik | Link label |
| `paywall_link_terms` | Shartlar | Link label |
| `paywall_link_support` | Yordam | Link label |
| `paywall_not_now_button` | Hozir emas | Dismiss button |
| `paywall_products_error_title` | Mahsulotlarni yuklab boʻlmadi | Error state |
| `paywall_products_error_retry` | Qayta urinish | Retry button |
| `paywall_purchase_error_title` | Xarid xatosi | Alert title |
| `paywall_purchase_error_message` | Xaridni yakunlab boʻlmadi. Iltimos, qayta urinib koʻring. | Error message |
| `paywall_purchase_error_ok` | OK | Alert button |
| `paywall_trial_badge` | {days} kunlik bepul sinov | Trial offer badge |

---

## DailySpinView.swift (slot machine)

| Key | Uzbek | Notes |
|---|---|---|
| `spin_title` | Kunlik aylantirish | Screen title |
| `spin_subtitle_closed` | Yana aylantirish uchun ertaga qayting | Status when spin unavailable |
| `spin_rule_hint` | 3 🪙 = jackpot · 2 🪙 = sovrin | Rules hint below title |
| `spin_result_win_singular` | +1 tanga yutdingiz! | count == 1 (one) |
| `spin_result_win_plural` | +{count} tanga yutdingiz! | count != 1 (other) |
| `spin_subtitle_lose` | Sal qoldi! Ertaga qayta urinib koʻring | Lose message |
| `spin_status_rolling` | Aylanmoqda… | Status while spinning |
| `spin_button_spin` | Aylantirish | Primary button |
| `spin_button_awesome` | Ajoyib | After a win |
| `spin_button_continue` | Davom etish | After a lose |
| `spin_button_close` | Yopish | Bottom close button |

---

## TrimmingView.swift

| Key | Uzbek | Notes |
|---|---|---|
| `trimming_video_loading` | Video yuklanmoqda… | Loading indicator |
| `trimming_toggle_slowmo` | Sekin harakatni yoqish | Toggle label |
| `trimming_toggle_mute` | Videoni ovozsiz qilish | Toggle label |
| `trimming_pro_badge` | PRO | Pro feature badge |
| `trimming_time_start` | Boshi: {time} | Trim start time display |
| `trimming_time_end` | Oxiri: {time} | Trim end time display |
| `trimming_button_done` | Tayyor | Save trim + close |

---

## AppConfigurationView.swift

| Key | Uzbek | Notes |
|---|---|---|
| `app_config_title` | Ilova sozlamalari | Modal title |

---

## NotificationManager.swift

| Key | Uzbek | Notes |
|---|---|---|
| `notification_video_ready_title` | Video jamlanmasi tayyor! | Local push title |
| `notification_video_ready_body` | Videongiz Photos'ga saqlandi | Local push body |

---

## Info.plist (bundle metadata)

| Key | Uzbek | Limit | Notes |
|---|---|---|---|
| `bundle_display_name` | Movie Maker | 30 | `CFBundleDisplayName` — brand |
| `plist_photo_library_add_usage` | Jamlangan videongizni Photos'ga saqlash uchun ruxsat kerak | ≤100 | 58 chars |
| `plist_photo_library_usage` | Video jamlash uchun video va rasmlaringizga kirish kerak | ≤100 | 56 chars |

---

## App Store Connect Listing

| Key | Uzbek | Limit | Notes |
|---|---|---|---|
| `asc_app_name` | Movie Maker - Reels & YouTube | 30 | Brand-consistent (29 chars) |
| `asc_subtitle` | Video: TikTok Reels Shorts | 30 | 26 chars (alt considered `TikTok Reels Shorts uchun video` = 31, over limit) |
| `asc_keywords` | video birlashtirish,montaj,kollaj,musiqa,rasm,slayd,klip,kesish,tahrir,redaktor,video qoʻshish | 100 | Re-targeted (97 chars) |
| `asc_promotional_text` | Video, rasm va musiqani bitta toza filmga birlashtiring. Kliplarni qoʻshing, kesing, tartiblang, musiqa qoʻshing va eksport qiling. | 170 | 130 chars |
| `asc_whats_new` | Endi har bir platforma uchun ideal oʻlchamda eksport qiling. YouTube uchun 16:9, Reels va TikTok uchun 9:16, Instagram uchun 1:1 tanlang — va toʻgʻridan-toʻgʻri ilovadan ulashing.\n\nBepul rejim yanada qulay: 3 ta toʻliq eksport, suv belgisi yoʻq, element cheklovi yoʻq. Keyin tangalar bilan toʻldiring yoki Pro'ning oylik yoki yillik obunasiga oʻting. | 4000 | v2.4 release notes |
| `asc_description` | *(Description structure boʻlimiga qarang)* | 4000 | |

### Description structure

| Section | Uzbek |
|---|---|
| `desc_headline` | Video, rasm va musiqani bitta toza filmga birlashtiring — murakkab vaqt chizigʻisiz. |
| `desc_hook` | Movie Maker — kliplarni birlashtirish, soundtrack qoʻshish va galereyaga eksport qilishning eng tez usuli. Faqat sudrang, keseng va tayyor. |
| `desc_section_what` | NIMA QILA OLASIZ |
| `desc_what_merge` | Kutubxonangizdagi videolarni bitta filmga birlashtiring — istagancha klip. |
| `desc_what_combine` | Video va rasmlarni istalgan tartibda birlashtirib, harakatli slayd shousi tuzing. |
| `desc_what_trim` | Har bir klipning boshi va oxirini keseng, faqat eng yaxshi lahzalar qoladi. |
| `desc_what_reorder` | Sahnalarni sudrab, hikoya oʻzingizga toʻgʻri kelguncha qayta tartiblang. |
| `desc_what_mute` | Sokin montaj yoki faqat musiqali soundtrack xohlaganda klip ovozini oʻchiring. |
| `desc_what_export` | Bir necha soniyada Photos'ga eksport qiling, ulashishga tayyor. |
| `desc_section_how` | QANDAY ISHLAYDI |
| `desc_how_1` | Kutubxonangizdan kliplar va rasmlarni tanlang. |
| `desc_how_2` | Kerak boʻlsa qayta tartiblang, keseng va ovozsiz qiling. |
| `desc_how_3` | Musiqa qoʻshing va eksport qiling. |
| `desc_section_perfect_for` | QUYIDAGILAR UCHUN IDEAL |
| `desc_perfect_travel` | Sayohat xulosalari va taʼtil eng yaxshi lahzalari |
| `desc_perfect_family` | Oilaviy lahzalar va tugʻilgan kun jamlanmalari |
| `desc_perfect_events` | Toʻy, bayram va oʻyinlar xulosalari |
| `desc_perfect_social` | Instagram, TikTok va YouTube Shorts uchun ijtimoiy postlar |
| `desc_perfect_slideshow` | Fotosessiya uchun tezkor slayd shoular |
| `desc_section_pro` | PRO IMKONIYATLARI (IXTIYORIY) |
| `desc_pro_music` | Sifatli soundtrack'lar uchun fon musiqasi kutubxonasi |
| `desc_pro_slowmo` | Muhim lahzalarda sekin harakat |
| `desc_pro_longer` | Koʻproq klip va rasmlar bilan uzunroq loyihalar |
| `desc_pro_trial` | Obuna boʻlishdan oldin Pro'ni bepul sinab koʻring — shartlar ilovada aniq koʻrsatilgan. |
| `desc_section_privacy` | MAXFIYLIK BIRINCHI OʻRINDA |
| `desc_privacy_body` | Tahrirlash toʻliq qurilmangizda amalga oshiriladi. Media faylllaringiz kutubxonangizda qoladi. Siz ulashishni tanlamasangiz, hech narsa hech qayerga yuklanmaydi. |
| `desc_privacy_url_line` | Maxfiylik siyosati: https://okekedev.github.io/MovieMaker/privacy.html |
| `desc_terms_url_line` | Foydalanish shartlari: https://okekedev.github.io/MovieMaker/terms.html |

---

## Translation notes (Uzbek)

- **Script:** Latin (Yangi Alifbo), not Cyrillic. Uses ISO Latin-Uzbek forms: `oʻ` (o with modifier apostrophe U+02BB), `gʻ` (g with modifier apostrophe), `sh`, `ch`, `ng`. This is the modern App Store standard for `uz`.
- Plural forms: 2 (one/other). Kept singular/plural key pairs for source-parity but the text is often identical because Uzbek uses the numeral itself to carry count; the classifier `ta` (element counter) works for both.
- Terminology:
  - `tanga` — coin (natural, used across gaming apps).
  - `eksport` (loanword) — kept as international tech term; `yuklab olish` would be download.
  - `soundtrack` — kept as international; native `ovozli fon` also possible but soundtrack is well-understood.
  - `kollaj`, `montaj`, `redaktor`, `tahrir`, `klip` — all standard tech loans used on Uzbek App Store and social media.
  - "Photos" — kept as brand.
- Subtitle: picked `Video: TikTok Reels Shorts` (26 chars) because the natural phrasing `TikTok Reels Shorts uchun video` came in at 31 — 1 char over the 30 limit. Reviewer may swap phrasing if a fitting alternative arises.
- Keywords: local phrasing `video birlashtirish` (video merging), `video qoʻshish` (video adding) reflects how Uzbek speakers query the store. Included `redaktor` (editor loanword) and native `tahrir`.
- Percentage format: `43%` (numeric leading) matches Uzbek convention.
- Duration abbreviations: `daq.` (daqiqa/minute), `son.` (soniya/second) — abbreviated to save space in tight UI slots.
