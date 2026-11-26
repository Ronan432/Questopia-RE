# Geri Bildirim ve Katmanlar

Bu referans `flutter_miuix` **1.4.0** kaynak koduna ve showcase örneklerine dayanır. Bileşenler `package:flutter_miuix/miuix.dart` üzerinden dışa aktarılır. Örnekler `MiuixTheme` ve uygun `MaterialApp`/`Navigator` kökü varsayar.

## Modal kararı ve katman hiyerarşisi

- **Snackbar:** mevcut akışı kesmeden kısa sonuç bildirir; önemli bilgi veya tekil onay için değildir.
- **Tooltip:** simge/kısaltma hakkında bağlamsal, kısa açıklama verir; kritik bilgi veya tek başına erişilebilir etiket değildir.
- **Dialog:** odağı ve dikkati kaplayan, genellikle bir karar/onay gerektiren modal yüzeydir.
- **Bottom sheet:** mobilde ekran altından açılan, bağlama bağlı aksiyonlar veya uzun seçim içeriği içindir. `MiuixWindowBottomSheet` pencere/kök Overlay'inde çalışır ve masaüstünde kullanılabilir; yerel masaüstü penceresine dönüşmez.
- **List popup:** bir düğmeye/bağlama bağlı kısa seçenek listesidir; tam ekran scrim ve back yakalama ile modal davranır.
- **Floating toolbar:** modal değildir; mevcut içerik üzerinde bağlamsal komutlar sunar.
- **Progress:** işlemin sürekliliğini gösterir; kendi başına modal oluşturmaz.

Birden fazla modalı aynı anda açmayın. `onDismissRequest` yalnızca bir **istek** iletir; sahibi `show`/`expanded` değerini `false` yapmalıdır. `onDismissFinished` çıkış animasyonundan sonradır. Aynı anda hem body ScrollView hem de modal açılırken body'yi `IgnorePointer` ile kilitlemek yerine modalın kendi scrim/focus davranışını koruyun.

## MiuixSnackbar

`MiuixSnackbarHostState` tarafından yönetilen, metin + isteğe bağlı aksiyon ve kapatma simgesi bulunan gölgeli squircle karttır. Doğrudan `MiuixSnackbar(data: ...)` kullanmak yerine normalde host üzerinden gösterilir.

### Kullan

- Kaydetme, silme, paylaşma gibi işlemlerin kısa geri bildirimi için.
- Tek, geri alınabilir aksiyon (`actionLabel`) ve gerekiyorsa `withDismissAction` için.
- Mesajı `state.showSnackbar(...)` ile göstermek; dönen `Future<MiuixSnackbarResult>` ile sonucu almak için.

### Kullanma

- Yıkıcı işlemden **önce** onay almak için; Snackbar sonrası “Geri al” ancak geri alınabiliyorsa anlamlıdır.
- Kritik hata, veri kaybı veya kullanıcının okuması zorunlu bilgi için kullanmayın.
- `MiuixSnackbarDuration.indefinite` mesajı görünür kapatma aksiyonu olmadan bırakmayın.
- Mesajı iki satırdan uzun tutmayın; kart metni ellipsis ile kesilir.

### Önemli durumlar ve varyantlar

- `short` 4 sn, `long` 10 sn, `indefinite` süresiz, `custom(ms)` pozitif özel süre.
- Sonuçlar `dismissed` ve `actionPerformed`; aksiyon, dismiss veya swipe sonrası Future tamamlanır.
- `canSwipeToDismiss` varsayılan `true`; yatayda yarı genişlik veya hızlı fling kapatır.
- `cornerRadius`, `colors`, `insideMargin`, `blurSigma`, `blurBackgroundAlpha` özelleştirilebilir.
- Her `showSnackbar` kuyruğa eklenir; birden fazla Snackbar **aynı anda** görünebilir. Yeni olan altta, eskiler üstte sıralanır.

### Erişilebilirlik ve platform

- Kart `liveRegion: true` semantiğiyle mesajı duyurur. Çok hızlı mesajlar ekran okuyucuyu bunaltabilir.
- Yerleşik kapatma semantiği İngilizce `Dismiss`/Çince `关闭` içerir; uygulama çevirisi için `builder` ile özelleştirin.
- Dokunmatik cihazda swipe yerine görünür kapatma/aksiyon seçeneği bırakın.

