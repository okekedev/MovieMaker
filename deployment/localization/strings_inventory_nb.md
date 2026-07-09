# Movie Maker — Strings Inventory (nb)

**Locale:** nb — Norwegian Bokmål (Norway)
**Direction:** LTR (not RTL)
**Plural forms:** 2 (one, other)
**Tone:** Norwegian Bokmål (not Nynorsk), casual-friendly, modern app-style. Brand terms (Movie Maker, Pro, Reels, YouTube, TikTok, Shorts, Instagram, iPhone, iPad, Photos) stay in English.

---

## MediaSelectionView.swift (home)

| Key | Translated | Notes |
|---|---|---|
| `media_home_title` | Movie Maker | Main title on empty home state |
| `media_home_cta` | Trykk for å velge videoer og bilder | Helper text below pulse button |
| `media_header_back` | Tilbake | Button to deselect all media |
| `media_header_spin` | Spinn | Daily spin button label |
| `media_section_title` | Velg øyeblikkene dine | Section headline when media selected |
| `media_section_subtitle` | Trykk for å redigere  \|  Hold for å endre rekkefølge | Instruction text |
| `media_coin_balance_singular` | {count} coin igjen — 1 coin per eksport | count == 1 |
| `media_coin_balance_plural` | {count} coins igjen — 1 coin per eksport | count != 1 |
| `media_grid_add_more` | Legg til flere | Button below media grid |
| `media_button_continue` | Fortsett | Primary CTA at bottom |
| `media_permission_alert_title` | Foto-tilgang kreves | Alert title |
| `media_permission_alert_open_settings` | Åpne Innstillinger | Alert button |
| `media_permission_alert_cancel` | Avbryt | Alert cancel button |
| `media_permission_alert_message` | Gi Movie Maker tilgang til videoene og bildene dine i Innstillinger for å lage samlefilmer. | Alert message |

---

## SettingsView.swift (export options)

| Key | Translated | Notes |
|---|---|---|
| `settings_header_back` | Tilbake | Back button |
| `settings_aspect_ratio_label` | Bildeforhold | Section title |
| `settings_aspect_ratio_for_hint` | For {platform} | Subtext; {platform} = "YouTube", "Instagram", "Reels & TikTok" |
| `settings_title_screen_label` | Tittelskjerm | Section title |
| `settings_title_required_label` | Tittel (Påkrevd) | Field label |
| `settings_title_placeholder` | Skriv inn tittel | TextField placeholder |
| `settings_subtitle_label` | Undertittel (Valgfri) | Field label |
| `settings_subtitle_placeholder` | Skriv inn undertittel | TextField placeholder |
| `settings_title_screen_hint` | Hvit tekst på svart bakgrunn • 3 sekunder | Instruction/note |
| `settings_title_screen_no_title` | Ingen tittel | Status when title empty |
| `settings_transition_style_label` | Overgangsstil | Section title |
| `settings_transition_color_label` | Overgangsfarge | ColorPicker label |
| `settings_photo_duration_label` | Bildevarighet | Section title |
| `settings_photo_duration_value` | {value} sek | Duration picker |
| `settings_background_music_label` | Bakgrunnsmusikk | Section title |
| `settings_music_select_button` | Velg musikk | Button to open music picker |
| `settings_music_volume_label` | Volum | Slider label |
| `settings_music_volume_percentage` | {value}% | Volume display |
| `settings_music_background_only_toggle` | Kun bakgrunnsmusikk | Toggle label |
| `settings_music_remove_button` | Fjern musikk | Button to clear selection |
| `settings_music_loop_hint` | Musikken loopes gjennom hele videoen | Note about looping |
| `settings_music_none_indicator` | Ingen | Status when no music |
| `settings_preview_section_label` | Forhåndsvisning | Section title |
| `settings_preview_total_length` | Total lengde: {duration} | Formatted duration |
| `settings_preview_item_count_singular` | {count} element | count == 1 |
| `settings_preview_item_count_plural` | {count} elementer | count != 1 |
| `settings_create_button` | Lag video | Primary button |
| `settings_warning_alert_title` | Advarsel | Alert title for validation warnings |
| `settings_warning_long_videos_singular` | Du har 1 video som er lengre enn 5 minutter. Det kan gi en veldig stor fil. | count == 1 |
| `settings_warning_long_videos_plural` | Du har {count} videoer som er lengre enn 5 minutter. Det kan gi en veldig stor fil. | count != 1 |
| `settings_warning_many_items_message` | Du har {count} elementer. Det kan ta flere minutter å lage. | Warning about many items |
| `settings_warning_create_anyway` | Lag likevel | Alert button to proceed |
| `settings_warning_cancel` | Avbryt | Alert cancel button |
| `settings_pro_badge` | PRO | Pro tier badge |
| `settings_duration_min_sec` | {minutes} min {seconds} sek | Duration format for minutes > 0 |
| `settings_duration_sec_only` | {seconds} sek | Duration format for < 1 min |

---

## VideoCreationView.swift (export progress)

