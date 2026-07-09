# Movie Maker — Turkish (tr) Strings Inventory

**Locale:** `tr` — Turkish (Turkey)
**RTL:** no
**Plural forms:** 1 (no distinction between singular and plural for cardinal numbers in Turkish) — Unicode CLDR `tr` treats all counts identically; the numeral itself carries the count

**Scope:** every user-visible string in Movie Maker v2.4, localized for Turkish (Istanbul standard).

**Brand terms kept in English:** Movie Maker, Pro, Reels, YouTube, TikTok, Shorts, Instagram, iPhone, iPad, Photos.

---

## MediaSelectionView.swift (home)

| Key | Turkish | Notes |
|---|---|---|
| `media_home_title` | Movie Maker | Main title on empty home state |
| `media_home_cta` | Video ve fotoğraf seçmek için dokun | Helper text below pulse button |
| `media_header_back` | Geri | Button to deselect all media |
| `media_header_spin` | Çevir | Daily spin button label |
| `media_section_title` | Anlarını seç | Section headline when media selected |
| `media_section_subtitle` | Düzenlemek için dokun  \|  Sıralamak için basılı tut | Instruction text |
| `media_coin_balance_singular` | {count} jeton kaldı — dışa aktarım başına 1 jeton | count == 1 |
| `media_coin_balance_plural` | {count} jeton kaldı — dışa aktarım başına 1 jeton | count != 1 (identical in Turkish) |
| `media_grid_add_more` | Daha ekle | Button below media grid |
| `media_button_continue` | Devam et | Primary CTA at bottom |
| `media_permission_alert_title` | Fotoğraf erişimi gerekli | Alert title |
| `media_permission_alert_open_settings` | Ayarları aç | Alert button |
| `media_permission_alert_cancel` | İptal | Alert cancel button |
| `media_permission_alert_message` | Derlemeler oluşturmak için Movie Maker'ın video ve fotoğraflarına erişmesine Ayarlar'dan izin ver. | Alert message |

---

## SettingsView.swift (export options)

| Key | Turkish | Notes |
|---|---|---|
| `settings_header_back` | Geri | Back button |
| `settings_aspect_ratio_label` | En-boy oranı | Section title |
| `settings_aspect_ratio_for_hint` | {platform} için | Subtext |
| `settings_title_screen_label` | Başlık ekranı | Section title |
| `settings_title_required_label` | Başlık (zorunlu) | Field label |
| `settings_title_placeholder` | Başlık gir | TextField placeholder |
| `settings_subtitle_label` | Alt başlık (isteğe bağlı) | Field label |
| `settings_subtitle_placeholder` | Alt başlık gir | TextField placeholder |
| `settings_title_screen_hint` | Siyah arka planda beyaz metin • 3 saniye | Instruction/note |
| `settings_title_screen_no_title` | Başlık yok | Status when title empty |
| `settings_transition_style_label` | Geçiş stili | Section title |
| `settings_transition_color_label` | Geçiş rengi | ColorPicker label |
| `settings_photo_duration_label` | Fotoğraf süresi | Section title |
| `settings_photo_duration_value` | {value} sn | Duration picker |
| `settings_background_music_label` | Arka plan müziği | Section title |
| `settings_music_select_button` | Müzik seç | Button to open music picker |
| `settings_music_volume_label` | Ses düzeyi | Slider label |
| `settings_music_volume_percentage` | %{value} | Volume display |
| `settings_music_background_only_toggle` | Sadece arka plan müziği | Toggle label |
| `settings_music_remove_button` | Müziği kaldır | Button to clear selection |
| `settings_music_loop_hint` | Müzik video boyunca döngüye girer | Note about looping |
| `settings_music_none_indicator` | Yok | Status when no music |
| `settings_preview_section_label` | Önizleme | Section title |
| `settings_preview_total_length` | Toplam uzunluk: {duration} | Formatted duration |
| `settings_preview_item_count_singular` | {count} öğe | count == 1 |
| `settings_preview_item_count_plural` | {count} öğe | count != 1 (identical) |
| `settings_create_button` | Video oluştur | Primary button |
| `settings_warning_alert_title` | Uyarı | Alert title for validation warnings |
| `settings_warning_long_videos_singular` | 5 dakikadan uzun 1 videon var. Bu, çok büyük bir dosyaya yol açabilir. | count == 1 |
| `settings_warning_long_videos_plural` | 5 dakikadan uzun {count} videon var. Bu, çok büyük bir dosyaya yol açabilir. | count != 1 |
| `settings_warning_many_items_message` | {count} öğen var. Oluşturmak birkaç dakika sürebilir. | Warning about many items |
| `settings_warning_create_anyway` | Yine de oluştur | Alert button to proceed |
| `settings_warning_cancel` | İptal | Alert cancel button |
| `settings_pro_badge` | PRO | Pro tier badge |
| `settings_duration_min_sec` | {minutes} dk {seconds} sn | Duration format for minutes > 0 |
| `settings_duration_sec_only` | {seconds} sn | Duration format for < 1 min |