```dart
final snackbarState = MiuixSnackbarHostState();

MiuixScaffold(
  snackbarHost: MiuixSnackbarHost(state: snackbarState),
  content: (_) => MiuixButton(
    onPressed: () => snackbarState.showSnackbar(
      'Dosya silindi',
      actionLabel: 'Geri al',
      withDismissAction: true,
    ),
    child: const MiuixText('Sil'),
  ),
)
```

## MiuixSnackbarHost

Host, Snackbar girişlerini dinler; süre sayar, giriş/çıkış animasyonunu yapar ve varsayılan kartları `MiuixSnackbar` olarak oluşturur. Scaffold'ın `snackbarHost` slotuna yerleştirilir.

### Kullan

- Sayfada tek bir Snackbar yönetim noktası oluşturmak için.
- `state`, `builder`, `canSwipeToDismiss`, `blurSigma` ve `blurBackgroundAlpha` ile sunumu yönetmek için.

### Kullanma

- Her sayfada ayrı host/state oluşturup aynı mesajı birkaç kez göstermeyin.
- `builder` verirken `blurSigma`/`blurBackgroundAlpha` değerlerinin otomatik uygulanmadığını unutmayın; kartta kendiniz aktarın.

### Önemli durumlar ve varyantlar

- Host alt ortalı `Column` içinde birden fazla kartı stack benzeri dikey akışta gösterir.
- Özel `builder` her `MiuixSnackbarData` için çağrılır.
- State `ChangeNotifier` olduğundan sahibi onu `dispose` etmelidir.

### Erişilebilirlik ve platform

- Hostun kendisi ek semantik başlık üretmez; mesajlar kartların live region'ından okunur.
- Alt navigasyon varsayılan host boşluğuyla çakışabilir; Scaffold slotu ve body padding'i birlikte test edin.

## MiuixTooltip

1.4.0'da **`MiuixTooltip` adında widget yoktur**. Doğru bileşim `MiuixTooltipBox` + `MiuixPlainTooltip` (kısa metin) veya `MiuixRichTooltip`/`MiuixRichTooltipBox` (başlık ve aksiyon) şeklindedir.

### Kullan

- Yalnızca ikonlu düğmelerde, kısaltmalarda ve ek açıklama gerektiren küçük kontrollerde.
- `MiuixTooltipBox(tooltip: (context, scope) => MiuixPlainTooltip(scope: scope, child: ...), child: ...)` ile.
- `MiuixTooltipState` ile programatik `show()`/`dismiss()` veya `isPersistent` kontrolü için.

### Kullanma

- Temel işlevi, form hatasını veya zorunlu bilgiyi yalnızca tooltip'te saklamayın.
- Dokunmatik ekranda tooltip'i tek tıklama gerektiren aksiyon yapmayın; long press/hover farklı etkileşimlerdir.
- Her hover'da uzun metin göstermeyin; kısa ipucu yeterlidir.

### Önemli durumlar ve varyantlar

- `above`, `below`, `left`, `right`, `start`, `end` tercihleri; yer yetmezse karşı tarafa çevrilir.
- `showCaret`, `maxWidth`, `cornerRadius`, renk ve `insideMargin` seçenekleri vardır.
- Tüm tooltip state'leri tek etkin paylaşır; yeni tooltip öncekini kapatır.
- Varsayılan süre 1500 ms; açılış/kapanış animasyonu 180 ms.

### Erişilebilirlik ve platform

- Mouse hover, dokunmatik long press ve semantik long-press vardır.
- `MiuixTooltipBox` varsayılan olarak odaklanabilir bir klavye tetikleyicisi değildir. Klavye kullanıcısı için görünür focus ve alternatif bir tetikleyici/erişilebilir açıklama sağlayın.
- `focusable: true` dış tıklama barrier'ı ve route local history ekler; plain tooltip'i uzun süre açık bırakmayın.

## MiuixRichTooltip

Başlık, çok satırlı metin ve isteğe bağlı sağ hizalı aksiyon taşıyan daha geniş tooltip yüzeyidir. `MiuixRichTooltip` düşük seviyelidir; `MiuixRichTooltipBox` bunun pratik kısayoludur.

### Kullan

- Yeni özellik tanıtımı, kısa yönlendirme veya bir açıklama + tek aksiyon gerektiğinde.
- `MiuixRichTooltipBox(text:, title:, actionText:, onActionPressed:)` ile hızlı kurulum için.

### Kullanma

- Formun tamamı, onay penceresi veya uzun dokümantasyon için kullanmayın.
- Aksiyonlu tooltip'i dış tıklamayla kaybolan önemsiz bilgi gibi sunmayın; odak/klavye davranışını tasarlayın.