| Key | Translated | Notes |
|---|---|---|
| `video_creation_title` | Lager videoen din... | Main title during export |
| `video_creation_status_preparing` | Forbereder... | Initial status |
| `video_creation_status_adding` | Legger til videoer... | Progress status (early) |
| `video_creation_status_composing` | Setter sammen video... | Progress status (mid) |
| `video_creation_status_almost_done` | Nesten ferdig... | Progress status (late) |
| `video_creation_status_saving` | Lagrer til Photos... | Status during save |
| `video_creation_helper_text` | Du kan lukke appen — vi varsler deg når den er klar | Reassurance text |
| `video_creation_error_alert_title` | Feil | Alert title |
| `video_creation_error_alert_ok` | OK | Error alert button |

---

## CompletionView.swift (success screen)

| Key | Translated | Notes |
|---|---|---|
| `completion_title` | Video laget! | Success title |
| `completion_subtitle` | Videoen din er lagret blant bildene dine. | Confirmation text |
| `completion_button_share` | Del video | Share sheet button |
| `completion_button_open_photos` | Åpne Photos | Button to open Photos app |
| `completion_button_create_another` | Lag en video til | Button to reset and start over |

---

## PaywallView.swift (buy sheet)

| Key | Translated | Notes |
|---|---|---|
| `paywall_hero_unlimited` | Ubegrenset | Pro badge on hero |
| `paywall_hero_current_coins_label` | Nåværende coins: | Free-tier label |
| `paywall_hero_coin_ratio` | 1 coin = 1 video | Explanation of coin model |
| `paywall_feature_music_title` | Bakgrunnsmusikk | Feature row |
| `paywall_feature_music_desc` | Legg til ditt eget lydspor | |
| `paywall_feature_slowmo_title` | Slow Motion | Feature row |
| `paywall_feature_slowmo_desc` | Filmatisk slow-mo på hvilket som helst klipp | |
| `paywall_feature_watermark_title` | Ingen vannmerke | Feature row |
| `paywall_feature_watermark_desc` | Eksporter i full kvalitet | |
| `paywall_coins_section_title` | Kjøp coins | Section header |
| `paywall_coins_tier_label` | {count} coins | Tier button (e.g. "5 coins") |
| `paywall_coins_tag_best_value` | Beste tilbud | Badge on 15-coin tier |
| `paywall_subscription_section_title` | Eller gå ubegrenset | Section header |
| `paywall_subscription_monthly_title` | Månedlig | Subscription tier |
| `paywall_subscription_monthly_badge` | Spar 43% | Discount badge |
| `paywall_subscription_yearly_title` | Årlig | Subscription tier |
| `paywall_subscription_yearly_badge` | Spar 68% | Discount badge |
| `paywall_subscription_monthly_price` | {price} / måned | {price} auto-formatted by StoreKit |
| `paywall_subscription_yearly_price` | {price} / år | {price} auto-formatted by StoreKit |
| `paywall_restore_purchases` | Gjenopprett kjøp | Button |
| `paywall_link_privacy` | Personvern | Link label |
| `paywall_link_terms` | Vilkår | Link label |
| `paywall_link_support` | Support | Link label |
| `paywall_not_now_button` | Ikke nå | Dismiss button |
| `paywall_products_error_title` | Kunne ikke laste produkter | Error state |
| `paywall_products_error_retry` | Prøv igjen | Retry button |
| `paywall_purchase_error_title` | Kjøpsfeil | Alert title |
| `paywall_purchase_error_message` | Kunne ikke fullføre kjøpet. Vennligst prøv igjen. | Error message |
| `paywall_purchase_error_ok` | OK | Alert button |
| `paywall_trial_badge` | {days} dagers gratis prøveperiode | Trial offer badge |

---

## DailySpinView.swift (slot machine)

| Key | Translated | Notes |
|---|---|---|
| `spin_title` | Daglig spinn | Screen title |
| `spin_subtitle_closed` | Kom tilbake i morgen for en ny spinn | Status when spin unavailable |
| `spin_rule_hint` | 3 🪙 = jackpot · 2 🪙 = premie | Rules hint below title |
| `spin_result_win_singular` | Du vant +1 coin! | count == 1 |
| `spin_result_win_plural` | Du vant +{count} coins! | count != 1 |
| `spin_subtitle_lose` | Så nære! Prøv igjen i morgen | Lose message |
| `spin_status_rolling` | Spinner… | Status while spinning |
| `spin_button_spin` | Spinn | Primary button |
| `spin_button_awesome` | Fantastisk | After a win |
| `spin_button_continue` | Fortsett | After a lose |
| `spin_button_close` | Lukk | Bottom close button |

---

## TrimmingView.swift

| Key | Translated | Notes |
|---|---|---|
| `trimming_video_loading` | Laster video... | Loading indicator |
| `trimming_toggle_slowmo` | Aktiver Slow-Mo | Toggle label |
| `trimming_toggle_mute` | Demp video | Toggle label |
| `trimming_pro_badge` | PRO | Pro feature badge |
| `trimming_time_start` | Start: {time} | Trim start time display |
| `trimming_time_end` | Slutt: {time} | Trim end time display |
| `trimming_button_done` | Ferdig | Save trim + close |

