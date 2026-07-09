# Movie Maker — Czech (cs) Strings Inventory

**Locale:** `cs` — Czech (Czech Republic)
**RTL:** no
**Plural forms:** 3 (one: n=1; few: n=2–4; other: n=0 or n≥5) — Unicode CLDR `cs`

**Scope:** every user-visible string in Movie Maker v2.4, localized for Czech.

**Brand terms kept in English:** Movie Maker, Pro, Reels, YouTube, TikTok, Shorts, Instagram, iPhone, iPad, Photos.

---

## MediaSelectionView.swift (home)

| Key | Czech | Notes |
|---|---|---|
| `media_home_title` | Movie Maker | Main title on empty home state |
| `media_home_cta` | Klepnutím vyberte videa a fotky | Helper text below pulse button |
| `media_header_back` | Zpět | Button to deselect all media |
| `media_header_spin` | Točit | Daily spin button label |
| `media_section_title` | Vyberte své okamžiky | Section headline when media selected |
| `media_section_subtitle` | Klepnutím upravíte  \|  Podržením přesunete | Instruction text |
| `media_coin_balance_singular` | Zbývá {count} mince — 1 mince za export | count == 1 (one) |
| `media_coin_balance_paucal_2_4` | Zbývají {count} mince — 1 mince za export | count 2–4 (few) |
| `media_coin_balance_plural_5plus` | Zbývá {count} mincí — 1 mince za export | count 0, 5+ (other) |
| `media_grid_add_more` | Přidat další | Button below media grid |
| `media_button_continue` | Pokračovat | Primary CTA at bottom |
| `media_permission_alert_title` | Vyžadován přístup k fotkám | Alert title |
| `media_permission_alert_open_settings` | Otevřít Nastavení | Alert button |
| `media_permission_alert_cancel` | Zrušit | Alert cancel button |
| `media_permission_alert_message` | Povolte prosím Movie Maker přístup k vašim videím a fotkám v Nastavení pro vytváření sestřihů. | Alert message |

---

## SettingsView.swift (export options)

| Key | Czech | Notes |
|---|---|---|
| `settings_header_back` | Zpět | Back button |
| `settings_aspect_ratio_label` | Poměr stran | Section title |
| `settings_aspect_ratio_for_hint` | Pro {platform} | Subtext |
| `settings_title_screen_label` | Titulní obrazovka | Section title |
| `settings_title_required_label` | Název (povinné) | Field label |
| `settings_title_placeholder` | Zadejte název | TextField placeholder |
| `settings_subtitle_label` | Podnázev (volitelné) | Field label |
| `settings_subtitle_placeholder` | Zadejte podnázev | TextField placeholder |
| `settings_title_screen_hint` | Bílý text na černém pozadí • 3 sekundy | Instruction/note |
| `settings_title_screen_no_title` | Bez názvu | Status when title empty |
| `settings_transition_style_label` | Styl přechodu | Section title |
| `settings_transition_color_label` | Barva přechodu | ColorPicker label |
| `settings_photo_duration_label` | Délka fotky | Section title |
| `settings_photo_duration_value` | {value} s | Duration picker |
| `settings_background_music_label` | Hudba na pozadí | Section title |
| `settings_music_select_button` | Vybrat hudbu | Button to open music picker |
| `settings_music_volume_label` | Hlasitost | Slider label |
| `settings_music_volume_percentage` | {value} % | Volume display |
| `settings_music_background_only_toggle` | Pouze hudba na pozadí | Toggle label |
| `settings_music_remove_button` | Odstranit hudbu | Button to clear selection |
| `settings_music_loop_hint` | Hudba se bude opakovat po celé video | Note about looping |
| `settings_music_none_indicator` | Žádná | Status when no music |
| `settings_preview_section_label` | Náhled | Section title |
| `settings_preview_total_length` | Celková délka: {duration} | Formatted duration |
| `settings_preview_item_count_singular` | {count} položka | count == 1 (one) |
| `settings_preview_item_count_paucal_2_4` | {count} položky | count 2–4 (few) |
| `settings_preview_item_count_plural_5plus` | {count} položek | count 0, 5+ (other) |
| `settings_create_button` | Vytvořit video | Primary button |
| `settings_warning_alert_title` | Upozornění | Alert title for validation warnings |
| `settings_warning_long_videos_singular` | Máte 1 video delší než 5 minut. Výsledný soubor může být velmi velký. | count == 1 (one) |
| `settings_warning_long_videos_paucal_2_4` | Máte {count} videa delší než 5 minut. Výsledný soubor může být velmi velký. | count 2–4 (few) |
| `settings_warning_long_videos_plural_5plus` | Máte {count} videí delších než 5 minut. Výsledný soubor může být velmi velký. | count 0, 5+ (other) |
| `settings_warning_many_items_message` | Máte {count} položek. Vytváření může trvat několik minut. | Warning about many items |
| `settings_warning_create_anyway` | Přesto vytvořit | Alert button to proceed |
| `settings_warning_cancel` | Zrušit | Alert cancel button |
| `settings_pro_badge` | PRO | Pro tier badge |
| `settings_duration_min_sec` | {minutes} min {seconds} s | Duration format for minutes > 0 |
| `settings_duration_sec_only` | {seconds} s | Duration format for < 1 min |

