# Movie Maker — Bosnian (bs) Strings Inventory

**Locale:** `bs` — Bosnian (Bosnia and Herzegovina)
**RTL:** no
**Plural forms:** 3 (one: n mod 10 = 1 and n mod 100 != 11; few: n mod 10 = 2..4 and n mod 100 != 12..14; other) — Unicode CLDR `bs`

**Scope:** every user-visible string in Movie Maker v2.4, localized for Bosnian (Latin script, Bosnian standard).

**Brand terms kept in English:** Movie Maker, Pro, Reels, YouTube, TikTok, Shorts, Instagram, iPhone, iPad, Photos.

---

## MediaSelectionView.swift (home)

| Key | Bosnian | Notes |
|---|---|---|
| `media_home_title` | Movie Maker | Main title on empty home state |
| `media_home_cta` | Dodirni za odabir videa i fotografija | Helper text below pulse button |
| `media_header_back` | Nazad | Button to deselect all media |
| `media_header_spin` | Vrti | Daily spin button label |
| `media_section_title` | Odaberi svoje trenutke | Section headline when media selected |
| `media_section_subtitle` | Dodirni za uređivanje  \|  Drži za premještanje | Instruction text |
| `media_coin_balance_singular` | Preostao {count} novčić — 1 novčić po eksportu | count == 1 (one) |
| `media_coin_balance_paucal_2_4` | Preostala {count} novčića — 1 novčić po eksportu | count 2–4 (few) |
| `media_coin_balance_plural_5plus` | Preostalo {count} novčića — 1 novčić po eksportu | count 0, 5+ (other) |
| `media_grid_add_more` | Dodaj još | Button below media grid |
| `media_button_continue` | Nastavi | Primary CTA at bottom |
| `media_permission_alert_title` | Potreban pristup fotografijama | Alert title |
| `media_permission_alert_open_settings` | Otvori postavke | Alert button |
| `media_permission_alert_cancel` | Odustani | Alert cancel button |
| `media_permission_alert_message` | Molimo dozvoli Movie Makeru pristup videima i fotografijama u postavkama radi kreiranja kompilacija. | Alert message |

---

## SettingsView.swift (export options)

| Key | Bosnian | Notes |
|---|---|---|
| `settings_header_back` | Nazad | Back button |
| `settings_aspect_ratio_label` | Omjer slike | Section title |
| `settings_aspect_ratio_for_hint` | Za {platform} | Subtext |
| `settings_title_screen_label` | Naslovni ekran | Section title |
| `settings_title_required_label` | Naslov (obavezno) | Field label |
| `settings_title_placeholder` | Unesi naslov | TextField placeholder |
| `settings_subtitle_label` | Podnaslov (opcionalno) | Field label |
| `settings_subtitle_placeholder` | Unesi podnaslov | TextField placeholder |
| `settings_title_screen_hint` | Bijeli tekst na crnoj pozadini • 3 sekunde | Instruction/note |
| `settings_title_screen_no_title` | Bez naslova | Status when title empty |
| `settings_transition_style_label` | Stil prijelaza | Section title |
| `settings_transition_color_label` | Boja prijelaza | ColorPicker label |
| `settings_photo_duration_label` | Trajanje fotografije | Section title |
| `settings_photo_duration_value` | {value} s | Duration picker |
| `settings_background_music_label` | Pozadinska muzika | Section title |
| `settings_music_select_button` | Odaberi muziku | Button to open music picker |
| `settings_music_volume_label` | Jačina zvuka | Slider label |
| `settings_music_volume_percentage` | {value} % | Volume display |
| `settings_music_background_only_toggle` | Samo pozadinska muzika | Toggle label |
| `settings_music_remove_button` | Ukloni muziku | Button to clear selection |
| `settings_music_loop_hint` | Muzika će se ponavljati kroz cijeli video | Note about looping |
| `settings_music_none_indicator` | Nema | Status when no music |
| `settings_preview_section_label` | Pregled | Section title |
| `settings_preview_total_length` | Ukupno trajanje: {duration} | Formatted duration |
| `settings_preview_item_count_singular` | {count} stavka | count == 1 (one) |
| `settings_preview_item_count_paucal_2_4` | {count} stavke | count 2–4 (few) |
| `settings_preview_item_count_plural_5plus` | {count} stavki | count 0, 5+ (other) |
| `settings_create_button` | Kreiraj video | Primary button |
| `settings_warning_alert_title` | Upozorenje | Alert title for validation warnings |
| `settings_warning_long_videos_singular` | Imaš 1 video duži od 5 minuta. Fajl može biti vrlo velik. | count == 1 (one) |
| `settings_warning_long_videos_paucal_2_4` | Imaš {count} videa duža od 5 minuta. Fajl može biti vrlo velik. | count 2–4 (few) |
| `settings_warning_long_videos_plural_5plus` | Imaš {count} videa dužih od 5 minuta. Fajl može biti vrlo velik. | count 0, 5+ (other) |
| `settings_warning_many_items_message` | Imaš {count} stavki. Kreiranje može trajati nekoliko minuta. | Warning about many items |
| `settings_warning_create_anyway` | Ipak kreiraj | Alert button to proceed |
| `settings_warning_cancel` | Odustani | Alert cancel button |
| `settings_pro_badge` | PRO | Pro tier badge |
| `settings_duration_min_sec` | {minutes} min {seconds} s | Duration format for minutes > 0 |
| `settings_duration_sec_only` | {seconds} s | Duration format for < 1 min |