### Önemli durumlar ve varyantlar

- Varsayılan max genişlik 320 dp; title ve action isteğe bağlıdır.
- `MiuixRichTooltipBox` kendi persistent state oluşturur; dış tıklama ve route back ile kapanır.
- `MiuixRichTooltip` doğrudan kullanılırsa persistent davranışı çağıran `MiuixTooltipState`/`MiuixTooltipBox` ile sağlanır.

### Erişilebilirlik ve platform

- İçerik `container` semantiğine sahiptir; dış barrier ayrı bir “kapat” semantiği sunar.
- Klavye ile tooltip içindeki aksiyona ulaşım ve Escape/back ile kapanış uygulamada doğrulanmalıdır.

```dart
MiuixTooltipBox(
  tooltip: (context, scope) => MiuixPlainTooltip(
    scope: scope,
    showCaret: true,
    child: const MiuixText('Bildirimleri aç'),
  ),
  child: MiuixIconButton(
    onPressed: openNotifications,
    child: const MiuixIcon(
      icon: Icons.notifications_outlined,
      contentDescription: 'Bildirimler',
    ),
  ),
)
```

## MiuixOverlayDialog

`show` ile kontrol edilen modal iletişim kutusudur. Büyük ekranda ortada (varsayılan max 420 dp, max yükseklik 2/3 ekran), küçük ekranda altta ve IME yüksekliğine uyum sağlayan şekilde gösterilir.

### Kullan

- Kısa onay, kritik bilgi, düzenleme veya kullanıcının şu an cevap vermesi gereken içerik için.
- `title`, `summary`, `content`, `onDismissRequest` ve `onDismissFinished` ile yaşam döngüsünü yönetmek için.

### Kullanma

- Pasif bildirimler veya uzun iş akışlarının tamamı için kullanmayın.
- `onDismissRequest` içinde yalnızca iş yapmayın; sahibi `show = false` yapmalıdır.
- Yıkıcı onayda “İptal”i güvenli varsayılan bırakın; “Sil” eylemini açık adlandırın, sonucu açıklayın ve mümkünse geri alma sunun.

### Önemli durumlar ve varyantlar

- `show` false/true ve animasyonlu giriş/çıkış durumları.
- `enableWindowDim`, `dimColor`, `surfaceBuilder`, `largeScreen`, `cornerRadius`, margin ve `renderInRootScaffold` seçenekleri vardır.
- İçerik `MiuixDismissScope` altında render edilir; `MiuixDismissScope.maybeOf(context)?.call()` programatik kapatma isteği verir.

### Erişilebilirlik ve platform

- Modal, arka planı scrim ile kapatır; panel içi boş `GestureDetector` dış tıklamanın içeriğe geçmesini engeller.
- İlk anlamlı kontrolü odaklayın, Tab sırasını kısa tutun ve sonuç mesajını dialog dışında da erişilebilir kılın.
- Yerleşik dış tıklama semantiği İngilizce `Dismiss` içerir; gerekirse özelleştirin.

```dart
MiuixOverlayDialog(
  show: showConfirmation,
  title: 'Değişiklikleri kaydet',
  summary: 'Yaptığınız düzenlemeler bu cihazda saklanacak.',
  onDismissRequest: () => setState(() => showConfirmation = false),
  onDismissFinished: () => saveIfConfirmed(),
  content: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      MiuixTextButton(
        'İptal',
        onPressed: () => setState(() => showConfirmation = false),
      ),
      const SizedBox(width: 12),
      MiuixButton(
        onPressed: () => setState(() => showConfirmation = false),
        child: const MiuixText('Kaydet'),
      ),
    ],
  ),
)
```

## MiuixLinearProgressIndicator

Tam genişlikte ince bir ray + yuvarlak uçlu dolgu gösteren lineer göstergedir. `progress == null` belirsiz, 0–1 değeri belirli ilerlemedir.

### Kullan

- Yükleme/indirme/yükleme görevi gibi işlemin ilerlemesini göstermek için.
- Bilinen oran için `progress: value.clamp(0, 1)`; bilinmeyen süre için `progress: null` kullanmak için.

### Kullanma

- Tek bir düğmenin kısa beklemesini göstermek için tüm ekranı bloklamayın.
- İlerleme bilinmiyorsa sahte yüzde üretmeyin.
- `progress: 0` değerini “henüz başlamadı” olarak görsel olarak tamamen boş sanmayın; kod minimum bir yuvarlak uç korur.

