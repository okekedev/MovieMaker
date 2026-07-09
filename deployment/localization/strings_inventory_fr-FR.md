# Movie Maker — Strings Inventory (fr-FR)

**Locale:** fr-FR (French — France)
**RTL:** no
**Plural forms:** 2 (one, other) — note: French treats 0 and 1 as singular
**Scope:** 15 views · 89 unique app-side strings · 35 ASC listing keys.

---

## MediaSelectionView.swift (home)

| Key | Translated | Notes |
|---|---|---|
| `media_home_title` | Movie Maker | Marque — non traduit |
| `media_home_cta` | Appuyez pour choisir vidéos et photos | Texte d'aide |
| `media_header_back` | Retour | Bouton pour tout désélectionner |
| `media_header_spin` | Tourner | Libellé du tirage quotidien |
| `media_section_title` | Choisissez vos moments | En-tête quand des médias sont sélectionnés |
| `media_section_subtitle` | Appuyez pour modifier  \|  Maintenez pour réorganiser | Instruction |
| `media_coin_balance_singular` | {count} jeton restant — 1 jeton par export | count == 1 |
| `media_coin_balance_plural` | {count} jetons restants — 1 jeton par export | count != 1 |
| `media_grid_add_more` | Ajouter | Bouton sous la grille |
| `media_button_continue` | Continuer | CTA principal |
| `media_permission_alert_title` | Accès à Photos requis | Titre de l'alerte |
| `media_permission_alert_open_settings` | Ouvrir les Réglages | Bouton d'alerte |
| `media_permission_alert_cancel` | Annuler | Annuler |
| `media_permission_alert_message` | Autorisez Movie Maker à accéder à vos vidéos et photos dans Réglages pour créer des compilations. | Message d'alerte |

---

## SettingsView.swift (export options)

| Key | Translated | Notes |
|---|---|---|
| `settings_header_back` | Retour | Bouton retour |
| `settings_aspect_ratio_label` | Format d'image | Titre de section |
| `settings_aspect_ratio_for_hint` | Pour {platform} | Sous-texte ; {platform} = "YouTube", "Instagram", "Reels & TikTok" |
| `settings_title_screen_label` | Écran de titre | Titre de section |
| `settings_title_required_label` | Titre (requis) | Libellé de champ |
| `settings_title_placeholder` | Saisissez le titre | Placeholder |
| `settings_subtitle_label` | Sous-titre (facultatif) | Libellé de champ |
| `settings_subtitle_placeholder` | Saisissez le sous-titre | Placeholder |
| `settings_title_screen_hint` | Texte blanc sur fond noir • 3 secondes | Note |
| `settings_title_screen_no_title` | Sans titre | État sans titre |
| `settings_transition_style_label` | Style de transition | Titre de section |
| `settings_transition_color_label` | Couleur de transition | Libellé ColorPicker |
| `settings_photo_duration_label` | Durée des photos | Titre de section |
| `settings_photo_duration_value` | {value} s | Sélecteur de durée |
| `settings_background_music_label` | Musique de fond | Titre de section |
| `settings_music_select_button` | Choisir une musique | Ouvre le sélecteur |
| `settings_music_volume_label` | Volume | Libellé slider |
| `settings_music_volume_percentage` | {value} % | Volume |
| `settings_music_background_only_toggle` | Musique de fond uniquement | Toggle |
| `settings_music_remove_button` | Retirer la musique | Effacer |
| `settings_music_loop_hint` | La musique sera jouée en boucle pendant toute la vidéo | Note sur la boucle |
| `settings_music_none_indicator` | Aucune | État sans musique |
| `settings_preview_section_label` | Aperçu | Titre de section |
| `settings_preview_total_length` | Durée totale : {duration} | Durée formatée |
| `settings_preview_item_count_singular` | {count} élément | count == 1 |
| `settings_preview_item_count_plural` | {count} éléments | count != 1 |
| `settings_create_button` | Créer la vidéo | Bouton principal |
| `settings_warning_alert_title` | Avertissement | Alerte de validation |
| `settings_warning_long_videos_singular` | Vous avez 1 vidéo de plus de 5 minutes. Le fichier peut devenir très volumineux. | count == 1 |
| `settings_warning_long_videos_plural` | Vous avez {count} vidéos de plus de 5 minutes. Le fichier peut devenir très volumineux. | count != 1 |
| `settings_warning_many_items_message` | Vous avez {count} éléments. Cela peut prendre plusieurs minutes. | Nombreux éléments |
| `settings_warning_create_anyway` | Créer quand même | Continuer |
| `settings_warning_cancel` | Annuler | Annuler |
| `settings_pro_badge` | PRO | Non traduit |
| `settings_duration_min_sec` | {minutes} min {seconds} s | Durée avec minutes |
| `settings_duration_sec_only` | {seconds} s | Durée < 1 min |

---

## VideoCreationView.swift (export progress)

