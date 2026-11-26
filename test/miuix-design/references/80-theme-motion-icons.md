# Tema, hareket ve ikonlar — flutter_miuix 1.4.0

Bu referans, yerel `packages/flutter_miuix/lib`, README, CHANGELOG ve `lib/showcase` kaynaklarına göre hazırlanmıştır. Herkese açık giriş noktası `package:flutter_miuix/miuix.dart` içindendir. `src/` dosyalarından doğrudan import etmeyin.

## 1. Tema kurulumu

### MiuixTheme

**Tanım:** `MiuixThemeData` değerini alt ağaca sunan `InheritedWidget`. `MiuixTheme.of(context)` bağlamaya bağımlı okuma yapar; tema değişince ilgili widget'lar yeniden kurulur. Tema yoksa `MiuixThemeData.light()` kullanılır. `MiuixTheme.maybeOf(context)` bağımlılık oluşturmadan okur; bulunamazsa `null` döner.

**Kullan:** Uygulama genelinde tek tema sağlamak, bir vitrin/önizleme alt ağacını geçici olarak yeniden renklendirmek, açık/koyu tema verisini açıkça sabitlemek.

**Kullanma:** Her sayfada ayrı ayrı renk seçmek yerine en yüksek uygun köke koyun. `maybeOf` sonucunu kontrol etmeden `.colors` erişmeyin. `MiuixTheme` bir `MaterialApp` değildir; Material bileşenleri için Material altyapısını ayrıca kurun.

**Durumlar/varyantlar:** `MiuixThemeData.light()`, `.dark()`, `.of(brightness)` ve `copyWith(...)`. Veri; `colors`, `textStyles`, `brightness`, `fontWeightAdjustment` içerir.

**Erişilebilirlik/platform:** `fontWeightAdjustment` 100'lük adımlarla çalışır; +100, belirtilmeyen w400'ü w500 yapar. `MiuixSystemTheme` ve `MiuixThemeController` varsayılan olarak `MediaQuery.boldTextOf` değerini izler. Sistem “Kalın metin” ayarını elle tekrar uygulamayın.

```dart
final base = MiuixTheme.of(context);
MiuixTheme(
  data: base.copyWith(
    colors: miuixColorsFromSeed(
      seed: const Color(0xFF3482FF),
      dark: false,
    ),
    brightness: Brightness.light,
  ),
  child: const PreviewPanel(),
);
```

### MiuixSystemTheme

**Tanım:** `MediaQuery.platformBrightnessOf(context)` ile sistem açık/koyu durumunu seçen kolay tema sarmalayıcısı. İsteğe bağlı `light`, `dark`, `textStyles`, `fontWeightAdjustment`, `boldTextFontWeightAdjustment` alır.

**Kullan:** Uygulamanın sistem temasını otomatik izlemesi gerektiğinde ve kullanıcıya ayrı bir tema modu sunulmadığında.

**Kullanma:** Uygulama içi açık/koyu/kalıcı tercihi yönetiyorsanız `MiuixThemeController` kullanın. Sistem ayarlarını sabitlemek istediğiniz özel test köklerinde yerine `MiuixTheme` tercih edin.

**Durumlar/varyantlar:** Sistem `Brightness.light/dark`; `fontWeightAdjustment` açıkça verilirse otomatik kalın metin izleme devre dışı kalır.

**Erişilebilirlik/platform:** Tema `MaterialApp` dışında, onu besleyen `Builder` içinde okunmalıdır. Aksi halde `MediaQuery` yoksa çalışma zamanı hatası oluşur.

```dart
MiuixSystemTheme(
  child: Builder(
    builder: (context) {
      final t = MiuixTheme.of(context);
      return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          brightness: t.brightness,
          colorScheme: ColorScheme.fromSeed(
            seedColor: t.colors.primary,
            brightness: t.brightness,
          ),
        ),
        home: const HomePage(),
      );
    },
  ),
);
```

### MiuixThemeController

**Tanım:** `MiuixColorSchemeMode` değerine göre statik veya Monet paletini çözen `StatefulWidget`. Modlar: `system`, `light`, `dark`, `monetSystem`, `monetLight`, `monetDark`.

