# Foundation, bulanıklık ve HyperOS 4 cam — flutter_miuix 1.4.0

Bu belge yerel paket kaynak koduna, README/CHANGELOG ve `lib/showcase/foundation.dart`, `blur.dart`, `os4.dart` örneklerine göre yazılmıştır. Kamu girişi `package:flutter_miuix/miuix.dart` içindendir.

## Kamu bileşen mi, altyapı mı?

- **Uygulama sayfalarında tercih edilen:** `MiuixSquircleBorder` bir `ShapeBorder` olarak; `MiuixScrollEndHaptic` isteğe bağlı davranış sarmalayıcısı; hazır OS4 bileşenleri (`MiuixGlassTopAppBar`, `MiuixGlassTabRow`, `MiuixGlassNavigationBar`, `MiuixGlassDialog`, `MiuixGlassBottomSheet`, vb.).
- **Çoğu sayfanın doğrudan kurmaması gereken altyapı:** `MiuixPressable`, `MiuixContentColor`, `MiuixSpringEngine`, `MiuixPopupHost`, `MiuixTextureBlur`, `MiuixHighlight`, `MiuixLayerBackdrop`, `MiuixLayerBackdropCapture`, `MiuixGlass`, `MiuixGlassMaterial`, `MiuixGlassStyle`. Bunlar özel bileşen veya cam yüzeyi yazarken kullanılır; mevcut Miuix bileşenleri bunları zaten yönetir.

## 1. MiuixSquircleBorder

**Tanım:** HiperOS benzeri sürekli eğri köşeler üreten `ShapeBorder`. Varsayılan `cornerRadius = 0`, `extension = 1.1`, `enabled = true`, `side = BorderSide.none`. Yarıçap kısa kenarın yarısına, `extension` 1.0–2.0 aralığına kırpılır.

**Kullan:** `ShapeDecoration`, `Material.shape`, `PhysicalShape` veya `MiuixPressable.shape` ile özel yüzeylerde.

**Kullanma:** Widget ağacına tek başına yerleştirmeyin; kenarlık tek başına çocuk çizmez. Yalnızca normal yuvarlak köşe isteniyorsa `enabled: false` veya `RoundedRectangleBorder` kullanın.

**Durumlar/varyantlar:** Sabit köşe, ölçeklenmiş köşe, `side` ile çizilen kenarlık, disabled squircle. `addSquircleRect(...)` düşük seviyeli `Path` yardımcısıdır.

**Erişilebilirlik/platform:** Görsel biçimdir; semantik veya dokunma alanı sağlamaz. Çizgi `side` rengi ve genişliği açık/koyu temada kontrastlı kalmalıdır.

```dart
Container(
  decoration: ShapeDecoration(
    color: theme.colors.surfaceContainer,
    shape: MiuixSquircleBorder(
      cornerRadius: 24,
      side: BorderSide(color: theme.colors.outline),
    ),
  ),
  child: const SizedBox(height: 80),
);
```

## 2. MiuixPressable

**Tanım:** Basma, hover, focus ve `heldDown` durumlarında yay animasyonlu maske; isteğe bağlı `sink` veya `tilt` dönüşümü sunan düşük seviyeli etkileşim sarmalayıcısı. Enter/Space/numpad Enter ile çalışır.

**Kullan:** Paket dışında Miuix hissi veren özel tıklanabilir kart/satır yazarken.

**Kullanma:** Standart buton, checkbox veya switch yerine geçmeyin. İçinde başka bir tam işlevli buton varsa iç içe semantik/tıklama çakışmasını önleyin. `onPressed == null` veya `enabled == false` etkileşimi kapatır.

**Durumlar/varyantlar:** `MiuixPressFeedbackType.none`, `sink`, `tilt`; normal/hover/focus/pressed/heldDown/disabled. `sinkAmount` varsayılan 0.94, `tiltAmount` 8 derece. `shape`, `borderRadius` ikisinden biri; `shape` önceliklidir.

