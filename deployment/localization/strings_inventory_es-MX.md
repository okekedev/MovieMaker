# Movie Maker — Strings Inventory (es-MX)

**Locale:** es-MX (Spanish — Mexico, neutral Latin American)
**RTL:** no
**Plural forms:** 2 (one, other)
**Scope:** 15 views · 89 unique app-side strings · 35 ASC listing keys.

---

## MediaSelectionView.swift (home)

| Key | Translated | Notes |
|---|---|---|
| `media_home_title` | Movie Maker | Brand — sin traducir |
| `media_home_cta` | Toca para elegir videos y fotos | Texto de ayuda debajo del botón pulsante |
| `media_header_back` | Atrás | Botón para deseleccionar todo |
| `media_header_spin` | Girar | Etiqueta del giro diario |
| `media_section_title` | Elige tus momentos | Encabezado cuando hay media seleccionada |
| `media_section_subtitle` | Toca para editar  \|  Mantén para reordenar | Instrucción |
| `media_coin_balance_singular` | Queda {count} moneda — 1 moneda por exportación | count == 1 |
| `media_coin_balance_plural` | Quedan {count} monedas — 1 moneda por exportación | count != 1 |
| `media_grid_add_more` | Agregar más | Botón debajo del grid |
| `media_button_continue` | Continuar | CTA principal |
| `media_permission_alert_title` | Acceso a Photos requerido | Título de alerta |
| `media_permission_alert_open_settings` | Abrir Ajustes | Botón de alerta |
| `media_permission_alert_cancel` | Cancelar | Cancelar alerta |
| `media_permission_alert_message` | Permite a Movie Maker acceder a tus videos y fotos en Ajustes para crear compilaciones. | Mensaje de alerta |

---

## SettingsView.swift (export options)

| Key | Translated | Notes |
|---|---|---|
| `settings_header_back` | Atrás | Botón de regreso |
| `settings_aspect_ratio_label` | Relación de aspecto | Título de sección |
| `settings_aspect_ratio_for_hint` | Para {platform} | Subtexto; {platform} = "YouTube", "Instagram", "Reels & TikTok" |
| `settings_title_screen_label` | Pantalla de título | Título de sección |
| `settings_title_required_label` | Título (requerido) | Etiqueta de campo |
| `settings_title_placeholder` | Escribe el título | Placeholder |
| `settings_subtitle_label` | Subtítulo (opcional) | Etiqueta de campo |
| `settings_subtitle_placeholder` | Escribe el subtítulo | Placeholder |
| `settings_title_screen_hint` | Texto blanco sobre fondo negro • 3 segundos | Nota |
| `settings_title_screen_no_title` | Sin título | Estado cuando el título está vacío |
| `settings_transition_style_label` | Estilo de transición | Título de sección |
| `settings_transition_color_label` | Color de transición | Etiqueta de ColorPicker |
| `settings_photo_duration_label` | Duración de foto | Título de sección |
| `settings_photo_duration_value` | {value} s | Selector de duración |
| `settings_background_music_label` | Música de fondo | Título de sección |
| `settings_music_select_button` | Elegir música | Botón para abrir selector |
| `settings_music_volume_label` | Volumen | Etiqueta de slider |
| `settings_music_volume_percentage` | {value}% | Volumen |
| `settings_music_background_only_toggle` | Solo música de fondo | Toggle |
| `settings_music_remove_button` | Quitar música | Botón para limpiar |
| `settings_music_loop_hint` | La música se repetirá durante todo el video | Nota sobre el loop |
| `settings_music_none_indicator` | Ninguna | Estado sin música |
| `settings_preview_section_label` | Vista previa | Título de sección |
| `settings_preview_total_length` | Duración total: {duration} | Duración formateada |
| `settings_preview_item_count_singular` | {count} elemento | count == 1 |
| `settings_preview_item_count_plural` | {count} elementos | count != 1 |
| `settings_create_button` | Crear video | Botón principal |
| `settings_warning_alert_title` | Advertencia | Alerta de validación |
| `settings_warning_long_videos_singular` | Tienes 1 video de más de 5 minutos. El archivo puede quedar muy grande. | count == 1 |
| `settings_warning_long_videos_plural` | Tienes {count} videos de más de 5 minutos. El archivo puede quedar muy grande. | count != 1 |
| `settings_warning_many_items_message` | Tienes {count} elementos. Esto puede tardar varios minutos. | Muchos elementos |
| `settings_warning_create_anyway` | Crear de todos modos | Continuar en alerta |
| `settings_warning_cancel` | Cancelar | Cancelar |
| `settings_pro_badge` | PRO | Sin traducir |
| `settings_duration_min_sec` | {minutes} min {seconds} s | Duración con minutos |
| `settings_duration_sec_only` | {seconds} s | Duración < 1 min |

---

## VideoCreationView.swift (export progress)

