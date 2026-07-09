# Movie Maker — Strings Inventory (nl)

**Locale:** nl — Dutch (Netherlands)
**Direction:** LTR (not RTL)
**Plural forms:** 2 (one, other)
**Tone:** Netherlands Dutch, informal "je/jij", modern app-style. Brand terms (Movie Maker, Pro, Reels, YouTube, TikTok, Shorts, Instagram, iPhone, iPad, Photos) stay in English.

---

## MediaSelectionView.swift (home)

| Key | Translated | Notes |
|---|---|---|
| `media_home_title` | Movie Maker | Main title on empty home state |
| `media_home_cta` | Tik om video's & foto's te selecteren | Helper text below pulse button |
| `media_header_back` | Terug | Button to deselect all media |
| `media_header_spin` | Draaien | Daily spin button label |
| `media_section_title` | Selecteer je momenten | Section headline when media selected |
| `media_section_subtitle` | Tik om te bewerken  \|  Houd vast om te herschikken | Instruction text |
| `media_coin_balance_singular` | Nog {count} coin — 1 coin per export | count == 1 |
| `media_coin_balance_plural` | Nog {count} coins — 1 coin per export | count != 1 |
| `media_grid_add_more` | Meer toevoegen | Button below media grid |
| `media_button_continue` | Doorgaan | Primary CTA at bottom |
| `media_permission_alert_title` | Foto-toegang vereist | Alert title |
| `media_permission_alert_open_settings` | Open Instellingen | Alert button |
| `media_permission_alert_cancel` | Annuleren | Alert cancel button |
| `media_permission_alert_message` | Geef Movie Maker toegang tot je video's en foto's in Instellingen om compilaties te maken. | Alert message |

---

## SettingsView.swift (export options)

| Key | Translated | Notes |
|---|---|---|
| `settings_header_back` | Terug | Back button |
| `settings_aspect_ratio_label` | Beeldverhouding | Section title |
| `settings_aspect_ratio_for_hint` | Voor {platform} | Subtext; {platform} = "YouTube", "Instagram", "Reels & TikTok" |
| `settings_title_screen_label` | Titelscherm | Section title |
| `settings_title_required_label` | Titel (Verplicht) | Field label |
| `settings_title_placeholder` | Voer titel in | TextField placeholder |
| `settings_subtitle_label` | Ondertitel (Optioneel) | Field label |
| `settings_subtitle_placeholder` | Voer ondertitel in | TextField placeholder |
| `settings_title_screen_hint` | Witte tekst op zwarte achtergrond • 3 seconden | Instruction/note |
| `settings_title_screen_no_title` | Geen titel | Status when title empty |
| `settings_transition_style_label` | Overgangsstijl | Section title |
| `settings_transition_color_label` | Overgangskleur | ColorPicker label |
| `settings_photo_duration_label` | Fotoduur | Section title |
| `settings_photo_duration_value` | {value} sec | Duration picker |
| `settings_background_music_label` | Achtergrondmuziek | Section title |
| `settings_music_select_button` | Muziek kiezen | Button to open music picker |
| `settings_music_volume_label` | Volume | Slider label |
| `settings_music_volume_percentage` | {value}% | Volume display |
| `settings_music_background_only_toggle` | Alleen achtergrondmuziek | Toggle label |
| `settings_music_remove_button` | Muziek verwijderen | Button to clear selection |
| `settings_music_loop_hint` | Muziek loopt door de hele video heen | Note about looping |
| `settings_music_none_indicator` | Geen | Status when no music |
| `settings_preview_section_label` | Voorbeeld | Section title |
| `settings_preview_total_length` | Totale lengte: {duration} | Formatted duration |
| `settings_preview_item_count_singular` | {count} item | count == 1 |
| `settings_preview_item_count_plural` | {count} items | count != 1 |
| `settings_create_button` | Video maken | Primary button |
| `settings_warning_alert_title` | Waarschuwing | Alert title for validation warnings |
| `settings_warning_long_videos_singular` | Je hebt 1 video die langer is dan 5 minuten. Dit kan een erg groot bestand opleveren. | count == 1 |
| `settings_warning_long_videos_plural` | Je hebt {count} video's die langer zijn dan 5 minuten. Dit kan een erg groot bestand opleveren. | count != 1 |
| `settings_warning_many_items_message` | Je hebt {count} items. Het maken kan enkele minuten duren. | Warning about many items |
| `settings_warning_create_anyway` | Toch maken | Alert button to proceed |
| `settings_warning_cancel` | Annuleren | Alert cancel button |
| `settings_pro_badge` | PRO | Pro tier badge |
| `settings_duration_min_sec` | {minutes} min {seconds} sec | Duration format for minutes > 0 |
| `settings_duration_sec_only` | {seconds} sec | Duration format for < 1 min |

---

## VideoCreationView.swift (export progress)