---

## VideoCreationView.swift (export progress)

| Key | Czech | Notes |
|---|---|---|
| `video_creation_title` | Vytváříme vaše video… | Main title during export |
| `video_creation_status_preparing` | Připravuji… | Initial status |
| `video_creation_status_adding` | Přidávám videa… | Progress status (early) |
| `video_creation_status_composing` | Skládám video… | Progress status (mid) |
| `video_creation_status_almost_done` | Skoro hotovo… | Progress status (late) |
| `video_creation_status_saving` | Ukládám do Photos… | Status during save |
| `video_creation_helper_text` | Aplikaci můžete zavřít – dáme vědět, až bude hotovo | Reassurance text |
| `video_creation_error_alert_title` | Chyba | Alert title |
| `video_creation_error_alert_ok` | OK | Error alert button |

---

## CompletionView.swift (success screen)

| Key | Czech | Notes |
|---|---|---|
| `completion_title` | Video hotovo! | Success title |
| `completion_subtitle` | Vaše video bylo uloženo do fotek. | Confirmation text |
| `completion_button_share` | Sdílet video | Share sheet button |
| `completion_button_open_photos` | Otevřít Photos | Button to open Photos app |
| `completion_button_create_another` | Vytvořit další video | Button to reset and start over |

---

## PaywallView.swift (buy sheet)

| Key | Czech | Notes |
|---|---|---|
| `paywall_hero_unlimited` | Neomezeně | Pro badge on hero |
| `paywall_hero_current_coins_label` | Aktuální mince: | Free-tier label |
| `paywall_hero_coin_ratio` | 1 mince = 1 video | Explanation of coin model |
| `paywall_feature_music_title` | Hudba na pozadí | Feature row |
| `paywall_feature_music_desc` | Přidejte vlastní soundtrack | |
| `paywall_feature_slowmo_title` | Zpomalený záběr | Feature row |
| `paywall_feature_slowmo_desc` | Filmové zpomalení na libovolném klipu | |
| `paywall_feature_watermark_title` | Bez vodoznaku | Feature row |
| `paywall_feature_watermark_desc` | Export v plné kvalitě | |
| `paywall_coins_section_title` | Kupte mince | Section header |
| `paywall_coins_tier_label` | {count} mincí | Tier button |
| `paywall_coins_tag_best_value` | Nejlepší hodnota | Badge on 15-coin tier |
| `paywall_subscription_section_title` | Nebo si pořiďte neomezené | Section header |
| `paywall_subscription_monthly_title` | Měsíčně | Subscription tier |
| `paywall_subscription_monthly_badge` | Ušetřete 43 % | Discount badge |
| `paywall_subscription_yearly_title` | Ročně | Subscription tier |
| `paywall_subscription_yearly_badge` | Ušetřete 68 % | Discount badge |
| `paywall_subscription_monthly_price` | {price} / měsíc | |
| `paywall_subscription_yearly_price` | {price} / rok | |
| `paywall_restore_purchases` | Obnovit nákupy | Button |
| `paywall_link_privacy` | Soukromí | Link label |
| `paywall_link_terms` | Podmínky | Link label |
| `paywall_link_support` | Podpora | Link label |
| `paywall_not_now_button` | Teď ne | Dismiss button |
| `paywall_products_error_title` | Nelze načíst produkty | Error state |
| `paywall_products_error_retry` | Zkusit znovu | Retry button |
| `paywall_purchase_error_title` | Chyba nákupu | Alert title |
| `paywall_purchase_error_message` | Nákup nelze dokončit. Zkuste to prosím znovu. | Error message |
| `paywall_purchase_error_ok` | OK | Alert button |
| `paywall_trial_badge` | {days}denní zkušební verze zdarma | Trial offer badge |

