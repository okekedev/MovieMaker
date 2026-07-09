# Movie Maker — 사용자 노출 문자열 인벤토리 (ko)

**Locale:** `ko` (Korean, South Korea)
**Script:** Hangul + Latin brand names
**Direction:** LTR
**Plural forms:** Korean has **no grammatical plural distinction** — singular and plural forms are identical. The `_singular` and `_plural` variants below intentionally resolve to the same string; the `{count}` placeholder carries the number.

**Scope:** every user-visible string in Movie Maker v2.4, organized by view + the App Store Connect listing text (translated from the English source of truth).

**Brand terms kept in English (Latin script):** Movie Maker, Pro, Reels, YouTube, TikTok, Shorts, Instagram, iPhone, iPad, Photos.

**Tone:** 해요체 (polite-informal, 요-ending) — friendly consumer app register. Avoided formal 습니다체 and casual 반말.

---

## MediaSelectionView.swift (home)

| Key | Korean | Notes |
|---|---|---|
| `media_home_title` | Movie Maker | Main title on empty home state |
| `media_home_cta` | 탭해서 동영상과 사진을 선택하세요 | Helper text below pulse button |
| `media_header_back` | 뒤로 | Button to deselect all media |
| `media_header_spin` | 스핀 | Daily spin button label |
| `media_section_title` | 순간을 골라보세요 | Section headline when media selected |
| `media_section_subtitle` | 탭하면 편집  \|  길게 눌러 정렬 | Instruction text |
| `media_coin_balance_singular` | 코인 {count}개 남음 — 내보내기 1회당 1코인 | count == 1 (identical to plural in ko) |
| `media_coin_balance_plural` | 코인 {count}개 남음 — 내보내기 1회당 1코인 | count != 1 (identical to singular in ko) |
| `media_grid_add_more` | 더 추가 | Button below media grid |
| `media_button_continue` | 계속 | Primary CTA at bottom |
| `media_permission_alert_title` | 사진 접근 권한 필요 | Alert title |
| `media_permission_alert_open_settings` | 설정 열기 | Alert button |
| `media_permission_alert_cancel` | 취소 | Alert cancel button |
| `media_permission_alert_message` | 영상을 만들려면 설정에서 Movie Maker의 동영상과 사진 접근을 허용해 주세요. | Alert message |

---

## SettingsView.swift (export options)

| Key | Korean | Notes |
|---|---|---|
| `settings_header_back` | 뒤로 | Back button |
| `settings_aspect_ratio_label` | 화면 비율 | Section title |
| `settings_aspect_ratio_for_hint` | {platform}용 | Subtext; {platform} = "YouTube", "Instagram", "Reels & TikTok" |
| `settings_title_screen_label` | 타이틀 화면 | Section title |
| `settings_title_required_label` | 제목 (필수) | Field label |
| `settings_title_placeholder` | 제목 입력 | TextField placeholder |
| `settings_subtitle_label` | 부제목 (선택) | Field label |
| `settings_subtitle_placeholder` | 부제목 입력 | TextField placeholder |
| `settings_title_screen_hint` | 검은 배경에 흰 텍스트 • 3초 | Instruction/note |
| `settings_title_screen_no_title` | 제목 없음 | Status when title empty |
| `settings_transition_style_label` | 전환 스타일 | Section title |
| `settings_transition_color_label` | 전환 색상 | ColorPicker label |
| `settings_photo_duration_label` | 사진 재생 시간 | Section title |
| `settings_photo_duration_value` | {value}초 | Duration picker |
| `settings_background_music_label` | 배경 음악 | Section title |
| `settings_music_select_button` | 음악 선택 | Button to open music picker |
| `settings_music_volume_label` | 볼륨 | Slider label |
| `settings_music_volume_percentage` | {value}% | Volume display |
| `settings_music_background_only_toggle` | 배경 음악만 재생 | Toggle label |
| `settings_music_remove_button` | 음악 제거 | Button to clear selection |
| `settings_music_loop_hint` | 영상 전체에서 음악이 반복 재생돼요 | Note about looping |
| `settings_music_none_indicator` | 없음 | Status when no music |
| `settings_preview_section_label` | 미리보기 | Section title |
| `settings_preview_total_length` | 전체 길이: {duration} | Formatted duration |
| `settings_preview_item_count_singular` | {count}개 항목 | count == 1 (identical to plural in ko) |
| `settings_preview_item_count_plural` | {count}개 항목 | count != 1 (identical to singular in ko) |
| `settings_create_button` | 영상 만들기 | Primary button |
| `settings_warning_alert_title` | 경고 | Alert title for validation warnings |
| `settings_warning_long_videos_singular` | 5분이 넘는 동영상이 1개 있어요. 파일이 매우 커질 수 있어요. | count == 1 |
| `settings_warning_long_videos_plural` | 5분이 넘는 동영상이 {count}개 있어요. 파일이 매우 커질 수 있어요. | count != 1 |
| `settings_warning_many_items_message` | 항목이 {count}개예요. 만드는 데 몇 분이 걸릴 수 있어요. | Warning about many items |
| `settings_warning_create_anyway` | 그대로 만들기 | Alert button to proceed |
| `settings_warning_cancel` | 취소 | Alert cancel button |
| `settings_pro_badge` | PRO | Pro tier badge (kept English) |
| `settings_duration_min_sec` | {minutes}분 {seconds}초 | Duration format for minutes > 0 |
| `settings_duration_sec_only` | {seconds}초 | Duration format for < 1 min |

