# Platform, kurulum ve test — flutter_miuix 1.4.0

Bu notlar paket ve uygulama kaynak incelemesine; ayrıca çalıştırılan Linux release, widget testleri ve Android release APK kurulumuna dayanır. Android’de tüm cam efektleri ve etkileşimler manuel olarak test edilmemiştir.

## 1. SDK ve dependency kurulumu

### Yayımlanmış paketi kullanan uygulama

Paket `environment.sdk` değeri `^3.12.2`; README Flutter/Dart `>=3.12.2` der. Uygulamada şu yapı kullanılabilir:

```yaml
environment:
  sdk: ^3.12.2

dependencies:
  flutter:
    sdk: flutter
  flutter_miuix: ^1.4.0

flutter:
  uses-material-design: true
```

```bash
flutter pub get
```

`flutter_miuix` kendi bağımlılıkları olarak `material_color_utilities: ^0.13.0`, `dynamic_color: ^1.9.0`, `cupertino_icons: ^1.0.8` kullanır. Uygulamanın mevcut lock dosyasında `dynamic_color` 1.9.0 ve `material_color_utilities` 0.13.0 olarak çözülmüştür. Lock dosyasının `sdks` bölümü bu uygulama için `dart: ">=3.13.0-0 <4.0.0"` ve `flutter: ">=3.18.0-18.0.pre.54"` gösterir; bu, paketin yayımlanma SDK şartından daha geniş/daha yeni bir çözüm setidir. Tutarlı üretim için lock dosyasını depoya alın.

### Bu test uygulamasındaki yerel paket

`miuix_test_app/pubspec.yaml` paketi path override ile kullanır:

```yaml
dependencies:
  flutter_miuix: ^1.4.0

dependency_overrides:
  flutter_miuix:
    path: packages/flutter_miuix
```

Böylece 1.4.0 yerel kaynak ve yerel `MiuixScrollBar` yaması kullanılır. Farklı bir projeye bu yapıyı kopyalarken path'in gerçekten doğru çözüldüğünü `flutter pub deps` ile kontrol edin.

### Tema ve Material altyapısı

`MiuixSystemTheme` → `Builder` → `MaterialApp` sırası korunmalıdır. `MiuixTheme` Material temasının yerini tutmaz. `MiuixTextField` ve `MiuixInputField` içindeki Flutter `TextField` için `Material` ancestor gereklidir; gerekirse şeffaf kullanın:

```dart
Material(
  type: MaterialType.transparency,
  child: MiuixTextField(controller: controller),
);
```

`MiuixScaffold` kendi içinde Material sunabilir; yine de `OverlayEntry`, özel root `Stack`, `MiuixGlass` veya nested route içinde kontrol edin.

## 2. Platform farkları

| Platform | Kaynakta doğrulanan durum | Dikkat edilecekler |
|---|---|---|
| Android | README “fully supported”; `dynamic_color` Android duvar kağıdı/aksesan rengi okur. Release APK bu projede başarıyla derlendi ve `adb install -r` ile kuruldu: `com.example.miuix_test_app`, sürüm `1.0.0`, model `2412DPC0AG`, ADB serisi `VSZ5NBGYYPHAJFZH`. | Monet asenkron başlar; ilk placeholder sabit tohumdur. Klavye `viewInsets.bottom`, safe area, geri tuşu ve popup odak testi gerekir. Yerel release Flutter şablonunun debug anahtarıyla imzalanır; mağaza release'inde kendi imzasını kurun. |
| Linux | Projede `linux/` GTK runner ve CMake yapılandırması var. README “fully supported”; dynamic color fixed-seed fallback. | Release bundle'da `libflutter_linux_gtk.so`, `libapp.so`, `libdynamic_color_plugin.so` ve paket shader asset'leri statik olarak doğrulandı. Camın gerçek GL/Impeller davranışı çalıştırılarak doğrulanmadı. Pencere boyutu değişimini ve 768/840 eşiklerini test edin. |
| Windows | README “fully supported”; dynamic color fixed-seed fallback. | Bu test projesinde `windows/` klasörü yoktur; Windows derlemesi ve runtime doğrulanamadı. Oluşturulmuş bir Windows uygulamasında DLL/plugin paketleme, shader asset yolları ve klavye navigasyonu ayrıca test edilmelidir. |
| iOS/macOS/web | README destekler; dynamic color fixed-seed fallback. | Bu ortamda doğrulanmadı. Tarayıcıda runtime fragment shader, canvas snapshot ve pointer davranışı ayrıca sınanmalıdır. |