---

## DailySpinView.swift (slot machine)

| Key | Czech | Notes |
|---|---|---|
| `spin_title` | Denní roztočení | Screen title |
| `spin_subtitle_closed` | Vraťte se zítra pro další roztočení | Status when spin unavailable |
| `spin_rule_hint` | 3 🪙 = jackpot · 2 🪙 = výhra | Rules hint below title |
| `spin_result_win_singular` | Vyhráli jste +1 minci! | count == 1 (one) |
| `spin_result_win_paucal_2_4` | Vyhráli jste +{count} mince! | count 2–4 (few) |
| `spin_result_win_plural_5plus` | Vyhráli jste +{count} mincí! | count 0, 5+ (other) |
| `spin_subtitle_lose` | Skoro! Zkuste to zítra znovu | Lose message |
| `spin_status_rolling` | Točí se… | Status while spinning |
| `spin_button_spin` | Točit | Primary button |
| `spin_button_awesome` | Skvělé | After a win |
| `spin_button_continue` | Pokračovat | After a lose |
| `spin_button_close` | Zavřít | Bottom close button |

---

## TrimmingView.swift

| Key | Czech | Notes |
|---|---|---|
| `trimming_video_loading` | Načítám video… | Loading indicator |
| `trimming_toggle_slowmo` | Zapnout zpomalení | Toggle label |
| `trimming_toggle_mute` | Ztlumit video | Toggle label |
| `trimming_pro_badge` | PRO | Pro feature badge |
| `trimming_time_start` | Začátek: {time} | Trim start time display |
| `trimming_time_end` | Konec: {time} | Trim end time display |
| `trimming_button_done` | Hotovo | Save trim + close |

---

## AppConfigurationView.swift

| Key | Czech | Notes |
|---|---|---|
| `app_config_title` | Nastavení aplikace | Modal title |

---

## NotificationManager.swift

| Key | Czech | Notes |
|---|---|---|
| `notification_video_ready_title` | Sestřih videa je hotový! | Local push title |
| `notification_video_ready_body` | Vaše video bylo uloženo do Photos | Local push body |

---

## Info.plist (bundle metadata)

| Key | Czech | Limit | Notes |
|---|---|---|---|
| `bundle_display_name` | Movie Maker | 30 | `CFBundleDisplayName` — brand |
| `plist_photo_library_add_usage` | Potřebujeme oprávnění k uložení vašeho hotového videa do Photos | ≤100 | 63 chars |
| `plist_photo_library_usage` | Potřebujeme přístup k vašim videím a fotkám pro tvorbu sestřihů | ≤100 | 63 chars |

---

## App Store Connect Listing

| Key | Czech | Limit | Notes |
|---|---|---|---|
| `asc_app_name` | Movie Maker - Reels & YouTube | 30 | Brand-consistent (29 chars) |
| `asc_subtitle` | Videa pro TikTok Reels Shorts | 30 | 29 chars |
| `asc_keywords` | střihač,spojit,videa,fotky,hudba,úprava,koláž,slideshow,klipy,montáž,titulky,video,editor | 100 | Re-targeted for Czech search (95 chars) |
| `asc_promotional_text` | Spojte videa, fotky a hudbu do jednoho čistého filmu. Kombinujte klipy, ořízněte, přeuspořádejte, přidejte hudbu a exportujte. | 170 | 128 chars |
| `asc_whats_new` | Nyní exportujte v ideální velikosti pro každou platformu. Vyberte 16:9 pro YouTube, 9:16 pro Reels a TikTok, nebo 1:1 pro Instagram – a sdílejte přímo z aplikace.\n\nBezplatná verze je štědřejší: 3 plné exporty zdarma, bez vodoznaku, bez omezení počtu položek. Poté si dobijte mince nebo přejděte na Pro měsíčně či ročně. | 4000 | v2.4 release notes |
| `asc_description` | *(viz sekce Description structure níže)* | 4000 | |

