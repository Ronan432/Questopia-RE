# Menüler ve Seçiciler — flutter_miuix 1.4.0

Bu referans, yerel `flutter_miuix` kaynak koduna ve `lib/showcase/menus.dart` ile `lib/showcase/pickers.dart` dosyalarına karşı doğrulanmıştır. Örnekler `package:flutter/material.dart` ve `package:flutter_miuix/miuix.dart` içe aktarır. Değerler çoğunlukla **kontrollüdür**: kullanıcı etkileşiminden sonra üst widget'ın `setState` ile ilgili değeri güncellemesi gerekir.

## Menü, spinner veya tercih satırı mı?

| İhtiyaç | Doğru seçim | Neden |
|---|---|---|
| Satırdaki bağlamsal eylemler | `MiuixOverlayDropdownMenu` | Başlıklı satır + kısa eylem listesi |
| Yalnızca simge tetikleyen eylemler | `MiuixOverlayIconDropdownMenu` | Kompakt araç çubuğu/satır sonu aksiyonu |
| Bir alt düzey taşıyan eylemler | `MiuixOverlayIconCascadingDropdownMenu` | Ana liste ve tek alt liste; yalnızca iki seviye |
| Ayar satırında metin seçimi | `MiuixDropdownPreference` | `List<String>`, `selectedIndex`, görünen seçili değer |
| Simge/özetli seçenekli ayar | `MiuixOverlaySpinnerPreference` | `MiuixDropdownItem` öğeleri; isteğe bağlı dialog |
| Ayrık sayı, saat veya kademe | `MiuixNumberPicker` | Dikey çark; metin girişi değildir |
| Takvimden tek tarih | `MiuixDatePicker` | Ay ızgarası ve tarih aralığı |

**Overlay / Window:** Overlay varyantı `MiuixScaffold` bağlamında çalışır; `renderInRootScaffold` varsayılan `true` iken kök scaffold Overlay'ine yerleşir. Window varyantı da Flutter'da root Overlay kullanır; ayrı bir işletim sistemi penceresi açmaz. Masaüstü/çoklu scaffold durumunda `MiuixWindow...` varyantını, normal mobil sayfa akışında Overlay varyantını tercih et.

## Menülerde ortak davranış

- `MiuixDropdownItem`: `text`, `enabled`, `selected`, `onClick`, `icon`, `summary`, `children`.
- `MiuixDropdownEntry`: `items` ve grup düzeyinde `enabled`. Boş gruplar menü tarafından elenir; grup başlığı gösterilmez.
- Satır tetikleyicileri Enter/Space ile aktive olabilir; hover ve focus görsel geri bildirimi vardır. Menü açıldığında tetikleyici `holdDownState` görünümünü korur ve seçim titreşimi verir.
- `collapseOnSelection`: seçim sonrası kapatmayı belirler. Menülerde `null` ise tek grup kapanır, çok grup açık kalır; icon varyantlarının varsayılanı `true` tercih edilir.
- Dışarı dokunma kapatır. İç içe popup açmak yerine tek menü akışı kur; kapanış animasyonundan sonra dış FocusNode/controller temizliği yap.
- **Uzun liste:** Popup içeriği `SingleChildScrollView` + iç içe `Column` kullanır; tembel/lazy liste değildir. Çok büyük listelerde arama/dialog/search akışı veya daha uygun veri seçimi kullan. `maxHeight` taşmayı sınırlar, öğe sayısını optimize etmez. Dialog modunda büyük ekranda liste kaydırılır; küçük ekranda içsel yükseklik kullanılır.
- **Klavye eksikliği:** Menü satırları `GestureDetector` + `Semantics` ile çizilir; ok tuşları, Escape, roving focus veya ilk öğeye otomatik odak için built-in yönlendirme yoktur. Klavye öncelikli üründe bunları dış `Focus`/`Shortcuts`/`Actions` ile tamamla; yalnızca tetikleyicinin Enter/Space desteğini menü navigasyonu sanma.
- **Yok edici eylemler:** `MiuixDropdownItem` için `destructive` veya öğe bazlı error rengi yoktur. `text: 'Sil'` tek başına görsel uyarı değildir; `dropdownColors` tüm menüyü etkiler. Silmeden önce onay/geri al sun, gerçekten kaldırılmadan önce başarı bildir.

