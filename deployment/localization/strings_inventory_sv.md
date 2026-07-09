# Movie Maker — Strings Inventory (sv)

**Locale:** sv — Swedish (Sweden)
**Direction:** LTR (not RTL)
**Plural forms:** 2 (one, other)
**Tone:** Standard Sweden Swedish, casual-friendly, modern app-style. Brand terms (Movie Maker, Pro, Reels, YouTube, TikTok, Shorts, Instagram, iPhone, iPad, Photos) stay in English.

---

## MediaSelectionView.swift (home)

| Key | Translated | Notes |
|---|---|---|
| `media_home_title` | Movie Maker | Main title on empty home state |
| `media_home_cta` | Tryck för att välja videor & foton | Helper text below pulse button |
| `media_header_back` | Tillbaka | Button to deselect all media |
| `media_header_spin` | Snurra | Daily spin button label |
| `media_section_title` | Välj dina stunder | Section headline when media selected |
| `media_section_subtitle` | Tryck för att redigera  \|  Håll för att ändra ordning | Instruction text |
| `media_coin_balance_singular` | {count} coin kvar — 1 coin per export | count == 1 |
| `media_coin_balance_plural` | {count} coins kvar — 1 coin per export | count != 1 |
| `media_grid_add_more` | Lägg till fler | Button below media grid |
| `media_button_continue` | Fortsätt | Primary CTA at bottom |
| `media_permission_alert_title` | Fotoåtkomst krävs | Alert title |
| `media_permission_alert_open_settings` | Öppna Inställningar | Alert button |
| `media_permission_alert_cancel` | Avbryt | Alert cancel button |
| `media_permission_alert_message` | Låt Movie Maker komma åt dina videor och foton i Inställningar för att skapa kompileringar. | Alert message |

---

## SettingsView.swift (export options)

| Key | Translated | Notes |
|---|---|---|
| `settings_header_back` | Tillbaka | Back button |
| `settings_aspect_ratio_label` | Bildförhållande | Section title |
| `settings_aspect_ratio_for_hint` | För {platform} | Subtext; {platform} = "YouTube", "Instagram", "Reels & TikTok" |
| `settings_title_screen_label` | Titelskärm | Section title |
| `settings_title_required_label` | Titel (Obligatorisk) | Field label |
| `settings_title_placeholder` | Ange titel | TextField placeholder |
| `settings_subtitle_label` | Undertitel (Valfri) | Field label |
| `settings_subtitle_placeholder` | Ange undertitel | TextField placeholder |
| `settings_title_screen_hint` | Vit text på svart bakgrund • 3 sekunder | Instruction/note |
| `settings_title_screen_no_title` | Ingen titel | Status when title empty |
| `settings_transition_style_label` | Övergångsstil | Section title |
| `settings_transition_color_label` | Övergångsfärg | ColorPicker label |
| `settings_photo_duration_label` | Fotolängd | Section title |
| `settings_photo_duration_value` | {value} sek | Duration picker |
| `settings_background_music_label` | Bakgrundsmusik | Section title |
| `settings_music_select_button` | Välj musik | Button to open music picker |
| `settings_music_volume_label` | Volym | Slider label |
| `settings_music_volume_percentage` | {value}% | Volume display |
| `settings_music_background_only_toggle` | Endast bakgrundsmusik | Toggle label |
| `settings_music_remove_button` | Ta bort musik | Button to clear selection |
| `settings_music_loop_hint` | Musiken loopar genom hela videon | Note about looping |
| `settings_music_none_indicator` | Ingen | Status when no music |
| `settings_preview_section_label` | Förhandsvisning | Section title |
| `settings_preview_total_length` | Total längd: {duration} | Formatted duration |
| `settings_preview_item_count_singular` | {count} objekt | count == 1 |
| `settings_preview_item_count_plural` | {count} objekt | count != 1 (sv: same form as singular for "objekt") |
| `settings_create_button` | Skapa video | Primary button |
| `settings_warning_alert_title` | Varning | Alert title for validation warnings |
| `settings_warning_long_videos_singular` | Du har 1 video som är längre än 5 minuter. Det kan bli en väldigt stor fil. | count == 1 |
| `settings_warning_long_videos_plural` | Du har {count} videor som är längre än 5 minuter. Det kan bli en väldigt stor fil. | count != 1 |
| `settings_warning_many_items_message` | Du har {count} objekt. Det kan ta flera minuter att skapa. | Warning about many items |
| `settings_warning_create_anyway` | Skapa ändå | Alert button to proceed |
| `settings_warning_cancel` | Avbryt | Alert cancel button |
| `settings_pro_badge` | PRO | Pro tier badge |
| `settings_duration_min_sec` | {minutes} min {seconds} sek | Duration format for minutes > 0 |
| `settings_duration_sec_only` | {seconds} sek | Duration format for < 1 min |

---

## VideoCreationView.swift (export progress)

