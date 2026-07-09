# Movie Maker — User-Visible Strings Inventory

**Scope:** every user-visible string in Movie Maker v2.4, organized by view + the App Store Connect listing text.
**Ready for translation to 17 locales** matching WorldCup26's set: `ar, bs, cs, de-DE, es-MX, fa, fr-FR, hr, it, ja, ko, nb, nl, pt-BR, sv, tr, uz`.

**Counts:** 15 views · 89 unique app-side strings · 35 ASC listing keys.

---

## MediaSelectionView.swift (home)

| Key | Current English | Notes |
|---|---|---|
| `media_home_title` | Movie Maker | Main title on empty home state |
| `media_home_cta` | Tap to select videos & photos | Helper text below pulse button |
| `media_header_back` | Back | Button to deselect all media |
| `media_header_spin` | Spin | Daily spin button label |
| `media_section_title` | Select Your Moments | Section headline when media selected |
| `media_section_subtitle` | Tap to edit  \|  Hold to rearrange | Instruction text |
| `media_coin_balance_singular` | {count} coin left — 1 coin per export | count == 1 |
| `media_coin_balance_plural` | {count} coins left — 1 coin per export | count != 1 |
| `media_grid_add_more` | Add More | Button below media grid |
| `media_button_continue` | Continue | Primary CTA at bottom |
| `media_permission_alert_title` | Photo Access Required | Alert title |
| `media_permission_alert_open_settings` | Open Settings | Alert button |
| `media_permission_alert_cancel` | Cancel | Alert cancel button |
| `media_permission_alert_message` | Please allow Movie Maker to access your videos and photos in Settings to create compilations. | Alert message |

---

## SettingsView.swift (export options)

| Key | Current English | Notes |
|---|---|---|
| `settings_header_back` | Back | Back button |
| `settings_aspect_ratio_label` | Aspect Ratio | Section title |
| `settings_aspect_ratio_for_hint` | For {platform} | Subtext; {platform} = "YouTube", "Instagram", "Reels & TikTok" |
| `settings_title_screen_label` | Title Screen | Section title |
| `settings_title_required_label` | Title (Required) | Field label |
| `settings_title_placeholder` | Enter title | TextField placeholder |
| `settings_subtitle_label` | Subtitle (Optional) | Field label |
| `settings_subtitle_placeholder` | Enter subtitle | TextField placeholder |
| `settings_title_screen_hint` | White text on black background • 3 seconds | Instruction/note |
| `settings_title_screen_no_title` | No Title | Status when title empty |
| `settings_transition_style_label` | Transition Style | Section title |
| `settings_transition_color_label` | Transition Color | ColorPicker label |
| `settings_photo_duration_label` | Photo Duration | Section title |
| `settings_photo_duration_value` | {value} sec | Duration picker |
| `settings_background_music_label` | Background Music | Section title |
| `settings_music_select_button` | Select Music | Button to open music picker |
| `settings_music_volume_label` | Volume | Slider label |
| `settings_music_volume_percentage` | {value}% | Volume display |
| `settings_music_background_only_toggle` | Background Music Only | Toggle label |
| `settings_music_remove_button` | Remove Music | Button to clear selection |
| `settings_music_loop_hint` | Music will loop throughout the video | Note about looping |
| `settings_music_none_indicator` | None | Status when no music |
| `settings_preview_section_label` | Preview | Section title |
| `settings_preview_total_length` | Total length: {duration} | Formatted duration |
| `settings_preview_item_count_singular` | {count} item | count == 1 |
| `settings_preview_item_count_plural` | {count} items | count != 1 |
| `settings_create_button` | Create Video | Primary button |
| `settings_warning_alert_title` | Warning | Alert title for validation warnings |
| `settings_warning_long_videos_singular` | You have 1 video longer than 5 minutes. This may result in a very large file. | count == 1 |
| `settings_warning_long_videos_plural` | You have {count} videos longer than 5 minutes. This may result in a very large file. | count != 1 |
| `settings_warning_many_items_message` | You have {count} items. This may take several minutes to create. | Warning about many items |
| `settings_warning_create_anyway` | Create Anyway | Alert button to proceed |
| `settings_warning_cancel` | Cancel | Alert cancel button |
| `settings_pro_badge` | PRO | Pro tier badge |
| `settings_duration_min_sec` | {minutes} min {seconds} sec | Duration format for minutes > 0 |
| `settings_duration_sec_only` | {seconds} sec | Duration format for < 1 min |