## MiuixOverlayDropdownMenu

**Tanım ve anatomi:** Başlıklı `MiuixBasicComponent` satırı; isteğe bağlı `summary`, `startAction`, `bottomAction`, sağda yukarı/aşağı ok ve anchora göre hizalı popup. Tek grup için `entry`, çok grup için `.entries` kurucusu vardır. Gruplar arasında ince ayırıcı bulunur; satırlarda simge, başlık/özet ve seçiliyse çek işareti görünür.

**Kullan:** Ayar veya içerik satırında “Düzenle / Kopyala / Sil” gibi kısa eylemler için; seçili bir değer satırda gösterilmiyorsa. Çok gruplu işlemlerde `.entries` ve açık kalma davranışını bilinçli ayarla.

**Kullanma:** Seçili değer tercih satırı gerektiriyorsa `MiuixDropdownPreference` kullan. Alt menü, uzun form, arama gerektiren liste veya kritik onay için kullanma. Menüyü yalnızca görsel seçim göstergesi olarak kullanıp `selected`/`onClick` yönetimini atlama.

**Durumlar / varyantlar:** `enabled = false` veya boş `entries` satırı devre dışı bırakır; öğe ve grup ayrı devre dışı olabilir. `selected`, pressed/hover/focus, expanded ve `onExpandedChange` durumları vardır. `maxHeight`, `dropdownColors`, `insideMargin`, `renderInRootScaffold` özelleştirilebilir.

**Erişilebilirlik / platform:** Satır `dropdownList` rolünde buton semantiğine sahiptir; öğeler seçim ve mutually-exclusive-group semantiği verir. Menü içi klavye navigasyonu eksiktir. Mobilde yatay taşmayı, masaüstünde hover/focus ve popup konumunu doğrula.

```dart
MiuixOverlayDropdownMenu(
  title: 'Belge işlemleri',
  entry: MiuixDropdownEntry(items: [
    MiuixDropdownItem(text: 'Yeniden adlandır', onClick: rename),
    MiuixDropdownItem(text: 'Kopyala', onClick: copy),
    MiuixDropdownItem(text: 'Sil', onClick: confirmDelete),
  ]),
  maxHeight: 280,
)
```

## MiuixOverlayIconDropdownMenu

**Tanım ve anatomi:** Yalnızca `child` içindeki simgeyi tetirleyen kompakt ikon buton ve anchora bağlı açılır liste. Başlık/summary satırı kendi içine almaz; `MiuixBasicComponent.endActions` veya araç çubuğu içine yerleştirilir. Tek grup `entry`, çok grup `.entries`.

**Kullan:** Satır sonu “more”, paylaş veya düzenle menüsü için; metin başlığı zaten görünürken ek bir satır gerektirmiyorsa.

**Kullanma:** Tek bir eylem varsa doğrudan `MiuixIconButton` kullan. Birden çok belirsiz ikon menüsü veya seçili tercih değeri göstermek için kullanma.

**Durumlar / varyantlar:** `enabled`, boş liste, açık/kapalı, basılı tutma, seçili/disabled öğe ve `onExpandedChange`. `backgroundColor`, `cornerRadius`, `minHeight`, `minWidth`, `maxHeight`, `dropdownColors` vardır. Varsayılan ikon hedefi 40×40'tır; mobilde dokunma alanını en az 48 dp olacak şekilde dışarıdan genişlet.