---

## VideoCreationView.swift (export progress)

| Key | Turkish | Notes |
|---|---|---|
| `video_creation_title` | Videon oluşturuluyor… | Main title during export |
| `video_creation_status_preparing` | Hazırlanıyor… | Initial status |
| `video_creation_status_adding` | Videolar ekleniyor… | Progress status (early) |
| `video_creation_status_composing` | Video düzenleniyor… | Progress status (mid) |
| `video_creation_status_almost_done` | Neredeyse bitti… | Progress status (late) |
| `video_creation_status_saving` | Photos'a kaydediliyor… | Status during save |
| `video_creation_helper_text` | Uygulamayı kapatabilirsin — hazır olunca sana haber vereceğiz | Reassurance text |
| `video_creation_error_alert_title` | Hata | Alert title |
| `video_creation_error_alert_ok` | Tamam | Error alert button |

---

## CompletionView.swift (success screen)

| Key | Turkish | Notes |
|---|---|---|
| `completion_title` | Video hazır! | Success title |
| `completion_subtitle` | Videon fotoğraflarına kaydedildi. | Confirmation text |
| `completion_button_share` | Videoyu paylaş | Share sheet button |
| `completion_button_open_photos` | Photos'u aç | Button to open Photos app |
| `completion_button_create_another` | Yeni video oluştur | Button to reset and start over |

---

## PaywallView.swift (buy sheet)

| Key | Turkish | Notes |
|---|---|---|
| `paywall_hero_unlimited` | Sınırsız | Pro badge on hero |
| `paywall_hero_current_coins_label` | Mevcut jetonlar: | Free-tier label |
| `paywall_hero_coin_ratio` | 1 jeton = 1 video | Explanation of coin model |
| `paywall_feature_music_title` | Arka plan müziği | Feature row |
| `paywall_feature_music_desc` | Kendi soundtrack'ini ekle | |
| `paywall_feature_slowmo_title` | Ağır çekim | Feature row |
| `paywall_feature_slowmo_desc` | Herhangi bir klipte sinematik ağır çekim | |
| `paywall_feature_watermark_title` | Filigran yok | Feature row |
| `paywall_feature_watermark_desc` | Tam kalitede dışa aktar | |
| `paywall_coins_section_title` | Jeton al | Section header |
| `paywall_coins_tier_label` | {count} jeton | Tier button |
| `paywall_coins_tag_best_value` | En iyi değer | Badge on 15-coin tier |
| `paywall_subscription_section_title` | Ya da sınırsıza geç | Section header |
| `paywall_subscription_monthly_title` | Aylık | Subscription tier |
| `paywall_subscription_monthly_badge` | %43 tasarruf | Discount badge |
| `paywall_subscription_yearly_title` | Yıllık | Subscription tier |
| `paywall_subscription_yearly_badge` | %68 tasarruf | Discount badge |
| `paywall_subscription_monthly_price` | {price} / ay | |
| `paywall_subscription_yearly_price` | {price} / yıl | |
| `paywall_restore_purchases` | Satın alımları geri yükle | Button |
| `paywall_link_privacy` | Gizlilik | Link label |
| `paywall_link_terms` | Koşullar | Link label |
| `paywall_link_support` | Destek | Link label |
| `paywall_not_now_button` | Şimdi değil | Dismiss button |
| `paywall_products_error_title` | Ürünler yüklenemedi | Error state |
| `paywall_products_error_retry` | Tekrar dene | Retry button |
| `paywall_purchase_error_title` | Satın alma hatası | Alert title |
| `paywall_purchase_error_message` | Satın alma tamamlanamadı. Lütfen tekrar dene. | Error message |
| `paywall_purchase_error_ok` | Tamam | Alert button |
| `paywall_trial_badge` | {days} günlük ücretsiz deneme | Trial offer badge |

