# Movie Maker — ユーザー可視文字列インベントリ (ja)

**Locale:** `ja` (Japanese, Japan)
**Script:** Japanese (mixed Hiragana / Katakana / Kanji / Latin brand names)
**Direction:** LTR
**Plural forms:** Japanese has **no grammatical plural distinction** — singular and plural forms are identical (the count placeholder `{count}` carries the number). The `_singular` and `_plural` variants below intentionally resolve to the same string.

**Scope:** every user-visible string in Movie Maker v2.4, organized by view + the App Store Connect listing text (translated from the English source of truth).

**Brand terms kept in English (Latin script):** Movie Maker, Pro, Reels, YouTube, TikTok, Shorts, Instagram, iPhone, iPad, Photos.

---

## MediaSelectionView.swift (home)

| Key | Japanese | Notes |
|---|---|---|
| `media_home_title` | Movie Maker | Main title on empty home state |
| `media_home_cta` | タップして動画と写真を選択 | Helper text below pulse button |
| `media_header_back` | 戻る | Button to deselect all media |
| `media_header_spin` | スピン | Daily spin button label |
| `media_section_title` | 素材を選ぶ | Section headline when media selected |
| `media_section_subtitle` | タップで編集  \|  長押しで並び替え | Instruction text |
| `media_coin_balance_singular` | 残り{count}コイン — 書き出し1回につき1コイン | count == 1 (identical to plural in ja) |
| `media_coin_balance_plural` | 残り{count}コイン — 書き出し1回につき1コイン | count != 1 (identical to singular in ja) |
| `media_grid_add_more` | さらに追加 | Button below media grid |
| `media_button_continue` | 次へ | Primary CTA at bottom |
| `media_permission_alert_title` | 写真へのアクセスが必要です | Alert title |
| `media_permission_alert_open_settings` | 設定を開く | Alert button |
| `media_permission_alert_cancel` | キャンセル | Alert cancel button |
| `media_permission_alert_message` | 動画をまとめるには、設定でMovie Makerに写真と動画へのアクセスを許可してください。 | Alert message |

---

## SettingsView.swift (export options)

| Key | Japanese | Notes |
|---|---|---|
| `settings_header_back` | 戻る | Back button |
| `settings_aspect_ratio_label` | アスペクト比 | Section title |
| `settings_aspect_ratio_for_hint` | {platform}向け | Subtext; {platform} = "YouTube", "Instagram", "Reels & TikTok" |
| `settings_title_screen_label` | タイトル画面 | Section title |
| `settings_title_required_label` | タイトル(必須) | Field label |
| `settings_title_placeholder` | タイトルを入力 | TextField placeholder |
| `settings_subtitle_label` | サブタイトル(任意) | Field label |
| `settings_subtitle_placeholder` | サブタイトルを入力 | TextField placeholder |
| `settings_title_screen_hint` | 黒背景に白文字 • 3秒 | Instruction/note |
| `settings_title_screen_no_title` | タイトルなし | Status when title empty |
| `settings_transition_style_label` | トランジション スタイル | Section title |
| `settings_transition_color_label` | トランジション カラー | ColorPicker label |
| `settings_photo_duration_label` | 写真の表示時間 | Section title |
| `settings_photo_duration_value` | {value}秒 | Duration picker |
| `settings_background_music_label` | BGM | Section title |
| `settings_music_select_button` | 音楽を選ぶ | Button to open music picker |
| `settings_music_volume_label` | 音量 | Slider label |
| `settings_music_volume_percentage` | {value}% | Volume display |
| `settings_music_background_only_toggle` | BGMのみ再生 | Toggle label |
| `settings_music_remove_button` | 音楽を削除 | Button to clear selection |
| `settings_music_loop_hint` | 動画全体で音楽がループ再生されます | Note about looping |
| `settings_music_none_indicator` | なし | Status when no music |
| `settings_preview_section_label` | プレビュー | Section title |
| `settings_preview_total_length` | 合計時間: {duration} | Formatted duration |
| `settings_preview_item_count_singular` | {count}項目 | count == 1 (identical to plural in ja) |
| `settings_preview_item_count_plural` | {count}項目 | count != 1 (identical to singular in ja) |
| `settings_create_button` | 動画を作成 | Primary button |
| `settings_warning_alert_title` | 警告 | Alert title for validation warnings |
| `settings_warning_long_videos_singular` | 5分を超える動画が1本あります。ファイルサイズが非常に大きくなる可能性があります。 | count == 1 |
| `settings_warning_long_videos_plural` | 5分を超える動画が{count}本あります。ファイルサイズが非常に大きくなる可能性があります。 | count != 1 |
| `settings_warning_many_items_message` | 項目が{count}個あります。作成に数分かかる場合があります。 | Warning about many items |
| `settings_warning_create_anyway` | このまま作成 | Alert button to proceed |
| `settings_warning_cancel` | キャンセル | Alert cancel button |
| `settings_pro_badge` | PRO | Pro tier badge (kept English) |
| `settings_duration_min_sec` | {minutes}分{seconds}秒 | Duration format for minutes > 0 |
| `settings_duration_sec_only` | {seconds}秒 | Duration format for < 1 min |

