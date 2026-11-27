# Miuix & KoWSU UI Referans Dokumani (`Questopia-RE`)

Bu dosya projedeki tum **Compose Miuix / KernelSU-KoWSU** uyarlamalarini, kullanilan bilesenleri, bilinen tuzaklari ve tasarim kurallarini tek yerde toplar. Her UI degisikliginde guncellenmelidir.

---

## 1. Genel Tasarim & Tema Kurallari

- **Paket:** `flutter_miuix: ^1.4.0`
- **Referans Kaynaklar:** `../template-miuix/compose-miuix/` ve `../template-miuix/KernelSU-KoWSU/`
- **Uyarlanmis Dart Sablonlari:** `../template-miuix/dart-miuix/`
- **Yazi Tipi:** `fontFamily: null` (Android/HyperOS sistem yazi tipi).
  - Butonlar (`MiuixTheme.textStyles.button`): `17sp`, `FontWeight.w400` (+ sistem `fontWeightAdjustment`).
  - Basliklar (`title4`): `18sp`, genellikle `FontWeight.w600`.
- **Renderer:** `android/app/src/main/AndroidManifest.xml` icinde `io.flutter.embedding.android.EnableImpeller = false` (Skia).
- **Overscroll:** `lib/core/theme/miuix_design.dart` -> `MiuixOverscrollScrollBehavior` (`BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())` + Android stretch/glow kapali).
- **HyperOS Basili Tutma Vurgusu:** `MiuixDesignTheme` icinde `NoSplash.splashFactory`, `splashColor: Colors.transparent`, `highlightColor` acik temada koyu gri (`alpha: 0.08`), karanlik temada acik gri (`alpha: 0.14`).

---

## 2. Blur (`GlassEffect`) Kurallari

- `lib/core/theme/glass_effect.dart`:
  - `ImageFilter.compose` ve `TileMode.mirror` KESINLIKLE kullanilmaz (GPU kilitlenmesi / yavas kare).
  - Sadece tek `ImageFilter.blur(sigmaX: sigma, sigmaY: sigma)` (`sigma` 1.0..10.0) kullanilir.
- **Onemli Kural:** `MiuixScaffold.topBar` arkasinin bulaniklasmasi icin `content` bolumunun `topBar` altina itilmemesi, icerigin `MediaQuery.padding.top` kadar ust boslukla baslayip `topBar` arkasina dogru kaymasi gerekir (`MiuixLibraryShell`, `MiuixSettingsScreen`, `LocalGamesView`, `CatalogGamesView`).
- `settings.isNavBarBlur` kapaliyken `GlassEffect.wrap(..., enabled: false)` gecilmeli; aksi halde ustte kalinti blur gorunur.

---

## 3. Bilesen Eslesmeleri (KoWSU -> Flutter/Dart)

| Bilesen | Dosya | KoWSU / Miuix Karsiligi |
|---|---|---|
| Alt Gezinme Cubugu | `lib/core/widgets/miuix_nav_bar.dart` | `MiuixNavigationBar` + `MiuixNavigationBarItem` (`Icons.home_rounded`, `Icons.extension_rounded`, `Icons.settings_rounded`) |
| Ana Sayfa Hero | `lib/features/library/presentation/widgets/miuix_home_hero.dart` | 2 kartli bento (`Installed Games` yesil + `Favorites` kalp filigranli), `_KoWsuTiltCard` (karsi kose pivotlu 3D cokme) |
| Arama Cubugu | `lib/features/library/presentation/widgets/miuix_search_field.dart` | `SuperSearchBar.kt`: `SizedBox(height: 45)`, `surfaceContainerHigh` kapsul, `filled: false`, `Cancel` normal kalinlik (`w400`) |
| Katalog Satiri | `lib/features/library/presentation/widgets/miuix_catalog_game_row.dart` | `MiuixCard(cornerRadius: 20)` + `GamePoster` + `42x42` squircle aksiyon butonu |
| Ayarlar Ekrani | `lib/features/settings/presentation/miuix_settings_screen.dart` | `SingleChildScrollView` + `Column` (lazy `ListView` `MiuixPopupController` dispose hatasi verdigi icin) |
| Ayar Satirlari | `lib/features/settings/presentation/widgets/miuix_settings_tiles.dart` | `MiuixOverlayDropdownPreference`, `MiuixSwitchPreference`, `MiuixSliderPreference`, `MiuixArrowPreference`, renkli `MiuixSquircleBorder` ikonlar |
| Diyaloglar | `lib/core/helpers/dialog_helper.dart` | `MiuixOverlayDialog` + `MiuixPopupScope(establishRoot: true)` + esit genislikli `MiuixButton` (`minHeight: 46, cornerRadius: 16`) |
| Alt Paneller (Sheets) | `lib/core/helpers/sheet_helper.dart` | `ModalBottomSheetRoute` + sag ust koyu dairesel `X` kapatma butonu |
| Oyun Ekrani | `lib/features/game/presentation/game_screen.dart` | `_GameMiuixTopBar`, `MiuixButton` aksiyon butonlari, `MiuixCard` envanter, `MiuixNavBar` |
| Oyun Secenekleri | `lib/features/game/presentation/sheets/game_options_sheet.dart` | `MiuixSettingsGroup` + `miuixSettingsIcon` |

