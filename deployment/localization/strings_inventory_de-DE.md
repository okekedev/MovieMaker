# Movie Maker — Strings Inventory (de-DE)

**Locale:** de-DE — German (Germany)
**Direction:** LTR (not RTL)
**Plural forms:** 2 (one, other)
**Tone:** Informal "du", modern app-style German. Brand terms (Movie Maker, Pro, Reels, YouTube, TikTok, Shorts, Instagram, iPhone, iPad, Photos) stay in English.

---

## MediaSelectionView.swift (home)

| Key | Translated | Notes |
|---|---|---|
| `media_home_title` | Movie Maker | Main title on empty home state |
| `media_home_cta` | Tippen, um Videos & Fotos auszuwählen | Helper text below pulse button |
| `media_header_back` | Zurück | Button to deselect all media |
| `media_header_spin` | Drehen | Daily spin button label |
| `media_section_title` | Wähle deine Momente | Section headline when media selected |
| `media_section_subtitle` | Tippen zum Bearbeiten  \|  Halten zum Umsortieren | Instruction text |
| `media_coin_balance_singular` | Noch {count} Coin — 1 Coin pro Export | count == 1 |
| `media_coin_balance_plural` | Noch {count} Coins — 1 Coin pro Export | count != 1 |
| `media_grid_add_more` | Mehr hinzufügen | Button below media grid |
| `media_button_continue` | Weiter | Primary CTA at bottom |
| `media_permission_alert_title` | Foto-Zugriff erforderlich | Alert title |
| `media_permission_alert_open_settings` | Einstellungen öffnen | Alert button |
| `media_permission_alert_cancel` | Abbrechen | Alert cancel button |
| `media_permission_alert_message` | Bitte erlaube Movie Maker in den Einstellungen den Zugriff auf deine Videos und Fotos, um Kompilationen zu erstellen. | Alert message |

---

## SettingsView.swift (export options)

| Key | Translated | Notes |
|---|---|---|
| `settings_header_back` | Zurück | Back button |
| `settings_aspect_ratio_label` | Seitenverhältnis | Section title |
| `settings_aspect_ratio_for_hint` | Für {platform} | Subtext; {platform} = "YouTube", "Instagram", "Reels & TikTok" |
| `settings_title_screen_label` | Titelbild | Section title |
| `settings_title_required_label` | Titel (Pflicht) | Field label |
| `settings_title_placeholder` | Titel eingeben | TextField placeholder |
| `settings_subtitle_label` | Untertitel (Optional) | Field label |
| `settings_subtitle_placeholder` | Untertitel eingeben | TextField placeholder |
| `settings_title_screen_hint` | Weißer Text auf schwarzem Hintergrund • 3 Sekunden | Instruction/note |
| `settings_title_screen_no_title` | Kein Titel | Status when title empty |
| `settings_transition_style_label` | Übergangsstil | Section title |
| `settings_transition_color_label` | Übergangsfarbe | ColorPicker label |
| `settings_photo_duration_label` | Foto-Dauer | Section title |
| `settings_photo_duration_value` | {value} Sek. | Duration picker |
| `settings_background_music_label` | Hintergrundmusik | Section title |
| `settings_music_select_button` | Musik auswählen | Button to open music picker |
| `settings_music_volume_label` | Lautstärke | Slider label |
| `settings_music_volume_percentage` | {value}% | Volume display |
| `settings_music_background_only_toggle` | Nur Hintergrundmusik | Toggle label |
| `settings_music_remove_button` | Musik entfernen | Button to clear selection |
| `settings_music_loop_hint` | Musik läuft während des gesamten Videos in Schleife | Note about looping |
| `settings_music_none_indicator` | Keine | Status when no music |
| `settings_preview_section_label` | Vorschau | Section title |
| `settings_preview_total_length` | Gesamtlänge: {duration} | Formatted duration |
| `settings_preview_item_count_singular` | {count} Element | count == 1 |
| `settings_preview_item_count_plural` | {count} Elemente | count != 1 |
| `settings_create_button` | Video erstellen | Primary button |
| `settings_warning_alert_title` | Warnung | Alert title for validation warnings |
| `settings_warning_long_videos_singular` | Du hast 1 Video, das länger als 5 Minuten ist. Das kann zu einer sehr großen Datei führen. | count == 1 |
| `settings_warning_long_videos_plural` | Du hast {count} Videos, die länger als 5 Minuten sind. Das kann zu einer sehr großen Datei führen. | count != 1 |
| `settings_warning_many_items_message` | Du hast {count} Elemente. Die Erstellung kann mehrere Minuten dauern. | Warning about many items |
| `settings_warning_create_anyway` | Trotzdem erstellen | Alert button to proceed |
| `settings_warning_cancel` | Abbrechen | Alert cancel button |
| `settings_pro_badge` | PRO | Pro tier badge |
| `settings_duration_min_sec` | {minutes} Min. {seconds} Sek. | Duration format for minutes > 0 |
| `settings_duration_sec_only` | {seconds} Sek. | Duration format for < 1 min |