**Kullan:** Kullanıcının tema modunu değiştirdiği uygulamalarda; `keyColor` ile deterministik tohum rengi üretiminde; Android duvar kağıdından dinamik renk alınmasında.

**Kullanma:** Yalnızca sistem teması izleniyorsa gereksiz karmaşa yaratmayın. Platform kanalı kendi kodunuzda tekrar okumayın; controller zaten yönetir.

**Durumlar/varyantlar:** `isDark` null ise sistem izlenir; verilirse statik modlarda da açık/koyu seçimi geçersiz kılar. `monet*` modunda `keyColor` varsa üretim senkrondur. `keyColor` null ise Android'de asenkron duvar kağıdı okunur; sonuç öncesi `miuixMonetSystemColors` yer tutar. Sonuç `mounted` kontrolüyle uygulanır.

**Erişilebilirlik/platform:** `colorSpec` şu anda yalnızca `spec2021` ve `spec2025` kabul eder; bağımlılık 0.13.0 olduğundan ikisi de pratikte SPEC_2021 üretir. `spec2025` gerçek 2025 üretimi vaat etmez. Palet stilleri: `tonalSpot`, `neutral`, `vibrant`, `expressive`, `rainbow`, `fruitSalad`, `monochrome`, `fidelity`, `content`.

```dart
MiuixThemeController(
  colorSchemeMode: MiuixColorSchemeMode.monetSystem,
  // keyColor verilirse platform kanalı yerine bu tohum kullanılır.
  keyColor: const Color(0xFF3482FF),
  paletteStyle: MiuixThemePaletteStyle.tonalSpot,
  child: const MyApp(),
);
```

## 2. Renk sistemi: MiuixColors

**Tanım:** Değişmez semantik renk rol koleksiyonu. `lightColorScheme()` ve `darkColorScheme()` varsayılanları; `copy(...)` ile kısmi geçersiz kılma yapılır. Dinamik üretim `miuixColorsFromSeed(seed:, dark:, colorSpec:, paletteStyle:)` ile tam `MiuixColors` döndürür.

**Kullan:** Yüzey, metin, ikon, sınır ve etkileşim rengini anlamına göre seçmek. Örneğin buton zemini için `primary`, üzerindeki içerik için `onPrimary`.

**Kullanma:** Sabit renkleri rastgele yüzeylere dağıtmayın. `on...` rolünü kendi zeminine uymayan renklerle değiştirmeyin. Monokrom cam yüzeylerde metin kontrastını ayrıca test edin.

**Durumlar/varyantlar:** Açık/koyu statik şemalar, tohum rengiyle üretilen Monet şemaları, `copy`. Renk rolleri durum bazlı değildir; disabled renkleri bileşen ilgili `disabled...` rolünden alır.

**Erişilebilirlik/platform:** Rol adları birebir eşleşir; koyu tema otomatik olarak “ters renk” değil, ayrı tanımlı koyu şemadır. Android duvar kağıdı okunamazsa veya desteklenmeyen platformdaysa sabit tohum `0xFF6750A4` kullanılır.

### Rol rehberi

| Alan | Tam roller |
|---|---|
| Birincil | `primary`, `onPrimary`, `primaryVariant`, `onPrimaryVariant`, `primaryContainer`, `onPrimaryContainer` |
| Hata | `error`, `onError`, `errorContainer`, `onErrorContainer` |
| Birincil disabled | `disabledPrimary`, `disabledOnPrimary`, `disabledPrimaryButton`, `disabledOnPrimaryButton`, `disabledPrimarySlider` |
| İkincil | `secondary`, `onSecondary`, `secondaryVariant`, `onSecondaryVariant`, `secondaryContainer`, `onSecondaryContainer`, `secondaryContainerVariant`, `onSecondaryContainerVariant` |
| İkincil disabled | `disabledSecondary`, `disabledOnSecondary`, `disabledSecondaryVariant`, `disabledOnSecondaryVariant` |
| Üçüncül kap | `tertiaryContainer`, `onTertiaryContainer`, `tertiaryContainerVariant` |
| Arka plan | `background`, `onBackground`, `onBackgroundVariant` |
| Yüzey | `surface`, `onSurface`, `surfaceVariant`, `onSurfaceSecondary`, `onSurfaceVariantSummary`, `onSurfaceVariantActions`, `disabledOnSurface` |
| Yüzey kapları | `surfaceContainer`, `onSurfaceContainer`, `onSurfaceContainerVariant`, `surfaceContainerHigh`, `onSurfaceContainerHigh`, `surfaceContainerHighest`, `onSurfaceContainerHighest` |
| Ayırıcı/özel | `outline`, `dividerLine`, `windowDimming`, `sliderKeyPoint`, `sliderKeyPointForeground`, `sliderBackground` |

