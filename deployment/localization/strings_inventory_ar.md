# Movie Maker — قائمة النصوص المرئية للمستخدم (ar)

**Locale:** `ar` (Arabic, default region Saudi Arabia — Modern Standard Arabic / فصحى)
**Script:** Arabic + Latin brand names (embedded LTR runs handled by iOS Bidi)
**Direction:** RTL
**Plural forms:** Arabic has **six CLDR plural categories** — zero, one, two, few (3–10), many (11–99), other (100+). Producing all six per key is impractical for MVP.

**MVP compromise:** each `_singular` key carries the one-form; each `_plural` key carries a **generic plural form** that reads naturally for "few" and "many" and is the safe default when routing through `.stringsdict`. When wiring up the actual `.stringsdict`, treat the `_plural` string as the `other` category and add `one`, `two`, `few`, `many` variants derived from it if/when translator budget allows. The `zero` case falls back to `other` and reads acceptably.

**Brand terms kept in English (Latin, LTR):** Movie Maker, Pro, Reels, YouTube, TikTok, Shorts, Instagram, iPhone, iPad, Photos.

**Punctuation:** Arabic comma ، and Arabic question mark ؟ used where natural. English punctuation (colons, periods) kept where sentences are structurally Latin (URLs, brand names).

---

## MediaSelectionView.swift (home)

| Key | Arabic | Notes |
|---|---|---|
| `media_home_title` | Movie Maker | Main title on empty home state |
| `media_home_cta` | انقر لاختيار الفيديوهات والصور | Helper text below pulse button |
| `media_header_back` | رجوع | Button to deselect all media |
| `media_header_spin` | لفة | Daily spin button label |
| `media_section_title` | اختر لحظاتك | Section headline when media selected |
| `media_section_subtitle` | انقر للتعديل  \|  اضغط مطولاً لإعادة الترتيب | Instruction text |
| `media_coin_balance_singular` | تبقى {count} عملة — عملة واحدة لكل تصدير | count == 1 |
| `media_coin_balance_plural` | تبقى {count} عملات — عملة واحدة لكل تصدير | count != 1 (generic plural — see header) |
| `media_grid_add_more` | إضافة المزيد | Button below media grid |
| `media_button_continue` | متابعة | Primary CTA at bottom |
| `media_permission_alert_title` | يلزم الوصول إلى الصور | Alert title |
| `media_permission_alert_open_settings` | فتح الإعدادات | Alert button |
| `media_permission_alert_cancel` | إلغاء | Alert cancel button |
| `media_permission_alert_message` | يُرجى السماح لـ Movie Maker بالوصول إلى فيديوهاتك وصورك من الإعدادات لإنشاء المونتاجات. | Alert message |

---

## SettingsView.swift (export options)