---

## VideoCreationView.swift (export progress)

| Key | Japanese | Notes |
|---|---|---|
| `video_creation_title` | 動画を作成中... | Main title during export |
| `video_creation_status_preparing` | 準備中... | Initial status |
| `video_creation_status_adding` | 動画を追加中... | Progress status (early) |
| `video_creation_status_composing` | 動画を構成中... | Progress status (mid) |
| `video_creation_status_almost_done` | まもなく完了... | Progress status (late) |
| `video_creation_status_saving` | Photosに保存中... | Status during save |
| `video_creation_helper_text` | アプリを閉じても大丈夫です。完了したらお知らせします | Reassurance text |
| `video_creation_error_alert_title` | エラー | Alert title |
| `video_creation_error_alert_ok` | OK | Error alert button |

---

## CompletionView.swift (success screen)

| Key | Japanese | Notes |
|---|---|---|
| `completion_title` | 動画が完成しました! | Success title |
| `completion_subtitle` | 動画をPhotosに保存しました。 | Confirmation text |
| `completion_button_share` | 動画を共有 | Share sheet button |
| `completion_button_open_photos` | Photosを開く | Button to open Photos app |
| `completion_button_create_another` | もう1本作成する | Button to reset and start over |

---

## PaywallView.swift (buy sheet)

| Key | Japanese | Notes |
|---|---|---|
| `paywall_hero_unlimited` | 無制限 | Pro badge on hero |
| `paywall_hero_current_coins_label` | 現在のコイン: | Free-tier label |
| `paywall_hero_coin_ratio` | 1コイン = 動画1本 | Explanation of coin model |
| `paywall_feature_music_title` | BGM | Feature row |
| `paywall_feature_music_desc` | お気に入りの音楽を追加 | |
| `paywall_feature_slowmo_title` | スローモーション | Feature row |
| `paywall_feature_slowmo_desc` | どのクリップでも映画的なスロー再生 | |
| `paywall_feature_watermark_title` | ウォーターマークなし | Feature row |
| `paywall_feature_watermark_desc` | 高画質で書き出し | |
| `paywall_coins_section_title` | コインを購入 | Section header |
| `paywall_coins_tier_label` | {count}コイン | Tier button (e.g. "5コイン") |
| `paywall_coins_tag_best_value` | お得 | Badge on 15-coin tier |
| `paywall_subscription_section_title` | または無制限プラン | Section header |
| `paywall_subscription_monthly_title` | 月額 | Subscription tier |
| `paywall_subscription_monthly_badge` | 43%オフ | Discount badge |
| `paywall_subscription_yearly_title` | 年額 | Subscription tier |
| `paywall_subscription_yearly_badge` | 68%オフ | Discount badge |
| `paywall_subscription_monthly_price` | {price} / 月 | {price} auto-formatted by StoreKit |
| `paywall_subscription_yearly_price` | {price} / 年 | {price} auto-formatted by StoreKit |
| `paywall_restore_purchases` | 購入を復元 | Button |
| `paywall_link_privacy` | プライバシー | Link label |
| `paywall_link_terms` | 利用規約 | Link label |
| `paywall_link_support` | サポート | Link label |
| `paywall_not_now_button` | あとで | Dismiss button |
| `paywall_products_error_title` | 商品を読み込めません | Error state |
| `paywall_products_error_retry` | 再試行 | Retry button |
| `paywall_purchase_error_title` | 購入エラー | Alert title |
| `paywall_purchase_error_message` | 購入を完了できませんでした。もう一度お試しください。 | Error message |
| `paywall_purchase_error_ok` | OK | Alert button |
| `paywall_trial_badge` | {days}日間無料トライアル | Trial offer badge |

