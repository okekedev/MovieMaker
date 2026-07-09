# Movie Maker — Croatian (hr) Strings Inventory

**Locale:** `hr` — Croatian (Croatia)
**RTL:** no
**Plural forms:** 3 (one: n mod 10 = 1 and n mod 100 != 11; few: n mod 10 = 2..4 and n mod 100 != 12..14; other) — Unicode CLDR `hr`

**Scope:** every user-visible string in Movie Maker v2.4, localized for Croatian (Zagreb standard).

**Brand terms kept in English:** Movie Maker, Pro, Reels, YouTube, TikTok, Shorts, Instagram, iPhone, iPad, Photos.

---

## MediaSelectionView.swift (home)

| Key | Croatian | Notes |
|---|---|---|
| `media_home_title` | Movie Maker | Main title on empty home state |
| `media_home_cta` | Dodirni za odabir videa i fotografija | Helper text below pulse button |
| `media_header_back` | Natrag | Button to deselect all media |
| `media_header_spin` | Vrti | Daily spin button label |
| `media_section_title` | Odaberi svoje trenutke | Section headline when media selected |
| `media_section_subtitle` | Dodirni za uređivanje  \|  Drži za premještanje | Instruction text |
| `media_coin_balance_singular` | Preostao {count} novčić — 1 novčić po izvozu | count == 1 (one) |
| `media_coin_balance_paucal_2_4` | Preostala {count} novčića — 1 novčić po izvozu | count 2–4 (few) |
| `media_coin_balance_plural_5plus` | Preostalo {count} novčića — 1 novčić po izvozu | count 0, 5+ (other) |
| `media_grid_add_more` | Dodaj još | Button below media grid |
| `media_button_continue` | Nastavi | Primary CTA at bottom |
| `media_permission_alert_title` | Potreban pristup fotografijama | Alert title |
| `media_permission_alert_open_settings` | Otvori postavke | Alert button |
| `media_permission_alert_cancel` | Odustani | Alert cancel button |
| `media_permission_alert_message` | Dopusti Movie Makeru pristup videima i fotografijama u postavkama kako biste stvarali kompilacije. | Alert message |

---

## SettingsView.swift (export options)

| Key | Croatian | Notes |
|---|---|---|
| `settings_header_back` | Natrag | Back button |
| `settings_aspect_ratio_label` | Omjer slike | Section title |
| `settings_aspect_ratio_for_hint` | Za {platform} | Subtext |
| `settings_title_screen_label` | Naslovni zaslon | Section title |
| `settings_title_required_label` | Naslov (obavezno) | Field label |
| `settings_title_placeholder` | Unesi naslov | TextField placeholder |
| `settings_subtitle_label` | Podnaslov (neobavezno) | Field label |
| `settings_subtitle_placeholder` | Unesi podnaslov | TextField placeholder |
| `settings_title_screen_hint` | Bijeli tekst na crnoj pozadini • 3 sekunde | Instruction/note |
| `settings_title_screen_no_title` | Bez naslova | Status when title empty |
| `settings_transition_style_label` | Stil prijelaza | Section title |
| `settings_transition_color_label` | Boja prijelaza | ColorPicker label |
| `settings_photo_duration_label` | Trajanje fotografije | Section title |
| `settings_photo_duration_value` | {value} s | Duration picker |
| `settings_background_music_label` | Pozadinska glazba | Section title |
| `settings_music_select_button` | Odaberi glazbu | Button to open music picker |
| `settings_music_volume_label` | Glasnoća | Slider label |
| `settings_music_volume_percentage` | {value} % | Volume display |
| `settings_music_background_only_toggle` | Samo pozadinska glazba | Toggle label |
| `settings_music_remove_button` | Ukloni glazbu | Button to clear selection |
| `settings_music_loop_hint` | Glazba će se ponavljati kroz cijeli video | Note about looping |
| `settings_music_none_indicator` | Nema | Status when no music |
| `settings_preview_section_label` | Pregled | Section title |
| `settings_preview_total_length` | Ukupno trajanje: {duration} | Formatted duration |
| `settings_preview_item_count_singular` | {count} stavka | count == 1 (one) |
| `settings_preview_item_count_paucal_2_4` | {count} stavke | count 2–4 (few) |
| `settings_preview_item_count_plural_5plus` | {count} stavki | count 0, 5+ (other) |
| `settings_create_button` | Stvori video | Primary button |
| `settings_warning_alert_title` | Upozorenje | Alert title for validation warnings |
| `settings_warning_long_videos_singular` | Imate 1 video duži od 5 minuta. Datoteka može biti vrlo velika. | count == 1 (one) |
| `settings_warning_long_videos_paucal_2_4` | Imate {count} videa duža od 5 minuta. Datoteka može biti vrlo velika. | count 2–4 (few) |
| `settings_warning_long_videos_plural_5plus` | Imate {count} videa dužih od 5 minuta. Datoteka može biti vrlo velika. | count 0, 5+ (other) |
| `settings_warning_many_items_message` | Imate {count} stavki. Stvaranje može trajati nekoliko minuta. | Warning about many items |
| `settings_warning_create_anyway` | Ipak stvori | Alert button to proceed |
| `settings_warning_cancel` | Odustani | Alert cancel button |
| `settings_pro_badge` | PRO | Pro tier badge |
| `settings_duration_min_sec` | {minutes} min {seconds} s | Duration format for minutes > 0 |
| `settings_duration_sec_only` | {seconds} s | Duration format for < 1 min |