| Key | Arabic | Notes |
|---|---|---|
| `settings_header_back` | رجوع | Back button |
| `settings_aspect_ratio_label` | نسبة العرض إلى الارتفاع | Section title |
| `settings_aspect_ratio_for_hint` | لـ {platform} | Subtext; {platform} = "YouTube", "Instagram", "Reels & TikTok" |
| `settings_title_screen_label` | شاشة العنوان | Section title |
| `settings_title_required_label` | العنوان (إلزامي) | Field label |
| `settings_title_placeholder` | أدخل العنوان | TextField placeholder |
| `settings_subtitle_label` | العنوان الفرعي (اختياري) | Field label |
| `settings_subtitle_placeholder` | أدخل العنوان الفرعي | TextField placeholder |
| `settings_title_screen_hint` | نص أبيض على خلفية سوداء • 3 ثوانٍ | Instruction/note |
| `settings_title_screen_no_title` | بدون عنوان | Status when title empty |
| `settings_transition_style_label` | نمط الانتقال | Section title |
| `settings_transition_color_label` | لون الانتقال | ColorPicker label |
| `settings_photo_duration_label` | مدة عرض الصورة | Section title |
| `settings_photo_duration_value` | {value} ث | Duration picker (ث = ثانية) |
| `settings_background_music_label` | موسيقى الخلفية | Section title |
| `settings_music_select_button` | اختيار الموسيقى | Button to open music picker |
| `settings_music_volume_label` | مستوى الصوت | Slider label |
| `settings_music_volume_percentage` | {value}% | Volume display |
| `settings_music_background_only_toggle` | موسيقى الخلفية فقط | Toggle label |
| `settings_music_remove_button` | إزالة الموسيقى | Button to clear selection |
| `settings_music_loop_hint` | ستُكرَّر الموسيقى طوال الفيديو | Note about looping |
| `settings_music_none_indicator` | لا شيء | Status when no music |
| `settings_preview_section_label` | معاينة | Section title |
| `settings_preview_total_length` | المدة الإجمالية: {duration} | Formatted duration |
| `settings_preview_item_count_singular` | عنصر واحد | count == 1 (one form) |
| `settings_preview_item_count_plural` | {count} عنصر | count != 1 (generic plural — see header) |
| `settings_create_button` | إنشاء الفيديو | Primary button |
| `settings_warning_alert_title` | تحذير | Alert title for validation warnings |
| `settings_warning_long_videos_singular` | لديك فيديو واحد أطول من 5 دقائق. قد يؤدي ذلك إلى ملف كبير جداً. | count == 1 |
| `settings_warning_long_videos_plural` | لديك {count} فيديوهات أطول من 5 دقائق. قد يؤدي ذلك إلى ملف كبير جداً. | count != 1 (generic plural) |
| `settings_warning_many_items_message` | لديك {count} عنصراً. قد يستغرق الإنشاء عدة دقائق. | Warning about many items |
| `settings_warning_create_anyway` | إنشاء على أي حال | Alert button to proceed |
| `settings_warning_cancel` | إلغاء | Alert cancel button |
| `settings_pro_badge` | PRO | Pro tier badge (kept English) |
| `settings_duration_min_sec` | {minutes} د {seconds} ث | Duration format for minutes > 0 (د = دقيقة، ث = ثانية) |
| `settings_duration_sec_only` | {seconds} ث | Duration format for < 1 min |

---

## VideoCreationView.swift (export progress)

| Key | Arabic | Notes |
|---|---|---|
| `video_creation_title` | جارٍ إنشاء الفيديو... | Main title during export |
| `video_creation_status_preparing` | جارٍ التحضير... | Initial status |
| `video_creation_status_adding` | جارٍ إضافة الفيديوهات... | Progress status (early) |
| `video_creation_status_composing` | جارٍ تركيب الفيديو... | Progress status (mid) |
| `video_creation_status_almost_done` | اقترب الانتهاء... | Progress status (late) |
| `video_creation_status_saving` | جارٍ الحفظ في Photos... | Status during save |
| `video_creation_helper_text` | يمكنك إغلاق التطبيق — سنُعلمك عند الانتهاء | Reassurance text |
| `video_creation_error_alert_title` | خطأ | Alert title |
| `video_creation_error_alert_ok` | حسناً | Error alert button |

---

## CompletionView.swift (success screen)

| Key | Arabic | Notes |
|---|---|---|
| `completion_title` | تم إنشاء الفيديو! | Success title |
| `completion_subtitle` | تم حفظ الفيديو في Photos. | Confirmation text |
| `completion_button_share` | مشاركة الفيديو | Share sheet button |
| `completion_button_open_photos` | فتح Photos | Button to open Photos app |
| `completion_button_create_another` | إنشاء فيديو آخر | Button to reset and start over |

---

## PaywallView.swift (buy sheet)