**Erişilebilirlik/platform:** `button`, `enabled`, `semanticLabel`, `focusNode`, `autofocus` vardır. Checkbox/Switch gibi özel semantiğe sahip kontrol çevresinde `button: false` düşünülebilir. `behavior` varsayılan `HitTestBehavior.opaque`; küçük hedeflerde yeterli dolgu bırakın.

## 3. MiuixScrollEndHaptic

**Tanım:** İçindeki scrollable içerik **fırlatma** ile üst/alt sınırını geçtiğinde bir kez dokunsal geri bildirim veren `NotificationListener<ScrollNotification>` sarmalayıcısı.

**Kullan:** Uzun listelerde sınır hissi isteniyorsa.

**Kullanma:** Her kaydırmada titreşim vermeyin. Sürükleme sırasındaki overscroll tetiklemez; yalnızca `dragDetails == null` olan inertial overscroll değerlendirilir. Bildirim yayılımını durdurmaz.

**Durumlar/varyantlar:** `MiuixHapticFeedbackType.textHandleMove` (varsayılan, `selectionClick`), `lightImpact`, `mediumImpact`, `heavyImpact`. Top/bottom hit state'i içeriğe dönünce sıfırlanır; eşik 1.0 pikseldir.

**Erişilebilirlik/platform:** Titreşim cihaz ve kullanıcı ayarına bağlıdır; kritik bilgiyi yalnızca haptic ile vermeyin. Fiziksel olmayan platformlarda sessizlik normaldir.

## 4. MiuixContentColor

**Tanım:** Alt ağaca varsayılan metin/ikon rengi aktaran `InheritedWidget`. `of(context)` yakın ata bakar; yoksa siyah döner.

**Kullan:** Özel bir yüzey, içerik rengini çocuklarına aktarırken.

**Kullanma:** Sayfa kökünde her metne tekrar aynı rengi vermek yerine uygun yüzeyde kullanın. Material `IconTheme` ile tamamen aynı mekanizma değildir.

**Durumlar/varyantlar:** Tek `color`; renk değişince bağımlı alt ağaç yeniden kurulur.

**Erişilebilirlik/platform:** Yalnızca varsayılan renktir; açık `color` önceliklidir. `MiuixText` ve `MiuixIcon` bu değeri tüketir. Temaya uygun `onSurface`/`onPrimary` rolünü seçin.

## 5. MiuixSpringEngine

**Tanım:** Kritik dampingli, açık Euler adımlı yay motoru. `start(...)`, `step(deltaSeconds)` veya `TickerProvider` ile `runSettleAnimation(...)` kullanılır. Adım süresi 0.001–0.016 saniyeye kırpılır.

**Kullan:** Özel sürükleme bırakma, fiziksel konum izleme veya mevcut Flutter spring API'sinin yeterli olmadığı Miuix uyumlu motor gerektiğinde.

**Kullanma:** Sıradan fade/scale geçişleri için `AnimationController` ve `MiuixMotion` yeterlidir. `TickerProvider` sahibi dispose olduğunda yarışan ticker'ı bırakmayın; `runSettleAnimation` sonlandığında `finally` içinde ticker'ı temizler.

**Durumlar/varyantlar:** `velocity`, `currentPosition`; yüksek başlangıç hızı > 5000 ise doğal periyot 0.4'ten 0.55'e çıkar. `MiuixSpringOperator` ve damping yardımcıları daha düşük seviyedir.

**Erişilebilirlik/platform:** Hareket azaltma ayarına kendiliğinden uymaz; devre dışı bırakma kararını çağıran taraf verir. `onFrame` her adımda çağrılır; ağır iş yapmayın.

## 6. MiuixPopupHost ve popup altyapısı

**Tanım:** `MiuixPopupRegistry` içindeki dialog/plain popup girdilerini z-order ile çizen, alt işaretmeleri yakan ve en üst uygun plain popup için geri tuşunu yöneten host. `MiuixPopupScope` local/root registry ayrımı sağlar.

**Kullan:** `MiuixDialogLayout` / `MiuixPopupLayout` kullanan özel popup altyapısında, uygun scaffold/root seviyesinde bir kez.

**Kullanma:** Her sayfada ikinci bir host açmayın. Girdileri elle `add/remove` etmek yerine layout bileşenlerini kullanın. `MiuixPopupHost` MaterialApp'ın Navigator'ı veya OverlayPortal'ı değildir.

