# Tercih ve Ayar Satırları

Bu bölüm `flutter_miuix` **1.4.0** kaynak kodu, `menus.dart` ve `preferences.dart` showcase'larıyla doğrulanmıştır. Bileşenler `package:flutter_miuix/miuix.dart` üzerinden dışa aktarılır.

## Tercih sayfası düzeni

- İlgili satırları `MiuixCard` içinde `Column` ile grupla; satırlar arasına `MiuixHorizontalDivider` koy. Her satırı ayrı kart yapma.
- Grupların üstüne `MiuixSmallTitle` yerleştir. Kartın iç satırları genellikle `EdgeInsets.symmetric(horizontal: 16, vertical: 14)` kullanır.
- Satırın merkezinde kısa başlık ve gerekirse durum özeti; başlangıçta ikon, sonda değer/kontrol/chevron bulunur.
- Tercih satırı, içerik kartı değildir. Kullanıcının değiştirdiği ayarı, gezinmek istediği ekranı veya seçtiği değeri açıkça ayır.
- Yıkıcı işlemi doğrudan bir preference satırına bağlama. Satırı açıklamalı bir onay ekranına yönlendir; kalıcı silme gibi eylemlerde onay ve mümkünse geri alma sun.
- Pakette preference başına `loading`, `error`, `busy` veya otomatik async durumu yoktur. İşlem sürerken `enabled: false` kullan ve gerekiyorsa durum metni göster; callback tipi zorunluysa disabled satırda no-op callback ver.
- Görsel satır minimum 56 dp'dir; switch gibi 28 dp görsel kontroller satırın tamamıyla birlikte geniş hedef sağlar.
- Mobilde tek sütun ve kısa değerler; masaüstünde okunabilir genişlik, hover/focus ve klavye sırası. Overlay tercihleri Scaffold kapsamındadır; farklı pencere/kök katmanı gerektiğinde aynı API ailesindeki `MiuixWindowDropdownPreference` / `MiuixWindowSpinnerPreference` varyantlarını değerlendir.

## MiuixArrowPreference

Başlık/özet ve isteğe bağlı başlangıç/bitiş içeriklerinin yanına RTL'de aynalanan sağ chevron ekleyen, başka bir ekrana veya ayrıntı ekranına giden gezinme satırı.

### Kullan

- Hesap, güvenlik, genel ayarlar gibi alt ekrana geçişler için.
- Sonda mevcut değeri veya kısa durum özeti göstermek gerektiğinde.
- `endActions` ile rozet, metin veya küçük bir durum göstergesi eklemek için.

### Kullanma

- Switch, checkbox veya radio ile yapılabilir doğrudan ayar değişimi için.
- Yalnızca bir eylemi tetikleyen buton yerine; eğer sayfada kalınıyorsa düğme daha doğru olabilir.
- Silme/kalıcı işlemi açıklamasız chevron ile yönlendirmek için.
- `onClick: null` satırını tıklanabilir göstermek için.

### Önemli durumlar ve varyantlar

- `title` zorunludur; `summary`, `startAction`, `endActions`, `bottomAction` isteğe bağlıdır.
- `onClick == null` veya `enabled: false` etkileşimsiz yapar; chevron disabled rengine geçer.
- `holdDownState` açık bir alt ekran/popup sırasında basılı görünümü korur.
- Chevron 10×16 dp'dir; ek `endActions` chevron'dan önce ve 8 dp boşlukla yerleşir.

### Erişilebilirlik ve platform

- Alt `MiuixBasicComponent` tıklama semantiği sağlar; `MiuixArrowPreference` kendi `onClickLabel` parametresine sahip değildir, gerekirse dış `Semantics(label: ...)` ile eylem adını açıkla.
- “Ayarlar” gibi başlık, hedef ekranı belirtmiyorsa özet veya semantik etiket hedefi tamamlamalıdır.
- Masaüstünde satır genişliğini sınırla ve hover/focus görünürlüğünü doğrula; mobilde 56 dp satır hedefi korunmalıdır.