---

## AppConfigurationView.swift

| Key | Translated | Notes |
|---|---|---|
| `app_config_title` | Appinnstillinger | Modal title |

---

## NotificationManager.swift

| Key | Translated | Notes |
|---|---|---|
| `notification_video_ready_title` | Videosamling klar! | Local push title |
| `notification_video_ready_body` | Videoen din er lagret til Photos | Local push body |

---

## Info.plist (bundle metadata)

| Key | Translated | Limit | Notes |
|---|---|---|---|
| `bundle_display_name` | Movie Maker | 30 | `CFBundleDisplayName` — brand |
| `plist_photo_library_add_usage` | Vi trenger tilgang for å lagre den ferdige videoen til Photos. | ≤100 | 62 chars |
| `plist_photo_library_usage` | Vi trenger tilgang til videoene og bildene dine for å lage samlefilmer. | ≤100 | 71 chars |

---

## App Store Connect Listing

| Key | Translated | Limit | Notes |
|---|---|---|---|
| `asc_app_name` | Movie Maker - Reels & YouTube | 30 | Brand-consistent, kept as-is |
| `asc_subtitle` | Videoer for TikTok & Reels | 30 | 26 chars |
| `asc_keywords` | video editor,slå sammen videoer,videoredigering,filmredigerer,montasje,reels,tiktok,youtube,shorts | 100 | 98 chars incl. commas — NB search intent |
| `asc_promotional_text` | Slå sammen videoer, bilder og musikk til én ren film. Kombiner klipp, trim, endre rekkefølge, legg til lydspor og eksporter — uten komplisert tidslinje. | 170 | 152 chars |
| `asc_whats_new` | Eksporter nå i perfekt format for hver plattform. Velg 16:9 for YouTube, 9:16 for Reels & TikTok eller 1:1 for Instagram — og del rett fra appen.\n\nGratisnivået er romsligere: 3 fullstendige eksporter gratis, ingen vannmerke, ingen elementgrense. Deretter fyller du på med coins eller kjører Pro månedlig eller årlig. | 4000 | v2.4 release notes |
| `asc_description` | *(fullstendig beskrivelse — se seksjonen nedenfor)* | 4000 | Seksjonsvis nedenfor |

### Description structure (for translation)

| Section | Translated |
|---|---|
| `desc_headline` | Slå sammen videoer, bilder og musikk til én ren film — uten komplisert tidslinje. |
| `desc_hook` | Movie Maker er den raskeste måten å kombinere klipp, legge til et lydspor og eksportere til kamerarullen. Bare dra, trim, og du er ferdig. |
| `desc_section_what` | HVA DU KAN GJØRE |
| `desc_what_merge` | Slå sammen videoer fra biblioteket til én film — så mange klipp du vil. |
| `desc_what_combine` | Kombiner videoer og bilder i hvilken som helst rekkefølge for en lysbildefremvisning med bevegelse. |
| `desc_what_trim` | Trim starten og slutten av hvert klipp så bare de beste øyeblikkene blir igjen. |
| `desc_what_reorder` | Dra for å endre rekkefølge på scener til historien føles riktig. |
| `desc_what_mute` | Demp klipplyden når du vil ha en stille redigering eller kun musikk som lydspor. |
| `desc_what_export` | Eksporter tilbake til Photos på sekunder, klar til å deles. |
| `desc_section_how` | SLIK FUNGERER DET |
| `desc_how_1` | Velg klipp og bilder fra biblioteket. |
| `desc_how_2` | Endre rekkefølge, trim og demp etter behov. |
| `desc_how_3` | Legg til musikk og eksporter. |
| `desc_section_perfect_for` | PERFEKT FOR |
| `desc_perfect_travel` | Reisesammendrag og ferie-høydepunkter |
| `desc_perfect_family` | Familieøyeblikk og bursdagssamlinger |
| `desc_perfect_events` | Eventoppsummeringer fra bryllup, fester, kamper |
| `desc_perfect_social` | Sosiale innlegg for Instagram, TikTok og YouTube Shorts |
| `desc_perfect_slideshow` | Raske lysbildefremvisninger fra en fotoshoot |
| `desc_section_pro` | PRO-FUNKSJONER (VALGFRITT) |
| `desc_pro_music` | Bakgrunnsmusikkbibliotek for polerte lydspor |
| `desc_pro_slowmo` | Slow motion på nøkkeløyeblikk |
| `desc_pro_longer` | Lengre prosjekter med flere klipp og bilder |
| `desc_pro_trial` | Prøv Pro gratis før du abonnerer — vilkårene vises tydelig i appen. |
| `desc_section_privacy` | PERSONVERN FØRST |
| `desc_privacy_body` | Redigeringen skjer helt på enheten din. Media forblir i fotobiblioteket ditt. Ingenting lastes opp noe sted med mindre du selv velger å dele. |
| `desc_privacy_url_line` | Personvernerklæring: https://okekedev.github.io/MovieMaker/privacy.html |
| `desc_terms_url_line` | Bruksvilkår: https://okekedev.github.io/MovieMaker/terms.html |
