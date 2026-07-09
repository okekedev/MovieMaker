# Movie Maker — فهرست رشته‌های قابل مشاهدهٔ کاربر (fa)

**Locale:** `fa` (Persian / Farsi, Iran — Standard Iranian Persian)
**Script:** Persian (Perso-Arabic) + Latin brand names (embedded LTR runs handled by iOS Bidi)
**Direction:** RTL
**Plural forms:** Persian has **2 plural forms** (CLDR: `one` and `other`). The `_singular` variants map to `one`; the `_plural` variants map to `other`.

**Brand terms kept in English (Latin, LTR):** Movie Maker, Pro, Reels, YouTube, TikTok, Shorts, Instagram, iPhone, iPad, Photos.

**Register:** Standard Iranian Persian, polite/neutral. Not Dari (Afghanistan) or Tajik. Uses ی and ک (not ي and ك — those are Arabic).

**Punctuation:** Persian comma ، and Persian question mark ؟ used where natural. English colons, dashes, and periods retained where they attach to Latin brand names or URLs.

---

## MediaSelectionView.swift (home)

| Key | Persian | Notes |
|---|---|---|
| `media_home_title` | Movie Maker | Main title on empty home state |
| `media_home_cta` | برای انتخاب ویدیو و عکس لمس کنید | Helper text below pulse button |
| `media_header_back` | بازگشت | Button to deselect all media |
| `media_header_spin` | چرخش | Daily spin button label |
| `media_section_title` | لحظه‌هایتان را انتخاب کنید | Section headline when media selected |
| `media_section_subtitle` | برای ویرایش لمس کنید  \|  برای جابه‌جایی نگه دارید | Instruction text |
| `media_coin_balance_singular` | {count} سکه باقی مانده — هر خروجی ۱ سکه | count == 1 |
| `media_coin_balance_plural` | {count} سکه باقی مانده — هر خروجی ۱ سکه | count != 1 (Persian noun stays uninflected after numeral) |
| `media_grid_add_more` | افزودن بیشتر | Button below media grid |
| `media_button_continue` | ادامه | Primary CTA at bottom |
| `media_permission_alert_title` | دسترسی به عکس‌ها لازم است | Alert title |
| `media_permission_alert_open_settings` | باز کردن تنظیمات | Alert button |
| `media_permission_alert_cancel` | لغو | Alert cancel button |
| `media_permission_alert_message` | برای ساخت کلیپ، لطفاً از تنظیمات به Movie Maker اجازهٔ دسترسی به ویدیوها و عکس‌هایتان را بدهید. | Alert message |

---

## SettingsView.swift (export options)