---

## VideoCreationView.swift (export progress)

| Key | Croatian | Notes |
|---|---|---|
| `video_creation_title` | Stvaramo tvoj video… | Main title during export |
| `video_creation_status_preparing` | Priprema… | Initial status |
| `video_creation_status_adding` | Dodavanje videa… | Progress status (early) |
| `video_creation_status_composing` | Slaganje videa… | Progress status (mid) |
| `video_creation_status_almost_done` | Skoro gotovo… | Progress status (late) |
| `video_creation_status_saving` | Spremanje u Photos… | Status during save |
| `video_creation_helper_text` | Možeš zatvoriti aplikaciju – obavijestit ćemo te kad bude spremno | Reassurance text |
| `video_creation_error_alert_title` | Pogreška | Alert title |
| `video_creation_error_alert_ok` | U redu | Error alert button |

---

## CompletionView.swift (success screen)

| Key | Croatian | Notes |
|---|---|---|
| `completion_title` | Video je gotov! | Success title |
| `completion_subtitle` | Tvoj video je spremljen u tvoje fotografije. | Confirmation text |
| `completion_button_share` | Podijeli video | Share sheet button |
| `completion_button_open_photos` | Otvori Photos | Button to open Photos app |
| `completion_button_create_another` | Stvori novi video | Button to reset and start over |

---

## PaywallView.swift (buy sheet)

| Key | Croatian | Notes |
|---|---|---|
| `paywall_hero_unlimited` | Neograničeno | Pro badge on hero |
| `paywall_hero_current_coins_label` | Trenutni novčići: | Free-tier label |
| `paywall_hero_coin_ratio` | 1 novčić = 1 video | Explanation of coin model |
| `paywall_feature_music_title` | Pozadinska glazba | Feature row |
| `paywall_feature_music_desc` | Dodaj vlastiti soundtrack | |
| `paywall_feature_slowmo_title` | Usporeni prikaz | Feature row |
| `paywall_feature_slowmo_desc` | Filmski usporeni prikaz na bilo kojoj snimci | |
| `paywall_feature_watermark_title` | Bez vodenog žiga | Feature row |
| `paywall_feature_watermark_desc` | Izvoz u punoj kvaliteti | |
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
| `paywall_products_error_retry` | Pokušaj ponovno | Retry button |
| `paywall_purchase_error_title` | Pogreška pri kupnji | Alert title |
| `paywall_purchase_error_message` | Nije moguće dovršiti kupnju. Pokušaj ponovno. | Error message |
| `paywall_purchase_error_ok` | U redu | Alert button |
| `paywall_trial_badge` | Besplatna probna verzija od {days} dana | Trial offer badge |