| Key | Translated | Notes |
|---|---|---|
| `video_creation_title` | Creando tu video… | Título durante exportación |
| `video_creation_status_preparing` | Preparando… | Estado inicial |
| `video_creation_status_adding` | Agregando videos… | Estado temprano |
| `video_creation_status_composing` | Componiendo video… | Estado medio |
| `video_creation_status_almost_done` | Casi listo… | Estado tardío |
| `video_creation_status_saving` | Guardando en Photos… | Estado al guardar |
| `video_creation_helper_text` | Puedes cerrar la app — te avisamos cuando esté listo | Texto de tranquilidad |
| `video_creation_error_alert_title` | Error | Título de alerta |
| `video_creation_error_alert_ok` | OK | Botón |

---

## CompletionView.swift (success screen)

| Key | Translated | Notes |
|---|---|---|
| `completion_title` | ¡Video creado! | Título de éxito |
| `completion_subtitle` | Tu video se guardó en tus fotos. | Confirmación |
| `completion_button_share` | Compartir video | Botón de compartir |
| `completion_button_open_photos` | Abrir Photos | Abrir la app Photos |
| `completion_button_create_another` | Crear otro video | Reiniciar |

---

## PaywallView.swift (buy sheet)

| Key | Translated | Notes |
|---|---|---|
| `paywall_hero_unlimited` | Ilimitado | Distintivo Pro |
| `paywall_hero_current_coins_label` | Monedas actuales: | Etiqueta free |
| `paywall_hero_coin_ratio` | 1 moneda = 1 video | Explicación |
| `paywall_feature_music_title` | Música de fondo | Fila de función |
| `paywall_feature_music_desc` | Agrega tu propio soundtrack | |
| `paywall_feature_slowmo_title` | Cámara lenta | Fila de función |
| `paywall_feature_slowmo_desc` | Slow-mo cinematográfico en cualquier clip | |
| `paywall_feature_watermark_title` | Sin marca de agua | Fila de función |
| `paywall_feature_watermark_desc` | Exporta con calidad total | |
| `paywall_coins_section_title` | Comprar monedas | Encabezado |
| `paywall_coins_tier_label` | {count} monedas | Botón de paquete |
| `paywall_coins_tag_best_value` | Mejor valor | Distintivo del paquete de 15 |
| `paywall_subscription_section_title` | O hazte ilimitado | Encabezado |
| `paywall_subscription_monthly_title` | Mensual | Nivel de suscripción |
| `paywall_subscription_monthly_badge` | Ahorra 43% | Distintivo de descuento |
| `paywall_subscription_yearly_title` | Anual | Nivel de suscripción |
| `paywall_subscription_yearly_badge` | Ahorra 68% | Distintivo de descuento |
| `paywall_subscription_monthly_price` | {price} / mes | {price} lo formatea StoreKit |
| `paywall_subscription_yearly_price` | {price} / año | {price} lo formatea StoreKit |
| `paywall_restore_purchases` | Restaurar compras | Botón |
| `paywall_link_privacy` | Privacidad | Enlace |
| `paywall_link_terms` | Términos | Enlace |
| `paywall_link_support` | Soporte | Enlace |
| `paywall_not_now_button` | Ahora no | Cerrar |
| `paywall_products_error_title` | No se pudieron cargar los productos | Estado de error |
| `paywall_products_error_retry` | Reintentar | Botón |
| `paywall_purchase_error_title` | Error de compra | Título de alerta |
| `paywall_purchase_error_message` | No se pudo completar la compra. Inténtalo de nuevo. | Mensaje |
| `paywall_purchase_error_ok` | OK | Botón |
| `paywall_trial_badge` | Prueba gratis de {days} días | Distintivo de prueba |

---

## DailySpinView.swift (slot machine)

| Key | Translated | Notes |
|---|---|---|
| `spin_title` | Giro diario | Título |
| `spin_subtitle_closed` | Vuelve mañana para otro giro | Estado no disponible |
| `spin_rule_hint` | 3 🪙 = jackpot · 2 🪙 = premio | Reglas |
| `spin_result_win_singular` | ¡Ganaste +1 moneda! | count == 1 |
| `spin_result_win_plural` | ¡Ganaste +{count} monedas! | count != 1 |
| `spin_subtitle_lose` | ¡Casi! Intenta de nuevo mañana | Mensaje de pérdida |
| `spin_status_rolling` | Girando… | Mientras gira |
| `spin_button_spin` | Girar | Botón principal |
| `spin_button_awesome` | ¡Genial! | Tras ganar |
| `spin_button_continue` | Continuar | Tras perder |
| `spin_button_close` | Cerrar | Botón inferior |

---

## TrimmingView.swift

| Key | Translated | Notes |
|---|---|---|
| `trimming_video_loading` | Cargando video… | Indicador |
| `trimming_toggle_slowmo` | Activar cámara lenta | Toggle |
| `trimming_toggle_mute` | Silenciar video | Toggle |
| `trimming_pro_badge` | PRO | Sin traducir |
| `trimming_time_start` | Inicio: {time} | Tiempo de inicio |
| `trimming_time_end` | Fin: {time} | Tiempo de fin |
| `trimming_button_done` | Listo | Guardar y cerrar |