---

## DailySpinView.swift (slot machine)

| Key | Turkish | Notes |
|---|---|---|
| `spin_title` | Günlük çevirme | Screen title |
| `spin_subtitle_closed` | Yarın yeni bir çevirme için geri gel | Status when spin unavailable |
| `spin_rule_hint` | 3 🪙 = jackpot · 2 🪙 = ödül | Rules hint below title |
| `spin_result_win_singular` | +1 jeton kazandın! | count == 1 |
| `spin_result_win_plural` | +{count} jeton kazandın! | count != 1 (identical) |
| `spin_subtitle_lose` | Az kaldı! Yarın tekrar dene | Lose message |
| `spin_status_rolling` | Dönüyor… | Status while spinning |
| `spin_button_spin` | Çevir | Primary button |
| `spin_button_awesome` | Harika | After a win |
| `spin_button_continue` | Devam et | After a lose |
| `spin_button_close` | Kapat | Bottom close button |

---

## TrimmingView.swift

| Key | Turkish | Notes |
|---|---|---|
| `trimming_video_loading` | Video yükleniyor… | Loading indicator |
| `trimming_toggle_slowmo` | Ağır çekimi aç | Toggle label |
| `trimming_toggle_mute` | Videoyu sessize al | Toggle label |
| `trimming_pro_badge` | PRO | Pro feature badge |
| `trimming_time_start` | Başlangıç: {time} | Trim start time display |
| `trimming_time_end` | Bitiş: {time} | Trim end time display |
| `trimming_button_done` | Bitti | Save trim + close |

---

## AppConfigurationView.swift

| Key | Turkish | Notes |
|---|---|---|
| `app_config_title` | Uygulama ayarları | Modal title |

---

## NotificationManager.swift

| Key | Turkish | Notes |
|---|---|---|
| `notification_video_ready_title` | Video derlemesi hazır! | Local push title |
| `notification_video_ready_body` | Videon Photos'a kaydedildi | Local push body |

---

## Info.plist (bundle metadata)

| Key | Turkish | Limit | Notes |
|---|---|---|---|
| `bundle_display_name` | Movie Maker | 30 | `CFBundleDisplayName` — brand |
| `plist_photo_library_add_usage` | Derlenen videonu Photos'a kaydetmek için izne ihtiyacımız var | ≤100 | 62 chars |
| `plist_photo_library_usage` | Derleme oluşturmak için video ve fotoğraflarına erişmemiz gerekiyor | ≤100 | 67 chars |

---

## App Store Connect Listing

| Key | Turkish | Limit | Notes |
|---|---|---|---|
| `asc_app_name` | Movie Maker - Reels & YouTube | 30 | Brand-consistent (29 chars) |
| `asc_subtitle` | TikTok Reels Shorts için video | 30 | 30 chars |
| `asc_keywords` | video birleştir,montaj,kolaj,müzik,fotoğraf,slayt,klip,kes,düzenle,editör,birleştirici | 100 | Re-targeted for TR search (91 chars) |
| `asc_promotional_text` | Video, fotoğraf ve müziği tek bir temiz filmde birleştir. Klipleri birleştir, kırp, sırala, soundtrack ekle ve dışa aktar. | 170 | 124 chars |
| `asc_whats_new` | Artık her platform için mükemmel boyutta dışa aktar. YouTube için 16:9, Reels ve TikTok için 9:16, Instagram için 1:1 seç — ve doğrudan uygulamadan paylaş.\n\nÜcretsiz sürüm daha esnek: 3 tam dışa aktarım, filigran yok, öğe sınırı yok. Sonrasında jetonla dolum yap ya da Pro'ya aylık veya yıllık geç. | 4000 | v2.4 release notes |
| `asc_description` | *(bkz. Description structure)* | 4000 | |