| Key | Translated | Notes |
|---|---|---|
| `video_creation_title` | Je video wordt gemaakt... | Main title during export |
| `video_creation_status_preparing` | Voorbereiden... | Initial status |
| `video_creation_status_adding` | Video's toevoegen... | Progress status (early) |
| `video_creation_status_composing` | Video samenstellen... | Progress status (mid) |
| `video_creation_status_almost_done` | Bijna klaar... | Progress status (late) |
| `video_creation_status_saving` | Opslaan in Photos... | Status during save |
| `video_creation_helper_text` | Je kunt de app sluiten — we laten het weten zodra hij klaar is | Reassurance text |
| `video_creation_error_alert_title` | Fout | Alert title |
| `video_creation_error_alert_ok` | OK | Error alert button |

---

## CompletionView.swift (success screen)

| Key | Translated | Notes |
|---|---|---|
| `completion_title` | Video gemaakt! | Success title |
| `completion_subtitle` | Je video is opgeslagen in je foto's. | Confirmation text |
| `completion_button_share` | Video delen | Share sheet button |
| `completion_button_open_photos` | Open Photos | Button to open Photos app |
| `completion_button_create_another` | Nog een video maken | Button to reset and start over |

---

## PaywallView.swift (buy sheet)

| Key | Translated | Notes |
|---|---|---|
| `paywall_hero_unlimited` | Onbeperkt | Pro badge on hero |
| `paywall_hero_current_coins_label` | Huidige coins: | Free-tier label |
| `paywall_hero_coin_ratio` | 1 coin = 1 video | Explanation of coin model |
| `paywall_feature_music_title` | Achtergrondmuziek | Feature row |
| `paywall_feature_music_desc` | Voeg je eigen soundtrack toe | |
| `paywall_feature_slowmo_title` | Slow Motion | Feature row |
| `paywall_feature_slowmo_desc` | Filmische slow-mo op elke clip | |
| `paywall_feature_watermark_title` | Geen watermerk | Feature row |
| `paywall_feature_watermark_desc` | Exporteer in volle kwaliteit | |
| `paywall_coins_section_title` | Coins kopen | Section header |
| `paywall_coins_tier_label` | {count} coins | Tier button (e.g. "5 coins") |
| `paywall_coins_tag_best_value` | Beste deal | Badge on 15-coin tier |
| `paywall_subscription_section_title` | Of ga onbeperkt | Section header |
| `paywall_subscription_monthly_title` | Maandelijks | Subscription tier |
| `paywall_subscription_monthly_badge` | 43% korting | Discount badge |
| `paywall_subscription_yearly_title` | Jaarlijks | Subscription tier |
| `paywall_subscription_yearly_badge` | 68% korting | Discount badge |
| `paywall_subscription_monthly_price` | {price} / maand | {price} auto-formatted by StoreKit |
| `paywall_subscription_yearly_price` | {price} / jaar | {price} auto-formatted by StoreKit |
| `paywall_restore_purchases` | Aankopen herstellen | Button |
| `paywall_link_privacy` | Privacy | Link label |
| `paywall_link_terms` | Voorwaarden | Link label |
| `paywall_link_support` | Support | Link label |
| `paywall_not_now_button` | Niet nu | Dismiss button |
| `paywall_products_error_title` | Kan producten niet laden | Error state |
| `paywall_products_error_retry` | Opnieuw proberen | Retry button |
| `paywall_purchase_error_title` | Aankoopfout | Alert title |
| `paywall_purchase_error_message` | Aankoop kon niet worden voltooid. Probeer het opnieuw. | Error message |
| `paywall_purchase_error_ok` | OK | Alert button |
| `paywall_trial_badge` | {days} dagen gratis proberen | Trial offer badge |

---

## DailySpinView.swift (slot machine)

| Key | Translated | Notes |
|---|---|---|
| `spin_title` | Dagelijkse spin | Screen title |
| `spin_subtitle_closed` | Kom morgen terug voor een nieuwe spin | Status when spin unavailable |
| `spin_rule_hint` | 3 🪙 = jackpot · 2 🪙 = prijs | Rules hint below title |
| `spin_result_win_singular` | Je hebt +1 coin gewonnen! | count == 1 |
| `spin_result_win_plural` | Je hebt +{count} coins gewonnen! | count != 1 |
| `spin_subtitle_lose` | Bijna! Probeer het morgen opnieuw | Lose message |
| `spin_status_rolling` | Draait… | Status while spinning |
| `spin_button_spin` | Draaien | Primary button |
| `spin_button_awesome` | Geweldig | After a win |
| `spin_button_continue` | Doorgaan | After a lose |
| `spin_button_close` | Sluiten | Bottom close button |

---

## TrimmingView.swift

| Key | Translated | Notes |
|---|---|---|
| `trimming_video_loading` | Video laden... | Loading indicator |
| `trimming_toggle_slowmo` | Slow-Mo inschakelen | Toggle label |
| `trimming_toggle_mute` | Video dempen | Toggle label |
| `trimming_pro_badge` | PRO | Pro feature badge |
| `trimming_time_start` | Start: {time} | Trim start time display |
| `trimming_time_end` | Einde: {time} | Trim end time display |
| `trimming_button_done` | Klaar | Save trim + close |

---