| Key | Persian | Notes |
|---|---|---|
| `settings_header_back` | بازگشت | Back button |
| `settings_aspect_ratio_label` | نسبت تصویر | Section title |
| `settings_aspect_ratio_for_hint` | برای {platform} | Subtext; {platform} = "YouTube", "Instagram", "Reels & TikTok" |
| `settings_title_screen_label` | صفحهٔ عنوان | Section title |
| `settings_title_required_label` | عنوان (الزامی) | Field label |
| `settings_title_placeholder` | عنوان را وارد کنید | TextField placeholder |
| `settings_subtitle_label` | زیرعنوان (اختیاری) | Field label |
| `settings_subtitle_placeholder` | زیرعنوان را وارد کنید | TextField placeholder |
| `settings_title_screen_hint` | متن سفید روی زمینهٔ سیاه • ۳ ثانیه | Instruction/note |
| `settings_title_screen_no_title` | بدون عنوان | Status when title empty |
| `settings_transition_style_label` | سبک گذار | Section title |
| `settings_transition_color_label` | رنگ گذار | ColorPicker label |
| `settings_photo_duration_label` | مدت نمایش عکس | Section title |
| `settings_photo_duration_value` | {value} ثانیه | Duration picker |
| `settings_background_music_label` | موسیقی پس‌زمینه | Section title |
| `settings_music_select_button` | انتخاب موسیقی | Button to open music picker |
| `settings_music_volume_label` | بلندی صدا | Slider label |
| `settings_music_volume_percentage` | ٪{value} | Volume display (Persian convention: percent sign precedes) |
| `settings_music_background_only_toggle` | فقط موسیقی پس‌زمینه | Toggle label |
| `settings_music_remove_button` | حذف موسیقی | Button to clear selection |
| `settings_music_loop_hint` | موسیقی در تمام ویدیو تکرار می‌شود | Note about looping |
| `settings_music_none_indicator` | هیچ | Status when no music |
| `settings_preview_section_label` | پیش‌نمایش | Section title |
| `settings_preview_total_length` | مدت کل: {duration} | Formatted duration |
| `settings_preview_item_count_singular` | {count} مورد | count == 1 |
| `settings_preview_item_count_plural` | {count} مورد | count != 1 (noun stays singular after numeral in fa) |
| `settings_create_button` | ساخت ویدیو | Primary button |
| `settings_warning_alert_title` | هشدار | Alert title for validation warnings |
| `settings_warning_long_videos_singular` | ۱ ویدیوی طولانی‌تر از ۵ دقیقه دارید. ممکن است فایل خیلی بزرگ شود. | count == 1 |
| `settings_warning_long_videos_plural` | {count} ویدیوی طولانی‌تر از ۵ دقیقه دارید. ممکن است فایل خیلی بزرگ شود. | count != 1 |
| `settings_warning_many_items_message` | {count} مورد دارید. ساخت ممکن است چند دقیقه طول بکشد. | Warning about many items |
| `settings_warning_create_anyway` | با این حال بساز | Alert button to proceed |
| `settings_warning_cancel` | لغو | Alert cancel button |
| `settings_pro_badge` | PRO | Pro tier badge (kept English) |
| `settings_duration_min_sec` | {minutes} دقیقه {seconds} ثانیه | Duration format for minutes > 0 |
| `settings_duration_sec_only` | {seconds} ثانیه | Duration format for < 1 min |

---

## VideoCreationView.swift (export progress)

| Key | Persian | Notes |
|---|---|---|
| `video_creation_title` | در حال ساخت ویدیو... | Main title during export |
| `video_creation_status_preparing` | در حال آماده‌سازی... | Initial status |
| `video_creation_status_adding` | در حال افزودن ویدیوها... | Progress status (early) |
| `video_creation_status_composing` | در حال تنظیم ویدیو... | Progress status (mid) |
| `video_creation_status_almost_done` | تقریباً تمام شد... | Progress status (late) |
| `video_creation_status_saving` | در حال ذخیره در Photos... | Status during save |
| `video_creation_helper_text` | می‌توانید برنامه را ببندید — پس از آماده شدن به شما اطلاع می‌دهیم | Reassurance text |
| `video_creation_error_alert_title` | خطا | Alert title |
| `video_creation_error_alert_ok` | باشه | Error alert button |

---

## CompletionView.swift (success screen)

| Key | Persian | Notes |
|---|---|---|
| `completion_title` | ویدیو ساخته شد! | Success title |
| `completion_subtitle` | ویدیوی شما در Photos ذخیره شد. | Confirmation text |
| `completion_button_share` | اشتراک‌گذاری ویدیو | Share sheet button |
| `completion_button_open_photos` | باز کردن Photos | Button to open Photos app |
| `completion_button_create_another` | ساخت ویدیوی دیگر | Button to reset and start over |

---

## PaywallView.swift (buy sheet)