```dart
MiuixArrowPreference(
  title: 'Hesap ve güvenlik',
  summary: 'Parola, iki adımlı doğrulama',
  onClick: openAccountSettings,
)
```

## MiuixSwitchPreference

Sonda `MiuixSwitch` bulunan ve switch'e veya satırın tamamına tıklandığında `value` değerini tersine çeviren binary tercih satırı.

### Kullan

- Wi-Fi, Bluetooth, bildirimler gibi anlık aç/kapat ayarları için.
- Başlık ve açıklamalı bir satırın tamamı kontrol olarak çalışması gerektiğinde.

### Kullanma

- Seçim yapıldıktan sonra ayrı bir “Kaydet” gerektiren işlemler için.
- Ağ başarısından bağımsız olarak ayarın tamamlandığını varsaymak için.
- İçindeki switch'i ayrıca başka bir callback'e bağlayıp iki farklı durum yönetimi oluşturmak için.

### Önemli durumlar ve varyantlar

- `value`, `onChanged`, `title` zorunludur; `onChanged` nullable değildir.
- `enabled: false` satır ve switch'i birlikte devre dışı bırakır; disabled satırda da `onChanged` verilmelidir.
- `switchColors`, `summary`, `startAction`, `endActions`, `bottomAction`, `holdDownState` desteklenir.
- Satır tıklaması `onChanged(!value)` çağırır; switch kendi tıklama/sürükleme davranışını korur.

### Erişilebilirlik ve platform

- İç switch `toggled` semantiği verir; satır da `MiuixBasicComponentRole.switchControl` ile rol kazanır. Çift semantik düğümün aynı kontrolü iki kez duyurmadığını test et.
- Satır rolündeki `checked` bilgisi gerçek `value`yi dinamik yansıtmaz; önemli ekran okuyucu testlerinde `Semantics(toggled: value)` ile açık durum eklemeyi düşün.
- Mobilde satırın tamamı hedeftir; masaüstünde odak sırasında açık/kapalı metnini de görünür tut.

```dart
MiuixSwitchPreference(
  title: 'Bildirimler',
  summary: enabled ? 'Etkin' : 'Devre dışı',
  value: enabled,
  onChanged: (value) => setState(() => enabled = value),
)
```

## MiuixCheckboxPreference

Başlangıçta veya sonda `MiuixCheckbox` bulunan; satır tıklaması `value`yi tersine çeviren ve iki konum seçeneği sunan onay tercihi.

### Kullan

- Bildirim türleri, izinler veya birden çok bağımsız seçenek gibi çoklu seçimler için.
- Uzun bir açıklamalı onay ifadesiyle birlikte kullanmak için.
- `checkboxLocation` ile listenin mevcut kontrol tarafına uyum sağlamak için.

### Kullanma

- Yalnızca tek seçenek seçilebilen gruplarda; radio tercih et.
- Üç durumlu grup göstergesi için; bu preference `value` tipi `bool`dur, `null` kabul etmez.
- Bir tercihi zorunlu kılmak için görsel olarak işaretli disabled satır göstermek yerine anlaşılır bir doğrulama mesajı kullanmak için.

### Önemli durumlar ve varyantlar

- `MiuixCheckboxLocation.start` varsayılan, `end` alternatiftir.
- `value` `bool`; `onChanged` nullable'dır ve null ise satır ile checkbox etkileşimsiz olur.
- `enabled: false` ayrıca disabled renkleri seçer.
- `checkboxColors`, `startAction`, `endActions`, `bottomAction`, `holdDownState` vardır.

### Erişilebilirlik ve platform

- İç checkbox yalnızca button semantiği verir; satır `checkbox` rolü taşır. Gerçek `checked: value` durumunu ekran okuyucu testinde açıkça doğrula.
- Etiket ile kontrolün aynı eylemi bir kez duyurması için semantik ağacı incele.
- Mobilde başlangıç checkbox'u 26 dp görsel boyutundadır ama satır hedefi 56 dp'dir; uzun etiketlerde satır kırpma yerine yüksekliğin büyümesine izin ver.

