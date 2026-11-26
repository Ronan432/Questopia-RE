# Yardımcı Bileşenler: Arama, Kaydırma, Yenileme ve Yüzey

Bu referans `flutter_miuix` **1.4.0** kaynak koduna ve `lib/showcase/utility.dart` örneklerine dayanır. Bileşenler `package:flutter_miuix/miuix.dart` üzerinden dışa aktarılır. Örnekler uygun `MiuixTheme`, `MaterialApp` ve gerektiğinde `Material`/`Navigator` kökü varsayar.

## MiuixSearchBar

Daraltılmış hâlde tek satırlık arama alanı, genişlediğinde içerik ve isteğe bağlı `outsideEndAction` gösteren kontrollü arama konteyneridir. `inputField` slotuna normalde `MiuixInputField` konur.

### Kullan

- Uygulama genelindeki içerik aramak veya bir sayfada önerileri filtrelemek için.
- `expanded` ve `onExpandedChange` ile arama görünümünü açıp kapatmak için.
- `content` içinde öneri/sonuç listesi ve boş durum göstermek için.

### Kullanma

- Her küçük listede filtre gerekiyorsa basit bir `TextField` yerine ekranı kaplayan arama deneyimi kurmayın.
- Aramayı yalnızca renk veya hover ile erişilebilir yapmayın; alan odaklanabilir olmalıdır.
- Sonuçları sonsuz kaydırılabilir bir listeye bağlarken arama alanının IME ile çakışmasını kontrol etmeyin.

### Önemli durumlar ve varyantlar

- `expanded: false`: yalnızca input; `true`: input + açılan content + `outsideEndAction`.
- Açılış/kapanış 275 ms; içerik `ClipRect` içinde animasyonlu genişler.
- `PopScope`, genişkenken sistem geri isteğini önce `onExpandedChange(false)` ile daraltmaya çevirir.
- `insideMargin` özelleştirilebilir; input slotunun kendi görsel stilini belirler.

### Erişilebilirlik ve platform

- Kontrollü `expanded` değeri parent'ta tutulmalı; `onExpandedChange` yalnızca istek iletir.
- Genişlerken `MiuixInputField` focus ister; daraltırken query varsa önce fade sonrası query temizlenir ve focus kapatılır. Query'yi korumak istiyorsan bu varsayılanı bilinçli yönetin.
- Sonuçlara klavyeyle erişim, “Eşleşme yok” metni ve arama gönderimi `onSearch` üzerinden sağlanmalıdır.

```dart
MiuixSearchBar(
  expanded: expanded,
  onExpandedChange: (v) => setState(() => expanded = v),
  inputField: MiuixInputField(
    query: query,
    label: 'Kişi ara',
    expanded: expanded,
    focusNode: searchFocus,
    onExpandedChange: (v) => setState(() => expanded = v),
    onQueryChange: (v) => setState(() => query = v),
    onSearch: (_) => searchContacts(query),
  ),
  content: results.isEmpty
      ? const Padding(
          padding: EdgeInsets.all(16),
          child: MiuixText('Eşleşme yok'),
        )
      : MiuixListPopupColumn(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final result in results)
              MiuixBasicComponent(
                title: result.name,
                onClick: () => openContact(result),
              ),
          ],
        ),
)
```

Search içeriği popup menüsü değildir; öneri listesi için daha uygun `ListView`/`Column` da kullanılabilir. `MiuixListPopupColumn` yalnızca ortak satır genişliği istendiğinde tercih edilmelidir.

## MiuixInputField

`MiuixSearchBar` içindeki stadium şeklinde input alanıdır. `TextEditingController`'ı ve isteğe bağlı `FocusNode`'u kendi yaşam döngüsünde yönetir; query ile metin güncellemeleri arasında IME composing bölgesini korumaya çalışır.

### Kullan

- `MiuixSearchBar.inputField` içinde tek satır arama, `TextInputAction.search` ve varsayılan başlangıç/temizleme ikonlarıyla.

### Kullanma