**Erişilebilirlik / platform:** `MiuixIconButton` içeriği kendi başına anlamlı etiket sağlamayabilir. Bir `Tooltip` ve `Semantics(label: 'Belge işlemleri')` ekle; ikonun yalnızca görsel anlamına bırakma. Enter/Space tetikleyiciyi çalıştırır, menü satırlarında ok gezinmesi yoktur. Masaüstünde hover/focus, mobilde yan ekran kenarında popup taşmasını test et.

```dart
Semantics(
  label: 'Belge işlemleri',
  child: Tooltip(
    message: 'Belge işlemleri',
    child: MiuixOverlayIconDropdownMenu(
      entry: MiuixDropdownEntry(items: [
        MiuixDropdownItem(text: 'Paylaş', onClick: share),
      ]),
      child: const Icon(Icons.more_horiz),
    ),
  ),
)
```

## MiuixOverlayIconCascadingDropdownMenu

**Tanım ve anatomi:** İkon tetikleyicili iki seviyeli menü. `MiuixDropdownItem.children` boş değilse satır sağ oklu alt menü tetirleyicisine dönüşür; alt listede tetirleyici başlık geri dönüş satırı olarak görünür. Ana liste yerine alt liste fade/scale geçişiyle gösterilir; yan yana büyük bir alt menü değildir.

**Kullan:** “Paylaş → E-posta / Bağlantı / WeChat” gibi kısa, tek alt düzeyli iş akışı için.

**Kullanma:** Üçüncü seviye, derin navigasyon, çok sayıda alt öğe veya bağımsız sayfalar için kullanma. Kaynak kodundaki derinlik sınırı iki seviyedir; `children` içindeki alt öğelerin kendi `children`ı normal seçim gibi ele alınır, üçüncü menü açılmaz. Aynı işi tek listede anlatabiliyorsan basit menüyü tercih et.

**Durumlar / varyantlar:** Ana/alt liste, geri dönüş, açık/kapalı, pressed/hover/focus, seçili ve disabled öğeler. `collapseOnSelection` varsayılan `true`; `surfaceBuilder`, `maxHeight`, `dropdownColors` ve ikon buton görünümü ayarlanabilir. Devre dışı gruplar ana listeden elenir.

**Erişilebilirlik / platform:** Alt menü tetirleyicisi buton semantiği ve sağ ok alır; yok edici eylem ve klavye navigasyonu menüdeki ortak sınırları paylaşır. Alt listeye geçiş/geri dönüş odak davranışını ayrı test et. Dar mobil ekranda uzun alt listelerde kaydırma ve ekran kenarı sınırlarını kontrol et; masaüstünde hızlı hover erişimini koru.

```dart
MiuixOverlayIconCascadingDropdownMenu(
  entry: MiuixDropdownEntry(items: [
    MiuixDropdownItem(text: 'Yeni', onClick: create),
    MiuixDropdownItem(
      text: 'Paylaş',
      children: [
        MiuixDropdownItem(text: 'E-posta', onClick: shareByEmail),
        MiuixDropdownItem(text: 'Bağlantıyı kopyala', onClick: copyLink),
      ],
    ),
  ]),
  child: const Icon(Icons.more_horiz),
)
```

## MiuixOverlaySpinnerPreference

**Tanım ve anatomi:** Tercih satırında başlık, isteğe bağlı özet ve başlangıç/bitiş aksiyonları; sağda seçili değer metni, yukarı/aşağı ok ve popup veya dialog. `items + selectedIndex` kısa yolunda seçim üst widget tarafından yönetilir. `.entry` ve `.entries` gruplu kurucuları doğrudan `selected` ve `onClick` kullanır.

**Kullan:** Renk, kalite, hesap veya hız gibi simge/özet taşıyan seçeneklerde. Uzun veya dikkat gerektiren listede `dialogButtonString` vererek onaylı dialog moduna geç.