### Description structure

| Section | Czech |
|---|---|
| `desc_headline` | Spojte videa, fotky a hudbu do jednoho čistého filmu — bez složité časové osy. |
| `desc_hook` | Movie Maker je nejrychlejší způsob, jak spojit klipy, přidat soundtrack a exportovat do fotoaparátu. Stačí přetáhnout, oříznout a je hotovo. |
| `desc_section_what` | CO MŮŽETE DĚLAT |
| `desc_what_merge` | Spojte videa z knihovny do jednoho filmu — tolik klipů, kolik chcete. |
| `desc_what_combine` | Kombinujte videa a fotky v libovolném pořadí a vytvořte slideshow s pohybem. |
| `desc_what_trim` | Ořízněte začátek a konec každého klipu, aby zůstaly jen nejlepší momenty. |
| `desc_what_reorder` | Přetažením přeuspořádejte scény, dokud příběh nesedí. |
| `desc_what_mute` | Ztlumte zvuk klipu, když chcete tichý sestřih nebo jen hudbu. |
| `desc_what_export` | Exportujte zpět do Photos během sekund, připraveno ke sdílení. |
| `desc_section_how` | JAK TO FUNGUJE |
| `desc_how_1` | Vyberte klipy a fotky ze své knihovny. |
| `desc_how_2` | Přeuspořádejte, ořízněte a ztlumte podle potřeby. |
| `desc_how_3` | Přidejte hudbu a exportujte. |
| `desc_section_perfect_for` | IDEÁLNÍ PRO |
| `desc_perfect_travel` | Cestovatelské sestřihy a nejlepší momenty z dovolené |
| `desc_perfect_family` | Rodinné okamžiky a narozeninové sestřihy |
| `desc_perfect_events` | Sestřihy ze svateb, oslav a sportu |
| `desc_perfect_social` | Příspěvky pro Instagram, TikTok a YouTube Shorts |
| `desc_perfect_slideshow` | Rychlé slideshow z fotografování |
| `desc_section_pro` | FUNKCE PRO (VOLITELNÉ) |
| `desc_pro_music` | Knihovna hudby na pozadí pro dokonalé soundtracky |
| `desc_pro_slowmo` | Zpomalený záběr na klíčových momentech |
| `desc_pro_longer` | Delší projekty s více klipy a fotkami |
| `desc_pro_trial` | Vyzkoušejte Pro zdarma před předplatným — podmínky jsou v aplikaci jasně uvedeny. |
| `desc_section_privacy` | SOUKROMÍ NA PRVNÍM MÍSTĚ |
| `desc_privacy_body` | Úpravy probíhají výhradně na vašem zařízení. Vaše média zůstávají ve vaší fotoknihovně. Nic se nikam nenahrává, pokud se nerozhodnete sdílet. |
| `desc_privacy_url_line` | Zásady ochrany soukromí: https://okekedev.github.io/MovieMaker/privacy.html |
| `desc_terms_url_line` | Podmínky použití: https://okekedev.github.io/MovieMaker/terms.html |

---

## Translation notes (Czech)

- Slavic plurals split into `one`, `few` (2–4), `other` (0, 5+). Extra rows added for `media_coin_balance`, `settings_preview_item_count`, `settings_warning_long_videos`, `spin_result_win`.
- "Photos" (the Apple app) preserved as English brand — matches iOS system.
- "PRO" left as-is (badge on cards).
- Keywords re-targeted: `střihač` (editor), `spojit` (merge), `koláž` (collage), `slideshow`, `montáž` (montage) — high-volume Czech search terms distinct from the app name.
- `points_ratio` and `days`-based trial badge use decliner suffix directly (`{days}denní`) — StoreKit passes cardinal; grammatically consistent for 1/2/5/etc.