- Genel metin girişi, şifre, çok satırlı form veya doğrulama hataları için kullanmayın; `MiuixTextField` uygundur.
- Arama dışında bağımsız input olarak kullanmayın.

### Önemli durumlar ve varyantlar

- `enabled`, `label`, `textStyle`, `color`, `leadingIcon`, `trailingIcon`, `focusNode`.
- Query boşken varsayılan trailing ikon yoktur; dolu query'de animated clear simgesi görünür.

### Erişilebilirlik ve platform

- `Semantics(textField: true, enabled:)` ile alanı sunar; varsayılan başlıç/temizleme açıklamaları İngilizcedir, gerekirse `leadingIcon`/`trailingIcon` ile Türkçeleştirin.
- Dış `FocusNode` verirseniz onu siz `dispose` edin; vermezseniz widget kapatır.

## MiuixVerticalScrollBar

Bir `ScrollController`'ı `MiuixScrollBarAdapter` ile dinleyen, sağ kenarda süzülen ince dikey thumb ve isteğe bağlı track çizen yardımcıdır. Scroll view'in kendisini oluşturmaz.

### Kullan

- Uzun içerikte konum göstergesi ve mouse/dokunmatik thumb sürükleme için.
- Aynı controller'ı kullanan dikey `ListView`/`SingleChildScrollView` üzerinde `Positioned(top: 0, bottom: 0, right: 0)` ile.

### Kullanma

- Kısa veya zaten bar içeren Material `Scrollbar` kullanan içerikte ikinci scrollbar çizmeyin.
- `reverseLayout` ile scrollview yönünü uyumsuz ayarlamayın.
- Track'e tıklayarak atlama beklemeyin; drag yalnızca thumb üzerinde başlar.

### Önemli durumlar ve varyantlar

- Scroll sırasında görünür, hareketsizlikte 1 sn sonra 500 ms fade; hover/drag thumb'ı genişletir ve koyulaştırır.
- `trackPadding`, `colors`, `thumbWidth`, `thumbMinLength`, `cornerRadius`, `endPadding`, `reverseLayout`.
- Thumb uzunluğu görünür oranı temsil eder ve minimum 36 dp'tir; tüm içerik görünürse çizilmez.

### Erişilebilirlik ve platform

- Bileşen özel semantik değer üretmez; içeriğin scroll semantics'i korunmalıdır.
- 48 dp'lik dokunmatik strip thumb'ı hedefler; görsel çizgi 3,64 dp'tir. İçeriğin sağ altına ek padding vererek metni thumb altında bırakmayın.

```dart
final controller = ScrollController();
final adapter = MiuixScrollBarAdapter(controller);

Stack(
  children: [
    ListView.builder(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(16, 8, 32, 8),
      itemCount: 100,
      itemBuilder: (_, i) => MiuixText('Öğe ${i + 1}'),
    ),
    Positioned(
      top: 0,
      bottom: 0,
      right: 0,
      child: MiuixVerticalScrollBar(adapter: adapter),
    ),
  ],
)
// controller'ı State.dispose içinde kapatın.
```

## MiuixHorizontalScrollBar

Yatay `ScrollController` için aynı görsel ve etkileşim modelin alt kenardaki karşılığıdır.

### Kullan

- Zaman çizelgesi, yatay galeri veya geniş tablo içinde yatay konum ve thumb sürükleme için.
- `Positioned(left: 0, right: 0, bottom: 0)` ile aynı controller'lı yatay scrollview üzerinde.

### Kullanma

- Dikey scrollview üzerinde kullanmayın.
- Sağdan sola yönlendirmede `reverseLayout` değerini gerçek `AxisDirection` ile eşleştirmeden varsayılan bırakmayın.
- Masaüstünde Shift+wheel gibi alternatif kaydırma imkânı yerine geçmeyin.

### Önemli durumlar ve varyantlar

- Dikey sürümle aynı fade, minimum thumb, hover/drag ve renk/ölçü parametreleri.
- `adapter` zorunludur; adapter birden fazla scroll position'a bağlı controller'da mevcut `position` değerini kullanır.