---

## VideoCreationView.swift (export progress)

| Key | Translated | Notes |
|---|---|---|
| `video_creation_title` | Video wird erstellt... | Main title during export |
| `video_creation_status_preparing` | Vorbereiten... | Initial status |
| `video_creation_status_adding` | Videos werden hinzugefügt... | Progress status (early) |
| `video_creation_status_composing` | Video wird zusammengestellt... | Progress status (mid) |
| `video_creation_status_almost_done` | Fast fertig... | Progress status (late) |
| `video_creation_status_saving` | Wird in Photos gespeichert... | Status during save |
| `video_creation_helper_text` | Du kannst die App schließen — wir benachrichtigen dich, sobald es fertig ist | Reassurance text |
| `video_creation_error_alert_title` | Fehler | Alert title |
| `video_creation_error_alert_ok` | OK | Error alert button |

---

## CompletionView.swift (success screen)

| Key | Translated | Notes |
|---|---|---|
| `completion_title` | Video erstellt! | Success title |
| `completion_subtitle` | Dein Video wurde in deinen Fotos gespeichert. | Confirmation text |
| `completion_button_share` | Video teilen | Share sheet button |
| `completion_button_open_photos` | Photos öffnen | Button to open Photos app |
| `completion_button_create_another` | Weiteres Video erstellen | Button to reset and start over |

---

## PaywallView.swift (buy sheet)

| Key | Translated | Notes |
|---|---|---|
| `paywall_hero_unlimited` | Unbegrenzt | Pro badge on hero |
| `paywall_hero_current_coins_label` | Aktuelle Coins: | Free-tier label |
| `paywall_hero_coin_ratio` | 1 Coin = 1 Video | Explanation of coin model |
| `paywall_feature_music_title` | Hintergrundmusik | Feature row |
| `paywall_feature_music_desc` | Eigenen Soundtrack hinzufügen | |
| `paywall_feature_slowmo_title` | Zeitlupe | Feature row |
| `paywall_feature_slowmo_desc` | Kinoreife Zeitlupe für jeden Clip | |
| `paywall_feature_watermark_title` | Kein Wasserzeichen | Feature row |
| `paywall_feature_watermark_desc` | Export in voller Qualität | |
| `paywall_coins_section_title` | Coins kaufen | Section header |
| `paywall_coins_tier_label` | {count} Coins | Tier button (e.g. "5 Coins") |
| `paywall_coins_tag_best_value` | Bestes Angebot | Badge on 15-coin tier |
| `paywall_subscription_section_title` | Oder unbegrenzt nutzen | Section header |
| `paywall_subscription_monthly_title` | Monatlich | Subscription tier |
| `paywall_subscription_monthly_badge` | 43% sparen | Discount badge |
| `paywall_subscription_yearly_title` | Jährlich | Subscription tier |
| `paywall_subscription_yearly_badge` | 68% sparen | Discount badge |
| `paywall_subscription_monthly_price` | {price} / Monat | {price} auto-formatted by StoreKit |
| `paywall_subscription_yearly_price` | {price} / Jahr | {price} auto-formatted by StoreKit |
| `paywall_restore_purchases` | Käufe wiederherstellen | Button |
| `paywall_link_privacy` | Datenschutz | Link label |
| `paywall_link_terms` | AGB | Link label |
| `paywall_link_support` | Support | Link label |
| `paywall_not_now_button` | Nicht jetzt | Dismiss button |
| `paywall_products_error_title` | Produkte konnten nicht geladen werden | Error state |
| `paywall_products_error_retry` | Erneut versuchen | Retry button |
| `paywall_purchase_error_title` | Kauffehler | Alert title |
| `paywall_purchase_error_message` | Kauf konnte nicht abgeschlossen werden. Bitte erneut versuchen. | Error message |
| `paywall_purchase_error_ok` | OK | Alert button |
| `paywall_trial_badge` | {days} Tage kostenlos testen | Trial offer badge |