---

## DailySpinView.swift (slot machine)

| Key | Japanese | Notes |
|---|---|---|
| `spin_title` | デイリースピン | Screen title |
| `spin_subtitle_closed` | 次のスピンは明日また | Status when spin unavailable |
| `spin_rule_hint` | 3 🪙 = ジャックポット · 2 🪙 = 当たり | Rules hint below title |
| `spin_result_win_singular` | +1コイン獲得! | count == 1 |
| `spin_result_win_plural` | +{count}コイン獲得! | count != 1 (identical to singular in ja) |
| `spin_subtitle_lose` | 惜しい! 明日また挑戦してね | Lose message |
| `spin_status_rolling` | 回転中… | Status while spinning |
| `spin_button_spin` | スピン | Primary button |
| `spin_button_awesome` | やった! | After a win |
| `spin_button_continue` | 続ける | After a lose |
| `spin_button_close` | 閉じる | Bottom close button |

---

## TrimmingView.swift

| Key | Japanese | Notes |
|---|---|---|
| `trimming_video_loading` | 動画を読み込み中... | Loading indicator |
| `trimming_toggle_slowmo` | スローモーションを有効化 | Toggle label |
| `trimming_toggle_mute` | 動画をミュート | Toggle label |
| `trimming_pro_badge` | PRO | Pro feature badge |
| `trimming_time_start` | 開始: {time} | Trim start time display |
| `trimming_time_end` | 終了: {time} | Trim end time display |
| `trimming_button_done` | 完了 | Save trim + close |

---

## AppConfigurationView.swift

| Key | Japanese | Notes |
|---|---|---|
| `app_config_title` | アプリ設定 | Modal title |

---

## NotificationManager.swift

| Key | Japanese | Notes |
|---|---|---|
| `notification_video_ready_title` | 動画の準備ができました! | Local push title |
| `notification_video_ready_body` | 動画をPhotosに保存しました | Local push body |

---

## Info.plist (bundle metadata)

| Key | Japanese | Limit | Notes |
|---|---|---|---|
| `bundle_display_name` | Movie Maker | 30 | `CFBundleDisplayName` (brand — English) |
| `plist_photo_library_add_usage` | 作成した動画をPhotosに保存するために権限が必要です | ≤100 | 25 chars — well under limit |
| `plist_photo_library_usage` | 動画をまとめるために、写真と動画へのアクセス許可が必要です | ≤100 | 28 chars — well under limit |

---

## App Store Connect Listing

| Key | Japanese | Limit | Notes |
|---|---|---|---|
| `asc_app_name` | Movie Maker - Reels & YouTube | 30 | KEPT AS IS — brand consistency across locales |
| `asc_subtitle` | 動画・写真を1本にまとめる編集アプリ | 30 | 18 chars — describes core value in kanji-dense form |
| `asc_keywords` | 動画編集,ムービー,結合,つなげる,写真,スライドショー,BGM,音楽,カット,トリミング,合成,加工,リール,ショート,SNS | 100 | Mix of kanji/katakana/hiragana + short English hooks; targets JP search terms like 動画編集, ムービー, スライドショー |
| `asc_promotional_text` | 動画・写真・音楽を1本のムービーに。クリップの結合、トリミング、並び替え、BGM追加、書き出しまで。複雑なタイムラインも学習も不要。 | 170 | 68 chars — punchy JP pitch, no learning curve tagline localized |
| `asc_whats_new` | プラットフォームごとに最適なサイズで書き出せるようになりました。YouTubeなら16:9、Reels & TikTokなら9:16、Instagramなら1:1を選んで、そのままアプリから共有できます。\n\n無料プランもより使いやすく。ウォーターマークなし・素材数の上限なしで3本まで書き出せます。それ以降はコインを購入するか、Proの月額または年額プランへ。 | 4000 | v2.4 release notes |
| `asc_description` | *(下記のセクション別テキストから合成 — 完成版は `description_ja.txt`)* | 4000 | Below-the-fold pitch; segmented by section |