### Erişilebilirlik ve platform

- Semantik desteği dikey sürümle aynı sınırlıdır; yatay içeriği başlıklarla ve ok tuşları/kaydırma kontrolleriyle erişilebilir kılın.
- Alt padding, thumb çizgisinin son satırı örtmemesi için ayrılmalıdır.

```dart
Stack(
  children: [
    ListView(
      controller: horizontalController,
      scrollDirection: Axis.horizontal,
      children: const [SizedBox(width: 120), SizedBox(width: 120)],
    ),
    Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: MiuixHorizontalScrollBar(
        adapter: MiuixScrollBarAdapter(horizontalController),
      ),
    ),
  ],
)
```

## MiuixPullToRefresh

Doğrudan child'ındaki dikey scroll bildirimlerini izleyen, damped pull başlığı ve threshold sonrası refresh state'i yöneten kapsayıcıdır. `isRefreshing` iş durumu parent tarafından yönetilir.

### Kullan

- Kullanıcının veri kaynağından güncel içerik çekmek istediği liste başlangıçlarında.
- `onRefresh` içinde hemen `isRefreshing = true` yapıp veri yüklenince `false` yapmak için.
- Kısa listelerde bile pull çalışsın istiyorsan child scrollview'a `AlwaysScrollableScrollPhysics` vermek için.

### Kullanma

- Form girişi, sürekli akış veya pull'un anlamsız olduğu salt okunur ekranlarda kullanmayın.
- İşlem başarısızsa sonsuz refresh bırakmayın; hata durumunu gösterip `isRefreshing = false` yapın.
- Yatay scrollview veya iç içe iki dikey scrollview'a gereksiz sarım yapmayın; yalnızca `depth == 0`, dikey overscroll işlenir.

### Önemli durumlar ve varyantlar

- `idle`, `pulling`, `thresholdReached`, `refreshing`, `refreshComplete`.
- Varsayılan threshold tam damped aralığın 0,25'i; `MiuixPullToRefreshController(refreshThreshold:)` ile 0–1 arası ayarlanır.
- `refreshTexts` dört metin taşır: pull, release, refreshing, complete. Yerleşik metinler İngilizcedir; Türkçe uygulamada dört metni birlikte verin.
- `color`, `circleSize`, `refreshTextStyle`, `contentPadding`, `onPullProgress`, `topAppBarScrollBehavior` vardır.

### Erişilebilirlik ve platform

- Refresh sırasında `liveRegion` semantiği etkinleşir; görünür durum metni de güncellenir.
- İşlem uzunsa ekran okuyucu kullanıcısı için ayrıca “Yenileniyor/Tamamlandı” bildirimi ve elle yenileme düğmesi sağlayın.
- Klavye kullanıcısı pull yapamaz; erişilebilir alternatif aksiyon zorunludur.

```dart
MiuixPullToRefresh(
  isRefreshing: refreshing,
  onRefresh: () async {
    setState(() => refreshing = true);
    try {
      await reloadItems();
    } finally {
      if (mounted) setState(() => refreshing = false);
    }
  },
  refreshTexts: const [
    'Yenilemek için aşağı çek',
    'Yenilemek için bırak',
    'Yenileniyor...',
    'Yenilendi',
  ],
  child: ListView.builder(
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: items.length,
    itemBuilder: (_, i) => MiuixText(items[i].title),
  ),
)
```

## MiuixSurface

Arka plan, içerik rengi, squircle köşe, tek kenarlık ve gölge sağlayan temel görsel konteynerdir. `MiuixContentColor` ile alt bileşenlere içerik rengi aktarır; varsayılan şekil dikdörtgendir.

### Kullan

- Kart yerine özel gruplama yüzeyi, seçili panel, ayırt edici bilgi kabığı oluşturmak için.
- `color`, `contentColor`, `cornerRadius`, `border`, `shadowElevation` ile tema yüzey hiyerarşisini kurmak için.
- `onPressed` varsa tüm yüzeyi tek bir tıklanabilir kontrol gibi kullanmak için.

### Kullanma