---

## VideoCreationView.swift (export progress)

| Key | Korean | Notes |
|---|---|---|
| `video_creation_title` | 영상을 만드는 중... | Main title during export |
| `video_creation_status_preparing` | 준비 중... | Initial status |
| `video_creation_status_adding` | 동영상 추가 중... | Progress status (early) |
| `video_creation_status_composing` | 영상 구성 중... | Progress status (mid) |
| `video_creation_status_almost_done` | 거의 다 됐어요... | Progress status (late) |
| `video_creation_status_saving` | Photos에 저장 중... | Status during save |
| `video_creation_helper_text` | 앱을 닫아도 괜찮아요. 준비되면 알려드릴게요 | Reassurance text |
| `video_creation_error_alert_title` | 오류 | Alert title |
| `video_creation_error_alert_ok` | 확인 | Error alert button |

---

## CompletionView.swift (success screen)

| Key | Korean | Notes |
|---|---|---|
| `completion_title` | 영상 완성! | Success title |
| `completion_subtitle` | 영상이 Photos에 저장됐어요. | Confirmation text |
| `completion_button_share` | 영상 공유 | Share sheet button |
| `completion_button_open_photos` | Photos 열기 | Button to open Photos app |
| `completion_button_create_another` | 다른 영상 만들기 | Button to reset and start over |

---

## PaywallView.swift (buy sheet)

| Key | Korean | Notes |
|---|---|---|
| `paywall_hero_unlimited` | 무제한 | Pro badge on hero |
| `paywall_hero_current_coins_label` | 보유 코인: | Free-tier label |
| `paywall_hero_coin_ratio` | 1코인 = 영상 1개 | Explanation of coin model |
| `paywall_feature_music_title` | 배경 음악 | Feature row |
| `paywall_feature_music_desc` | 원하는 사운드트랙을 추가 | |
| `paywall_feature_slowmo_title` | 슬로우 모션 | Feature row |
| `paywall_feature_slowmo_desc` | 어떤 클립에도 시네마틱 슬로우 모션 | |
| `paywall_feature_watermark_title` | 워터마크 없음 | Feature row |
| `paywall_feature_watermark_desc` | 최고 화질로 내보내기 | |
| `paywall_coins_section_title` | 코인 구매 | Section header |
| `paywall_coins_tier_label` | 코인 {count}개 | Tier button (e.g. "코인 5개") |
| `paywall_coins_tag_best_value` | 최고 가성비 | Badge on 15-coin tier |
| `paywall_subscription_section_title` | 또는 무제한으로 | Section header |
| `paywall_subscription_monthly_title` | 월간 | Subscription tier |
| `paywall_subscription_monthly_badge` | 43% 할인 | Discount badge |
| `paywall_subscription_yearly_title` | 연간 | Subscription tier |
| `paywall_subscription_yearly_badge` | 68% 할인 | Discount badge |
| `paywall_subscription_monthly_price` | {price} / 월 | {price} auto-formatted by StoreKit |
| `paywall_subscription_yearly_price` | {price} / 년 | {price} auto-formatted by StoreKit |
| `paywall_restore_purchases` | 구매 복원 | Button |
| `paywall_link_privacy` | 개인정보 | Link label |
| `paywall_link_terms` | 이용약관 | Link label |
| `paywall_link_support` | 고객지원 | Link label |
| `paywall_not_now_button` | 나중에 | Dismiss button |
| `paywall_products_error_title` | 상품을 불러올 수 없어요 | Error state |
| `paywall_products_error_retry` | 다시 시도 | Retry button |
| `paywall_purchase_error_title` | 구매 오류 | Alert title |
| `paywall_purchase_error_message` | 구매를 완료할 수 없어요. 다시 시도해 주세요. | Error message |
| `paywall_purchase_error_ok` | 확인 | Alert button |
| `paywall_trial_badge` | {days}일 무료 체험 | Trial offer badge |