### Description structure (translated)

| Section | Japanese |
|---|---|
| `desc_headline` | 動画・写真・音楽を1本のムービーに。複雑なタイムラインは不要。 |
| `desc_hook` | Movie Makerは、クリップをまとめてBGMを追加し、カメラロールへ書き出す最速の方法です。ドラッグしてトリミングするだけで完成。 |
| `desc_section_what` | できること |
| `desc_what_merge` | ライブラリの動画を1本のムービーに結合 — クリップ数に上限なし。 |
| `desc_what_combine` | 動画と写真を好きな順番で組み合わせ、動きのあるスライドショーを作成。 |
| `desc_what_trim` | 各クリップの開始と終了をトリミングし、ベストな瞬間だけを残す。 |
| `desc_what_reorder` | シーンをドラッグして並び替え、しっくりくるストーリーに。 |
| `desc_what_mute` | 静かな編集やBGMのみの構成にしたいときはクリップの音声をミュート。 |
| `desc_what_export` | 数秒でPhotosに書き出し、そのままシェア可能。 |
| `desc_section_how` | 使い方 |
| `desc_how_1` | ライブラリからクリップと写真を選ぶ。 |
| `desc_how_2` | 並び替え、トリミング、ミュートを必要に応じて。 |
| `desc_how_3` | 音楽を追加して書き出し。 |
| `desc_section_perfect_for` | こんなときに |
| `desc_perfect_travel` | 旅行のダイジェスト、思い出のハイライト |
| `desc_perfect_family` | 家族の記録や誕生日のまとめ動画 |
| `desc_perfect_events` | 結婚式・パーティー・スポーツなどイベントの振り返り |
| `desc_perfect_social` | Instagram、TikTok、YouTube Shortsへの投稿 |
| `desc_perfect_slideshow` | 撮影会写真からサクッとスライドショー |
| `desc_section_pro` | PRO機能(オプション) |
| `desc_pro_music` | 洗練されたサウンドトラックのためのBGMライブラリ |
| `desc_pro_slowmo` | 決定的瞬間にスローモーション |
| `desc_pro_longer` | より多くのクリップ・写真を使った長編プロジェクト |
| `desc_pro_trial` | 定額の前に無料でお試し — 条件はアプリ内で明記。 |
| `desc_section_privacy` | プライバシー最優先 |
| `desc_privacy_body` | 編集はすべてデバイス内で完結します。素材はフォトライブラリに残り、共有を選ばない限り、どこにもアップロードされません。 |
| `desc_privacy_url_line` | プライバシーポリシー: https://okekedev.github.io/MovieMaker/privacy.html |
| `desc_terms_url_line` | 利用規約: https://okekedev.github.io/MovieMaker/terms.html |

---

## Translation notes (ja)

1. **Plural collapse:** `_singular` and `_plural` variants are intentionally identical. Japanese doesn't distinguish grammatical plural — the `{count}` value carries the number and the counter (本 / 項目 / コイン) stays fixed.
2. **Counter words:** used 本 for video clips (settings_warning_long_videos), 項目 for generic items (preview count), 個/枚 avoided in favor of consistent 項目 across counts.
3. **Tone:** です・ます polite-neutral throughout. Avoided both stiff 〜でございます and casual 〜だよ/〜だね.
4. **Keyword strategy:** mixed 動画編集 (heavy JP search term), ムービー (katakana loanword — high volume), plus targeted platform hooks (リール / ショート / SNS). Kept comma-separated ASCII commas since ASC indexer expects them.
5. **Subtitle:** 動画・写真を1本にまとめる編集アプリ (18 chars) packs value prop + category ("編集アプリ" = editor app) — well under 30.
6. **Promo text:** 68 chars — the JP form is naturally denser than English.
7. **BGM vs バックグラウンドミュージック:** used BGM (widely understood loanword, shorter) consistently in-app.