**Durumlar/varyantlar:** `MiuixPopupController.visible/show()/dismiss()/toggle()`, enter/exit/dim transition'ları, `windowDimmingColor`, local/root registry. Registry yoksa süreç genelindeki `fallback` kullanılır; çoklu uygulama testlerinde izolasyon için scope kurun.

**Erişilebilirlik/platform:** Klavye odak tuzağı ve geri tuşu davranışı popup içeriğinde de doğrulanmalıdır. Host build sırasındaki registry değişikliklerini post-frame'e erteler; registry üzerinde build içinden senkron işlem yapmayın.

## 7. Bulanıklık ve arka plan yakalama

### MiuixLayerBackdrop

**Tanım:** Yakalanan `ui.Image`, global konum ve piksel oranını tutayan `MiuixBackdrop`. `globalOffset` yakalama renderbox'ı bağlı ve ölçülmüşken anlık hesaplanır; böylece kaydırma/route transformu sonrası örnekleme kaymaz.

**Kullan:** `MiuixTextureBlur` veya OS4 camına arka plan sağlayan state içinde bir kez oluşturulur.

**Kullanma:** Her build'de yeni backdrop oluşturmayın. Sahip `State.dispose()` içinde `dispose()` edin; kendi snapshot'ını serbest bırakır. Aynı backdrop'i aynı anda birden çok capture renderbox'ına bağlamayın; kayıt tek renderbox tutar.

**Durumlar/varyantlar:** İlk karede `snapshot == null` olabilir; tüketici yalnızca child çizer. Snapshot değişince listener'lara haber verilir, eski image dispose edilir.

**Erişilebilirlik/platform:** Snapshot maliyeti cihaz çözünürlüğüne bağlıdır. İçerik kritikse camın arkasında düz, okunur bir alternatif bulundurun.

### MiuixLayerBackdropCapture

**Tanım:** Alt ağacı repaint boundary olarak kaydeden `SingleChildRenderObjectWidget`. Frame sonrası `toImageSync` ile snapshot alır; `pixelRatio` özel olarak verilebilir.

**Kullan:** Camın görünmesi gereken sayfa/panel arka planını sarmalarken.

**Kullanma:** Cam yüzeyinin kendisini veya popup host/遮罩 katmanını capture içine almayın; kendi kendini örnekleme oluşur. Her scroll frame'inde gereksiz yeniden boyama tetiklemeyin.

**Durumlar/varyantlar:** Boş/ölçülmemiş boyut snapshot üretmez. `pixelRatio` null ise `MediaQuery.devicePixelRatioOf` kullanılır; pozitif ve sonsuz olmayan bir değer olmalıdır.

**Erişilebilirlik/platform:** Düşük `pixelRatio` performansı artırır ama ince metni bozar. Snapshot arka plandır; semantik ağacı değiştirmez.

### MiuixTextureBlur

**Tanım:** Backdrop snapshot'ını `ImageFilter.blur` ile bulanıklaştırıp `BlurColors` ile ayarlayan, isteğe bağlı `ShapeBorder` ile kırpan render sarmalayıcısı. `sigma = blurRadius * 0.45`; varsayılanlar `MiuixBlurDefaults` içinden gelir.

**Kullan:** Basit özel frosted panel; gerçek OS4 refractive cam gerekmeyen yüzeylerde.

**Kullanma:** Backdrop yoksa gerçek bulanıklık beklemeyin. Büyük alanları her karede yeniden üretmeyin. Metin kontrastını yalnızca blur üzerine bırakmayın.

**Durumlar/varyantlar:** `enabled: false` child'ı doğrudan verir; `shape == null` dikdörtgen; `blurRadius` 0'da blur yoktur; snapshot yokken child gösterilir. `BlurColors` blur sonrası renk dönüşümü/blend katmanları taşır.

**Erişilebilirlik/platform:** Yüksek blur maliyeti vardır. `FilterQuality.medium` ve 3σ örnekleme payı kullanılır. Renk/blend sonrası metin kontrastını açık ve koyu temada test edin.