---

## AppConfigurationView.swift

| Key | Translated | Notes |
|---|---|---|
| `app_config_title` | Ajustes de la app | Título modal |

---

## NotificationManager.swift

| Key | Translated | Notes |
|---|---|---|
| `notification_video_ready_title` | ¡Tu video está listo! | Título de push |
| `notification_video_ready_body` | Tu video se guardó en Photos | Cuerpo de push |

---

## Info.plist (bundle metadata)

| Key | Translated | Limit | Notes |
|---|---|---|---|
| `bundle_display_name` | Movie Maker | 30 | `CFBundleDisplayName` — marca sin traducir |
| `plist_photo_library_add_usage` | Necesitamos permiso para guardar tu video en Photos | ≤100 | 53 chars |
| `plist_photo_library_usage` | Necesitamos acceso a tus videos y fotos para crear compilaciones | ≤100 | 64 chars |

---

## App Store Connect Listing

| Key | Translated | Limit | Notes |
|---|---|---|---|
| `asc_app_name` | Movie Maker - Reels & YouTube | 30 | Marca — igual en todos los locales |
| `asc_subtitle` | Editor: unir videos y fotos | 30 | 27 chars — SEO principal en español |
| `asc_keywords` | editor,unir,combinar,fusionar,montaje,collage,video,foto,musica,recortar,reels,tiktok,shorts | 100 | 91 chars — términos de búsqueda ES sin duplicar el título |
| `asc_promotional_text` | Une videos, fotos y música en una película lista para compartir. Combina clips, recorta, reordena y exporta — sin línea de tiempo compleja. | 170 | 138 chars |
| `asc_whats_new` | Ahora exporta en el tamaño ideal para cada plataforma. Elige 16:9 para YouTube, 9:16 para Reels & TikTok o 1:1 para Instagram — y comparte directo desde la app.\n\nLa versión gratis es más generosa: 3 exportaciones completas, sin marca de agua ni límite de elementos. Después, recarga con monedas o hazte Pro mensual o anual. | 4000 | Notas v2.4 |
| `asc_description` | *(descripción completa — ver secciones abajo)* | 4000 | Segmentada por sección |

### Description structure (for translation)

| Section | Translated |
|---|---|
| `desc_headline` | Une videos, fotos y música en una película lista — sin línea de tiempo compleja. |
| `desc_hook` | Movie Maker es la forma más rápida de combinar clips, agregar música y exportar a tu carrete. Solo arrastra, recorta y listo. |
| `desc_section_what` | LO QUE PUEDES HACER |
| `desc_what_merge` | Une videos de tu biblioteca en una sola película — todos los clips que quieras. |
| `desc_what_combine` | Combina videos y fotos en cualquier orden para armar una presentación con movimiento. |
| `desc_what_trim` | Recorta el inicio y el final de cada clip para dejar solo lo mejor. |
| `desc_what_reorder` | Arrastra para reordenar las escenas hasta que la historia fluya. |
| `desc_what_mute` | Silencia el audio del clip cuando quieras una edición callada o solo música. |
| `desc_what_export` | Exporta a Photos en segundos, listo para compartir. |
| `desc_section_how` | CÓMO FUNCIONA |
| `desc_how_1` | Elige clips y fotos de tu biblioteca. |
| `desc_how_2` | Reordena, recorta y silencia según necesites. |
| `desc_how_3` | Agrega música y exporta. |
| `desc_section_perfect_for` | PERFECTO PARA |
| `desc_perfect_travel` | Resúmenes de viajes y momentos de vacaciones |
| `desc_perfect_family` | Momentos familiares y compilaciones de cumpleaños |
| `desc_perfect_events` | Resúmenes de bodas, fiestas y partidos |
| `desc_perfect_social` | Publicaciones para Instagram, TikTok y YouTube Shorts |
| `desc_perfect_slideshow` | Presentaciones rápidas de una sesión de fotos |
| `desc_section_pro` | FUNCIONES PRO (OPCIONALES) |
| `desc_pro_music` | Biblioteca de música de fondo para soundtracks pulidos |
| `desc_pro_slowmo` | Cámara lenta en los momentos clave |
| `desc_pro_longer` | Proyectos más largos con más clips y fotos |
| `desc_pro_trial` | Prueba Pro gratis antes de suscribirte — los términos se muestran claramente en la app. |
| `desc_section_privacy` | PRIVACIDAD PRIMERO |
| `desc_privacy_body` | La edición ocurre por completo en tu dispositivo. Tu contenido se queda en tu biblioteca de fotos. Nada se sube a ningún lado salvo que elijas compartir. |
| `desc_privacy_url_line` | Política de privacidad: https://okekedev.github.io/MovieMaker/privacy.html |
| `desc_terms_url_line` | Términos de uso: https://okekedev.github.io/MovieMaker/terms.html |
