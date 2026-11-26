# Gezinme: İskelet, Uygulama Çubukları ve Hedefler

Bu referans `flutter_miuix` **1.4.0** kaynak koduna ve `miuix_test_app/lib/showcase` kullanımlarına dayanır. Tüm bileşenler `package:flutter_miuix/miuix.dart` üzerinden dışa aktarılır. Dart örneklerinde `MiuixTheme`, `MaterialApp`/`Navigator` ve gerekli `Material` ataWidget'larının bulunduğu varsayılır.

## Navigasyon hiyerarşisi ve back-stack

- **Sayfa iskeleti:** `MiuixScaffold`; üst/alt bar, içerik, Snackbar ve popup katmanlarını tek ekranda konumlar.
- **Sayfa bağlamı:** `MiuixTopAppBar` veya `MiuixSmallTopAppBar`; başlık, geri simgesi ve sayfa aksiyonlarını taşır.
- **Birincil hedefler:** `MiuixNavigationBar`, `MiuixFloatingNavigationBar` veya geniş ekranda `MiuixNavigationRail`. Genellikle 3–5 eş düzey, karşılıklı olarak dışlayan bölüm için kullanılır.
- **İçerik görünümleri:** `MiuixTabRow` / `MiuixTabRowWithContour`; aynı hedef içindeki yakın içerik grupları içindir. Sekmeler kendiliğinden sayfa yüklemez veya back-stack oluşturmaz.
- **Hiyerarşik konum:** `MiuixBreadcrumbBar`; özellikle derin dosya/kategori ağacında üst düzey hedeflere dönüş sağlar.

`MiuixScaffold`, app bar ve navigation bar **Navigator yönetmez**. Geri düğmesini `Navigator.of(context).maybePop()` ile bağlayın. Birincil hedef değişimini `pushReplacementNamed` ile her seferinde yeni sayfaya yığmak yerine tek kök kabukta kontrollü içerik/`IndexedStack` ile yönetin; böylece geri beklenmedik hedeflere dönmez. Derin bir ağaçta breadcrumb tıklaması açıkça hedef route'a gitmeli, yalnızca görsel seçim değiştirmemelidir.

## MiuixScaffold

Ekranın body → topBar → snackbarHost → bottomBar → floatingToolbar → FAB → popupHost sırasıyla çizildiği, bar yüksekliklerini ölçen ve `content(EdgeInsets)` verilen Miuix iskeletidir.

### Kullan

- Sayfanın tek görsel ve katman kökü için.
- `content: (padding) => ...` içinde verilen padding'i listenin/root Padding'in `padding`'ine uygulamak için.
- `topBar`, `bottomBar`, `floatingActionButton`, `floatingToolbar`, `snackbarHost` ve `popupHost` arasında tek düzen oluşturmak için.
- `containerColor`, `contentWindowInsets`, `MiuixFabPosition` veya `MiuixToolbarPosition` ile ekrana özgü yerleşim kurmak için.

### Kullanma

- `content` içinde dönen padding'i yok sayıp içeriği barların altına çizmek için; Scaffold padding'i otomatik uygulamaz.
- Her kart veya nested panel için nested Scaffold oluşturmak için. Gerekirse popup root'unu paylaşır; gereksiz iç iskeletler ölçüm ve focus karmaşası yaratır.
- Sistem barı + bar + `SafeArea` üç katmanını bilinçsiz birleştirmek için. Varsayılan `contentWindowInsets` zaten `MediaQuery.paddingOf` kullanır.

### Önemli durumlar ve varyantlar

- Tüm slot'lar isteğe bağlıdır; yalnızca `content` zorunludur.
- FAB varsayılanı `MiuixFabPosition.end`; toolbar varsayılanı `MiuixToolbarPosition.bottomCenter`.
- `containerColor: null` tema `surface` rengi; şeffaf iskelet için `Colors.transparent` verin.
- Padding ölçüm sonrası `ValueNotifier` ile bildirilir; bar boyutu değişirse içerik yeniden düzenlenir.

### Erişilebilirlik ve platform

- Scaffold semantik bir sayfa container'ı değildir; sayfa başlığını app bar metni, içeriği anlamlı widget'larla sunun.
- Sağdan sola dillerde toolbar konumları `Directionality` ile çözülür.
- Klavye açıkken body'nin `viewInsets.bottom` değerini gerektiği yerlerde tüketin; Scaffold yalnızca varsayılan olarak üst/yan/sistem alt padding'ini hesaplar.