Android Gradle dosyaları Java/Kotlin JVM 17, AGP 9.3.1 ve Kotlin 2.4.20 kullanır. `compileSdk`, `targetSdk`, `minSdk` ve NDK sürümleri Flutter SDK'sından devralınır; projede sabit sayı yazılmamıştır.

## 3. Shader ve Impeller notları

Paket `flutter.shaders` altında yedi asset tanımlıdır:

- `miuix_bloom_stroke.frag`
- `miuix_os4_glass.frag`
- `miuix_os4_mask.frag`
- `miuix_os4_stroke.frag`
- `miuix_os4_shadow.frag`
- `miuix_os4_rim.frag`
- `miuix_os4_blend.frag`

Linux release bundle'ında bu yedi dosyanın `data/flutter_assets/packages/flutter_miuix/shaders/` altında bulunduğu doğrulandı. Bu, shader derlemesinin veya görsel doğruluğun çalışma zamanı kanıtı değildir.

OS4 shader'ları tek tek yüklenir. Biri başarısız olursa diğerleri etkilenmez; blend shader yoksa native `BlendMode` fallback kullanılır. Durum için:

```dart
await MiuixGlassRendering.load();
debugPrint('${MiuixGlassRendering.loadedPrograms}');
debugPrint('${MiuixGlassRendering.loadError}');
debugPrint('${MiuixGlassRendering.has('blend')}');
```

**Impeller:** CHANGELOG 1.3.0 ve `miuix_glass.dart` kaynağı, `drawImageRect` üzerindeki `Paint.imageFilter` filtresinin bazı özellikle Impeller backend'lerinde sessizce çalışmadığını belirtir. Cam blur'u bu nedenle `Canvas.saveLayer` + `ImageFilter.blur` ile yapılır. Bu yolu doğrudan `Paint.imageFilter` ile değiştirmeyin; “camın arkasındaki yazılar görünüyor” şikâyeti geri gelebilir.

Maliyet önlemleri:

- `MiuixLayerBackdropCapture.pixelRatio` yalnızca kalite kabul edilebilirse düşürün.
- Aynı `MiuixGlassMaterial` değerini cache'leyin; her build'de eşdeğer nesne üretmek texture cache'i boşar.
- Backdrop capture'ı cam/popup/scrim dışında tutun.
- Birçok büyük cam yüzeyini aynı anda kaydırmalı listede canlı tutmayın.
- Shader yoksa opak/fallback görünümün metin kontrastı kabul edilebilir olmalıdır.

## 4. Dinamik renk fallback'i

`MiuixThemeController` içinde:

- `keyColor != null`: `miuixColorsFromSeed(...)` senkron üretim; platform kanalı okunmaz.
- `keyColor == null` ve `monet*`: Android'de `DynamicColorPlugin.getAccentColor()` asenkron okunur. Sonuç null/hata ise `miuixMonetSystemColors(dark: ...)` kullanılır.
- Diğer platformlar: README ve kaynak açıklaması fixed-seed fallback belirtir; sabit tohum `0xFF6750A4`, `tonalSpot`, SPEC_2021.

Sonuç gelene kadar aynı fixed-seed placeholder gösterilir. Bu, renk sıçramasını azaltmak içindir; duvar kağıdı renginin çalıştığı anlamına gelmez. Testte `keyColor` vererek deterministik kalın; ayrıca `keyColor: null` ile placeholder → platform sonucu geçişini sınayın.

## 5. Desktop eşikleri ve yerleşim

Aynı sayfada üç farklı ölçü kavramı vardır:

| Değer | Anlamı |
|---|---|
| 768 mantıksal piksel | `lib/main.dart` içindeki uygulama breakpoint'i. Altında ana sayfa listesi + mobil full-screen arama; üstünde `MiuixNavigationRail` + embedded content. |
| 720 mantıksal piksel | `lib/showcase/common.dart` içindeki içerik üst sınırı; uzun satırların ekranı doldurmasını önler. OS4 sayfası da 720 kullanır. |
| 840 × 480 mantıksal piksel | Kitaplığın `isMiuixLargeScreen(context)` eşiği. Dialog gibi yerleşimlerde otomatik large-screen davranışını seçer. |

Bu eşikler birbirinin yerine kullanılmamalıdır. Örneğin 800 piksel genişlik uygulamada desktop rail demektir ama kütüphane dialog açısından large-screen değildir. 840 genişlik, 480'den düşük yükseklikte de large-screen değildir.

Yerleşim testleri: 390×844, 768×1024, 1280×720, 1024×600 ve çok uzun Türkçe metin. RTL de ayrıca denenmelidir. `ShowcaseEmbedded` kullanıldığında iç sayfanın kendi top bar'ı ve window insets'i kaldırılır; üst çubuk ve SafeArea sorumluluğu dış iskelete geçer.

## 6. Bilinen MiuixScrollBar initial-layout yaması

### Sorun

Yerel `MiuixVerticalScrollBar` / `MiuixHorizontalScrollBar`, thumb uzunluğu için `AnimationController` kullanır. İlk layout'ta `_displayedLength == 0` dalına girdiğinde paketin `/tmp/flutter_miuix-src` karşılaştırmasındaki hali `_length.value = targetLength` değerini doğrudan atar. Controller dinleyicisi `setState(() {})` çağırdığından bu, ilk layout sırasında “setState() or markNeedsBuild() called during build” hatasına yol açabilir. Bu projedeki yerel paket, build sırasında controller değeri değiştirmek yerine frame sonrasına alınmıştır.

### Bu projede kullanılan yerel yama

Dosya: `/home/ayzen/Masaüstü/Projeler/miuix_test_app/packages/flutter_miuix/lib/src/theme/miuix/components/miuix_scroll_bar.dart`

```dart
if (_displayedLength == 0) {
  _displayedLength = targetLength;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) _length.value = targetLength;
  });
}
```

Yerel kaynak ile `/tmp/flutter_miuix-src` arasındaki fark yalnızca bu iki satırlık post-frame değişikliğidir. `dependency_overrides` sayesinde test uygulaması bu paketi kullanır. Yama, üst sürümde düzeltilmiş bir soruna ilişkin yerel uygulama çözümüdür; her uygulamada paket `src/` dosyasını elle değiştirmeyin. Yeni sürümde önce üst paketi test edin, gerekirse kendi scrollbar sarmalayıcınızda frame sonrası yeniden ölçüm yapın.

## 7. Overlay ve focus tuzakları

### Overlay yaşam döngüsü

`OverlayEntry` oluştururken `Overlay.of(context)` değerini önce alın. Callback içinden widget'ın kendi context'ine erişmek yerine önceden yakalayın. Dispose sırasında animasyon/focus node'dan önce overlay'i kaldırın; proje `main.dart` içinde bu sıra açıkça uygulanmıştır.

Hızlı aç/kapat akışında:

- `OverlayEntry` null ise yeniden insert etmeyin.
- `remove()` sonrası referansı null yapın.
- Animasyonu doğrudan remove yolunda 0'a çekin; aksi halde ana sayfa opacity'si 0'da kalabilir.
- Callback'larda `mounted` kontrolü yapın.
- Sonuç satırına basınca Navigator'ı overlay kaldırılmadan önce alın.

### Focus