| Key | Arabic | Notes |
|---|---|---|
| `paywall_hero_unlimited` | بلا حدود | Pro badge on hero |
| `paywall_hero_current_coins_label` | العملات الحالية: | Free-tier label |
| `paywall_hero_coin_ratio` | عملة واحدة = فيديو واحد | Explanation of coin model |
| `paywall_feature_music_title` | موسيقى الخلفية | Feature row |
| `paywall_feature_music_desc` | أضف موسيقاك الخاصة | |
| `paywall_feature_slowmo_title` | حركة بطيئة | Feature row |
| `paywall_feature_slowmo_desc` | حركة بطيئة سينمائية على أي مقطع | |
| `paywall_feature_watermark_title` | بدون علامة مائية | Feature row |
| `paywall_feature_watermark_desc` | صدِّر بأعلى جودة | |
| `paywall_coins_section_title` | شراء العملات | Section header |
| `paywall_coins_tier_label` | {count} عملة | Tier button (uses generic form; localizer can expand) |
| `paywall_coins_tag_best_value` | الأفضل قيمة | Badge on 15-coin tier |
| `paywall_subscription_section_title` | أو انتقل إلى غير المحدود | Section header |
| `paywall_subscription_monthly_title` | شهري | Subscription tier |
| `paywall_subscription_monthly_badge` | وفّر 43% | Discount badge |
| `paywall_subscription_yearly_title` | سنوي | Subscription tier |
| `paywall_subscription_yearly_badge` | وفّر 68% | Discount badge |
| `paywall_subscription_monthly_price` | {price} / شهرياً | {price} auto-formatted by StoreKit |
| `paywall_subscription_yearly_price` | {price} / سنوياً | {price} auto-formatted by StoreKit |
| `paywall_restore_purchases` | استعادة المشتريات | Button |
| `paywall_link_privacy` | الخصوصية | Link label |
| `paywall_link_terms` | الشروط | Link label |
| `paywall_link_support` | الدعم | Link label |
| `paywall_not_now_button` | ليس الآن | Dismiss button |
| `paywall_products_error_title` | تعذّر تحميل المنتجات | Error state |
| `paywall_products_error_retry` | إعادة المحاولة | Retry button |
| `paywall_purchase_error_title` | خطأ في الشراء | Alert title |
| `paywall_purchase_error_message` | تعذّر إتمام عملية الشراء. يُرجى المحاولة مرة أخرى. | Error message |
| `paywall_purchase_error_ok` | حسناً | Alert button |
| `paywall_trial_badge` | تجربة مجانية لمدة {days} أيام | Trial offer badge (generic plural; single-day case handled at UI level) |

---

## DailySpinView.swift (slot machine)

| Key | Arabic | Notes |
|---|---|---|
| `spin_title` | اللفة اليومية | Screen title |
| `spin_subtitle_closed` | عُد غداً للفة أخرى | Status when spin unavailable |
| `spin_rule_hint` | 3 🪙 = الجائزة الكبرى · 2 🪙 = جائزة | Rules hint below title |
| `spin_result_win_singular` | ربحت عملة واحدة! | count == 1 |
| `spin_result_win_plural` | ربحت +{count} عملات! | count != 1 (generic plural) |
| `spin_subtitle_lose` | كانت قريبة! حاول غداً | Lose message |
| `spin_status_rolling` | جارٍ اللف… | Status while spinning |
| `spin_button_spin` | لف | Primary button |
| `spin_button_awesome` | رائع | After a win |
| `spin_button_continue` | متابعة | After a lose |
| `spin_button_close` | إغلاق | Bottom close button |

---

## TrimmingView.swift

| Key | Arabic | Notes |
|---|---|---|
| `trimming_video_loading` | جارٍ تحميل الفيديو... | Loading indicator |
| `trimming_toggle_slowmo` | تفعيل الحركة البطيئة | Toggle label |
| `trimming_toggle_mute` | كتم صوت الفيديو | Toggle label |
| `trimming_pro_badge` | PRO | Pro feature badge |
| `trimming_time_start` | البداية: {time} | Trim start time display |
| `trimming_time_end` | النهاية: {time} | Trim end time display |
| `trimming_button_done` | تم | Save trim + close |

---

## AppConfigurationView.swift

| Key | Arabic | Notes |
|---|---|---|
| `app_config_title` | إعدادات التطبيق | Modal title |