| Key | Persian | Notes |
|---|---|---|
| `paywall_hero_unlimited` | نامحدود | Pro badge on hero |
| `paywall_hero_current_coins_label` | سکه‌های فعلی: | Free-tier label |
| `paywall_hero_coin_ratio` | ۱ سکه = ۱ ویدیو | Explanation of coin model |
| `paywall_feature_music_title` | موسیقی پس‌زمینه | Feature row |
| `paywall_feature_music_desc` | موسیقی دلخواه خود را اضافه کنید | |
| `paywall_feature_slowmo_title` | حرکت آهسته | Feature row |
| `paywall_feature_slowmo_desc` | اسلوموی سینمایی روی هر کلیپ | |
| `paywall_feature_watermark_title` | بدون واترمارک | Feature row |
| `paywall_feature_watermark_desc` | خروجی با بالاترین کیفیت | |
| `paywall_coins_section_title` | خرید سکه | Section header |
| `paywall_coins_tier_label` | {count} سکه | Tier button (e.g. "۵ سکه") |
| `paywall_coins_tag_best_value` | بهترین ارزش | Badge on 15-coin tier |
| `paywall_subscription_section_title` | یا نامحدود شوید | Section header |
| `paywall_subscription_monthly_title` | ماهانه | Subscription tier |
| `paywall_subscription_monthly_badge` | ٪۴۳ تخفیف | Discount badge |
| `paywall_subscription_yearly_title` | سالانه | Subscription tier |
| `paywall_subscription_yearly_badge` | ٪۶۸ تخفیف | Discount badge |
| `paywall_subscription_monthly_price` | {price} / ماه | {price} auto-formatted by StoreKit |
| `paywall_subscription_yearly_price` | {price} / سال | {price} auto-formatted by StoreKit |
| `paywall_restore_purchases` | بازیابی خریدها | Button |
| `paywall_link_privacy` | حریم خصوصی | Link label |
| `paywall_link_terms` | شرایط | Link label |
| `paywall_link_support` | پشتیبانی | Link label |
| `paywall_not_now_button` | حالا نه | Dismiss button |
| `paywall_products_error_title` | بارگذاری محصولات ممکن نشد | Error state |
| `paywall_products_error_retry` | تلاش دوباره | Retry button |
| `paywall_purchase_error_title` | خطای خرید | Alert title |
| `paywall_purchase_error_message` | تکمیل خرید ممکن نشد. لطفاً دوباره تلاش کنید. | Error message |
| `paywall_purchase_error_ok` | باشه | Alert button |
| `paywall_trial_badge` | {days} روز آزمایش رایگان | Trial offer badge |

---

## DailySpinView.swift (slot machine)

| Key | Persian | Notes |
|---|---|---|
| `spin_title` | چرخش روزانه | Screen title |
| `spin_subtitle_closed` | فردا دوباره برای چرخش سر بزنید | Status when spin unavailable |
| `spin_rule_hint` | ۳ 🪙 = جکپات · ۲ 🪙 = جایزه | Rules hint below title |
| `spin_result_win_singular` | ۱ سکه بردید! | count == 1 |
| `spin_result_win_plural` | +{count} سکه بردید! | count != 1 |
| `spin_subtitle_lose` | نزدیک بود! فردا دوباره امتحان کنید | Lose message |
| `spin_status_rolling` | در حال چرخش… | Status while spinning |
| `spin_button_spin` | چرخش | Primary button |
| `spin_button_awesome` | عالی | After a win |
| `spin_button_continue` | ادامه | After a lose |
| `spin_button_close` | بستن | Bottom close button |

---

## TrimmingView.swift

| Key | Persian | Notes |
|---|---|---|
| `trimming_video_loading` | در حال بارگذاری ویدیو... | Loading indicator |
| `trimming_toggle_slowmo` | فعال کردن حرکت آهسته | Toggle label |
| `trimming_toggle_mute` | بی‌صدا کردن ویدیو | Toggle label |
| `trimming_pro_badge` | PRO | Pro feature badge |
| `trimming_time_start` | شروع: {time} | Trim start time display |
| `trimming_time_end` | پایان: {time} | Trim end time display |
| `trimming_button_done` | انجام شد | Save trim + close |

---

## AppConfigurationView.swift

| Key | Persian | Notes |
|---|---|---|
| `app_config_title` | تنظیمات برنامه | Modal title |

---

## NotificationManager.swift

| Key | Persian | Notes |
|---|---|---|
| `notification_video_ready_title` | ویدیو آماده است! | Local push title |
| `notification_video_ready_body` | ویدیوی شما در Photos ذخیره شد | Local push body |

---

## Info.plist (bundle metadata)