### MiuixHighlight

**Tanım:** Çocuğun üzerine bloom kenar ışığı çizen shader tabanlı sarmalayıcı. `Highlight`, `BloomStroke`, `LightPosition`, `LightSource` ile yapılandırılır. Varsayılan `Highlight.defaultHighlight`, width 0.8, alpha 1.0.

**Kullan:** Özel cam panelin ışık kenarını tamamlamak için.

**Kullanma:** Normal kartlarda zorunlu varsayılan efekta dönüştürmeyin. `MiuixSquircleBorder` verirken shader'ın köşe okumasının yalnızca `RoundedRectangleBorder` için dört ayrı radius aldığını unutmayın; squircle'da tam yuvarlak fallback olur.

**Durumlar/varyantlar:** Big/middle/small × light/dalt presetleri; width veya alpha <= 0 ise highlight çizilmez. Shader yüklenmezse child korunur. İç uygulama single-peak'tir; `dualPeak` yine de modelde bulunur.

**Erişilebilirlik/platform:** Shader runtime desteği yoksa kenar yok olabilir; bunu tek bilgi göstergesi yapmayın. Işık efekti koyu modda ayrı dark preset ister.

## 8. OS4 cam modeli

### MiuixGlass, MiuixGlassPanel, miuixGlassSurface

**Tanım:** `MiuixGlass`, backdrop + style/material + shape/stroke/shadow ile refractive cam çizer. `MiuixGlassPanel` varsayılan `MiuixGlassShadows.regular` ekler. `miuixGlassSurface(...)`, mevcut cascading menülerin `surfaceBuilder` imzasına uygun OS4 yüzeyi döndürür.

**Kullan:** Hazır OS4 bileşenleri karşılamıyorsa özel cam panel/menü yüzeyi için.

**Kullanma:** `shading: true` refractive görünüm ile `shading: false` bar/menu malzemesini karıştırmayın. Hazır dialog/sheet/popup varken aynı davranışı ham `MiuixGlass` ile yeniden yazmayın. Backdrop'i popup host dışında tutun.

**Durumlar/varyantlar:** `alpha`, `tint`, `fill`, `stroke`, `shadow`, `underlayMaterial`, `enabled`; shape ve açık/koyu stil. Backdrop/shader yoksa konturlu, opak fallback kalır; shader'lar ayrı ayrı yüklenir.

**Erişilebilirlik/platform:** Cam metin alanı değildir. Çocuğa okunur renk, kontrast ve semantik verin. Shader yükleme durumu `MiuixGlassRendering.loadError`, `loadedPrograms`, `has(name)` ile incelenir.

### MiuixGlassMaterial ve MiuixGlassMaterials

**Tanım:** `MiuixGlassMaterial` bir `blurRadius` ve bir–üç `MiuixGlassColorLayer` içerir. `MiuixGlassMaterials` hazır light/dark malzemeleri ve `forTheme(isDark, light:, dark:)`, `puredThinGlass`, `popupViewGlass`, `dialogGlass`, `actionBarMask` seçicilerini sağlar.

**Kullan:** Aynı aileye ait OS4 yüzeylerde doğru bulanıklık ve renk katmanlarını paylaşmak.

**Kullanma:** Her build'de eşdeğer yeni material üretmeyin; değer eşitliği texture cache anahtarıdır ve instance kaybı performansı düşürür. `third` verirken `second` null bırakmayın.

**Durumlar/varyantlar:** `dialogGlassLight/Dark`, `dialogGlass(bool)`, `popupViewGlassLight/Dark`, `puredThinGlassLight/Dark`, `actionBarMaskLight/Dark`. `withUnderlayBlur(...)` iki blur yarıçapını `sqrt(r1² + r2²)` ile birleştirir. `copyWith` yalnızca `blurRadius` değiştirir.

**Erişilebilirlik/platform:** Blend modları `MiuixGlassColorBlendMode`; shader yoksa `fallback` `BlendMode` kullanılır. `plusDarker` multiply, `plusLighter` plus'a yaklaşır; tam piksel eşitliği garanti edilmez.