---

## NotificationManager.swift

| Key | Arabic | Notes |
|---|---|---|
| `notification_video_ready_title` | الفيديو جاهز! | Local push title |
| `notification_video_ready_body` | تم حفظ الفيديو في Photos | Local push body |

---

## Info.plist (bundle metadata)

| Key | Arabic | Limit | Notes |
|---|---|---|---|
| `bundle_display_name` | Movie Maker | 30 | `CFBundleDisplayName` (brand — English) |
| `plist_photo_library_add_usage` | نحتاج إلى إذن لحفظ الفيديو الذي أنشأته في Photos | ≤100 | 51 chars — well under limit |
| `plist_photo_library_usage` | نحتاج إلى الوصول إلى فيديوهاتك وصورك لإنشاء المونتاجات | ≤100 | 55 chars — well under limit |

---

## App Store Connect Listing

| Key | Arabic | Limit | Notes |
|---|---|---|---|
| `asc_app_name` | Movie Maker - Reels & YouTube | 30 | KEPT AS IS — brand consistency across locales |
| `asc_subtitle` | دمج الفيديو والصور بالموسيقى | 30 | 28 chars — hits the value prop; brand names live in title. (Earlier candidate الفيديوهات pushed to 31 chars, over limit — switched to generic singular الفيديو.) |
| `asc_keywords` | محرر فيديو,دمج فيديوهات,مونتاج,قص,تعديل,صور,شرائح,موسيقى,ريلز,شورتس,تيك توك,فلوق,انستقرام | 100 | Arabic-first search terms; includes transliterations of platforms (ريلز، شورتس، تيك توك، انستقرام، فلوق) — these are how Arab users actually type them |
| `asc_promotional_text` | ادمج الفيديوهات والصور والموسيقى في فيلم واحد أنيق. اجمع المقاطع، قصّها، أعد ترتيبها، أضف الموسيقى وصدّر — بلا خط زمني معقّد. | 170 | 118 chars — natural MSA phrasing |
| `asc_whats_new` | يمكنك الآن التصدير بالمقاس المناسب لكل منصة. اختر 16:9 لـ YouTube، أو 9:16 لـ Reels & TikTok، أو 1:1 لـ Instagram — ثم شارك مباشرةً من التطبيق.\n\nالنسخة المجانية صارت أوسع: 3 عمليات تصدير كاملة بدون علامة مائية وبدون حد للعناصر. بعدها، اشحن رصيدك بالعملات أو انتقل إلى Pro شهرياً أو سنوياً. | 4000 | v2.4 release notes |
| `asc_description` | *(نص كامل ~1500 حرف — مُقسَّم في `description_ar.txt`)* | 4000 | Below-the-fold pitch; segmented by section |

### Description structure (translated)