---

## DailySpinView.swift (slot machine)

| Key | Croatian | Notes |
|---|---|---|
| `spin_title` | Dnevno vrtanje | Screen title |
| `spin_subtitle_closed` | Vrati se sutra za novo vrtanje | Status when spin unavailable |
| `spin_rule_hint` | 3 🪙 = jackpot · 2 🪙 = nagrada | Rules hint below title |
| `spin_result_win_singular` | Osvojio si +1 novčić! | count == 1 (one) |
| `spin_result_win_paucal_2_4` | Osvojio si +{count} novčića! | count 2–4 (few) |
| `spin_result_win_plural_5plus` | Osvojio si +{count} novčića! | count 0, 5+ (other) |
| `spin_subtitle_lose` | Skoro! Pokušaj ponovno sutra | Lose message |
| `spin_status_rolling` | Vrti se… | Status while spinning |
| `spin_button_spin` | Vrti | Primary button |
| `spin_button_awesome` | Super | After a win |
| `spin_button_continue` | Nastavi | After a lose |
| `spin_button_close` | Zatvori | Bottom close button |

---

## TrimmingView.swift

| Key | Croatian | Notes |
|---|---|---|
| `trimming_video_loading` | Učitavanje videa… | Loading indicator |
| `trimming_toggle_slowmo` | Uključi usporeni prikaz | Toggle label |
| `trimming_toggle_mute` | Utišaj video | Toggle label |
| `trimming_pro_badge` | PRO | Pro feature badge |
| `trimming_time_start` | Početak: {time} | Trim start time display |
| `trimming_time_end` | Kraj: {time} | Trim end time display |
| `trimming_button_done` | Gotovo | Save trim + close |

---

## AppConfigurationView.swift

| Key | Croatian | Notes |
|---|---|---|
| `app_config_title` | Postavke aplikacije | Modal title |

---

## NotificationManager.swift

| Key | Croatian | Notes |
|---|---|---|
| `notification_video_ready_title` | Video kompilacija je spremna! | Local push title |
| `notification_video_ready_body` | Tvoj video je spremljen u Photos | Local push body |

---

## Info.plist (bundle metadata)

| Key | Croatian | Limit | Notes |
|---|---|---|---|
| `bundle_display_name` | Movie Maker | 30 | `CFBundleDisplayName` — brand |
| `plist_photo_library_add_usage` | Trebamo dozvolu za spremanje tvog videa u Photos | ≤100 | 51 chars |
| `plist_photo_library_usage` | Trebamo pristup videima i fotografijama za stvaranje kompilacija | ≤100 | 65 chars |

---

## App Store Connect Listing

| Key | Croatian | Limit | Notes |
|---|---|---|---|
| `asc_app_name` | Movie Maker - Reels & YouTube | 30 | Brand-consistent (29 chars) |
| `asc_subtitle` | Video za TikTok Reels Shorts | 30 | 28 chars |
| `asc_keywords` | spajanje,rezanje,videa,fotke,glazba,kolaž,montaža,slideshow,klipovi,editor,uređivanje,video | 100 | Re-targeted (98 chars) |
| `asc_promotional_text` | Spoji videa, fotke i glazbu u jedan čisti film. Kombiniraj snimke, reži, presloži, dodaj glazbu i izvezi — bez složene vremenske crte. | 170 | 134 chars |
| `asc_whats_new` | Sada izvezi u savršenoj veličini za svaku platformu. Odaberi 16:9 za YouTube, 9:16 za Reels i TikTok, ili 1:1 za Instagram — pa dijeli izravno iz aplikacije.\n\nBesplatna razina je opuštenija: 3 puna izvoza, bez vodenog žiga, bez ograničenja stavki. Nakon toga dopuni novčićima ili idi na Pro mjesečno ili godišnje. | 4000 | v2.4 release notes |
| `asc_description` | *(vidi sekciju Description structure)* | 4000 | |