---

## VideoCreationView.swift (export progress)

| Key | Bosnian | Notes |
|---|---|---|
| `video_creation_title` | Kreiramo tvoj video… | Main title during export |
| `video_creation_status_preparing` | Priprema… | Initial status |
| `video_creation_status_adding` | Dodavanje videa… | Progress status (early) |
| `video_creation_status_composing` | Slaganje videa… | Progress status (mid) |
| `video_creation_status_almost_done` | Skoro gotovo… | Progress status (late) |
| `video_creation_status_saving` | Čuvanje u Photos… | Status during save |
| `video_creation_helper_text` | Možeš zatvoriti aplikaciju — obavijestit ćemo te kad bude spremno | Reassurance text |
| `video_creation_error_alert_title` | Greška | Alert title |
| `video_creation_error_alert_ok` | U redu | Error alert button |

---

## CompletionView.swift (success screen)

| Key | Bosnian | Notes |
|---|---|---|
| `completion_title` | Video je kreiran! | Success title |
| `completion_subtitle` | Tvoj video je sačuvan u tvoje fotografije. | Confirmation text |
| `completion_button_share` | Podijeli video | Share sheet button |
| `completion_button_open_photos` | Otvori Photos | Button to open Photos app |
| `completion_button_create_another` | Kreiraj novi video | Button to reset and start over |

---

## PaywallView.swift (buy sheet)

| Key | Bosnian | Notes |
|---|---|---|
| `paywall_hero_unlimited` | Neograničeno | Pro badge on hero |
| `paywall_hero_current_coins_label` | Trenutni novčići: | Free-tier label |
| `paywall_hero_coin_ratio` | 1 novčić = 1 video | Explanation of coin model |
| `paywall_feature_music_title` | Pozadinska muzika | Feature row |
| `paywall_feature_music_desc` | Dodaj vlastiti soundtrack | |
| `paywall_feature_slowmo_title` | Usporeni snimak | Feature row |
| `paywall_feature_slowmo_desc` | Filmski usporeni snimak na bilo kojem klipu | |
| `paywall_feature_watermark_title` | Bez vodenog žiga | Feature row |
| `paywall_feature_watermark_desc` | Eksport u punom kvalitetu | |
| `paywall_coins_section_title` | Kupi novčiće | Section header |
| `paywall_coins_tier_label` | {count} novčića | Tier button |
| `paywall_coins_tag_best_value` | Najbolja vrijednost | Badge on 15-coin tier |
| `paywall_subscription_section_title` | Ili idi na neograničeno | Section header |
| `paywall_subscription_monthly_title` | Mjesečno | Subscription tier |
| `paywall_subscription_monthly_badge` | Ušteda 43 % | Discount badge |
| `paywall_subscription_yearly_title` | Godišnje | Subscription tier |
| `paywall_subscription_yearly_badge` | Ušteda 68 % | Discount badge |
| `paywall_subscription_monthly_price` | {price} / mjesec | |
| `paywall_subscription_yearly_price` | {price} / godina | |
| `paywall_restore_purchases` | Obnovi kupovine | Button |
| `paywall_link_privacy` | Privatnost | Link label |
| `paywall_link_terms` | Uvjeti | Link label |
| `paywall_link_support` | Podrška | Link label |
| `paywall_not_now_button` | Ne sada | Dismiss button |
| `paywall_products_error_title` | Nije moguće učitati proizvode | Error state |
| `paywall_products_error_retry` | Pokušaj ponovo | Retry button |
| `paywall_purchase_error_title` | Greška pri kupovini | Alert title |
| `paywall_purchase_error_message` | Nije moguće završiti kupovinu. Molimo pokušaj ponovo. | Error message |
| `paywall_purchase_error_ok` | U redu | Alert button |
| `paywall_trial_badge` | Besplatna probna verzija od {days} dana | Trial offer badge |