## AppConfigurationView.swift

| Key | Translated | Notes |
|---|---|---|
| `app_config_title` | App-instellingen | Modal title |

---

## NotificationManager.swift

| Key | Translated | Notes |
|---|---|---|
| `notification_video_ready_title` | Videocompilatie klaar! | Local push title |
| `notification_video_ready_body` | Je video is opgeslagen in Photos | Local push body |

---

## Info.plist (bundle metadata)

| Key | Translated | Limit | Notes |
|---|---|---|---|
| `bundle_display_name` | Movie Maker | 30 | `CFBundleDisplayName` — brand |
| `plist_photo_library_add_usage` | Toegang nodig om je gemaakte video in Photos op te slaan. | ≤100 | 57 chars |
| `plist_photo_library_usage` | Toegang tot video's en foto's nodig om compilaties te maken. | ≤100 | 60 chars |

---

## App Store Connect Listing

| Key | Translated | Limit | Notes |
|---|---|---|---|
| `asc_app_name` | Movie Maker - Reels & YouTube | 30 | Brand-consistent, kept as-is |
| `asc_subtitle` | Video's voor TikTok & Reels | 30 | 27 chars |
| `asc_keywords` | video editor,videos samenvoegen,video maken,montage,videobewerking,reels,tiktok,youtube,shorts | 100 | 94 chars incl. commas — NL search intent |
| `asc_promotional_text` | Voeg video's, foto's en muziek samen tot één strakke film. Combineer clips, trim, herschik, voeg een soundtrack toe en exporteer — zonder ingewikkelde tijdlijn. | 170 | 159 chars |
| `asc_whats_new` | Exporteer nu in het perfecte formaat voor elk platform. Kies 16:9 voor YouTube, 9:16 voor Reels & TikTok of 1:1 voor Instagram — en deel direct vanuit de app.\n\nDe gratis versie is ruimer: 3 volledige exports gratis, geen watermerk, geen itemlimiet. Daarna aanvullen met coins of upgraden naar Pro (maandelijks of jaarlijks). | 4000 | v2.4 release notes |
| `asc_description` | *(volledige beschrijving — zie sectie hieronder)* | 4000 | Sectiegewijs hieronder |

### Description structure (for translation)

| Section | Translated |
|---|---|
| `desc_headline` | Voeg video's, foto's en muziek samen tot één strakke film — zonder ingewikkelde tijdlijn. |
| `desc_hook` | Movie Maker is de snelste manier om clips te combineren, een soundtrack toe te voegen en te exporteren naar je fotorol. Gewoon slepen, trimmen en klaar. |
| `desc_section_what` | WAT JE KUNT DOEN |
| `desc_what_merge` | Video's uit je bibliotheek samenvoegen tot één film — zoveel clips als je wilt. |
| `desc_what_combine` | Combineer video's en foto's in elke volgorde voor een slideshow met beweging. |
| `desc_what_trim` | Trim het begin en einde van elke clip zodat alleen de beste momenten overblijven. |
| `desc_what_reorder` | Sleep om scènes te herschikken tot het verhaal klopt. |
| `desc_what_mute` | Demp clip-audio als je een stille edit of alleen muziek als soundtrack wilt. |
| `desc_what_export` | Exporteer in seconden terug naar Photos, klaar om te delen. |
| `desc_section_how` | HOE HET WERKT |
| `desc_how_1` | Kies clips en foto's uit je bibliotheek. |
| `desc_how_2` | Herschik, trim en demp naar wens. |
| `desc_how_3` | Voeg muziek toe en exporteer. |
| `desc_section_perfect_for` | PERFECT VOOR |
| `desc_perfect_travel` | Reissamenvattingen en vakantiehoogtepunten |
| `desc_perfect_family` | Familiemomenten en verjaardagscompilaties |
| `desc_perfect_events` | Eventrecaps van bruiloften, feesten, wedstrijden |
| `desc_perfect_social` | Social posts voor Instagram, TikTok en YouTube Shorts |
| `desc_perfect_slideshow` | Snelle slideshows van een fotoshoot |
| `desc_section_pro` | PRO-FUNCTIES (OPTIONEEL) |
| `desc_pro_music` | Achtergrondmuziekbibliotheek voor gepolijste soundtracks |
| `desc_pro_slowmo` | Slow motion op de belangrijkste momenten |
| `desc_pro_longer` | Langere projecten met meer clips en foto's |
| `desc_pro_trial` | Probeer Pro gratis voordat je een abonnement neemt — voorwaarden duidelijk in de app. |
| `desc_section_privacy` | PRIVACY VOOROP |
| `desc_privacy_body` | Het bewerken gebeurt volledig op je apparaat. Je media blijft in je fotobibliotheek. Er wordt niets ergens geüpload, tenzij jij ervoor kiest om te delen. |
| `desc_privacy_url_line` | Privacybeleid: https://okekedev.github.io/MovieMaker/privacy.html |
| `desc_terms_url_line` | Gebruiksvoorwaarden: https://okekedev.github.io/MovieMaker/terms.html |