| Key | Translated | Notes |
|---|---|---|
| `video_creation_title` | Création de votre vidéo… | Titre pendant l'export |
| `video_creation_status_preparing` | Préparation… | État initial |
| `video_creation_status_adding` | Ajout des vidéos… | Progression début |
| `video_creation_status_composing` | Composition de la vidéo… | Progression milieu |
| `video_creation_status_almost_done` | Presque terminé… | Progression fin |
| `video_creation_status_saving` | Enregistrement dans Photos… | Enregistrement |
| `video_creation_helper_text` | Vous pouvez fermer l'app — nous vous préviendrons quand ce sera prêt | Texte rassurant |
| `video_creation_error_alert_title` | Erreur | Titre d'alerte |
| `video_creation_error_alert_ok` | OK | Bouton |

---

## CompletionView.swift (success screen)

| Key | Translated | Notes |
|---|---|---|
| `completion_title` | Vidéo créée ! | Titre de succès |
| `completion_subtitle` | Votre vidéo a été enregistrée dans vos photos. | Confirmation |
| `completion_button_share` | Partager la vidéo | Bouton de partage |
| `completion_button_open_photos` | Ouvrir Photos | Ouvrir l'app Photos |
| `completion_button_create_another` | Créer une autre vidéo | Recommencer |

---

## PaywallView.swift (buy sheet)

| Key | Translated | Notes |
|---|---|---|
| `paywall_hero_unlimited` | Illimité | Badge Pro |
| `paywall_hero_current_coins_label` | Jetons actuels : | Libellé free |
| `paywall_hero_coin_ratio` | 1 jeton = 1 vidéo | Explication |
| `paywall_feature_music_title` | Musique de fond | Ligne de fonctionnalité |
| `paywall_feature_music_desc` | Ajoutez votre propre bande-son | |
| `paywall_feature_slowmo_title` | Ralenti | Ligne de fonctionnalité |
| `paywall_feature_slowmo_desc` | Ralenti cinématographique sur n'importe quel clip | |
| `paywall_feature_watermark_title` | Sans filigrane | Ligne de fonctionnalité |
| `paywall_feature_watermark_desc` | Export en qualité maximale | |
| `paywall_coins_section_title` | Acheter des jetons | En-tête |
| `paywall_coins_tier_label` | {count} jetons | Bouton de pack |
| `paywall_coins_tag_best_value` | Meilleure offre | Badge du pack de 15 |
| `paywall_subscription_section_title` | Ou passez en illimité | En-tête |
| `paywall_subscription_monthly_title` | Mensuel | Niveau d'abonnement |
| `paywall_subscription_monthly_badge` | -43 % | Badge de réduction |
| `paywall_subscription_yearly_title` | Annuel | Niveau d'abonnement |
| `paywall_subscription_yearly_badge` | -68 % | Badge de réduction |
| `paywall_subscription_monthly_price` | {price} / mois | {price} formaté par StoreKit |
| `paywall_subscription_yearly_price` | {price} / an | {price} formaté par StoreKit |
| `paywall_restore_purchases` | Restaurer les achats | Bouton |
| `paywall_link_privacy` | Confidentialité | Lien |
| `paywall_link_terms` | Conditions | Lien |
| `paywall_link_support` | Assistance | Lien |
| `paywall_not_now_button` | Pas maintenant | Fermer |
| `paywall_products_error_title` | Impossible de charger les produits | État d'erreur |
| `paywall_products_error_retry` | Réessayer | Bouton |
| `paywall_purchase_error_title` | Erreur d'achat | Titre d'alerte |
| `paywall_purchase_error_message` | Impossible de finaliser l'achat. Veuillez réessayer. | Message |
| `paywall_purchase_error_ok` | OK | Bouton |
| `paywall_trial_badge` | Essai gratuit de {days} jours | Badge d'essai |

---

## DailySpinView.swift (slot machine)

| Key | Translated | Notes |
|---|---|---|
| `spin_title` | Tirage du jour | Titre |
| `spin_subtitle_closed` | Revenez demain pour un autre tirage | État indisponible |
| `spin_rule_hint` | 3 🪙 = jackpot · 2 🪙 = prix | Règles |
| `spin_result_win_singular` | Vous avez gagné +1 jeton ! | count == 1 |
| `spin_result_win_plural` | Vous avez gagné +{count} jetons ! | count != 1 |
| `spin_subtitle_lose` | De justesse ! Réessayez demain | Message de défaite |
| `spin_status_rolling` | En cours… | Pendant le tirage |
| `spin_button_spin` | Tourner | Bouton principal |
| `spin_button_awesome` | Super | Après victoire |
| `spin_button_continue` | Continuer | Après défaite |
| `spin_button_close` | Fermer | Bouton du bas |

---

## TrimmingView.swift

| Key | Translated | Notes |
|---|---|---|
| `trimming_video_loading` | Chargement de la vidéo… | Indicateur |
| `trimming_toggle_slowmo` | Activer le ralenti | Toggle |
| `trimming_toggle_mute` | Couper le son | Toggle |
| `trimming_pro_badge` | PRO | Non traduit |
| `trimming_time_start` | Début : {time} | Temps de début |
| `trimming_time_end` | Fin : {time} | Temps de fin |
| `trimming_button_done` | Terminé | Enregistrer et fermer |

---

## AppConfigurationView.swift