```dart
MiuixScaffold(
  topBar: MiuixSmallTopAppBar(title: 'Ayarlar'),
  bottomBar: MiuixNavigationBar(children: navigationItems),
  snackbarHost: MiuixSnackbarHost(state: snackbarHostState),
  content: (padding) => ListView(
    padding: padding,
    children: const [Text('İçerik')],
  ),
)
```

## MiuixTopAppBar

Üstte 52 dp sabit çökük şerit, altında büyük başlık ve isteğe bağlı alt başlık bulunan, dikey kaydırmayla çökebilen uygulama çubuğudur. Büyük başlık çökmenin ilk üçte birinde kaybolur; küçük başlık bu eşikte belirir.

### Kullan

- Uzun kaydırılabilir sayfalarda ekran kimliği ve büyük başlık hiyerarşisi için.
- `scrollBehavior` + `MiuixScrollBehaviorListener` ile başlığı doğrudan ana dikey scroll'a bağlamak için.
- `navigationIcon`, `actions`, `subtitle`, `bottomContent` ile sayfaya özgü bağlam sağlamak için.

### Kullanma

- Çökme istemiyorsan `MiuixSmallTopAppBar` kullanın; `scrollBehavior` vermeden büyük bar statik geniş görünür.
- `navigationIcon` içinde ham `IconButton` yerine erişilebilir etiketli Miuix/Flutter düğmesi koymadan ikon bırakmayın.
- Başlığı tek satırı aşacak şekilde kullanmayın; uygulama başlığını `TextOverflow.ellipsis` ile kısaltır.

### Önemli durumlar ve varyantlar

- Genişletilmiş, geçiş ve çökük durumlar; `title` küçük, `largeTitle ?? title` büyük metindir.
- `subtitle` her iki başlık durumunda görünür.
- `blurred: true`, `blurRadius`, `blurTintAlpha` ile isteğe bağlı BackdropFilter; varsayılanı saf renklidir.
- `titleAlpha`, `bottomContent`, renk ve padding özelleştirmeleri vardır.

### Erişilebilirlik ve platform

- `defaultWindowInsetsPadding: true` üst sistem alanını ve yatay kesilmiş alanları hesaba katar.
- Çok sayıda action'ı dar ekranda sıkıştırmayın; daha az önemli olanları overflow menüsüne taşıyın.
- Büyük/küçük başlık aynı metni iki kez çizebilir; gereksiz `Semantics` katmanı eklemeyin.

```dart
final behavior = miuixScrollBehavior();

MiuixScaffold(
  topBar: MiuixTopAppBar(
    title: 'Mesajlar',
    navigationIcon: IconButton(
      tooltip: 'Geri',
      onPressed: () => Navigator.of(context).maybePop(),
      icon: const Icon(Icons.arrow_back),
    ),
    scrollBehavior: behavior,
  ),
  content: (_) => MiuixScrollBehaviorListener(
    behavior: behavior,
    child: ListView(children: const [Text('Mesaj listesi')]),
  ),
)
```

## MiuixSmallTopAppBar

Çökmeyen, başlığı ortalanan, varsayılan merkez yüksekliği 50 dp olan statik uygulama çubuğudur. `subtitle` ve `bottomContent` ekleyebilir.

### Kullan

- Form, ayrıntı, ayar veya kısa sayfalarda sabit bağlam için.
- Paylaşılan bir `scrollBehavior` içinde barı `pin()` ile sabit tutmak için.

### Kullanma

- Uzun kaydırılabilir içerikte büyük başlık gerekiyorsa bunu tercih etmeyin.
- Aynı anda çökük büyük bar ile aynı behavior state'ini paylaşıp birbirlerinin sınırlarını sıfırlatmayın.

### Önemli durumlar ve varyantlar

- Her zaman tek satır küçük başlık; isteğe bağlı alt başlık ve alt içerik.
- `navigationIcon`, `actions`, renkler ve üç yatay padding parametresi vardır.
- `scrollBehavior` verildiğinde bar kendini pinned yapar.

### Erişilebilirlik ve platform

- Başlık ile leading/trailing ikonların çakışmaması için kısa başlık seçin.
- Geri yalnızca `Navigator.canPop()` ise gösterilmeli; kök ekranda sahte geri düğmesi koymayın.