---

## VideoCreationView.swift (export progress)

| Key | Current English | Notes |
|---|---|---|
| `video_creation_title` | Creating your video... | Main title during export |
| `video_creation_status_preparing` | Preparing... | Initial status |
| `video_creation_status_adding` | Adding videos... | Progress status (early) |
| `video_creation_status_composing` | Composing video... | Progress status (mid) |
| `video_creation_status_almost_done` | Almost done... | Progress status (late) |
| `video_creation_status_saving` | Saving to Photos... | Status during save |
| `video_creation_helper_text` | You can close the app - we'll notify you when it's ready | Reassurance text |
| `video_creation_error_alert_title` | Error | Alert title |
| `video_creation_error_alert_ok` | OK | Error alert button |

---

## CompletionView.swift (success screen)

| Key | Current English | Notes |
|---|---|---|
| `completion_title` | Video Created! | Success title |
| `completion_subtitle` | Your video has been saved to your photos. | Confirmation text |
| `completion_button_share` | Share Video | Share sheet button |
| `completion_button_open_photos` | Open Photos | Button to open Photos app |
| `completion_button_create_another` | Create Another Video | Button to reset and start over |

---

## PaywallView.swift (buy sheet)

| Key | Current English | Notes |
|---|---|---|
| `paywall_hero_unlimited` | Unlimited | Pro badge on hero |
| `paywall_hero_current_coins_label` | Current coins: | Free-tier label |
| `paywall_hero_coin_ratio` | 1 coin = 1 video | Explanation of coin model |
| `paywall_feature_music_title` | Background Music | Feature row |
| `paywall_feature_music_desc` | Add your own soundtrack | |
| `paywall_feature_slowmo_title` | Slow Motion | Feature row |
| `paywall_feature_slowmo_desc` | Cinematic slow-mo on any clip | |
| `paywall_feature_watermark_title` | No Watermark | Feature row |
| `paywall_feature_watermark_desc` | Export in full quality | |
| `paywall_coins_section_title` | Buy coins | Section header |
| `paywall_coins_tier_label` | {count} coins | Tier button (e.g. "5 coins") |
| `paywall_coins_tag_best_value` | Best value | Badge on 15-coin tier |
| `paywall_subscription_section_title` | Or go unlimited | Section header |
| `paywall_subscription_monthly_title` | Monthly | Subscription tier |
| `paywall_subscription_monthly_badge` | Save 43% | Discount badge |
| `paywall_subscription_yearly_title` | Yearly | Subscription tier |
| `paywall_subscription_yearly_badge` | Save 68% | Discount badge |
| `paywall_subscription_monthly_price` | {price} / month | {price} auto-formatted by StoreKit |
| `paywall_subscription_yearly_price` | {price} / year | {price} auto-formatted by StoreKit |
| `paywall_restore_purchases` | Restore Purchases | Button |
| `paywall_link_privacy` | Privacy | Link label |
| `paywall_link_terms` | Terms | Link label |
| `paywall_link_support` | Support | Link label |
| `paywall_not_now_button` | Not now | Dismiss button |
| `paywall_products_error_title` | Unable to load products | Error state |
| `paywall_products_error_retry` | Retry | Retry button |
| `paywall_purchase_error_title` | Purchase Error | Alert title |
| `paywall_purchase_error_message` | Unable to complete purchase. Please try again. | Error message |
| `paywall_purchase_error_ok` | OK | Alert button |
| `paywall_trial_badge` | {days}-day free trial | Trial offer badge |

---

## DailySpinView.swift (slot machine)