### Önemli durumlar ve varyantlar

- Belirli/belirsiz mod; `height` varsayılan 6 dp, `colors` özelleştirilebilir.
- Değerler 0–1'e clamp edilir; bileşen değerleri kendiliğinden yumuşatma/interpolasyon yapmaz.
- Yerleşik `enabled` parametresi yoktur; `MiuixProgressIndicatorColors.disabledForegroundColor` mevcuttur ancak bu widget onu kullanmaz.

### Erişilebilirlik ve platform

- Semantik değer yüzde olarak verilir; etiket yerleşik Çince `进度` metnidir. Türkçe etiket için anlamlı bir `Semantics` sarmalayın ve gereksiz tekrarı önleyin.
- Uzun işlemlerde yalnızca renk/animasyon değil, durum metni ve iptal imkânı sunun.

## MiuixCircularProgressIndicator

Yuvarlak iz + yay gösteren kompakt göstergedir. `progress == null` dönen ve açılıp kapanan yay; belirli modda 12 saat yönünden başlayan yay çizer.

### Kullan

- Düğme yanı, kart içi veya küçük yükleme alanında kompakt ilerleme için.
- Bilinen oran için `progress`, bilinmeyen için `null` kullanmak için.

### Kullanma

- Çok küçük alana 30 dp'den belirgin şekilde küçük boyut vermeyin.
- Her listede birden çok sonsuz spinner kullanmayın; yüklenen bölümü placeholder ile ifade edin.

### Önemli durumlar ve varyantlar

- Varsayılan 30 dp boyut ve 4 dp stroke; `size`, `strokeWidth`, `colors` vardır.
- Belirsiz dönme 1000 ms, yay genişliği 1600 ms döngüsündedir.
- Belirli modda 0 ve 1 arası clamp; otomatik geçiş animasyonu yoktur.

### Erişilebilirlik ve platform

- Semantik yüzde ve `进度` etiketi sağlar; Türkçeleştirme için sarmalayın.
- Eşzamanlı hareket azaltma tercihinde dönen göstergenin yanında statik durum metni tutun.

```dart
MiuixLinearProgressIndicator(progress: downloadProgress)
// Bilinmeyen süre:
const MiuixCircularProgressIndicator()
```

## MiuixInfiniteProgressIndicator

İnce halka ve halka çevresinde dönen noktadan oluşan, belirli ilerleme sunmayan 20 dp'lik sonsuz göstergedir.

### Kullan

- Kısa, belirsiz süreli beklemenin zarif ve hafif göstergesi için.
- `color`, `size`, `strokeWidth`, `orbitingDotSize` ile ölçeklemek için.

### Kullanma

- Yüzde bilinen işlemler için kullanmayın.
- Zaten `MiuixCircularProgressIndicator(progress: null)` gösterilen alanda ikinci spinner koymayın.

### Önemli durumlar ve varyantlar

- Her zaman döner; belirli/belirsiz seçeneği yoktur.
- Varsayılan renk `Color(0xFF888888)`; tema rengine uyum için `color` verin.
- Dönme döngüsü 800 ms; varsayılan halka 2 dp ve nokta 2 dp.

### Erişilebilirlik ve platform

- Yalnızca `进度` semantiği vardır; yüzde vermez. “Yükleniyor” durumunu Türkçe metinle tamamlayın.

## MiuixOverlayBottomSheet

Scaffold popup host'unda çalışan, alt köşeleri squircle, üstte drag handle, isteğe bağlı title/start/end action içeren modal bottom sheet'tir.

### Kullan

- Mobilde 3–7 bağlamsal aksiyon, filtre veya kısa seçim panosu için.
- `show`, `onDismissRequest`, `content`, `title`, `allowDismiss`, `enableNestedScroll` ile yönetmek için.

### Kullanma

- Karmaşık çok adımlı form veya bağımsız sayfa akışı için kullanmayın.
- İçerik çok uzunsa ayrı route/sayfaya geçin; sheet'i küçük bir ekrana sıkıştırmayın.
- `allowDismiss: false` yaparken görünür bir kapatma/Tamam aksiyonu bırakın.

### Önemli durumlar ve varyantlar

- Yükselme, dış tıklama/back isteği, aşağı sürükleme ve çıkış animasyonu.
- İçerik altta `viewInsets.bottom` ile klavyeye uyar; `sheetMaxWidth` varsayılan 640 dp.
- `surfaceBuilder`, `dimColor`, `cornerRadius`, margin ve `enableNestedScroll` vardır.