### MiuixGlassStyle ve MiuixGlassStyles

**Tanım:** `MiuixGlassStyle`; `blend`, `inner`, `edge`, `reflect`, `light`, `refract`, `background`, `blur` alt modellerinden oluşur. `MiuixGlassStyles.values` 35 hazır stili içerir; `forTheme(false)` → `commonMediumRegularLowLight`, `forTheme(true)` → `commonMediumRegularDark`.

**Kullan:** Gerçek refractive camda hazır stil seçmek veya özel cam geliştirirken `copyWith` ile ince ayar yapmak.

**Kullanma:** Bar/menu yüzeylerinde style'ı material ile karıştırmayın; `shading: false` yüzeyler style refractive gölgeleme kullanmaz. 35 stilin tamamını aynı ekrande karşılaştırmak yerine amaçlı seçin.

**Durumlar/varyantlar:** `commonSmall*`, `commonMedium*`, `commonLarge*`, `bionicMedium*`, `tint*` aileleri; light/dark, thin/normal/regular/semibold/bold/demibold ve motion varyantları.

**Erişilebilirlik/platform:** Işık ve kırılma parametreleri cihaz/arka plana göre değişken görünür. Metin okunurluğu şeffaflıkla doğrudan ilişkili olduğundan düşük kontrastlı kombinasyonları test edin.

## 9. Hazır OS4 bileşen varyantları

Aşağıdakiler **kamu UI bileşenleridir**; normal sayfalar bunları tercih eder. Hepsi opt-in'dır ve eski bileşenlerin varsayılan görünümünü değiştirmez.

| Bileşen | Tanım ve Kullan | Kullanma ve durumlar |
|---|---|---|
| `MiuixGlassTopAppBar` | `title`, backdrop, scroll behavior ve opsiyonel `largeTitle`; glass actions/tabs için üst çubuk. | `progressiveBlur` backdrop ister; `isContentScrolled` ile kaydırma sonrası malzeme resetlenir. `bandBlurRadius = 0` blur'u kapatır; `bandHeightFactor` (0,1] aralığındadır. Gereksiz katmanlı blur kullanmayın. |
| `MiuixGlassIconButton` | `onPressed`, `child`, tooltip/semanticLabel; 44 varsayılan boyut. | `inheritTopBarMaterial` true iken bar malzemesini/scroll alpha'sını miras alır. Sayfa üzerinde bağımsız cam butonda `false`, uygun `backdrop` ve görünür `material` verin. Disabled: `onPressed: null`. |
| `MiuixGlassTabRow` | Bağımsız kapsül sekmeler; `tabs`, `selectedIndex`, `onSelect`. | `primaryColors(context)` veya `neutralColors(context)`; pressed/selected/resting/focus durumları. Boş `tabs` küçültülür. Çok sayıda sekmede yatay taşma/okunabilirlik testi yapın. |
| `MiuixGlassSegmentedTabRow` | Birleşik segmented görünüm. | Tek bir seçim modeli kullanın; tab row ile aynı anda iki seçim kaynağı kurmayın. `showStroke` mevcuttur. |
| `MiuixGlassNavigationBar` | `items`, `selectedIndex`, `onSelect`; cross-destination sürükleme, visible/hide ve indicator animasyonu. | `MiuixGlassNavigationItem.isAction` yalnızca `onSelect` çağırır, seçim/indicator değiştirmez. `trailingAction` ayrı eylemdir. `defaultWindowInsetsPadding` varsayılan false; kendi SafeArea/padding'inizi hesaplayın. Boş items küçültülür. |
| `MiuixGlassDialog` | Scaffold host'lu glass dialog; scope yoksa root `OverlayPortal` fallback. `show` veya eski `visible` zorunludur. | `title`, `summary`, `dialogGlass`, küçük stroke, `dimColor`, `scrimAlpha`, `largeScreen`. Backdrop dialog host ve scrim'i dışlamalıdır. `MiuixGlassDialogButton` rolleri `normal`, `primary`, `destructive`; pressed/disabled renkleri vardır. |
| `MiuixGlassBottomSheet` | Scaffold host'lu glass sheet; host yoksa `MiuixWindowBottomSheet`. Sürükleme kapatma, upward over-drag extension. | `show`, `onDismissRequest`, `title`, actions, `allowDismiss`, `enableNestedScroll`, `sheetMaxWidth`, `dimColor`. Over-drag'da stroke kaldırılır. Klavye ve nested scroll testi yapın. |
| `MiuixGlassPopup` | `ordinary` motion, trigger köşesine yakın açılan menü. | `show`, `onDismissRequest`, `anchor` veya `anchorBounds`, `sizing`, `visuals`. Exit tamamlanana kadar mounted tutun. |
| `MiuixGlassTransformPopup` | Buttondan menüye `transform` motion. | `anchor` ve key'siz `anchorContent` kopyası gerekir; aynı `GlobalKey` içeriği iki yerde kullanmayın. |
| `MiuixGlassSecondaryPopup` | Menü satırından ikincil panel; `secondary` motion. | `materialAnchor` ile birincil menü malzemesi paylaşılabilir. RTL ve ekran sınırlarını test edin. |
| `MiuixGlassDropdownPopup` | İki yayla boyut/merkez animasyonlu `dropdown` motion. | Değer satırı hizalama için düşük seviyeli `valueAnchor`; çoğu uygulama `MiuixGlassDropdownPreference` kullanır. |
| `MiuixGlassIconDropdownMenu` | `MiuixGlassIconButton` anchor'ından cascading menü. | `entries` `MiuixDropdownEntry` listesidir; `collapseOnSelection` null ise yalnızca tek gruplu menü otomatik kapanır. `anchorContent` yine key'siz kopya olmalıdır. |
| `MiuixGlassDropdownPreference` | Seçili değer + oka göre hizalanan tercih satırı ve arc dropdown. | `items`, `selectedIndex`, `onSelectedIndexChange`, `title`; boş items disabled sayılır. `showValue`, `enabled`, `onExpandedChange` mevcuttur. |
| `MiuixGlassPopupItem` | Menü satırı; icon, summary, selected check, submenu arrow. | `onPressed: null` veya `enabled: false` disabled; seçili check yer tutucu sabittir. `arrowRotation` derecedir; RTL'de +90, LTR'de -90 tipiktir. |