| Key | Translated | Notes |
|---|---|---|
| `video_creation_title` | Skapar din video... | Main title during export |
| `video_creation_status_preparing` | Förbereder... | Initial status |
| `video_creation_status_adding` | Lägger till videor... | Progress status (early) |
| `video_creation_status_composing` | Sätter ihop videon... | Progress status (mid) |
| `video_creation_status_almost_done` | Snart klar... | Progress status (late) |
| `video_creation_status_saving` | Sparar till Photos... | Status during save |
| `video_creation_helper_text` | Du kan stänga appen — vi meddelar dig när den är klar | Reassurance text |
| `video_creation_error_alert_title` | Fel | Alert title |
| `video_creation_error_alert_ok` | OK | Error alert button |

---

## CompletionView.swift (success screen)

| Key | Translated | Notes |
|---|---|---|
| `completion_title` | Video skapad! | Success title |
| `completion_subtitle` | Din video har sparats bland dina foton. | Confirmation text |
| `completion_button_share` | Dela video | Share sheet button |
| `completion_button_open_photos` | Öppna Photos | Button to open Photos app |
| `completion_button_create_another` | Skapa en till video | Button to reset and start over |

---

## PaywallView.swift (buy sheet)

| Key | Translated | Notes |
|---|---|---|
| `paywall_hero_unlimited` | Obegränsat | Pro badge on hero |
| `paywall_hero_current_coins_label` | Nuvarande coins: | Free-tier label |
| `paywall_hero_coin_ratio` | 1 coin = 1 video | Explanation of coin model |
| `paywall_feature_music_title` | Bakgrundsmusik | Feature row |
| `paywall_feature_music_desc` | Lägg till ditt eget soundtrack | |
| `paywall_feature_slowmo_title` | Slow Motion | Feature row |
| `paywall_feature_slowmo_desc` | Filmisk slow-mo på valfri klipp | |
| `paywall_feature_watermark_title` | Ingen vattenstämpel | Feature row |
| `paywall_feature_watermark_desc` | Exportera i full kvalitet | |
| `paywall_coins_section_title` | Köp coins | Section header |
| `paywall_coins_tier_label` | {count} coins | Tier button (e.g. "5 coins") |
| `paywall_coins_tag_best_value` | Bästa värdet | Badge on 15-coin tier |
| `paywall_subscription_section_title` | Eller kör obegränsat | Section header |
| `paywall_subscription_monthly_title` | Månadsvis | Subscription tier |
| `paywall_subscription_monthly_badge` | Spara 43% | Discount badge |
| `paywall_subscription_yearly_title` | Årsvis | Subscription tier |
| `paywall_subscription_yearly_badge` | Spara 68% | Discount badge |
| `paywall_subscription_monthly_price` | {price} / månad | {price} auto-formatted by StoreKit |
| `paywall_subscription_yearly_price` | {price} / år | {price} auto-formatted by StoreKit |
| `paywall_restore_purchases` | Återställ köp | Button |
| `paywall_link_privacy` | Integritet | Link label |
| `paywall_link_terms` | Villkor | Link label |
| `paywall_link_support` | Support | Link label |
| `paywall_not_now_button` | Inte nu | Dismiss button |
| `paywall_products_error_title` | Kunde inte ladda produkter | Error state |
| `paywall_products_error_retry` | Försök igen | Retry button |
| `paywall_purchase_error_title` | Köpfel | Alert title |
| `paywall_purchase_error_message` | Kunde inte slutföra köpet. Försök igen. | Error message |
| `paywall_purchase_error_ok` | OK | Alert button |
| `paywall_trial_badge` | {days} dagars gratis provperiod | Trial offer badge |

---

## DailySpinView.swift (slot machine)

| Key | Translated | Notes |
|---|---|---|
| `spin_title` | Daglig snurr | Screen title |
| `spin_subtitle_closed` | Kom tillbaka imorgon för en ny snurr | Status when spin unavailable |
| `spin_rule_hint` | 3 🪙 = jackpot · 2 🪙 = vinst | Rules hint below title |
| `spin_result_win_singular` | Du vann +1 coin! | count == 1 |
| `spin_result_win_plural` | Du vann +{count} coins! | count != 1 |
| `spin_subtitle_lose` | Så nära! Försök igen imorgon | Lose message |
| `spin_status_rolling` | Snurrar… | Status while spinning |
| `spin_button_spin` | Snurra | Primary button |
| `spin_button_awesome` | Grymt | After a win |
| `spin_button_continue` | Fortsätt | After a lose |
| `spin_button_close` | Stäng | Bottom close button |

---

## TrimmingView.swift

| Key | Translated | Notes |
|---|---|---|
| `trimming_video_loading` | Laddar video... | Loading indicator |
| `trimming_toggle_slowmo` | Aktivera Slow-Mo | Toggle label |
| `trimming_toggle_mute` | Tysta video | Toggle label |
| `trimming_pro_badge` | PRO | Pro feature badge |
| `trimming_time_start` | Start: {time} | Trim start time display |
| `trimming_time_end` | Slut: {time} | Trim end time display |
| `trimming_button_done` | Klar | Save trim + close |