**Kullanma:** Düz metin seçenekleri ve basit ayar için `MiuixDropdownPreference` daha yalın olabilir. Sürekli sayı ayarı için slider, hassas ayrık değer için `MiuixNumberPicker` kullan. “Spinner” burada Android `Spinner` görünümü veya metin girişi değildir.

**Durumlar / varyantlar:** `enabled = false`, boş liste, `showValue = false`, tek/çok grup, popup/dialog, seçili/disabled öğe ve `onExpandedChange`. `dialogButtonString` null değilse dialog kullanılır; dialog butonu yalnızca kapatır, ayrı bir “commit” callback'i yoktur. `maxHeight` yalnızca popup moduna aktarılır.

**Erişilebilirlik / platform:** Tercih satırı buton/dropdown semantiğine sahiptir; uzun seçili değer ellipsis olur. Dialog kapatma düğmesi Türkçe etiket ister. Mobilde liste uzunluğuna göre popup/dialog seç; masaüstünde pencere seviyesi davranışı istiyorsan `MiuixWindowSpinnerPreference` kullan. Menü ok tuşu navigasyonu yoktur.

```dart
MiuixOverlaySpinnerPreference(
  title: 'Renk',
  items: const [
    MiuixDropdownItem(text: 'Mavi', summary: 'Önerilen'),
    MiuixDropdownItem(text: 'Yeşil', summary: 'Yüksek kontrast'),
  ],
  selectedIndex: selectedColorIndex,
  onSelectedIndexChange: (i) => setState(() => selectedColorIndex = i),
)
```

## MiuixDropdownPreference ile farklar

`MiuixDropdownPreference` metin tercihidir: varsayılan kurucu `items` olarak `List<String>`, `selectedIndex` ve `onSelectedIndexChange` ister. `.entry` / `.entries` ile zengin `MiuixDropdownItem` sunulabilir; seçili metinler satırda birleştirilir. `dialogButtonString` parametresi yoktur.

`MiuixOverlaySpinnerPreference` ise zengin öğeleri korur (`icon`, `summary`, `enabled`, özgün `onClick`), `spinnerColors` kullanır ve `dialogButtonString` ile dialog moduna geçer. Kısa yolta seçim sonrası hem `onSelectedIndexChange(index)` hem özgün öğenin `onClick`ı çağrılır; aynı yan etkisi iki yere yazma. Her ikisinde de `selectedIndex` geçerli aralıkta tutulmalıdır.

```dart
MiuixOverlayDropdownPreference(
  title: 'Görünüm',
  items: const ['Sistem', 'Açık', 'Koyu'],
  selectedIndex: themeIndex,
  onSelectedIndexChange: (i) => setState(() => themeIndex = i),
)
```

## MiuixNumberPicker

**Tanım ve anatomi:** Dikey kaydırılan sayı/liste çarkı. Merteki belirgin, uzaktaki öğeler soluklaşıp küçülür; bırakınca en yakın öğeye spring ile snap olur. `value`, `min`, `max`, `label`, `itemHeight`, `visibleItemCount` ve `wrapAround` belirler. Varsayılanlar: 0–10, 5 görünür öğe, çevrim yok.

**Kullan:** Saat/dakika, adet, gün veya kısa kademeli ayar için; seçenek sayısı sınırlı ve kullanıcı yukarı/aşağı kaydırmayı bekliyorsa.

**Kullanma:** Serbest sayı girişi, IME ile yazma, büyük veya bilinmeyen aralık, çok uzun etiketler veya doğrudan dokunarak kesin değer seçimi için kullanma. `min == max` gibi tek değerli durumda ayrı bir seçici gereksizdir.

**Durumlar / varyantlar:** `enabled` ve null `onValueChanged` etkileşimi kapatır; disabled renkleri kullanılır. `wrapAround = true` uçtan uca döner; false'da sınırda durur. `visibleItemCount` tek ve en az 3 olmalıdır; `min <= max` olmalıdır. `label` örneğin iki haneli saati biçimler. `onValueChanged` yalnızca kaydırma bırakıldıktan sonra, değer değiştiyse çağrılır.