---

## DailySpinView.swift (slot machine)

| Key | Bosnian | Notes |
|---|---|---|
| `spin_title` | Dnevno okretanje | Screen title |
| `spin_subtitle_closed` | Vrati se sutra za novo okretanje | Status when spin unavailable |
| `spin_rule_hint` | 3 🪙 = jackpot · 2 🪙 = nagrada | Rules hint below title |
| `spin_result_win_singular` | Osvojio si +1 novčić! | count == 1 (one) |
| `spin_result_win_paucal_2_4` | Osvojio si +{count} novčića! | count 2–4 (few) |
| `spin_result_win_plural_5plus` | Osvojio si +{count} novčića! | count 0, 5+ (other) |
| `spin_subtitle_lose` | Skoro! Pokušaj ponovo sutra | Lose message |
| `spin_status_rolling` | Okreće se… | Status while spinning |
| `spin_button_spin` | Vrti | Primary button |
| `spin_button_awesome` | Odlično | After a win |
| `spin_button_continue` | Nastavi | After a lose |
| `spin_button_close` | Zatvori | Bottom close button |

---

## TrimmingView.swift

| Key | Bosnian | Notes |
|---|---|---|
| `trimming_video_loading` | Učitavanje videa… | Loading indicator |
| `trimming_toggle_slowmo` | Uključi usporeni snimak | Toggle label |
| `trimming_toggle_mute` | Utišaj video | Toggle label |
| `trimming_pro_badge` | PRO | Pro feature badge |
| `trimming_time_start` | Početak: {time} | Trim start time display |
| `trimming_time_end` | Kraj: {time} | Trim end time display |
| `trimming_button_done` | Gotovo | Save trim + close |

---

## AppConfigurationView.swift

| Key | Bosnian | Notes |
|---|---|---|
| `app_config_title` | Postavke aplikacije | Modal title |

---

## NotificationManager.swift

| Key | Bosnian | Notes |
|---|---|---|
| `notification_video_ready_title` | Video kompilacija je spremna! | Local push title |
| `notification_video_ready_body` | Tvoj video je sačuvan u Photos | Local push body |

---

## Info.plist (bundle metadata)

| Key | Bosnian | Limit | Notes |
|---|---|---|---|
| `bundle_display_name` | Movie Maker | 30 | `CFBundleDisplayName` — brand |
| `plist_photo_library_add_usage` | Trebamo dozvolu da tvoj video sačuvamo u Photos | ≤100 | 49 chars |
| `plist_photo_library_usage` | Trebamo pristup videima i fotografijama za kreiranje kompilacija | ≤100 | 65 chars |

---

## App Store Connect Listing

| Key | Bosnian | Limit | Notes |
|---|---|---|---|
| `asc_app_name` | Movie Maker - Reels & YouTube | 30 | Brand-consistent (29 chars) |
| `asc_subtitle` | Video za TikTok Reels Shorts | 30 | 28 chars |
| `asc_keywords` | spajanje,rezanje,videa,slike,muzika,kolaž,montaža,slajdšou,klipovi,editor,uređivanje,film | 100 | Re-targeted for BiH search (97 chars) |
| `asc_promotional_text` | Spoji videa, slike i muziku u jedan čisti film. Kombiniraj snimke, izreži, presloži, dodaj muziku i eksportuj — bez složene vremenske ose. | 170 | 139 chars |
| `asc_whats_new` | Sada eksportuj u savršenoj veličini za svaku platformu. Odaberi 16:9 za YouTube, 9:16 za Reels i TikTok, ili 1:1 za Instagram — i dijeli direktno iz aplikacije.\n\nBesplatna verzija je opuštenija: 3 puna eksporta, bez vodenog žiga, bez ograničenja stavki. Nakon toga dopuni novčićima ili idi na Pro mjesečno ili godišnje. | 4000 | v2.4 release notes |
| `asc_description` | *(vidi Description structure sekciju)* | 4000 | |