### Erişilebilirlik ve platform

- `PopScope` back isteğini `allowDismiss` koşuluna göre yönetir.
- Drag handle dekoratiftir; klavye/ekran okuyucu için düğmelerle kapatma ve odak yönetimi şarttır.

## MiuixWindowBottomSheet

Aynı bottom sheet içeriğini **root Navigator Overlay**'inde gösteren pencere düzeyi varyantıdır. `MiuixScaffold` popup host'una bağlı değildir.

### Kullan

- Masaüstü/tablet kabuğu veya farklı scaffold bölgelerinin üzerinde aynı sheet'i göstermek için.
- Mobilde bile root overlay kapsaması gerektiğinde.

### Kullanma

- Dar ekranda içeriğin altında kalan navigasyona otomatik uyum beklemeyin; body boşluğu uygulama sorumluluğundadır.
- Bu bileşeni “native masaüstü penceresi” veya yan çekmece sanmayın; görsel olarak hâlâ alttan açılan bir sheet'tir.

### Önemli durumlar ve varyantlar

- `MiuixOverlayBottomSheet` ile aynı görsel API; fark `windowLevel: true` ve root `OverlayEntry` kullanımıdır.
- `renderInRootScaffold` parametresi **yoktur**; her zaman root overlay kullanır.

### Erişilebilirlik ve platform

- Tüm pencereyi kaplayan scrim ve `PopScope` back davranışı vardır.
- Root overlay tema/direction kaynağı korunur; yine de açık sheet varken arka plan klavye odaklanabilir kalmalıdır.

```dart
MiuixWindowBottomSheet(
  show: showSheet,
  title: 'Dışa aktar',
  allowDismiss: true,
  onDismissRequest: () => setState(() => showSheet = false),
  content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      MiuixBasicComponent(title: 'PDF olarak kaydet', onClick: exportPdf),
      MiuixBasicComponent(title: 'Paylaş', onClick: shareFile),
    ],
  ),
)
```

## MiuixFloatingToolbar

Squircle/kapsül arka plan, isteğe bağlı 0,75 dp divider ve sabit gölge içeren, modal olmayan komut konteyneridir. Yönü child'daki `Row`/`Column` belirler.

### Kullan

- Seçili içerik veya mevcut ekran için 2–5 bağlamsal komut sunmak için.
- `MiuixScaffold.floatingToolbar` veya `Stack` içinde konumlandırmak için.

### Kullanma

- Sayfanın birincil gezinmesi için kullanmayın; `MiuixFloatingNavigationBar` farklı bir bileşendir.
- Arka planın altındaki içerikle çakışan kalıcı bir bar yapmayın.
- Yalnızca ikonlarda tanınmayan simgeler kullanmayın; her komuta erişilebilir ad verin.

### Önemli durumlar ve varyantları

- Yatay veya dikey child düzeni; `cornerRadius`, `color`, `outSidePadding`, `showDivider`.
- `shadowElevation > 0` gölgeyi açar; diğer bileşenlerden farklı olarak gölgeyi büyütmez.
- Dış container tıklamaları tüketir; iç child düğmeleri kendi olaylarını alabilir.

### Erişilebilirlik ve platform

- Kendi semantik rolü yoktur; child'lara `MiuixIcon(contentDescription: ...)` gibi adlar ekleyin.
- Yoğun toolbar'larda 40 dp düğmelerin çevresinde en az 48 dp dokunma hedefi bırakın.

```dart
MiuixFloatingToolbar(
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      MiuixIconButton(
        onPressed: undo,
        child: const MiuixIcon(
          vector: MiuixIcons.extended.byName('undo')!,
          contentDescription: 'Geri al',
        ),
      ),
      MiuixIconButton(
        onPressed: redo,
        child: const MiuixIcon(
          vector: MiuixIcons.extended.byName('redo')!,
          contentDescription: 'Yinele',
        ),
      ),
    ],
  ),
)
```

## MiuixListPopupColumn

Liste popup içeriğini dikey kaydırır; genişliği ilk sekiz öğeden en genişine göre 200–288 dp aralığında toplar ve `FocusTraversalGroup` oluşturur. Tek başına popup değildir.

### Kullan

- `MiuixOverlayListPopup.content` içinde tutarlı genişlikte aksiyon/seçim listesi için.
- `scrollController`, `physics`, özel child widget'ları ve çok sayıda öğe için.

### Kullanma