---

## AppConfigurationView.swift

| Key | Translated | Notes |
|---|---|---|
| `app_config_title` | Appinställningar | Modal title |

---

## NotificationManager.swift

| Key | Translated | Notes |
|---|---|---|
| `notification_video_ready_title` | Videokompilering klar! | Local push title |
| `notification_video_ready_body` | Din video har sparats till Photos | Local push body |

---

## Info.plist (bundle metadata)

| Key | Translated | Limit | Notes |
|---|---|---|---|
| `bundle_display_name` | Movie Maker | 30 | `CFBundleDisplayName` — brand |
| `plist_photo_library_add_usage` | Vi behöver åtkomst för att spara din färdiga video till Photos. | ≤100 | 63 chars |
| `plist_photo_library_usage` | Vi behöver åtkomst till dina videor och foton för att skapa kompileringar. | ≤100 | 74 chars |

---

## App Store Connect Listing

| Key | Translated | Limit | Notes |
|---|---|---|---|
| `asc_app_name` | Movie Maker - Reels & YouTube | 30 | Brand-consistent, kept as-is |
| `asc_subtitle` | Videor för TikTok & Reels | 30 | 25 chars |
| `asc_keywords` | video editor,slå ihop videor,videoredigering,filmredigerare,montage,reels,tiktok,youtube,shorts | 100 | 95 chars incl. commas — SV search intent |
| `asc_promotional_text` | Slå ihop videor, foton och musik till en snygg film. Kombinera klipp, trimma, ändra ordning, lägg till ett soundtrack och exportera — utan komplicerad tidslinje. | 170 | 160 chars |
| `asc_whats_new` | Exportera nu i perfekt format för varje plattform. Välj 16:9 för YouTube, 9:16 för Reels & TikTok eller 1:1 för Instagram — och dela direkt från appen.\n\nGratisnivån är generösare: 3 fullständiga exporter gratis, ingen vattenstämpel, ingen gräns för antal klipp. Sedan fyller du på med coins eller kör Pro månadsvis eller årsvis. | 4000 | v2.4 release notes |
| `asc_description` | *(fullständig beskrivning — se avsnittet nedan)* | 4000 | Sektionsvis nedan |

### Description structure (for translation)

| Section | Translated |
|---|---|
| `desc_headline` | Slå ihop videor, foton och musik till en snygg film — utan komplicerad tidslinje. |
| `desc_hook` | Movie Maker är det snabbaste sättet att kombinera klipp, lägga till ett soundtrack och exportera till din kamerarulle. Dra, trimma — klart. |
| `desc_section_what` | VAD DU KAN GÖRA |
| `desc_what_merge` | Slå ihop videor från ditt bibliotek till en film — så många klipp du vill. |
| `desc_what_combine` | Kombinera videor och foton i valfri ordning för ett bildspel med rörelse. |
| `desc_what_trim` | Trimma början och slutet av varje klipp så att bara de bästa stunderna finns kvar. |
| `desc_what_reorder` | Dra för att ändra ordning på scener tills berättelsen känns rätt. |
| `desc_what_mute` | Tysta klippljudet när du vill ha en tyst redigering eller bara musik som soundtrack. |
| `desc_what_export` | Exportera tillbaka till Photos på några sekunder, redo att dela. |
| `desc_section_how` | SÅ FUNKAR DET |
| `desc_how_1` | Välj klipp och foton från ditt bibliotek. |
| `desc_how_2` | Ändra ordning, trimma och tysta efter behov. |
| `desc_how_3` | Lägg till musik och exportera. |
| `desc_section_perfect_for` | PERFEKT FÖR |
| `desc_perfect_travel` | Resesammanfattningar och semesterhöjdpunkter |
| `desc_perfect_family` | Familjestunder och födelsedagskompileringar |
| `desc_perfect_events` | Eventrecap från bröllop, fester, matcher |
| `desc_perfect_social` | Sociala inlägg för Instagram, TikTok och YouTube Shorts |
| `desc_perfect_slideshow` | Snabba bildspel från en fotografering |
| `desc_section_pro` | PRO-FUNKTIONER (VALFRITT) |
| `desc_pro_music` | Bakgrundsmusikbibliotek för polerade soundtrack |
| `desc_pro_slowmo` | Slow motion på nyckelstunder |
| `desc_pro_longer` | Längre projekt med fler klipp och foton |
| `desc_pro_trial` | Prova Pro gratis innan du prenumererar — villkoren visas tydligt i appen. |
| `desc_section_privacy` | INTEGRITET FÖRST |
| `desc_privacy_body` | Redigeringen sker helt på din enhet. Ditt media stannar i ditt fotobibliotek. Inget laddas upp någonstans om du inte själv väljer att dela. |
| `desc_privacy_url_line` | Integritetspolicy: https://okekedev.github.io/MovieMaker/privacy.html |
| `desc_terms_url_line` | Användarvillkor: https://okekedev.github.io/MovieMaker/terms.html |