| Key | Translated | Notes |
|---|---|---|
| `app_config_title` | Réglages de l'app | Titre modal |

---

## NotificationManager.swift

| Key | Translated | Notes |
|---|---|---|
| `notification_video_ready_title` | Votre vidéo est prête ! | Titre push |
| `notification_video_ready_body` | Votre vidéo a été enregistrée dans Photos | Corps push |

---

## Info.plist (bundle metadata)

| Key | Translated | Limit | Notes |
|---|---|---|---|
| `bundle_display_name` | Movie Maker | 30 | `CFBundleDisplayName` — marque non traduite |
| `plist_photo_library_add_usage` | Nous avons besoin de votre autorisation pour enregistrer votre vidéo dans Photos | ≤100 | 79 chars |
| `plist_photo_library_usage` | Nous avons besoin d'accéder à vos vidéos et photos pour créer des compilations | ≤100 | 78 chars |

---

## App Store Connect Listing

| Key | Translated | Limit | Notes |
|---|---|---|---|
| `asc_app_name` | Movie Maker - Reels & YouTube | 30 | Marque — identique à travers les locales |
| `asc_subtitle` | Fusionner vidéos et photos | 30 | 26 chars — SEO principal en FR |
| `asc_keywords` | montage,fusionner,couper,combiner,diaporama,collage,video,photo,musique,reels,tiktok,shorts | 100 | 91 chars — recherche FR sans dupliquer le titre (dropped "assembler" — redondant avec "combiner/fusionner") |
| `asc_promotional_text` | Fusionnez vidéos, photos et musique en un film prêt à partager. Combinez, coupez, réorganisez et exportez — sans timeline compliquée. | 170 | 131 chars |
| `asc_whats_new` | Exportez maintenant au format parfait pour chaque plateforme. Choisissez 16:9 pour YouTube, 9:16 pour Reels & TikTok ou 1:1 pour Instagram — puis partagez directement depuis l'app.\n\nLa version gratuite est plus généreuse : 3 exports complets, sans filigrane, sans limite d'éléments. Ensuite, rechargez avec des jetons ou passez Pro en mensuel ou annuel. | 4000 | Nouveautés v2.4 |
| `asc_description` | *(description complète — voir sections ci-dessous)* | 4000 | Segmentée par section |

### Description structure (for translation)

| Section | Translated |
|---|---|
| `desc_headline` | Fusionnez vidéos, photos et musique en un seul film — sans timeline compliquée. |
| `desc_hook` | Movie Maker est le moyen le plus rapide de combiner des clips, ajouter une bande-son et exporter vers votre pellicule. Glissez, coupez, c'est fait. |
| `desc_section_what` | CE QUE VOUS POUVEZ FAIRE |
| `desc_what_merge` | Fusionnez les vidéos de votre bibliothèque en un seul film — autant de clips que vous voulez. |
| `desc_what_combine` | Combinez vidéos et photos dans n'importe quel ordre pour créer un diaporama en mouvement. |
| `desc_what_trim` | Coupez le début et la fin de chaque clip pour ne garder que les meilleurs moments. |
| `desc_what_reorder` | Glissez pour réorganiser les scènes jusqu'à ce que l'histoire tienne. |
| `desc_what_mute` | Coupez le son du clip pour un montage silencieux ou uniquement musical. |
| `desc_what_export` | Exportez vers Photos en quelques secondes, prêt à partager. |
| `desc_section_how` | COMMENT ÇA MARCHE |
| `desc_how_1` | Choisissez des clips et photos dans votre bibliothèque. |
| `desc_how_2` | Réorganisez, coupez et mettez en sourdine selon vos besoins. |
| `desc_how_3` | Ajoutez de la musique et exportez. |
| `desc_section_perfect_for` | PARFAIT POUR |
| `desc_perfect_travel` | Récaps de voyage et souvenirs de vacances |
| `desc_perfect_family` | Moments en famille et compilations d'anniversaire |
| `desc_perfect_events` | Récaps de mariages, fêtes et matchs |
| `desc_perfect_social` | Posts pour Instagram, TikTok et YouTube Shorts |
| `desc_perfect_slideshow` | Diaporamas rapides depuis une séance photo |
| `desc_section_pro` | FONCTIONNALITÉS PRO (OPTIONNELLES) |
| `desc_pro_music` | Bibliothèque musicale pour des bandes-sons soignées |
| `desc_pro_slowmo` | Ralenti sur les moments clés |
| `desc_pro_longer` | Projets plus longs avec plus de clips et de photos |
| `desc_pro_trial` | Essayez Pro gratuitement avant de vous abonner — les conditions sont indiquées clairement dans l'app. |
| `desc_section_privacy` | LA CONFIDENTIALITÉ D'ABORD |
| `desc_privacy_body` | Le montage se fait entièrement sur votre appareil. Vos médias restent dans votre photothèque. Rien n'est envoyé nulle part sauf si vous choisissez de partager. |
| `desc_privacy_url_line` | Politique de confidentialité : https://okekedev.github.io/MovieMaker/privacy.html |
| `desc_terms_url_line` | Conditions d'utilisation : https://okekedev.github.io/MovieMaker/terms.html |