### Description structure

| Section | Bosnian |
|---|---|
| `desc_headline` | Spoji videa, slike i muziku u jedan čisti film — bez složene vremenske ose. |
| `desc_hook` | Movie Maker je najbrži način da spojiš snimke, dodaš soundtrack i eksportuješ u galeriju. Samo povuci, izreži i gotovo. |
| `desc_section_what` | ŠTA MOŽEŠ RADITI |
| `desc_what_merge` | Spoji videa iz svoje biblioteke u jedan film — koliko god klipova želiš. |
| `desc_what_combine` | Kombiniraj videa i slike u bilo kojem redoslijedu i napravi slajdšou s pokretom. |
| `desc_what_trim` | Izreži početak i kraj svakog klipa da ostanu samo najbolji trenuci. |
| `desc_what_reorder` | Povuci i presloži scene dok priča ne izgleda kako treba. |
| `desc_what_mute` | Utišaj zvuk klipa kad želiš tihi montažni rez ili samo muziku. |
| `desc_what_export` | Eksportuj nazad u Photos za par sekundi, spremno za dijeljenje. |
| `desc_section_how` | KAKO FUNKCIONIŠE |
| `desc_how_1` | Odaberi klipove i slike iz svoje biblioteke. |
| `desc_how_2` | Presloži, izreži i utišaj po potrebi. |
| `desc_how_3` | Dodaj muziku i eksportuj. |
| `desc_section_perfect_for` | SAVRŠENO ZA |
| `desc_perfect_travel` | Putopise i najbolje trenutke s odmora |
| `desc_perfect_family` | Porodične trenutke i rođendanske kompilacije |
| `desc_perfect_events` | Sažetke svadbi, žurki i utakmica |
| `desc_perfect_social` | Objave za Instagram, TikTok i YouTube Shorts |
| `desc_perfect_slideshow` | Brze slajdšou od fotografisanja |
| `desc_section_pro` | PRO OPCIJE (OPCIONALNO) |
| `desc_pro_music` | Biblioteka pozadinske muzike za dorađene soundtrackove |
| `desc_pro_slowmo` | Usporeni snimak na ključnim trenucima |
| `desc_pro_longer` | Duži projekti s više klipova i slika |
| `desc_pro_trial` | Isprobaj Pro besplatno prije pretplate — uvjeti su jasno prikazani u aplikaciji. |
| `desc_section_privacy` | PRIVATNOST NA PRVOM MJESTU |
| `desc_privacy_body` | Uređivanje se dešava potpuno na tvom uređaju. Tvoji mediji ostaju u tvojoj biblioteci. Ništa se nigdje ne prenosi osim ako ne odlučiš dijeliti. |
| `desc_privacy_url_line` | Politika privatnosti: https://okekedev.github.io/MovieMaker/privacy.html |
| `desc_terms_url_line` | Uvjeti korištenja: https://okekedev.github.io/MovieMaker/terms.html |

---

## Translation notes (Bosnian)

- Bosnian uses same CLDR plural rule set as Croatian/Serbian (`one/few/other`); extra rows added for coin balance, item count, long-video warning, and spin win.
- Bosnian-specific vocabulary differentiators vs Croatian: `muzika` (music, not `glazba`), `sačuvano` (saved, not `spremljeno`), `porodica` (family, not `obitelj`), `slika` (image), `dešavati se`, `nazad` (not `natrag`), `slajdšou` phonetic transliteration is common. Bosnia-Herzegovina standard accepts many Turkish/Ottoman-era loans; kept `soundtrack` as accepted media term.
- "Photos" preserved as Apple brand.
- Keywords use bs-standard terms: `muzika`, `slajdšou`, `montaža`, `kolaž`, `film`. `slike` chosen over `fotke` for search parity.
- Used `dorađene` (refined) in `desc_pro_music`.