**Erişilebilirlik / platform:** Yerleşim `GestureDetector` + `Text` kullanır; Semantics değeri, FocusNode, ok/Page Up/Down kısayolları ve metin girişi yoktur. `label` yalnızca görsel metindir. Klavye/ekran okuyucu için dış kontroller ve anlamlı `Semantics(value:)` ekle. Çark yalnızca görünür öğeleri çizer; ancak yüzlerce öğede kullanıcı hâlâ uzun kaydırır. Dar ekranda çok sütunlu saatte `textStyle` küçültülebilir; showcase'ın `title3` örneği uzun yıl etiketlerini korur.

```dart
SizedBox(
  height: 180,
  child: MiuixNumberPicker(
    value: hour,
    min: 0,
    max: 23,
    wrapAround: true,
    label: (v) => v.toString().padLeft(2, '0'),
    onValueChanged: (v) => setState(() => hour = v),
  ),
)
```

## MiuixDatePicker

**Tanım ve anatomi:** Ortalanmış yıl/ay başlığı, sol/sağ ay okları, hafta günleri ve 6×7 takvim ızgarası. Seçili gün primary squircle zemin; bugün primary çerçeve; hafta sonu renkli; ay dışı hücreler soluk görünür. Sağa/sola kaydırma ay değiştirir. `onHeaderTap` verilirse başlık açılır menü oklu hızlı seçim tetirleyicisi olur.

**Kullan:** Doğum tarihi, rezervasyon, hatırlatma gibi takvim bağlamı ve tek tarih seçimi için.

**Kullanma:** Tarih aralığı, çoklu tarih, saat seçimi veya serbest metin girişi için kullanma. Ay başlığı kendi başına yıl/ay seçici açmaz; `onHeaderTap` ile ayrı akış kurulmalıdır.

**Durumlar / varyantlar:** Seçili, bugün, hafta sonu, ay dışı, disabled ve normal gün. `weekStart` `monday`/`sunday`; `showOutOfMonthDays` ay dışı hücreleri gösterir/gizler. `cellHeight` ve `colors` özelleştirilebilir.

**Tarih kısıtları:** `firstDate` varsayılan 1970-01-01, `lastDate` 2100-12-31; `selectableDayPredicate` gün bazında ek kısıt verir. `initialDate` aralığa clamp edilir. `currentDate` “bugün” referansıdır. Bu değerler yalnızca `initState`de okunur; sonradan değiştirmek görünümü yeniden kurmaz. Dış state ile tarihi değiştirmek istiyorsan kontrollü bir sarmalayıcı/anahtar stratejisi kur. Ay dışı hücreler bu sürümde tıklanamaz.

**Erişilebilirlik / platform:** Gün hücreleri `MiuixPressable` olduğundan Enter/Space ile aktive edilebilir; ancak takvim ok tuşu gezinmesi, odak yönetimi ve tam gün semantiği yoktur. Ay okları 36 dp ikon butondur; dokunma hedefini büyüt. Başlık ve hafta günleri kaynakta Çince sabit metinlerdir; Türkçe yerelleştirme API'si yoktur. Türkçe ürün için bu eksikliği kabul edilebilir değilse özelleştirilmiş takvim gerekir. Telefonda alt sheet/dialog içine koyarken sabit 6 satır yüksekliği ve IME boşluğunu test et; masaüstünde yatay kaydırma ile fare tekerleği çakışabilir.

```dart
MiuixDatePicker(
  initialDate: selectedDate,
  firstDate: DateTime(2020, 1, 1),
  lastDate: DateTime(2030, 12, 31),
  weekStart: MiuixWeekStart.monday,
  selectableDayPredicate: (d) => d.weekday != DateTime.sunday,
  onDateChanged: (d) => setState(() => selectedDate = d),
)
```