- Host olmadan ekranda bağımsız bir menü gibi kullanmayın.
- İlk sekiz öğeden sonra çok daha geniş bir metin beklemeyin; ölçüm yalnızca ilk sekizi dikkate alır.
- Dış host `maxHeight` vermezsen çok uzun listenin ekranı taşmasını kontrol etmeyi unutmayın.

### Önemli durumlar ve varyantlar

- İçerik gerektiğinde kayar; varsayılan `ClampingScrollPhysics`.
- `physics: null` varsayılanı seçer; `NeverScrollableScrollPhysics` özel olarak verilebilir.

### Erişilebilirlik ve platform

- Focus traversal gruplar ama item semantiği çocuklardan gelir. Her satırı `MiuixBasicComponent`/erişilebilir düğme ile kurun.
- Uzun menülerde seçili öğeyi görünür alana getirin; yalnızca renkle işaretlemeyin.

## MiuixOverlayListPopup

`anchorBounds` etrafında konumlanan, default dropdown veya özel `popupPositionProvider` kullanan, dış tıklama/back ile kapanan modal liste popup'ıdır.

### Kullan

- Tek bir kontrolün kısa seçenek/aksiyon listesi için.
- `show`, `anchorBounds`, `alignment`, `maxHeight`, `minWidth`, `onDismissRequest` ve `content` ile.
- `content` içinde yukarıdaki `MiuixListPopupColumn` kullanmak için.

### Kullanma

- Uzun form veya çok seviyeli navigasyon için kullanmayın; cascade/sidebar daha uygundur.
- `enableWindowDim: false` yapınca popup modal olmaktan çıkmaz; scrim hâlâ tıklamayı yakalar.
- Seçimden sonra kapatmayı unutmayın; `MiuixDismissScope` üzerinden istek verebilirsiniz.

### Önemli durumlar ve varyantlar

- Varsayılan konum dropdown; `MiuixListPopupDefaults.contextMenuPosition` bağlama göre context-menu yerleşimi sağlar.
- 0,15→1 scale/reveal + fade animasyonu; pencere sınırlarına clamp edilmiş max yükseklik.
- `renderInRootScaffold` varsayılan `true`; false verilirse mevcut scaffold popup host'u kullanılır.

### Erişilebilirlik ve platform

- `PopScope(canPop: false)` back'i kapatma isteğine çevirir; dış barrier tam ekranı kaplar.
- `anchorBounds` global/overlay koordinat Rect olmalıdır; ekran dönüşünce yeniden hesaplayın.
- `MiuixDismissScope` isteği iletir; her zaman sahibin `show = false` yapması gerekir.

```dart
final anchorKey = GlobalKey(); // State'te tutun.

Rect anchorRect() {
  final box = anchorKey.currentContext!.findRenderObject() as RenderBox;
  final origin = box.localToGlobal(Offset.zero);
  final size = box.size;
  return Rect.fromLTWH(origin.dx, origin.dy, size.width, size.height);
}

MiuixButton(
  key: anchorKey,
  onPressed: () => setState(() => showPopup = true),
  child: const MiuixText('Seçenekler'),
)
MiuixOverlayListPopup(
  show: showPopup,
  anchorBounds: anchorRect(),
  maxHeight: 320,
  onDismissRequest: () => setState(() => showPopup = false),
  content: MiuixListPopupColumn(
    children: [
      MiuixBasicComponent(
        title: 'Kopyala',
        onClick: () => setState(() => showPopup = false),
      ),
      MiuixBasicComponent(
        title: 'Sil',
        onClick: () => setState(() => showPopup = false),
      ),
    ],
  ),
)
```

Örnekte tetikleyici ve popup aynı parent widget ağacında kalır; `anchorRect()` yalnızca tetikleyici render edildikten sonra çağrılır.

## Kaynak eşlemesi

Bileşen kaynakları `/home/ayzen/Masaüstü/Projeler/miuix_test_app/packages/flutter_miuix/lib/src/theme/miuix/components/` altında `miuix_snackbar.dart`, `miuix_tooltip.dart`, `miuix_overlay_dialog.dart`, `miuix_progress_indicator.dart`, `miuix_bottom_sheet.dart`, `miuix_floating_toolbar.dart`, `miuix_list_popup.dart` ve `miuix_list_popup_host.dart` dosyalarıdır. Kullanım karşılaştırması `/home/ayzen/Masaüstü/Projeler/miuix_test_app/lib/showcase/feedback.dart` ve `overlays.dart` ile yapılmıştır.