---

## DailySpinView.swift (slot machine)

| Key | Korean | Notes |
|---|---|---|
| `spin_title` | 데일리 스핀 | Screen title |
| `spin_subtitle_closed` | 내일 다시 돌려보세요 | Status when spin unavailable |
| `spin_rule_hint` | 3 🪙 = 잭팟 · 2 🪙 = 당첨 | Rules hint below title |
| `spin_result_win_singular` | +1코인 획득! | count == 1 |
| `spin_result_win_plural` | +{count}코인 획득! | count != 1 (identical form to singular in ko) |
| `spin_subtitle_lose` | 아쉬워요! 내일 다시 도전해 봐요 | Lose message |
| `spin_status_rolling` | 돌리는 중… | Status while spinning |
| `spin_button_spin` | 스핀 | Primary button |
| `spin_button_awesome` | 좋아요! | After a win |
| `spin_button_continue` | 계속 | After a lose |
| `spin_button_close` | 닫기 | Bottom close button |

---

## TrimmingView.swift

| Key | Korean | Notes |
|---|---|---|
| `trimming_video_loading` | 영상 불러오는 중... | Loading indicator |
| `trimming_toggle_slowmo` | 슬로우 모션 사용 | Toggle label |
| `trimming_toggle_mute` | 영상 음소거 | Toggle label |
| `trimming_pro_badge` | PRO | Pro feature badge |
| `trimming_time_start` | 시작: {time} | Trim start time display |
| `trimming_time_end` | 끝: {time} | Trim end time display |
| `trimming_button_done` | 완료 | Save trim + close |

---

## AppConfigurationView.swift

| Key | Korean | Notes |
|---|---|---|
| `app_config_title` | 앱 설정 | Modal title |

---

## NotificationManager.swift

| Key | Korean | Notes |
|---|---|---|
| `notification_video_ready_title` | 영상이 준비됐어요! | Local push title |
| `notification_video_ready_body` | 영상이 Photos에 저장됐어요 | Local push body |

---

## Info.plist (bundle metadata)

| Key | Korean | Limit | Notes |
|---|---|---|---|
| `bundle_display_name` | Movie Maker | 30 | `CFBundleDisplayName` (brand — English) |
| `plist_photo_library_add_usage` | 만든 영상을 Photos에 저장하려면 권한이 필요해요 | ≤100 | 26 chars — well under limit |
| `plist_photo_library_usage` | 영상을 만들려면 동영상과 사진에 대한 접근 권한이 필요해요 | ≤100 | 30 chars — well under limit |

---

## App Store Connect Listing

| Key | Korean | Limit | Notes |
|---|---|---|---|
| `asc_app_name` | Movie Maker - Reels & YouTube | 30 | KEPT AS IS — brand consistency across locales |
| `asc_subtitle` | 동영상·사진 합치고 편집하는 앱 | 30 | 17 chars — packs "merge + edit + app" in dense Hangul |
| `asc_keywords` | 동영상편집,영상합치기,사진영상,슬라이드쇼,릴스,쇼츠,배경음악,컷편집,영상제작,브이로그,SNS영상,틱톡 | 100 | Korean-first: 동영상편집 / 영상합치기 are dominant KR search terms; 브이로그 / 릴스 / 쇼츠 target social creators |
| `asc_promotional_text` | 동영상·사진·음악을 하나의 영상으로. 클립 합치기, 트리밍, 순서 변경, 배경음악 추가까지 — 복잡한 타임라인도, 학습 곡선도 없어요. | 170 | 74 chars — natural KR phrasing, 해요체 |
| `asc_whats_new` | 이제 플랫폼별로 딱 맞는 크기로 내보낼 수 있어요. YouTube는 16:9, Reels & TikTok은 9:16, Instagram은 1:1을 선택하고 앱에서 바로 공유하세요.\n\n무료 플랜도 더 넉넉해졌어요. 워터마크 없이, 항목 제한 없이 3번까지 내보낼 수 있어요. 그 이후에는 코인을 충전하거나 Pro 월간·연간 플랜으로 전환하세요. | 4000 | v2.4 release notes |
| `asc_description` | *(아래 섹션별 텍스트로 조합 — 완성본은 `description_ko.txt`)* | 4000 | Below-the-fold pitch; segmented by section |