## MiuixColorPicker

**Tanım ve anatomi:** Dört renk alanından birine göre üç kanal gradyan sliderı, opsiyonel üst renk önizlemesi ve dördüncü alpha sliderı. Alpha'da dama deseni vardır; slider ucundan 13 px içeride hareket eder, RTL'de ters çizilir. `colorSpace` HSV/OkHSV/OkLab/OkLch seçer.

**Kullan:** Serbest renk seçimi ve önizleme gerektiğinde. Varsayılan HSV normal kullanıcı için tanıdıktır; OkHSV daha dengeli algısal geçiş sunmak isteyen tasarımlar için ara seçenektir.

**Kullanma:** Marka rengi gibi küçük, önceden tanımlı set için tam seçici açma. Yalnızca UI önizlemesi gerekiorsa paleti tercih et. Kullanıcı kanalları anlamıyorsa OkLab/OkLch terimlerini varsayılan arayüz yapma.

**Durumlar / varyantlar:** `color` kontrollüdür; harici değişiklik iç kanallarla eşitlenir. `showPreview`, `hapticEffect` (`MiuixSliderHapticEffect`) ve `colorSpace` ayarlanabilir. HSV ve OkHSV: hue/saturation/value + alpha; OkLab: lightness/a/b + alpha; OkLch görsel sırayla hue/lightness/chroma + alpha gösterir. Disabled parametresi yoktur; salt okunur için etkileşimi dışarıda engelle.

**Erişilebilirlik / platform:** İç sliderlar `GestureDetector` + `CustomPaint`; kanal etiketleri, Semantics değerleri, klavye okları ve FocusNode yoktur. Görsel gradyan tek başına kanal anlamı vermez; erişilebilir üründe etiketli sayısal/metin kontroller veya özel semantik sarmalayıcı ekle. Renk körlüğünde gradyanlara dayanma; HEX/RGB değeri ve önizlemeyi metinle de sun. Dokunmatikte yatay sürükleme, masaüstünde ince 26 dp yükseklikte fare hedefini büyüt.

```dart
MiuixColorPicker(
  color: selectedColor,
  colorSpace: MiuixColorSpace.hsv,
  showPreview: true,
  onColorChanged: (c) => setState(() => selectedColor = c),
)
```

## MiuixHsvColorPicker

**Tanım ve anatomi:** `MiuixColorPicker` için doğrudan HSV uzmanlı seçeneği. Hue gökkuşağı, saturation gri→doygun, value siyah→canlı ve alpha damalı gradyanlardan oluşur; üstte önizleme olabilir.

**Kullan:** Geleneksel hue/saturation/value düzenini açıkça göstermek istediğinde veya renk seçiciyi HSV olarak sabitlemek istediğinde.

**Kullanma:** Kullanıcının kanal isimlerini bilmediği genel ayarlarda; algısal olarak eşit adımlar istiyorsan HSV doğal olarak eşit görünmez.

**Durumlar / varyantlar:** HSV, seçili alpha dahil kontrollü `color`, `showPreview`, `hapticEffect`; kullanıcı sürüklerken callback sık çağrılır. `MiuixColorPicker(colorSpace: hsv)` ile aynı gövdeyi kullanır.

**Erişilebilirlik / platform:** Tam seçicideki eksik kanal etiketi/focus/klavye davranışı geçerlidir. Hue tek başına anlamlı değildir; yardımcı metin ve renk değeri ekle. Mobilde parmakla hassas kanal seçimi, masaüstünde hover sırasında değişen rengin kontrolsüz güncellenmemesi için state akışını test et.

```dart
MiuixHsvColorPicker(
  color: color,
  onColorChanged: updateColor,
)
```

## MiuixOkHsvColorPicker

**Tanım ve anatomi:** HSV benzeri hue/saturation/value, fakat OkLab tabanlı dönüşüm kullanan üç gradyan ve alpha sliderı; önizleme damalı alfa dahil çalışır.