---

## DailySpinView.swift (slot machine)

| Key | Translated | Notes |
|---|---|---|
| `spin_title` | Tägliches Drehen | Screen title |
| `spin_subtitle_closed` | Komm morgen für ein weiteres Drehen zurück | Status when spin unavailable |
| `spin_rule_hint` | 3 🪙 = Jackpot · 2 🪙 = Gewinn | Rules hint below title |
| `spin_result_win_singular` | Du hast +1 Coin gewonnen! | count == 1 |
| `spin_result_win_plural` | Du hast +{count} Coins gewonnen! | count != 1 |
| `spin_subtitle_lose` | So knapp! Versuch es morgen wieder | Lose message |
| `spin_status_rolling` | Dreht… | Status while spinning |
| `spin_button_spin` | Drehen | Primary button |
| `spin_button_awesome` | Super | After a win |
| `spin_button_continue` | Weiter | After a lose |
| `spin_button_close` | Schließen | Bottom close button |

---

## TrimmingView.swift

| Key | Translated | Notes |
|---|---|---|
| `trimming_video_loading` | Video wird geladen... | Loading indicator |
| `trimming_toggle_slowmo` | Zeitlupe aktivieren | Toggle label |
| `trimming_toggle_mute` | Video stummschalten | Toggle label |
| `trimming_pro_badge` | PRO | Pro feature badge |
| `trimming_time_start` | Start: {time} | Trim start time display |
| `trimming_time_end` | Ende: {time} | Trim end time display |
| `trimming_button_done` | Fertig | Save trim + close |

---

## AppConfigurationView.swift

| Key | Translated | Notes |
|---|---|---|
| `app_config_title` | App-Einstellungen | Modal title |

---

## NotificationManager.swift

| Key | Translated | Notes |
|---|---|---|
| `notification_video_ready_title` | Video-Kompilation fertig! | Local push title |
| `notification_video_ready_body` | Dein Video wurde in Photos gespeichert | Local push body |

---

## Info.plist (bundle metadata)

| Key | Translated | Limit | Notes |
|---|---|---|---|
| `bundle_display_name` | Movie Maker | 30 | `CFBundleDisplayName` — brand |
| `plist_photo_library_add_usage` | Zugriff nötig, um dein erstelltes Video in Photos zu speichern. | ≤100 | 61 chars |
| `plist_photo_library_usage` | Zugriff auf Videos und Fotos nötig, um Kompilationen zu erstellen. | ≤100 | 65 chars |

---

## App Store Connect Listing