## 3. Metin: MiuixTextStyles

**Tanım:** Yalnızca boyut, satır yüksekliği ve ağırlık taşıyan metin presetleri. Renk çalışma zamanında `MiuixContentColor` veya açık `color` ile gelir. `defaultTextStyles()` yeni bir preset kümesi döndürür.

**Kullan:** `MiuixText(style: MiuixTheme.of(context).textStyles.body1)` ile tipografik hiyerarşiyi korumak.

**Kullanma:** Her ekranda yeni `TextStyle(fontSize: ...)` tanımlamayın. `MiuixTextStyles` içine tema rengi gömmeyin; renk rolünü ayrıca çözün. Kullanıcının metin ölçeği ayarını `fontSize` sabitleyerek baskılamayın.

**Durumlar/varyantlar:** `main` 17, `paragraph` 17/height 1.2, `body1` 16, `body2` 14, `button` 17, `footnote1` 13, `footnote2` 11, `headline1` 17, `headline2` 16, `subtitle` 14 kalın, `title1` 32, `title2` 24, `title3` 20, `title4` 18. `copy(...)` ile özel yapılabilir.

**Erişilebilirlik/platform:** Boyutlar Flutter'da mantıksal pikseldir; Android `sp` benzeri davranış `MediaQuery.textScaler` üzerinden gelir. `MiuixText`, son ağırlığa `fontWeightAdjustment` uygular. Ham `Text` kullanırsanız bu uygulamayı kendiniz yapmalısınız.

## 4. Hareket: MiuixMotion

**Tanım:** Miuix eğrileri ve Folme yay tanımlarının statik koleksiyonu.

**Kullan:** Giriş/çıkışta `standardDecelerate` / `standardAccelerate`; yumuşak konum veya ölçek geçişinde `sinOut`; basma/geri dönüş için `pressSpring`; hafif zıplamalı seçim için `bouncySpring`.

**Kullanma:** Uzun sayfa geçişlerini yalnızca dekorasyon için yavaşlatmayın. Her widget'ta farklı süreler ve eğriler kullanmayın. `response` saniye cinsindendir; milisaniye vermeyin.

**Durumlar/varyantlar:** `pressSpring`: damping 1.0, response 0.35; `bouncySpring`: damping 0.85, response 0.45. `folmeSpring(damping:, response:)`, stiffness hesabını `(2π/response)²` olarak yapar.

**Erişilebilirlik/platform:** `MediaQuery.disableAnimationsOf(context)` veya `maybeDisableAnimationsOf(context)` true ise hareketi atlayın. OS4 bazı kontrollerinde iç destek vardır; kendi `AnimationController` kodunuzda kontrol sizin sorumluluğunuzdadır.

## 5. İkon sistemi

### MiuixIcon

**Tanım:** Material `IconData`, `MiuixVectorIcon` veya özel `child` arasında tam olarak biriyle çalışan ortak render widget'ı. Varsayılan boyut 24 mantıksal pikseldir; varsayılan tint `MiuixContentColor.of(context)` gelir.

**Kullan:** Miuix ikonlarını tek tip boyut, renk ve semantikle çizmek.

**Kullanma:** `icon`, `vector`, `child` üçünü birlikte vermeyin. Etkileşimli düğmede yalnızca ikona güvenmeyin; düğme semantiği ve tıklama alanı ayrıca olmalıdır.

**Durumlar/varyantlar:** `tint` açık/koyu tema rengi; disabled durumda `disabledOnSurface` gibi uygun disabled rolü; çok renkli içerik için `kMiuixTintUnspecified`. `child` yolunda `size` verilmezse çocuğun kendi boyutu korunur.