```dart
MiuixSmallTopAppBar(
  title: 'Profil',
  navigationIcon: IconButton(
    tooltip: 'Geri',
    onPressed: () => Navigator.of(context).maybePop(),
    icon: const Icon(Icons.arrow_back),
  ),
)
```

## MiuixNavigationBar

2–5 eşit genişlikte hedefi olan, üstte isteğe bağlı ayırıcı, 64 dp hedefler ve varsayılan iOS 20 dp / diğer platformlarda `viewPadding.bottom` alt sistem boşluğu bulunan alt navigasyondur.

### Kullan

- Mobilde 2–5 birincil bölümü hızlı erişim için.
- Her hedef için `MiuixNavigationBarItem(selected:, onPressed:, icon:, label:)` kullanmak için.
- `mode` ile `iconAndText`, `iconOnly` veya `iconWithSelectedLabel` seçmek için.

### Kullanma

- 2'den az veya 5'ten çok hedef için; constructor assert eder.
- Derin içerik ağacı, form adımları veya sekme değiştirme yerine kullanmayın.
- `defaultWindowInsetsPadding` ile aynı alt sistemi tekrar `SafeArea` ile eklemeyin.

### Önemli durumlar ve varyantlar

- Seçili/seçili değil, basılı ve disabled durumları vardır; etkinlik için `enabled` true ve `onPressed` null değil olmalıdır.
- `badge`, `labelWidget`, `showDivider`, `color`/`colors` desteklenir.
- Seçili etiket animasyonu 300 ms; seçili hedefin tıklanması da tekrar `onPressed` çağırır.

### Erişilebilirlik ve platform

- Her item tek `button` + `selected` semantiği sunar; dekoratif ikon ve metin tekrar okunmaz.
- `iconOnly` modda bile `label` semantiğe aktarılır; yine de görsel hedefi tanınır kılın.

```dart
MiuixNavigationBar(
  children: [
    MiuixNavigationBarItem(
      selected: index == 0,
      onPressed: () => setState(() => index = 0),
      icon: const Icon(Icons.home_outlined),
      label: 'Ana sayfa',
    ),
    MiuixNavigationBarItem(
      selected: index == 1,
      onPressed: () => setState(() => index = 1),
      icon: const Icon(Icons.search),
      label: 'Ara',
    ),
  ],
)
```

## MiuixFloatingNavigationBar

Alt kenardan uzakta, kapsül/squircle arka planlı ve gölgeli 2–5 hedef içeren yüzen navigasyondur. Hedefler `Expanded` değildir; kendi genişliklerinde 12 dp aralıkla dizilir.

### Kullan

- İçerik ekranı tamamen kaplasın, gezinme görsel olarak üzerinde süzülsün istediğinizde.
- `MiuixFloatingNavigationBarItem` ile ikon, erişilebilir label ve badge taşıyan sade birincil gezinme için.

### Kullanma

- İçeriğin en alt satırlarını kalıcı olarak örtmek için; `MiuixScaffold.floatingToolbar`/Stack ile body'ye ek alt boşluk verin.
- Alt kenara yapışık sekmeler beklerken kullanmayın; bunun için `MiuixNavigationBar` vardır.
- Metin etiketli geniş masaüstü menüsü için kullanmayın; bu varyant zorunlu `iconOnly` çalışır.

### Önemli durumlar ve varyantlar

- `cornerRadius` varsayılan 50; `shadowElevation > 0` gölgeyi açar, değeri gölgeyi geometrik olarak büyütmez.
- `horizontalAlignment`, `horizontalOutSidePadding`, `showDivider`, renk ve badge varyantları vardır.
- Varsayılan alt boşluk iOS'ta 36, diğer platformlarda inset yoksa 36, varsa 26 + inset'tir.

### Erişilebilirlik ve platform

- Görünmez label yalnızca erişilebilirlik için korunur; insan kullanıcı için ikonlar yaygın ve tutarlı olmalıdır.
- Yüzen barın altındaki içerik scroll'una erişimi örtmemek için ekran boyutuna göre konumlandırın.

## MiuixNavigationRail

Geniş ekran ve tablette sol/başlangıç kenarında yer alan, isteğe bağlı 80→240 dp genişleyebilen dikey navigasyondur. `header`, divider, kaydırma ve badge destekler.

### Kullan