- Her liste satırını ayrı gölgeli yüzeye dönüştürmeyin; boşluk ve divider yeterli olabilir.
- `MiuixSurface`'i `Material`, `Card` veya `InkWell` yerine sanmayın; `DefaultTextStyle`, ripple ve focus sunmaz.
- `onPressed` verip yalnızca görsel basılılık beklemeyin; kendi durum/focus geri bildiriminizi ekleyin.
- Yuvarlak yüzeyin çocuklarını otomatik kırpma beklemeyin; görsel taşmayı kendiniz `ClipRRect`/uygun clip ile yönetin.

### Önemli durumlar ve varyantlar

- `cornerRadius: 0` dikdörtgen; >0 ve `squircleEnabled` ise Miuix squircle.
- `shadowElevation > 0`: siyah %15, blur = elevation, offset = (0, elevation/2).
- `border` alınır ama shape'in yanına yalnızca `border?.top` aktarılır; dört kenarlı farklı `Border` stilleri korunmaz.
- `enabled` yalnızca `onPressed` varsa tıklamayı etkisizleştirir; disabled rengi/fokus stili sağlamaz.
- `onPressed: null` olan yüzey etkileşimsiz dekoratif konteynerdir.

### Erişilebilirlik ve platform

- Düz `Text` `DefaultTextStyle` almaz; Miuix metinlerinde `MiuixContentColor` kullanılır. Gerekirse `Material(type: MaterialType.transparency)` veya `DefaultTextStyle` ekleyin.
- `GestureDetector` kendi başına button semantiği, klavye focus'u veya Enter/Space davranışı üretmez. Tıklanabilir yüzeyi `Semantics(button: true, label: ...)` ve focusable kontrolle sarmalayın; karmaşık içerikte `InkWell`/Miuix düğmesi daha uygundur.

```dart
MiuixSurface(
  color: colors.surfaceContainer,
  contentColor: colors.onSurfaceContainer,
  cornerRadius: 16,
  border: Border.all(color: colors.dividerLine),
  child: const Padding(
    padding: EdgeInsets.all(16),
    child: MiuixText('Yüzey içeriği'),
  ),
)
```

## Birleşik tasarım notları

- **Hiyerarşi:** body yüzeyi `surface`, gruplar `surfaceContainer`, seçili vurgu `primary`/indicator; her yüzeye ayrı gölge vermeyin.
- **Arama + IME:** search açılırken focus istenir; sonuçlar klavyenin önünde kalmalı, geri ilk önce aramayı kapatmalıdır.
- **Nesting:** scrollbar, pull-to-refresh ve büyük app bar aynı doğrudan dikey scroll bildirimlerini kullanabilir. Birbiriini kör körüne iç içe sarmayın; `topAppBarScrollBehavior` ile pull sırasında çökme davranışını açıkça yönetin.
- **Controller yaşamı:** `ScrollController`, `FocusNode`, `MiuixSnackbarHostState`, `MiuixNavigationRailState` ve isteğe bağlı controller/state'leri `State.dispose` içinde kapatın.
- **Mobil/masaüstü:** scrollbar ve hover tooltip farede faydalıdır; mobilde dokunma hedefleri, görünür metin ve klavye alternatifleri önceliklidir.

## Kaynak eşlemesi

- `/home/ayzen/Masaüstü/Projeler/miuix_test_app/packages/flutter_miuix/lib/src/theme/miuix/components/miuix_search_bar.dart`
- `/home/ayzen/Masaüstü/Projeler/miuix_test_app/packages/flutter_miuix/lib/src/theme/miuix/components/miuix_scroll_bar.dart`
- `/home/ayzen/Masaüstü/Projeler/miuix_test_app/packages/flutter_miuix/lib/src/theme/miuix/components/miuix_pull_to_refresh.dart`
- `/home/ayzen/Masaüstü/Projeler/miuix_test_app/packages/flutter_miuix/lib/src/theme/miuix/components/miuix_surface.dart`
- `/home/ayzen/Masaüstü/Projeler/miuix_test_app/lib/showcase/utility.dart`