### Description structure (translated)

| Section | Korean |
|---|---|
| `desc_headline` | 동영상·사진·음악을 하나의 깔끔한 영상으로 — 복잡한 타임라인은 필요 없어요. |
| `desc_hook` | Movie Maker는 클립을 합치고, 사운드트랙을 추가하고, 카메라 롤로 내보내는 가장 빠른 방법이에요. 드래그하고 트리밍만 하면 완성. |
| `desc_section_what` | 이런 걸 할 수 있어요 |
| `desc_what_merge` | 라이브러리의 동영상을 하나의 영상으로 합치기 — 클립 개수 제한 없음. |
| `desc_what_combine` | 동영상과 사진을 원하는 순서로 조합해 움직이는 슬라이드쇼 만들기. |
| `desc_what_trim` | 각 클립의 시작과 끝을 트리밍해 최고의 순간만 남기기. |
| `desc_what_reorder` | 장면을 드래그해 순서를 바꾸며 원하는 스토리로 정리하기. |
| `desc_what_mute` | 조용한 편집이나 배경음악만 살릴 때 클립 오디오 음소거하기. |
| `desc_what_export` | Photos로 몇 초 만에 내보내고 바로 공유하기. |
| `desc_section_how` | 사용 방법 |
| `desc_how_1` | 라이브러리에서 클립과 사진을 선택하세요. |
| `desc_how_2` | 필요한 만큼 순서를 바꾸고, 트리밍하고, 음소거하세요. |
| `desc_how_3` | 음악을 추가하고 내보내세요. |
| `desc_section_perfect_for` | 이럴 때 딱 좋아요 |
| `desc_perfect_travel` | 여행 요약, 휴가 하이라이트 영상 |
| `desc_perfect_family` | 가족 순간, 생일 모음 영상 |
| `desc_perfect_events` | 결혼식, 파티, 경기 등 이벤트 리캡 |
| `desc_perfect_social` | Instagram, TikTok, YouTube Shorts용 SNS 게시물 |
| `desc_perfect_slideshow` | 촬영한 사진으로 만드는 빠른 슬라이드쇼 |
| `desc_section_pro` | PRO 기능 (선택) |
| `desc_pro_music` | 완성도 높은 사운드트랙을 위한 배경음악 라이브러리 |
| `desc_pro_slowmo` | 결정적인 순간에 슬로우 모션 |
| `desc_pro_longer` | 더 많은 클립과 사진으로 만드는 긴 프로젝트 |
| `desc_pro_trial` | 구독 전에 Pro를 무료로 체험해 보세요 — 약관은 앱 내에서 명확히 안내해요. |
| `desc_section_privacy` | 개인정보 최우선 |
| `desc_privacy_body` | 편집은 모두 기기에서 이뤄져요. 미디어는 사진 라이브러리에 남아 있고, 직접 공유하지 않는 이상 어디에도 업로드되지 않아요. |
| `desc_privacy_url_line` | 개인정보 처리방침: https://okekedev.github.io/MovieMaker/privacy.html |
| `desc_terms_url_line` | 이용약관: https://okekedev.github.io/MovieMaker/terms.html |

---

## Translation notes (ko)

1. **Plural collapse:** `_singular` and `_plural` variants are intentionally identical. Korean marks number lexically via 개 / 명 / 번 counters and the `{count}` value — no grammatical inflection.
2. **Counter words:** 개 for generic items/coins, 개 for videos too (consistent with app-native usage). Kept concise since spec includes items, coins, and videos.
3. **Tone:** 해요체 throughout — friendly, respectful, but not stiff. Kept a warm ~해요 / ~요 pattern on system messages and helper text. Alerts stay slightly firmer but still 해요체.
4. **Keyword strategy:** 동영상편집 and 영상합치기 are the highest-volume KR ASO terms in this category; 브이로그, 릴스, 쇼츠, 틱톡 catch social-creator queries. All comma-separated per ASC spec.
5. **Subtitle:** 동영상·사진 합치고 편집하는 앱 (17 chars) — chose middle dot (·) to keep it compact and native-feeling.
6. **Promo text:** 74 chars — used em-dash for the "no timeline, no learning curve" beat.
7. **Spin copy:** kept motivational-but-humble ("아쉬워요!", "좋아요!") — matches consumer-app register.