| Key | Translated | Limit | Notes |
|---|---|---|---|
| `asc_app_name` | Movie Maker - Reels & YouTube | 30 | Brand-consistent, kept as-is |
| `asc_subtitle` | Videos für TikTok & Reels | 30 | 25 chars — see decisions note |
| `asc_keywords` | video editor,zusammenfügen,videos verbinden,videobearbeitung,reels,tiktok,youtube,shorts,collage | 100 | 96 chars incl. commas — DE search intent |
| `asc_promotional_text` | Videos, Fotos und Musik zu einem sauberen Film zusammenfügen. Clips kombinieren, trimmen, sortieren, Soundtrack hinzufügen — ohne komplizierte Timeline. | 170 | 152 chars |
| `asc_whats_new` | Jetzt im perfekten Format für jede Plattform exportieren. Wähle 16:9 für YouTube, 9:16 für Reels & TikTok oder 1:1 für Instagram — und teile direkt aus der App.\n\nDer kostenlose Tarif ist großzügiger: 3 vollständige Exporte gratis, kein Wasserzeichen, keine Element-Grenze. Danach mit Coins auffüllen oder Pro monatlich oder jährlich abschließen. | 4000 | v2.4 release notes |
| `asc_description` | *(vollständige Beschreibung — siehe Abschnitt unten)* | 4000 | Sektionsweise unten |

### Description structure (for translation)

| Section | Translated |
|---|---|
| `desc_headline` | Videos, Fotos und Musik zu einem sauberen Film zusammenfügen — ohne komplizierte Timeline. |
| `desc_hook` | Movie Maker ist der schnellste Weg, Clips zu kombinieren, einen Soundtrack hinzuzufügen und in dein Fotoalbum zu exportieren. Einfach ziehen, trimmen — fertig. |
| `desc_section_what` | WAS DU MACHEN KANNST |
| `desc_what_merge` | Videos aus deiner Mediathek zu einem Film zusammenfügen — so viele Clips du willst. |
| `desc_what_combine` | Videos und Fotos in beliebiger Reihenfolge kombinieren, um eine Slideshow mit Bewegung zu bauen. |
| `desc_what_trim` | Anfang und Ende jedes Clips trimmen, damit nur die besten Momente bleiben. |
| `desc_what_reorder` | Szenen per Drag & Drop umsortieren, bis die Story stimmt. |
| `desc_what_mute` | Clip-Audio stummschalten, wenn du einen ruhigen Schnitt oder nur Musik als Soundtrack willst. |
| `desc_what_export` | In Sekunden zurück in Photos exportieren — bereit zum Teilen. |
| `desc_section_how` | SO FUNKTIONIERT'S |
| `desc_how_1` | Clips und Fotos aus deiner Mediathek auswählen. |
| `desc_how_2` | Umsortieren, trimmen und stummschalten nach Bedarf. |
| `desc_how_3` | Musik hinzufügen und exportieren. |
| `desc_section_perfect_for` | PERFEKT FÜR |
| `desc_perfect_travel` | Reise-Zusammenfassungen und Urlaubs-Highlights |
| `desc_perfect_family` | Familienmomente und Geburtstags-Kompilationen |
| `desc_perfect_events` | Event-Recaps von Hochzeiten, Partys, Spielen |
| `desc_perfect_social` | Social-Posts für Instagram, TikTok und YouTube Shorts |
| `desc_perfect_slideshow` | Schnelle Slideshows von einem Fotoshooting |
| `desc_section_pro` | PRO-FEATURES (OPTIONAL) |
| `desc_pro_music` | Hintergrundmusik-Bibliothek für polierte Soundtracks |
| `desc_pro_slowmo` | Zeitlupe für Schlüsselmomente |
| `desc_pro_longer` | Längere Projekte mit mehr Clips und Fotos |
| `desc_pro_trial` | Pro kostenlos vor dem Abo testen — Bedingungen klar in der App sichtbar. |
| `desc_section_privacy` | PRIVATSPHÄRE ZUERST |
| `desc_privacy_body` | Die Bearbeitung findet komplett auf deinem Gerät statt. Deine Medien bleiben in deiner Fotomediathek. Nichts wird irgendwohin hochgeladen, außer du entscheidest dich zu teilen. |
| `desc_privacy_url_line` | Datenschutzrichtlinie: https://okekedev.github.io/MovieMaker/privacy.html |
| `desc_terms_url_line` | Nutzungsbedingungen: https://okekedev.github.io/MovieMaker/terms.html |