| Key | Persian | Limit | Notes |
|---|---|---|---|
| `bundle_display_name` | Movie Maker | 30 | `CFBundleDisplayName` (brand — English) |
| `plist_photo_library_add_usage` | برای ذخیرهٔ ویدیوی ساخته‌شده در Photos به اجازه نیاز داریم | ≤100 | 55 chars — well under limit |
| `plist_photo_library_usage` | برای ساخت کلیپ به دسترسی به ویدیوها و عکس‌های شما نیاز داریم | ≤100 | 58 chars — well under limit |

---

## App Store Connect Listing

| Key | Persian | Limit | Notes |
|---|---|---|---|
| `asc_app_name` | Movie Maker - Reels & YouTube | 30 | KEPT AS IS — brand consistency across locales |
| `asc_subtitle` | ادغام ویدیو و عکس با موسیقی | 30 | 28 chars — value prop in dense Persian |
| `asc_keywords` | ادیت ویدیو,ادغام ویدیو,کلیپ ساز,میکس عکس,اسلایدشو,ریلز,شورتس,تیک تاک,اینستاگرام,وی لاگ,موسیقی,برش | 100 | Persian-first: ادیت, کلیپ ساز, میکس are how Iranian users actually search; platform names transliterated (ریلز، شورتس، تیک تاک، اینستاگرام، وی لاگ) |
| `asc_promotional_text` | ویدیو، عکس و موسیقی را در یک فیلم زیبا ادغام کنید. کلیپ‌ها را ترکیب، برش، جابه‌جا، موسیقی اضافه و خروجی بگیرید — بدون تایم‌لاین پیچیده. | 170 | 133 chars — punchy Persian pitch |
| `asc_whats_new` | حالا می‌توانید برای هر پلتفرم با اندازهٔ مناسب خروجی بگیرید. ۱۶:۹ برای YouTube، ۹:۱۶ برای Reels & TikTok، یا ۱:۱ برای Instagram را انتخاب کنید و مستقیم از برنامه به اشتراک بگذارید.\n\nپلن رایگان دست‌ودل‌بازتر شد: ۳ خروجی کامل بدون واترمارک و بدون محدودیت تعداد. پس از آن با سکه شارژ کنید یا به Pro ماهانه یا سالانه ارتقا دهید. | 4000 | v2.4 release notes |
| `asc_description` | *(متن کامل ~۱۵۰۰ حرف — بخش‌بندی در `description_fa.txt`)* | 4000 | Below-the-fold pitch; segmented by section |

### Description structure (translated)