**Kullan:** HSV benzeri etkileşimi korurken daha iyi algısal renk geçişleri isteyen, orta/ileri düzey kullanıcılara yönelik seçicide.

**Kullanma:** Kanal adlarını kullanıcıya açıklamadan teknik arayüz yapmak; palet yeterliyken gereksiz karmaşık seçim sunmak için.

**Durumlar / varyantlar:** `color`, `showPreview`, `hapticEffect`; harici renk OkHSV'ye çevrilir ve kullanıcı değişiklikleri geri çağrılır. OkHSV, HSV'nin doymazlık/değer anlamını birebir garanti etmez.

**Erişilebilirlik / platform:** Tam seçiciyle aynı erişilebilirlik sınırı vardır; ekran okuyucuya kanal adları ve sayısal değer sağla. Renk dönüşümü ek maliyet getirir; yoğun önizleme listelerinde gereksiz yeniden hesaplamayı önle.

```dart
MiuixOkHsvColorPicker(
  color: color,
  showPreview: false,
  onColorChanged: updateColor,
)
```

## MiuixOkLabColorPicker

**Tanım ve anatomi:** Lightness, a (green–red) ve b (blue–yellow) eksenlerini temsil eden gradyanlar + alpha. Görsel a/b aralıkları daraltılmıştır; kanallar matematiksel OkLab değerlerinin doğrudan ham gösterimi değildir.

**Kullan:** Işık/doygunluk ilişkisini algısal olarak düzenlemek isteyen tasarımcı ve ileri kullanıcılar için.

**Kullanma:** a/b eksenlerini açıklamadan normal kullanıcıya sunmak; yalnızca “renk seç” ihtiyacı olan uygulamalarda varsayılan yapmak.

**Durumlar / varyantlar:** Kontrollü OkLab rengi, üç kanal + alpha, `showPreview` ve `hapticEffect`. `MiuixColorPicker(colorSpace: oklab)` ile aynıdır.

**Erişilebilirlik / platform:** a/b kanalları renk körlüğü ve semantik eksen bilgisi olmadan özellikle zorlayıcıdır; metinsel L/a/b girişini veya açıklamalı kontrolleri dışarıdan ekle. Klavye/focus desteği yoktur; dokunmatik ve masaüstünde dar kanal aralığında hassasiyeti test et.

```dart
MiuixOkLabColorPicker(
  color: color,
  onColorChanged: updateColor,
)
```

## MiuixOkLchColorPicker

**Tanım ve anatomi:** OkLch için hue, lightness ve chroma gradyanları + alpha. Hue doygunluk ve parlaklıkla birlikte değişir; bu yüzden ilk görsel slider hue'dur. OkLab'e göre renk tonunu doğrudan düzenlemek daha sezgiseldir.

**Kullan:** Hue sabit tutarak lightness/chroma ayarlamak, tasarımcı renk sistemleri veya gelişmiş renk düzenleme için.

**Kullanma:** Normal kullanıcının teknik OkLch bilgisi olmadığı yerde; “daha canlı” gibi belirsiz hedef için kanal adlarını tek başına göstermek.

**Durumlar / varyantlar:** Kontrollü OkLch rengi, `showPreview`, `hapticEffect`; `MiuixColorPicker(colorSpace: oklch)` ile aynı gövdedir. Ekran gamutı dışındaki dönüşümlerin sRGB sonucu farklılaşabilir.

**Erişilebilirlik / platform:** Hue/chroma gradyanları tek başına erişilebilir değildir; L/C/H değerlerini metin olarak sun. Renk körlüğünde hue ayarını destekle. Tam seçicideki eksik klavye/focus desteği ve 26 dp slider yüksekliği burada da geçerlidir.

```dart
MiuixOkLchColorPicker(
  color: color,
  onColorChanged: updateColor,
)
```