```dart
MiuixCheckboxPreference(
  title: 'Mesaj bildirimleri',
  summary: enabled ? 'Etkin' : 'Devre dışı',
  value: enabled,
  onChanged: (value) => setState(() => enabled = value),
)
```

## MiuixRadioButtonPreference

Başlangıçta veya sonda radio işareti bulunan; seçildiğinde başlık ve özeti primary renge çeviren tek seçim tercih satırı.

### Kullan

- Tema, dil veya görünüm gibi birbirini dışlayan birkaç seçenek için.
- Aynı gruptaki satırların ortak bir selected indeksle yönetildiği ayar ekranları için.

### Kullanma

- Bağımsız onay kutuları için.
- Seçim dışına çıkılamayan zorunlu alanda kullanıcıya geri dönüş yolu göstermeden.
- Her satırı farklı callback ile bağımsız seçilebilir gibi sunmak için.

### Önemli durumlar ve varyantlar

- `title` ve `selected` zorunludur; `onClick` isteğe bağlıdır.
- `MiuixRadioButtonLocation.start` varsayılan, `end` alternatiftir.
- Seçili satırın başlık/özeti `primary`; disabled durumda disabled renk kazanır.
- Radio ve satır aynı `_tap` çağrısını kullanır; `selectionClick` haptic üretir.
- `colors`, `radioButtonColors`, `startAction`, `endActions`, `bottomAction`, `holdDownState` desteklenir.

### Erişilebilirlik ve platform

- Satır `radioButton` rolü taşır ve iç radio button semantiği verir; grup üyeliği ve seçili indeks dışarıdan açık olmalıdır.
- Tek seçim grubunu `Semantics(inMutuallyExclusiveGroup: true)` ile adlandır; masaüstünde ok tuşlarıyla gezinme isteniyorsa ek klavye davranışı gerekir.
- Seçili durumu yalnızca primary renkle bırakma; çizgi işareti ve kısa “Seçili” özetiyle destekle.

```dart
for (final option in themeOptions.indexed)
  MiuixRadioButtonPreference(
    title: 'Tema: ${option.$2}',
    selected: selectedTheme == option.$1,
    onClick: () => setState(() => selectedTheme = option.$1),
  )
```

## MiuixSliderPreference

Başlık/özetin altında yatay `MiuixSlider`; sonda isteğe bağlı `valueText` ve `onClick` verildiğinde chevron gösteren ayarlı ölçüm satırı.

### Kullan

- Parlaklık veya yazı tipi ölçeği gibi tek değerli ayarlar için.
- `valueText` ile anlamlı güncel değeri göstermek için.
- `steps`, `showKeyPoints`, `keyPoints` ve `magnetThreshold` ile ölçeği kavramsal olarak netleştirmek için.

### Kullanma

- Kesin sayı/metin girişinin yerine geçmek için.
- `onClick` verilip satırın başka bir ekran açtığını kullanıcıya açık göstermemek için; chevron varsa hedef anlaşılmalıdır.
- Slider'ın üzerine başka tıklanabilir kontrol koyup hareket alanını bölmek için.

### Önemli durumlar ve varyantlar

- `value`, `onValueChange`, `min`, `max`, `steps`, `sliderHeight`, `sliderColors`, `hapticEffect` vardır.
- `onValueChange` nullable değildir; disabled satırda bile no-op callback sağla.
- `enabled: false` hem satırı hem slider'ı devre dışı bırakır.
- `valueText` body2 ölçeğinde ve `onSurfaceVariantActions` renginde gösterilir.
- `onClick` varsa chevron ve satır tıklaması eklenir; `onClick` yoksa alt slider yine etkileşimlidir.

### Erişilebilirlik ve platform

- `MiuixSlider` kendi başına semantik/klavye değer kontrolü sunmaz; `Semantics(value: ..., onIncrease: ..., onDecrease: ...)` ekle.
- `valueText` görsel durumu destekler ama semantik bağlantıyı tek başına garanti etmez.
- Mobilde değer metninin uzun Türkçe biçimde taşmadığını; masaüstünde slider'a focus ve ok tuşları erişimi olmadığını test et.