**Erişilebilirlik/platform:** Anlamlı ikonda `contentDescription` verin; dekoratif ikonda `null` bırakın. Yönlü vektörler `autoMirror` ile RTL'de yansır. `MiuixIcon` tek başına buton değildir.

```dart
MiuixIcon(
  vector: MiuixIcons.extended.byName('search')!,
  size: 24,
  contentDescription: 'Ara',
);
```

Üretim kodunda sabit ad kullanmak yerine nullable `byName` sonucunu kontrol edin; `!` yalnızca varlığı garanti edilen sabit veri adı için uygundur.

### MiuixVectorIcon

**Tanım:** `name`, `viewport`, `intrinsicSize`, `paths`, `autoMirror` taşıyan değişmez vektör modeli. `MiuixVectorPath`; fill/stroke, renk, alpha, çizgi genişliği, çizgi ucu ve grup dönüşümünü tanımlar. `MiuixVectorIconPainter` çizer; `miuixParsePath(...)` mutlak `M/L/Q/C/Z` path verisini ayrıştırır.

**Kullan:** Paket dışında özel vektör ikon tanımlarken veya mevcut vektörü kendiniz çizmek istediğinizde.

**Kullanma:** Normal uygulama sayfalarında path üretmek veya painter doğrudan kurmak yerine `MiuixIcon(vector: ...)` kullanın. Göreli SVG komutları veya `H/V/A/S/T` beklemeyin; ayrıştırıcı bunları desteklemez.

**Durumlar/varyantlar:** Tint uygulanırsa tüm katmanlar `BlendMode.srcIn` ile renklendirilir; alpha korunur. Tint yoksa path'lerin özgün renkleri kullanılır.

**Erişilebilirlik/platform:** Semantik `MiuixVectorIcon` modelinde değil, onu saran `MiuixIcon` içinde tanımlanır. `autoMirror` yalnızca gerçekten yönlü ikonlarda true olmalıdır.

### MiuixIcons, MiuixBasicIcons, MiuixExtendedIcons

**Tanım:** `MiuixIcons` üç namespace sağlar: `basic`, `extended`, `os4`. `MiuixBasicIcons` 7 temel ikon içerir. `MiuixExtendedIcons` 156 isim ve beş ağırlık içerir. `MiuixOs4Icons` 176 isim ve beş ağırlık içerir; eski extended kümesini değiştirmez.

**Kullan:** Temel kontroller için `MiuixIcons.basic`; genel uygulama sembolleri için `MiuixIcons.extended`; OS4 cam arayüzünde `MiuixIcons.os4`.

**Kullanma:** `MiuixExtendedIcons.internal` / `MiuixOs4Icons.internal` kurucularını doğrudan kullanmak yerine `MiuixIcons.extended` / `MiuixIcons.os4` singleton'larını tercih edin. Aynı işlevi gereksiz yere hem extended hem OS4 ile karıştırmayın.

**Durumlar/varyantlar:** Basic getter'ları: `arrowRight`, `arrowUpDown`, `check`, `close`, `search`, `searchCleanup`, `sidebar`. Extended `byName(name, [weight])`, `names`; OS4 `byName(name, [weight])`, `names` ve adlandırılmış getter'lar. Ağırlıklar: `MiuixIconWeight.light`, `normal`, `regular`, `medium`, `demibold`. Varsayılan `regular`.

**Erişilebilirlik/platform:** Extended intrinsic boyut 24'tür; bazı basic ikonlar kendi intrinsic boyutunu kullanır, tutarlı hizalama için `size: 24` verin. OS4'nın `markAsUnread` adı doğrudur; eski `markRasUnread` alias'ı deprecated'dir.

```dart
final icon = MiuixIcons.extended.byName(
  'settings',
  MiuixIconWeight.medium,
);
final os4Search = MiuixIcons.os4.byName('search');
```

Kaynaklar: `miuix_theme.dart`, `miuix_colors.dart`, `miuix_text_styles.dart`, `miuix_motion.dart`, `miuix_dynamic_colors.dart`, `miuix_platform_dynamic_colors.dart`, `miuix_icon.dart`, `miuix_vector_icon.dart`, `miuix_basic_icons.dart`, `miuix_extended_icons.dart`, `miuix_os4_icons.dart`, `lib/showcase/theming.dart`.