| Section | Persian |
|---|---|
| `desc_headline` | ویدیو، عکس و موسیقی را در یک فیلم زیبا ادغام کنید — بدون تایم‌لاین پیچیده. |
| `desc_hook` | Movie Maker سریع‌ترین راه ترکیب کلیپ‌ها، افزودن موسیقی و خروجی گرفتن به آلبوم دوربین است. فقط بکشید، برش بزنید و تمام. |
| `desc_section_what` | چه کارهایی می‌توانید انجام دهید |
| `desc_what_merge` | ویدیوهای کتابخانه‌تان را در یک فیلم ادغام کنید — بدون محدودیت در تعداد کلیپ. |
| `desc_what_combine` | ویدیو و عکس را با هر ترتیبی ترکیب کنید تا اسلایدشویی متحرک بسازید. |
| `desc_what_trim` | ابتدا و انتهای هر کلیپ را برش بزنید تا فقط بهترین لحظه‌ها بمانند. |
| `desc_what_reorder` | صحنه‌ها را بکشید و جابه‌جا کنید تا داستان درست شود. |
| `desc_what_mute` | وقتی می‌خواهید ادیت آرام یا فقط با موسیقی باشد، صدای کلیپ را بی‌صدا کنید. |
| `desc_what_export` | در چند ثانیه به Photos خروجی بگیرید، آمادهٔ اشتراک‌گذاری. |
| `desc_section_how` | نحوهٔ کار |
| `desc_how_1` | کلیپ‌ها و عکس‌ها را از کتابخانه انتخاب کنید. |
| `desc_how_2` | جابه‌جا کنید، برش بزنید و در صورت نیاز بی‌صدا کنید. |
| `desc_how_3` | موسیقی اضافه کنید و خروجی بگیرید. |
| `desc_section_perfect_for` | مناسب برای |
| `desc_perfect_travel` | جمع‌بندی سفر و لحظات برجستهٔ تعطیلات |
| `desc_perfect_family` | لحظات خانوادگی و کلیپ‌های تولد |
| `desc_perfect_events` | جمع‌بندی مراسم عروسی، مهمانی‌ها و بازی‌ها |
| `desc_perfect_social` | پست‌های شبکه‌های اجتماعی برای Instagram، TikTok و YouTube Shorts |
| `desc_perfect_slideshow` | اسلایدشوهای سریع از یک عکاسی |
| `desc_section_pro` | ویژگی‌های PRO (اختیاری) |
| `desc_pro_music` | کتابخانهٔ موسیقی پس‌زمینه برای موسیقی متن حرفه‌ای |
| `desc_pro_slowmo` | حرکت آهسته در لحظه‌های کلیدی |
| `desc_pro_longer` | پروژه‌های بلندتر با کلیپ‌ها و عکس‌های بیشتر |
| `desc_pro_trial` | قبل از اشتراک، Pro را رایگان امتحان کنید — شرایط در برنامه به‌وضوح نمایش داده می‌شود. |
| `desc_section_privacy` | حریم خصوصی در اولویت |
| `desc_privacy_body` | ویرایش کاملاً روی دستگاه شما انجام می‌شود. رسانه‌های شما در کتابخانهٔ عکس باقی می‌مانند. هیچ چیز جایی آپلود نمی‌شود مگر اینکه خودتان اشتراک بگذارید. |
| `desc_privacy_url_line` | سیاست حریم خصوصی: https://okekedev.github.io/MovieMaker/privacy.html |
| `desc_terms_url_line` | شرایط استفاده: https://okekedev.github.io/MovieMaker/terms.html |

---

## Translation notes (fa)

1. **Two plural forms:** Persian's CLDR categories are `one` and `other`. In practice, nouns after a numeral in Persian stay uninflected (singular form), so many `_singular` and `_plural` variants end up identical in surface form. Where they differ (e.g., "۱ سکه بردید!" vs "+{count} سکه بردید!"), the difference is contextual copy, not grammatical inflection.
2. **Persian vs Arabic letters:** used ی (Persian yeh) and ک (Persian kaf) throughout — NOT the Arabic ي / ك. This is a common quality signal for native Persian speakers.
3. **Numerals in body copy:** used Persian digits (۰-۹) in body copy and instruction text (e.g., ۳ ثانیه, ۵ دقیقه) but kept ASCII digits inside placeholders (`{count}`, `{days}`) since those are substituted by the app at runtime. StoreKit-formatted `{price}` handles its own locale numerals.
4. **Percent sign convention:** Persian typically writes ٪ before the number (٪۴۳) — differs from English 43%. Applied in paywall badges and volume display.
5. **Register:** neutral polite Iranian Persian. Used می‌کنید / لطفاً for user-facing directives. Avoided both bureaucratic فرمایید and overly casual می‌کنی.
6. **Subtitle:** ادغام ویدیو و عکس با موسیقی (28 chars) — "merge video and photos with music", packs the value prop.
7. **Keywords:** Persian-first search behavior. ادیت (loanword from "edit"), کلیپ ساز (clip maker — very common IR search), میکس (mix), اسلایدشو (slideshow), وی لاگ (vlog) all reflect actual query patterns on the Iranian App Store. Platform names transliterated (تیک تاک، ریلز، شورتس، اینستاگرام) since Persian users search that way; Latin brand names remain indexed via title/subtitle.
8. **Bidi mixing:** brand names (Movie Maker, YouTube, Reels & TikTok, Instagram, Pro, PRO, Photos) embedded LTR — iOS handles Bidi bracketing.
9. **Time units:** ثانیه (second), دقیقه (minute) — full words used since Persian doesn't have widely accepted single-letter abbreviations like Arabic's ث/د.
10. **Alert "OK":** used باشه (colloquial-neutral) for dismiss buttons — friendlier than the more formal بسیار خب. Fits consumer app tone.