```dart
MiuixSliderPreference(
  title: 'Parlaklık',
  valueText: '${(brightness * 100).round()}%',
  value: brightness,
  min: 0.2,
  max: 1.0,
  steps: 7,
  onValueChange: (value) => setState(() => brightness = value),
)
```

## MiuixRangeSliderPreference

Alt alanda `MiuixRangeSlider`; iki ucu `(double, double)` record'uyla bildiren ve sonda isteğe bağlı değer/chevron gösteren çift sınırlı ayar satırı.

### Kullan

- Fiyat, zaman aralığı veya iki sınır gerektiren filtre ayarları için.
- Başlangıç ve bitiş değerinin aynı ölçekte birlikte görünmesi gerektiğinde.

### Kullanma

- Tek merkez değer veya bağımsız iki ayar için.
- Kullanıcının iki ucu ayırt edemediği çok dar alanda; sayı alanları ekle.
- Sadece renkli aralık gösterip başlangıç/bitiş değerlerini metinsiz bırakmak için.

### Önemli durumlar ve varyantlar

- `startValue`, `endValue`, `onValueChange` zorunludur; callback `(start, end)` alır.
- `min`, `max`, `steps`, `sliderHeight`, `sliderColors`, `hapticEffect`, `keyPoints`, `magnetThreshold` vardır.
- `onValueChange` nullable değildir; disabled durumda no-op callback ver.
- `valueText` varsa tek metin alanında iki değeri anlaşılır biçimlendir; çoklu satır uzun değerde taşabilir.
- `onClick` varsa chevron eklenir; `enabled: false` slider ve satırı birlikte kapatır.

### Erişilebilirlik ve platform

- İki uç için ayrı semantik ad ve değer gerekir; kaynakta klavye/slider semantiği yoktur.
- `startValue <= endValue` düzenini uygulamada koru ve ekran okuyucuya iki sınırı da duyur.
- Mobilde uç thumb'ların birbirine yaklaşması, masaüstünde focus ve ince ayar için alternatif sayı girişi önemlidir.

```dart
MiuixRangeSliderPreference(
  title: 'Fiyat aralığı',
  valueText: '${priceStart.round()} - ${priceEnd.round()}',
  startValue: priceStart,
  endValue: priceEnd,
  min: 0,
  max: 1000,
  steps: 9,
  showKeyPoints: true,
  onValueChange: (range) => setState(() {
    priceStart = range.$1;
    priceEnd = range.$2;
  }),
)
```

## MiuixOverlayDropdownPreference

Tıklanınca Scaffold/overlay kapsamında açılan seçim listesi gösteren; sonda seçili değer metni ve aşağı chevron bulunan tek seçim tercihi.

### Kullan

- Birkaç metin seçeneği arasından tek değer seçmek için.
- `items` + `selectedIndex` ile basit bir liste kurmak için.
- `.entry` veya `.entries` ile `MiuixDropdownItem` icon/summary/disabled seçeneklerini korumak için.
- Uzun listede `maxHeight` ile popup yüksekliğini sınırlamak için.

### Kullanma

- Çok sayıda ikon ve açıklama içeren zengin seçenekler için; `MiuixOverlaySpinnerPreference` daha uygundur.
- `items` boşken satırı etkin görünmesini beklemek için; boş liste pratikte devre dışı olur.
- `.entries` kullanırken seçim durumunu yalnızca `MiuixDropdownItem.selected` alanına bırakıp uygulama state'ini güncellememek için.
- Popup açıkken satırın başka bir işlemi de tetiklemesine izin vermek için.

### Önemli durumlar ve varyantlar

- Ana constructor: `items: List<String>`, `selectedIndex`, `onSelectedIndexChange`.
- `.entry`: tek `MiuixDropdownEntry`; `.entries`: çok gruplu liste ve öğe başına callback.
- `showValue: false` seçili metni gizler; `renderInRootScaffold` overlay kökünü seçer.
- `collapseOnSelection == null` ise tek grup seçimde kapanır, çok gruplu listede varsayılan olarak açık kalır.
- Çoklu selected item metinleri newline ile birleştirilir; tek seçim tercih ediyorsan modele göre yalnızca birini seçili tut.
- `enabled: false` veya boş efektif liste etkileşimsiz yapar; `onExpandedChange` açılma/kapanmayı bildirir.