- Kalıcı birincil hedefleri olan tablet/masaüstü kabuklarında.
- `MiuixNavigationRailState` ile genişletme/daraltma animasyonu ve `MiuixNavigationRailItem` ile hedefler için.
- Yan panel yalnızca birkaç hedefliyse ve ekran genişliği 240 dp'lık açık hâli karşılayabiliyorsa.

### Kullanma

- Dar telefon ekranında alt gezinmenin yerine geçmeyin.
- 10–20 karışık komut için kullanmayın; bu bir komut menüsü değil, birincil hedef rail'idir.
- Çok uzun hiyerarşik liste için kullanmayın; çok sayıda hedefi sidebar/tree view'a taşıyın.
- Etiketleri daraltılmış hâlde tooltip'sız bırakmayın; özellikle farklı ikon anlamlarında görünür açıklama ekleyin.

### Önemli durumlar ve varyantlar

- `state == null`: klasik dar rail, toggle yok. `state != null`: kontrollü genişleyen rail ve toggle.
- Seçili görsel göstergesi genişleyen item düzeninde uygulanır; seçim yine de her zaman `selected` ile kontrollüdür.
- `header`, `colors`, `showDivider`, `scrollController`, genişlik ve item ölçüleri özelleştirilebilir.
- `MiuixNavigationRailState` otomatik süreç içi kayıt yapmaz; kalıcılık uygulamaya aittir.

### Erişilebilirlik ve platform

- Item `label`, `selected`, `enabled`, `button` semantiği sunar. Toggle için `expandContentDescription` / `collapseContentDescription` Türkçeleştirin.
- RTL'de rail başlangıç kenarına geçer; sistem inset'i de başlangıca göre alınır.
- Klavye kullanıcısı için focus sırasını rail'den içeriğe doğal tutun; state'i `dispose` edin.

```dart
final railState = MiuixNavigationRailState(); // initState; dispose'da kapatın
Row(
  children: [
    MiuixNavigationRail(
      state: railState,
      children: [
        MiuixNavigationRailItem(
          selected: index == 0,
          onPressed: () => setState(() => index = 0),
          icon: const Icon(Icons.home_outlined),
          label: 'Ana sayfa',
        ),
      ],
    ),
    const Expanded(child: Placeholder()),
  ],
)
```

## MiuixTabRow

Yatay kaydırılabilir, metin tabloları ve kare içi squircle seçili göstergesi içeren kontrollü sekme çubuğudur. Varsayılan yükseklik 42 dp'tir.

### Kullan

- Aynı içerikteki 2–6 yakın görünümü değiştirmek için.
- Seçili index'i `selectedTabIndex` ile tutup `onTabSelected` ile güncellemek için.
- Dar ekranda `scrollController` veya yerleşim ayarlı çok sekme göstermek için.

### Kullanma

- Tamamen farklı uygulama bölümleri arasında geçiş için kullanmayın.
- Sekme tıklamasını yalnızca highlight değiştirmeyle sınırlamayın; ilişkili içerik de güncellenmelidir.
- Çok uzun tab metinlerini minimum genişliği düşürerek sığdırmayın.

### Önemli durumlar ve varyantlar

- Seçili kalın metin + dolgulu gösterge; seçili değil ince metin + içe çekilmiş kenarlık.
- `colors`, `minWidth`/`maxWidth`, `height`, `cornerRadius`, `itemSpacing`, `contentAlignment` vardır.
- Seçili index çizimde geçerli aralığa clamp edilir; sağlam veri yönetimi uygulamada kalır.
- İçerik taşarsa seçili sekme görünür alana ortalanır; bu davranış `TabBarView` değildir.

### Erişilebilirlik ve platform

- Her sekme `button`, `selected`, `inMutuallyExclusiveGroup` semantiği verir.
- Yatay kaydırma ve seçim için içeriği klavyeyle de erişilebilir kılın; component sekmeler arasında ok tuşu gezinmesi kurmaz.

## MiuixTabRowWithContour

Sekmelerin dışında 5 dp iç padding ve birleşik kontur arka planı bulunan, 45 dp yüksekliğinde bir `MiuixTabRow` varyantıdır.

### Kullan

- Daha hafif, gruplu ve segment benzeri görünüm gerektiğinde.
- Aynı kontrollü `tabs`/`selectedTabIndex`/`onTabSelected` sözleşmesiyle.

### Kullanma