| Section | Arabic |
|---|---|
| `desc_headline` | ادمج الفيديوهات والصور والموسيقى في فيلم واحد أنيق — بلا خط زمني معقّد. |
| `desc_hook` | Movie Maker هو أسرع طريقة لدمج المقاطع، وإضافة موسيقى، والتصدير إلى ألبومك. فقط اسحب، وقصّ، ثم انتهيت. |
| `desc_section_what` | ما يمكنك فعله |
| `desc_what_merge` | ادمج فيديوهات من مكتبتك في فيلم واحد — دون حد لعدد المقاطع. |
| `desc_what_combine` | اجمع بين الفيديوهات والصور بأي ترتيب لإنشاء عرض شرائح متحرك. |
| `desc_what_trim` | قصّ بداية ونهاية كل مقطع للاحتفاظ بأفضل اللحظات فقط. |
| `desc_what_reorder` | اسحب لإعادة ترتيب المشاهد حتى تشعر أن القصة أصبحت مناسبة. |
| `desc_what_mute` | اكتم صوت المقطع عندما تريد تعديلاً هادئاً أو موسيقى فقط. |
| `desc_what_export` | صدِّر إلى Photos خلال ثوانٍ، جاهزاً للمشاركة. |
| `desc_section_how` | كيف يعمل |
| `desc_how_1` | اختر المقاطع والصور من مكتبتك. |
| `desc_how_2` | أعد الترتيب، وقصّ، واكتم الصوت حسب الحاجة. |
| `desc_how_3` | أضف الموسيقى وصدِّر. |
| `desc_section_perfect_for` | مثالي لـ |
| `desc_perfect_travel` | ملخّصات الرحلات وأبرز لحظات الإجازات |
| `desc_perfect_family` | اللحظات العائلية ومونتاجات أعياد الميلاد |
| `desc_perfect_events` | ملخّصات الفعاليات من الأعراس والحفلات والمباريات |
| `desc_perfect_social` | منشورات وسائل التواصل لـ Instagram وTikTok وYouTube Shorts |
| `desc_perfect_slideshow` | عروض شرائح سريعة من جلسة تصوير |
| `desc_section_pro` | ميزات PRO (اختياري) |
| `desc_pro_music` | مكتبة موسيقى خلفية لموسيقى تصويرية متقنة |
| `desc_pro_slowmo` | حركة بطيئة في اللحظات المميزة |
| `desc_pro_longer` | مشاريع أطول مع مزيد من المقاطع والصور |
| `desc_pro_trial` | جرّب Pro مجاناً قبل الاشتراك — الشروط موضّحة داخل التطبيق. |
| `desc_section_privacy` | الخصوصية أولاً |
| `desc_privacy_body` | يتم التعديل بالكامل على جهازك. تبقى وسائطك في مكتبة الصور. لا يُرفع أي شيء إلى أي مكان إلا إذا اخترت المشاركة. |
| `desc_privacy_url_line` | سياسة الخصوصية: https://okekedev.github.io/MovieMaker/privacy.html |
| `desc_terms_url_line` | شروط الاستخدام: https://okekedev.github.io/MovieMaker/terms.html |

---

## Translation notes (ar)

1. **Plural compromise (MVP):** two variants only — `_singular` (one form) and `_plural` (a generic form that reads naturally for few/many). Arabic CLDR has six categories; producing all six per key is out of scope for MVP. When wiring `.stringsdict`, treat the `_plural` string as the `other` category and expand `one`/`two`/`few`/`many` when translator budget allows.
2. **Coin/item counters:** used generic form (`{count} عملة`, `{count} عنصر`, `{count} فيديوهات`) for the plural slot. This reads acceptably for 3–99 without being wrong for very high counts. Native speakers will accept it; ASA will not reject it.
3. **Register:** Modern Standard Arabic (فصحى) throughout. No Gulf/Egyptian/Levantine colloquialisms. Works across all Arab-speaking markets on the App Store.
4. **Punctuation:** Arabic comma ، used in keyword field would break ASC parser — kept ASCII commas in `asc_keywords` since ASC requires ASCII delimiters. Arabic ، and ؟ used in body copy where natural.
5. **Bidi mixing:** brand names (Movie Maker, YouTube, Reels & TikTok, Instagram, Pro, PRO, Photos) embedded LTR — iOS/App Store handle the Bidi algorithm correctly; renderer will bracket them naturally.
6. **Subtitle:** دمج الفيديو والصور بالموسيقى (28 chars incl. spaces) — packs core value; brand names live in title. Used singular الفيديو as a generic mass noun (reads as "video" in general, not "one video") to stay under the 30-char cap; plural الفيديوهات would have pushed to 31.
7. **Keywords:** transliterated platform names (ريلز، شورتس، تيك توك، انستقرام، فلوق) added intentionally — these are how Arab users actually search on the App Store; Latin brand names are also indexed via title/subtitle so no duplication.
8. **Time abbreviations:** د for دقيقة (minute), ث for ثانية (second) — standard Arabic UI abbreviations.
9. **Promotional text length:** 118 chars, well under 170. Arabic tends to run longer than English; kept it lean.