---

## 4. Bilinen Tuzaklar (`flutter_miuix`)

1. **`MiuixOverlayDropdownPreference` + `ListView`:** Lazy `ListView` kaydirilirken offscreen ogeleri dispose ettigi icin `A MiuixPopupController was used after being disposed` hatasi olusur. Cozum: Ayarlar gibi `MiuixOverlayDropdownPreference` iceren listelerde `SingleChildScrollView` + `Column` kullan.
2. **`MiuixArrowPreference`:** `endAction` degil `endActions: List<Widget>` alir.
3. **`MiuixInputField`:** Material `InputDecorationTheme` icinden gelen `filled: true` arka planini miras alabilir; KoWSU arama kapsulu icin `TextField` + `InputDecoration(isCollapsed: true, filled: false, fillColor: Colors.transparent)` kullanmak daha temizdir.
4. **`MiuixExitUntilCollapsedScrollBehavior`:** Yalnizca `depth == 0` scroll bildirimlerini dinler; `PageView` yerine dogrudan `ListView`/`SingleChildScrollView` sarmalanmalidir.
5. **`MiuixSearchField` `SizeTransition`:** Dis `Row` yuksekligi `SizedBox(height: 45)` ile sabitlenmezse `SizeTransition(axis: Axis.horizontal)` `Cancel` butonunu yukari iterken kapsulu asagida ortalayabilir.
6. **Sekme Gecisleri:** `LibraryScreen` icinde `PageView` yerine `IndexedStack` kullanilir (yatay kaydirma ve gecis animasyonu yok).
7. **`MiuixPullToRefresh` + `topBar` Blur:** `MiuixPullToRefresh` icindeki `CustomScrollView` `ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics())` kullanmali ve `contentPadding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top)` verilmelidir; aksi halde yenileme dairesi `topBar` arkasinda gizlenir.
8. **Sheet Basliklari:** `QuestopiaSheetHeaderPill` yerine `showQuestopiaSheet(title: ...)` kullanilmalidir ki baslik daima sag ustteki `X` kapatma butonunun yaninda dursun.
9. **Slider Animasyonu:** `MiuixSliderPreference` icinde akici spring kaydirma icin `steps: 0` ve `showKeyPoints: false` kullanilir.
10. **APK Derleme:** `flutter build apk` JDK 17 nedeniyle `:webview_flutter_android:lintVitalAnalyzeRelease` adiminda duser; `cd android && ./gradlew assembleRelease -Ptarget-platform=android-arm64 -x lintVitalAnalyzeRelease` kullanilir.

---

## 5. Masaustu (Desktop) Miuix Gecis Plani (Sonraki Agent Icin)

Mobilde tum arayuz Miuix/KoWSU tasarimina gecirildi; yalnizca `isDesktop` kontrolu arkasindaki masaustu dallari (`library_screen.dart` ve `settings_screen.dart`) eski Monet/M3E widgetlarini kullaniyor. Masaustu tasarimi da Miuix'e gecirildiginde asagidaki adimlar uygulanmalidir:

1. **Responsive Miuix Masaustu Kabugu:**
   - `library_screen.dart` icindeki `if (shouldUseMiuixDesign(settings) && !isDesktop)` kosulunu kaldir; masaustunde de `MiuixDesignTheme` + sol kenar `MiuixNavigationRail` / genis pencere uyumlu `MiuixLibraryShell` kullan (`window_manager` baslik cubuguyla uyumlu).
   - `settings_screen.dart` icinde masaustunde de dogrudan `MiuixSettingsScreen` kullan.
2. **Silinecek Eski Monet/M3E Dosyalari (Masaustu Gecisi Sonrasi):**
   - `lib/core/widgets/questopia_scaffold.dart`
   - `lib/features/library/presentation/widgets/local_game_card.dart`
   - `lib/features/library/presentation/widgets/remote_game_card.dart`
   - `lib/features/library/presentation/widgets/miuix_game_card.dart`
   - `lib/features/settings/presentation/sections/appearance_general_section.dart`
   - `lib/features/settings/presentation/sections/typography_media_section.dart`
   - `lib/features/settings/presentation/sections/sound_storage_about_section.dart`
   - `lib/features/settings/presentation/widgets/settings_tile_builders.dart`
   - `lib/features/settings/presentation/sheets/settings_picker_sheets.dart` (statik etiket yardimcilarini kucuk bir `settings_labels.dart` dosyasina tasi)
3. **Kaldirilacak Paketler (`pubspec.yaml`):**
   - `material_3_expressive` ve `material_segmented_list` (masaustu dosyalari silindikten sonra tamamen bosa cikar).
   - Not: `webview_flutter` + `webview_flutter_android` OGV video oynatma (`qsp_ogv_video.dart`) icin gereklidir, silinmemelidir. `extended_image` disk/bellek onbellegi icin korunur.