### Description structure

| Section | Turkish |
|---|---|
| `desc_headline` | Video, fotoğraf ve müziği tek bir temiz filmde birleştir — karmaşık zaman çizelgesi yok. |
| `desc_hook` | Movie Maker, klipleri birleştirmenin, soundtrack eklemenin ve galeriye aktarmanın en hızlı yolu. Sürükle, kırp ve bittin. |
| `desc_section_what` | NELER YAPABİLİRSİN |
| `desc_what_merge` | Kütüphanendeki videoları tek bir filmde birleştir — istediğin kadar klip. |
| `desc_what_combine` | Video ve fotoğrafları istediğin sırayla birleştirip hareketli bir slayt gösterisi oluştur. |
| `desc_what_trim` | Her klibin başını ve sonunu kırp, sadece en iyi anlar kalsın. |
| `desc_what_reorder` | Sahneleri sürükleyerek hikaye doğru hissedene kadar yeniden sırala. |
| `desc_what_mute` | Sessiz bir kurgu veya sadece müzikli bir soundtrack istediğinde klip sesini kapat. |
| `desc_what_export` | Saniyeler içinde Photos'a dışa aktar, paylaşmaya hazır. |
| `desc_section_how` | NASIL ÇALIŞIR |
| `desc_how_1` | Kütüphanenden klipler ve fotoğraflar seç. |
| `desc_how_2` | İhtiyaca göre sırala, kırp ve sessize al. |
| `desc_how_3` | Müzik ekle ve dışa aktar. |
| `desc_section_perfect_for` | ŞUNLAR İÇİN İDEAL |
| `desc_perfect_travel` | Seyahat özetleri ve tatil vurguları |
| `desc_perfect_family` | Aile anları ve doğum günü derlemeleri |
| `desc_perfect_events` | Düğün, parti ve maç özetleri |
| `desc_perfect_social` | Instagram, TikTok ve YouTube Shorts için sosyal paylaşımlar |
| `desc_perfect_slideshow` | Bir fotoğraf çekiminden hızlı slayt gösterileri |
| `desc_section_pro` | PRO ÖZELLİKLER (İSTEĞE BAĞLI) |
| `desc_pro_music` | Cilalı soundtrack'ler için arka plan müzik kütüphanesi |
| `desc_pro_slowmo` | Önemli anlarda ağır çekim |
| `desc_pro_longer` | Daha fazla klip ve fotoğrafla daha uzun projeler |
| `desc_pro_trial` | Abone olmadan önce Pro'yu ücretsiz dene — koşullar uygulamada açıkça gösterilir. |
| `desc_section_privacy` | ÖNCE GİZLİLİK |
| `desc_privacy_body` | Düzenleme tamamen cihazında yapılır. Medyaların fotoğraf kütüphanende kalır. Sen paylaşmayı seçmediğin sürece hiçbir şey hiçbir yere yüklenmez. |
| `desc_privacy_url_line` | Gizlilik Politikası: https://okekedev.github.io/MovieMaker/privacy.html |
| `desc_terms_url_line` | Kullanım Koşulları: https://okekedev.github.io/MovieMaker/terms.html |

---

## Translation notes (Turkish)

- Turkish CLDR plural rule: 1 form (same string works for all counts). Kept singular/plural keys with identical text so the source key structure stays stable, but a single stringsdict entry per pair is sufficient at runtime.
- Tone: informal-friendly ("sen") — matches consumer video-app norm. Polite "siz" reserved for permission alerts if reviewer prefers formality; current strings mix "dokun" (imperative singular) throughout.
- "Photos" (Apple app) kept as brand — matches the iOS system app name in Turkey.
- Keywords re-targeted: `video birleştir` (merge video), `montaj`, `kolaj`, `slayt` (slide), `editör`, `birleştirici` (merger). Avoided duplicating title/subtitle words where possible.
- Percentage format: Turkish convention is `%43` (percent sign leading), applied consistently.
- Currency-in-price (`{price} / ay`) reads naturally in Turkish price contexts.