| Key | Current English | Notes |
|---|---|---|
| `spin_title` | Daily Spin | Screen title |
| `spin_subtitle_closed` | Come back tomorrow for another spin | Status when spin unavailable |
| `spin_rule_hint` | 3 🪙 = jackpot · 2 🪙 = prize | Rules hint below title |
| `spin_result_win_singular` | You won +1 coin! | count == 1 |
| `spin_result_win_plural` | You won +{count} coins! | count != 1 |
| `spin_subtitle_lose` | So close! Try again tomorrow | Lose message |
| `spin_status_rolling` | Rolling… | Status while spinning |
| `spin_button_spin` | Spin | Primary button |
| `spin_button_awesome` | Awesome | After a win |
| `spin_button_continue` | Continue | After a lose |
| `spin_button_close` | Close | Bottom close button |

---

## TrimmingView.swift

| Key | Current English | Notes |
|---|---|---|
| `trimming_video_loading` | Loading video... | Loading indicator |
| `trimming_toggle_slowmo` | Enable Slow-Mo | Toggle label |
| `trimming_toggle_mute` | Mute Video | Toggle label |
| `trimming_pro_badge` | PRO | Pro feature badge |
| `trimming_time_start` | Start: {time} | Trim start time display |
| `trimming_time_end` | End: {time} | Trim end time display |
| `trimming_button_done` | Done | Save trim + close |

---

## AppConfigurationView.swift

| Key | Current English | Notes |
|---|---|---|
| `app_config_title` | App Settings | Modal title |

---

## NotificationManager.swift

| Key | Current English | Notes |
|---|---|---|
| `notification_video_ready_title` | Video Compilation Ready! | Local push title |
| `notification_video_ready_body` | Your video has been saved to Photos | Local push body |

---

## Info.plist (bundle metadata)

| Key | Current English | Limit | Notes |
|---|---|---|---|
| `bundle_display_name` | Movie Maker | 30 | `CFBundleDisplayName` |
| `plist_photo_library_add_usage` | We need permission to save your compiled video to Photos | ≤100 | `NSPhotoLibraryAddUsageDescription` |
| `plist_photo_library_usage` | We need access to your videos and photos to create compilations | ≤100 | `NSPhotoLibraryUsageDescription` |

---

## App Store Connect Listing

| Key | Current English | Limit | Notes |
|---|---|---|---|
| `asc_app_name` | Movie Maker - Reels & YouTube | 30 | Stays brand-consistent across locales (like "Futbol Cup 2026 Tracker" did) |
| `asc_subtitle` | Videos for TikTok Reels Shorts | 30 | HIGH SEO impact — indexed per locale |
| `asc_keywords` | merger,joiner,trim,splice,montage,collage,splitter,reorder,photo,story,gif,video,combine,music | 100 | Comma-separated; HIGH SEO impact — indexed per locale, don't duplicate title/subtitle words |
| `asc_promotional_text` | Merge videos, photos, and music into one clean movie. Combine clips, trim, reorder, add a soundtrack, and export — no complex timeline, no learning curve. | 170 | Above-the-fold pitch |
| `asc_whats_new` | Now export in the perfect size for every platform. Pick 16:9 for YouTube, 9:16 for Reels & TikTok, or 1:1 for Instagram — then share straight from the app.\n\nFree tier is looser: 3 full exports on us, no watermark, no item cap. After that, top up with coins or go Pro monthly or yearly. | 4000 | v2.4 release notes |
| `asc_description` | *(full description ~1500 chars — see `description.txt`)* | 4000 | Below-the-fold pitch; segmented by section |

### Description structure (for translation)

Split the description into sections so translators can keep them balanced:

| Section | Current English |
|---|---|
| `desc_headline` | Merge videos, photos, and music into one clean movie — no complex timeline. |
| `desc_hook` | Movie Maker is the fastest way to combine clips, add a soundtrack, and export to your camera roll. Just drag, trim, and you're done. |
| `desc_section_what` | WHAT YOU CAN DO |
| `desc_what_merge` | Merge videos from your library into one movie — as many clips as you want. |
| `desc_what_combine` | Combine videos and photos in any order to build a slideshow with motion. |
| `desc_what_trim` | Trim the start and end of each clip so only the best moments remain. |
| `desc_what_reorder` | Drag to reorder scenes until the story feels right. |
| `desc_what_mute` | Mute clip audio when you want a quiet edit or music-only soundtrack. |
| `desc_what_export` | Export back to Photos in seconds, ready to share. |
| `desc_section_how` | HOW IT WORKS |
| `desc_how_1` | Pick clips and photos from your library. |
| `desc_how_2` | Reorder, trim, and mute as needed. |
| `desc_how_3` | Add music and export. |
| `desc_section_perfect_for` | PERFECT FOR |
| `desc_perfect_travel` | Travel recaps and vacation highlights |
| `desc_perfect_family` | Family moments and birthday compilations |
| `desc_perfect_events` | Event recaps from weddings, parties, games |
| `desc_perfect_social` | Social posts for Instagram, TikTok, and YouTube Shorts |
| `desc_perfect_slideshow` | Quick slideshows from a photo shoot |
| `desc_section_pro` | PRO FEATURES (OPTIONAL) |
| `desc_pro_music` | Background music library for polished soundtracks |
| `desc_pro_slowmo` | Slow motion on key moments |
| `desc_pro_longer` | Longer projects with more clips and photos |
| `desc_pro_trial` | Try Pro free before subscribing — terms shown clearly in the app. |
| `desc_section_privacy` | PRIVACY FIRST |
| `desc_privacy_body` | Editing happens entirely on your device. Your media stays in your photo library. Nothing uploads anywhere unless you choose to share. |
| `desc_privacy_url_line` | Privacy Policy: https://okekedev.github.io/MovieMaker/privacy.html |
| `desc_terms_url_line` | Terms of Use: https://okekedev.github.io/MovieMaker/terms.html |

---

## Notes for the translation pass

1. **Brand terms — leave in English**: `Movie Maker`, `Pro`, `Reels`, `YouTube`, `TikTok`, `Shorts`, `Instagram`. These are proper nouns / product names.

2. **Placeholders — preserve verbatim**: `{count}`, `{price}`, `{time}`, `{value}`, `{duration}`, `{platform}`, `{days}`, `{minutes}`, `{seconds}`. Do not translate the tokens themselves; only translate the surrounding text.

3. **URLs — never translate**: `https://okekedev.github.io/MovieMaker/privacy.html`, `https://okekedev.github.io/MovieMaker/terms.html`. These files are English-only for now.

4. **Character limits are HARD**:
   - App name (`bundle_display_name`, `asc_app_name`) — 30 chars
   - Subtitle (`asc_subtitle`) — 30 chars
   - Keywords (`asc_keywords`) — 100 chars total including commas
   - Promotional text (`asc_promotional_text`) — 170 chars
   - Description — 4000 chars
   - Photo permission strings — Apple recommends ≤ 100 chars

5. **Pluralization**: Follow each locale's plural rules (e.g., Russian has three plural forms; Arabic has six). Handle via `.stringsdict` or xcstrings variations.

6. **Keyword translation is high leverage** — each locale gets a fresh 100-char field. `es-MX` searches like "editor de video", "combinar videos" open up entirely new discovery paths that don't compete with English keywords.

7. **Right-to-left**: Arabic (`ar`) and Persian (`fa`) require RTL support. SwiftUI handles most of this automatically if you use semantic paddings (`.leading` / `.trailing`) instead of absolute (`.left` / `.right`).

8. **SF Symbols are language-agnostic** — leave symbol names like `film.fill`, `chevron.left` untouched in the codebase; they're read from the system font.

---

## Target locales (17)

| ASC code | Language | Region | RTL |
|---|---|---|---|
| `ar` | Arabic | Saudi Arabia (default) | yes |
| `bs` | Bosnian | Bosnia and Herzegovina | |
| `cs` | Czech | Czech Republic | |
| `de-DE` | German | Germany | |
| `es-MX` | Spanish | Mexico | |
| `fa` | Persian | Iran | yes |
| `fr-FR` | French | France | |
| `hr` | Croatian | Croatia | |
| `it` | Italian | Italy | |
| `ja` | Japanese | Japan | |
| `ko` | Korean | South Korea | |
| `nb` | Norwegian Bokmål | Norway | |
| `nl` | Dutch | Netherlands | |
| `pt-BR` | Portuguese | Brazil | |
| `sv` | Swedish | Sweden | |
| `tr` | Turkish | Turkey | |
| `uz` | Uzbek | Uzbekistan | |

*(Matches the 17-locale set used for WorldCup26; same tooling paths at `~/dev/wc/scripts/asc_localize_listings.py`.)*