## MiuixColorPalette

**Tanım ve anatomi:** HSV tabanlı renk ızgarası: varsayılan 7 satır, 12 hue sütunu ve sonunda bir gri sütun. Üstte önizleme, altta alpha sliderı vardır. Hücreye dokunma veya hücreler arasında sürükleme seçer; seçim halkası çizilir. `rows`, `hueColumns`, `includeGrayColumn`, `showPreview`, `cornerRadius`, `indicatorRadius` ayarlanabilir.

**Kullan:** Normal kullanıcılar için hızlı, sezgisel renk seçimi; ön tanımlı marka/UI renklerinin yakınında ince ayar; tam kanal seçiciden daha az teknik arayüz.

**Kullanma:** HSV ızgarasında bulunmayan kesin HEX/RGB rengi, çok hassas tonal ayar veya renk alanı seçimi gerektiğinde tek başına kullanma. Bütün renk uzayı yerine geçtiğini iddia etme.

**Durumlar / varyantlar:** Seçili hücre, normal renk, gri sütun, drag ve alpha; `rows > 0`, `hueColumns > 0`, negatif olmayan radius değerleri gerekir. Harici `color` en yakın ızgara hücresine eşlenir; palet seçimi bazı durumlarda özgün rengi önemli ölçüde değiştirebilir. Alpha, seçili hücrenin taban rengine uygulanır.

**Erişilebilirlik / platform:** Palet `Semantics` üzerinden yalnızca yatay artır/azalt (sütun) ve alpha %5 adımları sunar; dikey satır gezinmesi yoktur. Etiketler Çince sabit metindir (`颜色调色板`, `透明度`, `当前颜色预览`). Türkçe ve tam iki boyutlu klavye erişimi için özel sarmalayıcı gerekir. RTL kolon sırasını ters çevirir. Mobilde hücreler dokunmatiktir; masaüstünde fareyle sürükleme ve odak göstergesini test et. Renk körlüğüne karşı HEX/RGB metnini yanında göster.

```dart
MiuixColorPalette(
  color: selectedColor,
  includeGrayColumn: true,
  onColorChanged: (c) => setState(() => selectedColor = c),
)
```

## Renk uzayı ve palet karar kılavuzu

- **Normal kullanıcı, hızlı seçim:** `MiuixColorPalette`; HEX/RGB değerini ve önizlemeyi yanında göster.
- **Tanıdık serbest seçim:** `MiuixColorPicker` varsayılan HSV veya doğrudan `MiuixHsvColorPicker`.
- **Daha dengeli HSV benzeri deneyim:** OkHSV; kullanıcıya teknik terimleri açıklamadan yalnızca sonucu sun.
- **Tasarımcı / ileri kullanıcı:** OkLab lightness/a/b veya OkLch hue/lightness/chroma. Seçilen uzayı değiştirirken aynı `Color`ı koru; bileşen yeni uzmana dönüştürür.
- **Kesin değer:** HSV/OkLab/OkLch sliderı bile tek başına HEX girişi değildir. Doğrulama gereken üretim rengi için metin girişi ve önizleme ekle.

## Son doğrulama notları

- Yukarıdaki sınıf, kurucu, parametre, enum ve davranışlar belirtilen yerel `flutter_miuix 1.4.0` kaynaklarından doğrulandı; Dart kodu değiştirilmedi ve Flutter/ADB çalıştırılmadı.
- Doğrulanan eksikler: menü satırlarında ok/Escape navigasyonu; number/full-color picker'da klavye ve semantik değer desteği; date picker'da Türkçe başlık/hafta günü API'si; palette semantiğinde Türkçe metin; date picker'da sonradan `initialDate`/sınır güncellemesi.
- Bu dosyada uydurulmuş API yoktur. Yukarıdaki “eksik” davranışların dışarıdan tamamlanması önerilir; paket içinde mevcut parametre gibi sunulmamıştır.