### Description structure

| Section | Croatian |
|---|---|
| `desc_headline` | Spoji videa, fotke i glazbu u jedan čisti film — bez složene vremenske crte. |
| `desc_hook` | Movie Maker je najbrži način da spojiš snimke, dodaš soundtrack i izvezeš u galeriju. Samo povuci, izreži i gotovo. |
| `desc_section_what` | ŠTO MOŽEŠ RADITI |
| `desc_what_merge` | Spoji videa iz svoje biblioteke u jedan film — koliko god snimaka želiš. |
| `desc_what_combine` | Kombiniraj videa i fotke po bilo kojem redoslijedu i stvori slideshow s pokretom. |
| `desc_what_trim` | Izreži početak i kraj svakog klipa tako da ostanu samo najbolji trenuci. |
| `desc_what_reorder` | Povuci i presloži scene dok priča ne bude prava. |
| `desc_what_mute` | Utišaj zvuk klipa kad želiš tihi edit ili samo glazbu. |
| `desc_what_export` | Izvezi natrag u Photos u sekundama, spremno za dijeljenje. |
| `desc_section_how` | KAKO FUNKCIONIRA |
| `desc_how_1` | Odaberi klipove i fotke iz svoje biblioteke. |
| `desc_how_2` | Presloži, izreži i utišaj po potrebi. |
| `desc_how_3` | Dodaj glazbu i izvezi. |
| `desc_section_perfect_for` | SAVRŠENO ZA |
| `desc_perfect_travel` | Putopise i najbolje trenutke s odmora |
| `desc_perfect_family` | Obiteljske trenutke i rođendanske kompilacije |
| `desc_perfect_events` | Sažetke vjenčanja, zabava i utakmica |
| `desc_perfect_social` | Objave za Instagram, TikTok i YouTube Shorts |
| `desc_perfect_slideshow` | Brze slideshowe s fotografiranja |
| `desc_section_pro` | PRO ZNAČAJKE (NEOBAVEZNO) |
| `desc_pro_music` | Biblioteka pozadinske glazbe za profinjene soundtrackove |
| `desc_pro_slowmo` | Usporeni prikaz na ključnim trenucima |
| `desc_pro_longer` | Duži projekti s više snimaka i fotografija |
| `desc_pro_trial` | Isprobaj Pro besplatno prije pretplate — uvjeti su jasno prikazani u aplikaciji. |
| `desc_section_privacy` | PRIVATNOST NA PRVOM MJESTU |
| `desc_privacy_body` | Uređivanje se odvija u potpunosti na tvom uređaju. Tvoji mediji ostaju u tvojoj biblioteci. Ništa se nigdje ne prenosi osim ako sam ne odlučiš dijeliti. |
| `desc_privacy_url_line` | Pravila privatnosti: https://okekedev.github.io/MovieMaker/privacy.html |
| `desc_terms_url_line` | Uvjeti korištenja: https://okekedev.github.io/MovieMaker/terms.html |

---

## Translation notes (Croatian)

- Croatian uses CLDR plurals `one/few/other`; extra rows added for coin balance, item count, long-video warning, and spin win.
- Tone: modern Zagreb-standard, informal ("ti"/"tvoj") — matches consumer video-app norm.
- "Photos" kept as English brand (matches iOS system app name in Croatia).
- Keywords re-targeted with high-volume Croatian search terms: `spajanje` (merging), `rezanje` (cutting), `kolaž`, `montaža`, `slideshow`. Avoided duplicating title words ("video" appears only once at end for tail matching).
- `spin_result_win` uses "novčić" (coin) — same paradigm as `media_coin_balance`.