Popup ölçüleri `MiuixGlassPopupSizing(minWidth: 200, maxWidth: 288, maxHeight: 416, safeMargin: 12)`; görseller `MiuixGlassPopupVisuals`; motion enum `MiuixGlassPopupMotion` üzerinden gelir. Hazır bileşenler bu değerleri yönetir.

## 10. Doğru OS4 sayfa iskeleti

```dart
final backdrop = MiuixLayerBackdrop(); // State alanında; dispose edin.

MiuixScaffold(
  topBar: MiuixGlassTopAppBar(
    title: 'HyperOS 4',
    backdrop: backdrop,
    isContentScrolled: scrolled,
  ),
  content: (padding) => MiuixLayerBackdropCapture(
    backdrop: backdrop,
    child: ListView(
      padding: padding,
      children: [
        MiuixGlassDropdownPreference(
          items: const ['Bir', 'İki'],
          selectedIndex: selectedIndex,
          onSelectedIndexChange: onSelectionChanged,
          title: 'Seçim',
          backdrop: backdrop,
        ),
      ],
    ),
  ),
);
```

Backdrop, scaffold host ve scrim dışında kalmalıdır. Sahip State'de `backdrop.dispose()` çağrılmalıdır. Gerçek kodda `scrolled`, `onSelectionChanged` ve özel içerik tanımlanmalıdır.

Kaynaklar: `miuix_squircle.dart`, `miuix_pressable.dart`, `miuix_scroll_end_haptic.dart`, `miuix_content_color.dart`, `miuix_spring_utils.dart`, `miuix_popup_utils.dart`, `miuix_backdrop.dart`, `miuix_layer_backdrop.dart`, `miuix_texture_blur.dart`, `miuix_highlight.dart`, OS4 `glass/*` ve `components/miuix_glass*.dart`, `lib/showcase/foundation.dart`, `blur.dart`, `os4.dart`.