- Mobil arama: ana sayfadaki collapse edilmiş search bar `IgnorePointer` ile kapatılır; gerçek focus yalnızca overlay input'undadır. İki search bar'ın aynı anda focus değiştirmesine izin vermeyin.
- Overlay içindeki aynı `MiuixInputField` instance'ı animasyon boyunca korunmalıdır; her frame'de yeni keyed/input widget üretmek focus/klavye kaybı yaratır.
- `FocusNode.requestFocus()` genellikle `addPostFrameCallback` içinde, widget mount olduktan sonra yapılır. OS4 search örneği mounted ve visible kontrollerini birlikte doğrular.
- Kapatırken `unfocus()` yapın ve node'u sahibi `State.dispose()` içinde dispose edin.
- Popup içindeki inputta klavye `viewInsets.bottom`, `PopScope`, Escape ve geri tuşu birlikte test edilmelidir.

### Backdrop ve hit testing

- Glass backdrop, popup host ve scrim dışında tutulmalıdır.
- `MiuixPressable` ve glass butonlar hit test için opak olabilir; yanlışlıkla büyük alan kaplayan şeffaf katmanlar alt tıklamaları engelleyebilir.
- Mobil ana sayfada opacity ile gizlenen kartlar `IgnorePointer` ile etkisizleştirilir; yalnızca `Opacity: 0` yeterli değildir.
- Dialog/Sheet `onDismissRequest` içinde state'i güncelleyin; `show`/`visible` hâlâ true ise kapanma başlamaz.

## 8. Kontrol komutları

Komutlar uygulama kökü `/home/ayzen/Masaüstü/Projeler/miuix_test_app` için örneklerdir. Bu çalışmada `pub get`, `analyze --no-fatal-infos`, `test`, Linux release, Android release ve `adb install -r` başarıyla çalıştırıldı; Windows ve yerel paketin ayrı test suite'i çalıştırılmadı.

```bash
# Bağımlılıkları yerel path override ile çöz
flutter pub get

# Uygulama ve testleri analiz et
flutter analyze

# Yerel paketi ayrıca analiz et
cd packages/flutter_miuix
flutter analyze
cd ../..

# Uygulama widget testleri
flutter test

# Yerel paket testleri (mevcut test dizini varsa)
cd packages/flutter_miuix
flutter test
cd ../..

# Linux release
flutter build linux --release

# Android release APK
flutter build apk --release

# Release APK'yı bağlı cihaza kur (cihaz/ABI seçimini doğrula)
adb install -r build/app/outputs/flutter-apk/app-release.apk

# Uygulama kimliğini aç
adb shell monkey -p com.example.miuix_test_app -c android.intent.category.LAUNCHER 1
```

Windows yapılandırması mevcut değil. Oluşturulduktan sonra tipik komut `flutter build windows --release` olur; bu projede denenmemiştir. Android release çıktısı `build/app/outputs/flutter-apk/app-release.apk` konumunda oluşturulmuştur. Yerel release imzası debug olduğundan `adb install` mağaza dağıtımı için yeterli değildir.

## 9. Minimum test matrisi

- **Tema:** light/dark, sistem bold text, text scale, `monetSystem` placeholder/fallback, seed değişimi.
- **Scrollbar:** ilk görünür thumb uzunluğu, içerik kısalması/uzaması, controller değişimi, route pop sonrası post-frame callback.
- **OS4:** shader success/partial failure, backdrop snapshot ilk kare, scroll sonrası hizalama, popup aç/kapat, RTL, reduced motion.
- **Popup:** dış tıklama, geri/Escape, keyboard `viewInsets`, nested scroll, focus dönüşü, route birlikte pop.
- **Platform:** Android fiziksel cihazde dynamic color; Linux pencere resize; ayrıca Windows oluşturulduğunda gerçek Windows'ta release smoke test.

Kaynaklar: paket/uygulama `pubspec.yaml`, uygulama `pubspec.lock`, Android `app/build.gradle.kts`, `settings.gradle.kts`, `AndroidManifest.xml`, Linux CMake/runner ve mevcut release bundle, `lib/main.dart`, `lib/showcase/common.dart`, `utility.dart`, `os4.dart`, `test/widget_test.dart`, `miuix_scroll_bar.dart`, `miuix_glass.dart`, `miuix_platform_dynamic_colors.dart`.