- Alt navigasyon veya sayfa yığını gibi davranışları temsil etmek için kullanmayın.
- Aynı ekranda birbirine çok yakın iki farklı tab bar görünümü birleştirmeyin.

### Önemli durumlar ve varyantlar

- Dış yuvarlak kontur + seçili dolgu; daha küçük varsayılan min/max genişlik ve köşe yarıçapı.
- `MiuixTabRow` ile aynı renk, ölçek, kaydırma ve hizalama parametrelerini destekler.

### Erişilebilirlik ve platform

- Semantik model `MiuixTabRow` ile aynıdır. Kontur tek başına seçim anlamı taşımaz; metin ve semantik seçim korunmalıdır.

```dart
MiuixTabRow(
  tabs: const ['Genel', 'Bildirimler', 'Gizlilik'],
  selectedTabIndex: tabIndex,
  onTabSelected: (i) => setState(() => tabIndex = i),
)
```

## MiuixBreadcrumbBar

Kapsül metin parçalarını chevron ile ayıran, taşınca yatay kaydıran ve seçili/highlight parçayı otomatik ortalanan hiyerarşik gezinmedir. `text: null` ise `path` görünür.

### Kullan

- Dosya yolu, kategori ağacı veya çok seviyeli içerikte kullanıcının konumunu göstermek için.
- `MiuixBreadcrumbItem(path:, text:)` listesi ve `onItemClick` ile gerçek üst düzey hedefe dönmek için.
- `joinToPath()` ile parçaları uygulamanın route/path anahtarına dönüştürmek için.

### Kullanma

- 2–3 düzeyden sığ basit mobil akışlarda gereksiz tekrar yaratmayın.
- 20 derinliklik patika gibi uzun metin zincirini tek satırda okunur menü gibi kullanmayın.
- Sıradan alt/sekme navigasyonun yerine geçmeyin; breadcrumb hiyerarşik geri dönüştür.

### Önemli durumlar ve varyantlar

- `highlightIndex: null` son öğeyi, negatif değer hiçbir öğeyi highlight etmez.
- `enabled: false` tüm parçaları disabled gösterir ve tıklamayı durdurur.
- `insideMargin`, `itemMaxWidth`, `colors`, `scrollController` desteklenir.
- Son öğe de tıklanabilir; tıklama davranışı tamamen `onItemClick` ile uygulamaya aittir.

### Erişilebilirlik ve platform

- Her parça `button` ve `enabled` semantiği alır; chevron dekoratiftir ve RTL'de çevrilir.
- Breadcrumb'ın kendisi otomatik back-stack işlemi yapmaz; “Ana sayfa” tıklaması açık bir root/route hedefine gitmelidir.

```dart
MiuixBreadcrumbBar(
  items: const [
    MiuixBreadcrumbItem(path: 'files', text: 'Dosyalar'),
    MiuixBreadcrumbItem(path: 'reports', text: 'Raporlar'),
    MiuixBreadcrumbItem(path: 'annual', text: 'Yıllık'),
  ],
  onItemClick: (i) => openBreadcrumbRoute(i),
)
```

## Kaynak eşlemesi

- `/home/ayzen/Masaüstü/Projeler/miuix_test_app/packages/flutter_miuix/lib/src/theme/miuix/components/miuix_scaffold.dart`
- `/home/ayzen/Masaüstü/Projeler/miuix_test_app/packages/flutter_miuix/lib/src/theme/miuix/components/miuix_top_app_bar.dart`
- `/home/ayzen/Masaüstü/Projeler/miuix_test_app/packages/flutter_miuix/lib/src/theme/miuix/components/miuix_navigation_bar.dart`
- `/home/ayzen/Masaüstü/Projeler/miuix_test_app/packages/flutter_miuix/lib/src/theme/miuix/components/miuix_navigation_rail.dart`
- `/home/ayzen/Masaüstü/Projeler/miuix_test_app/packages/flutter_miuix/lib/src/theme/miuix/components/miuix_tab_row.dart`
- `/home/ayzen/Masaüstü/Projeler/miuix_test_app/packages/flutter_miuix/lib/src/theme/miuix/components/miuix_breadcrumb_bar.dart`
- `/home/ayzen/Masaüstü/Projeler/miuix_test_app/lib/showcase/navigation.dart`
- `/home/ayzen/Masaüstü/Projeler/miuix_test_app/lib/showcase/common.dart`