### Erişilebilirlik ve platform

- Satır `MiuixBasicComponentRole.dropdownList` rolü ve tıklama semantiği alır; seçili değer/expanded durumunu erişilebilir olarak test et.
- Klavye ile popup açma, seçenekler arasında gezinme ve Escape ile kapatma davranışını ayrıca doğrula.
- Mobilde overlay satırın dibinde ekran dışına taşmamalı; masaüstünde popup'ın pencere sınırları içinde kalması ve farklı kök Scaffold gereksinimi değerlendirilmelidir.

```dart
MiuixOverlayDropdownPreference(
  title: 'Tema',
  items: const ['Sistemi izle', 'Açık', 'Koyu'],
  selectedIndex: themeIndex,
  onSelectedIndexChange: (index) => setState(() => themeIndex = index),
)
```

## MiuixOverlaySpinnerPreference

`MiuixDropdownItem` listesini icon, özet, disabled ve seçim bilgileriyle koruyan; `dialogButtonString` verilirse dialog, verilmezse overlay popup açan zengin seçim tercihi.

### Kullan

- Seçeneklerin önünde icon ve altında açıklama bulunan ayarlar için.
- Çok seçenekli bir tercihi onay düğmeli dialog ile seçtirmek için.
- `.entry` / `.entries` ile gruplu zengin seçenekler sunmak için.

### Kullanma

- Düz metin listesi için; `MiuixOverlayDropdownPreference` daha hafiftir.
- Kısa, anında uygulanan seçimlerde gereksiz modal dialog açmak için.
- Seçeneklerde aynı anda birden çok seçim beklerken; bu bileşen seçim listesidir, çoklu seçim kontrolü değildir.
- `dialogButtonString: ''` gibi anlamsız bir onay etiketi vermek için.

### Önemli durumlar ve varyantlar

- Ana constructor `items: List<MiuixDropdownItem>`, `selectedIndex`, `onSelectedIndexChange` ister.
- `dialogButtonString != null` ise `MiuixOverlayDropdownDialog`; `null` ise `MiuixOverlayDropdownPopup` kullanılır.
- Öğelerin kendi `onClick` callback'leri korunur ve `onSelectedIndexChange` ile birlikte çağrılır; çift state değişimine dikkat et.
- `spinnerColors`, `maxHeight`, `showValue`, `renderInRootScaffold`, `onExpandedChange` vardır.
- `collapseOnSelection == null` ise tek grup popup seçimde kapanır; çok grup varsayılanı açık kalmasıdır.
- Boş liste veya `enabled: false` etkileşimsiz yapar; seçili item metinleri sonda gösterilir.

### Erişilebilirlik ve platform

- Satır dropdown role ve tıklama semantiği alır; seçili item metninin uzun icon/summary listesinde kırpılmadığını test et.
- Dialog modunda başlık, seçenekler ve onay düğmesi klavyeyle erişilebilir olmalı; popup modunda Escape/dismiss sonrası odakın tetikleyiciye dönmesi kontrol edilmeli.
- Mobilde uzun listeyi `maxHeight` ve kaydırma ile yönet; masaüstünde overlay yerine window varyantı farklı pencere köklerinde daha uygun olabilir.

```dart
MiuixOverlaySpinnerPreference(
  title: 'Yazı boyutu',
  items: const [
    MiuixDropdownItem(text: 'Küçük', summary: 'Daha kompakt'),
    MiuixDropdownItem(text: 'Orta', summary: 'Varsayılan'),
    MiuixDropdownItem(text: 'Büyük', summary: 'Daha okunaklı'),
  ],
  selectedIndex: fontSizeIndex,
  onSelectedIndexChange: (index) => setState(() => fontSizeIndex = index),
)
```
