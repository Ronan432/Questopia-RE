# Girdi ve Seçim Bileşenleri

Bu bölüm `flutter_miuix` **1.4.0** kaynak kodu ve çalışan showcase ile doğrulanmıştır. Herkese açık sınıflar `package:flutter_miuix/miuix.dart` üzerinden içe aktarılır.

## Ortak tasarım ilkeleri

- Her girdinin kalıcı bir adı olsun. Görsel placeholder, form etiketi ve erişilebilir adın yerine geçmez.
- Switch/checkbox/radio yalnızca ilgili değeri değiştirsin; başka bir ekrana geçiş ayrı bir satır/aksiyon olmalıdır.
- Switch anlık aç/kapat tercihi, checkbox bağımsız seçim, radio tek seçim içindir. Görsel benzerlikleri davranış farkını kaldırmaz.
- Slider sürekli veya adımlı ölçüm için; küçük ve kesin seçenek sayısında radio veya picker daha anlaşılır olabilir.
- `enabled: false` ile `onChanged: null` birlikte kullanmak tutarlıdır. Çoğu girdide etkinlik her iki koşulun birleşimine bağlıdır.
- Paket bu bileşenlerde ortak bir `loading`, `errorText` veya form doğrulama katmanı tanımlamaz. Doğrulamayı uygulamada, alanla ilişkili metin ve semantikle çöz.
- Varsayılan görsel kontroller 26–49 dp aralığında olabilir; dokunma hedefini dış dolgu veya tıklanabilir satırla en az 48 dp yap.
- Mobilde IME, ekran kaplaması ve tek elle erişim; masaüstünde Tab sırası, ok/Home/End tuşları, görünür focus ve fare hover'ı ayrı test edilmelidir. Bileşenler otomatik olarak platforma özgü değişik kontroller açmaz.

## MiuixTextField

Dolgulu squircle alan, odakta animasyonlu primary kenarlık ve metin girildiğinde yukarı taşınan etiket içeren çok satırlı da olabilen metin girdisi.

### Kullan

- Serbest metin, kullanıcı adı, parola ve açıklama alanları için.
- `label` ile alanın amacını her zaman görünür tutmak için.
- `keyboardType`, `textInputAction`, `onSubmitted` ve `textCapitalization` ile doğru IME davranışı kurmak için.
- `controller` dışarıdan verip `dispose` yönetimini uygulamada yapmak için.

### Kullanma

- Yalnızca placeholder ile alanı adlandırmak için; `useLabelAsPlaceholder: true` metin girilince etiketi gizler.
- Hata/yardım metni için `summary` benzeri varsayılan bir alan olmayan bir yapı uydurmak yerine alan altında açık metin ve semantik ilişki kullanmak için.
- `obscureText` ile çok satırlı alan kurmak için; Flutter gereği bu mod tek satıra zorlanır.
- İkonu tek başına eylem veya durum anlatımı yapmak için.

### Önemli durumlar ve varyantlar

- `enabled`, `readOnly`, `autofocus` birbirinden ayrıdır; `readOnly` odaklanabilir ama düzenlenemez.
- `singleLine` veya `obscureText` `maxLines: 1` uygular; aksi hâlde `maxLines` / `minLines` kullanılabilir.
- `leadingIcon` ve `trailingIcon` widget alır; iç dolgu davranışı için showcase'daki gibi ikonlara `Padding` eklenebilir.
- `insideMargin` varsayılanı `EdgeInsets.all(16)` olup her tarafın tekli değeri kullanılır; `.horizontal` / `.vertical` ile çift padding anlamı verme.
- `colors` yalnızca `backgroundColor`, `labelColor`, `borderColor` içerir; özel disabled rengi yoktur.

### Erişilebilirlik ve platform

- İç Flutter `TextField` düzenleme semantiğini sağlar; görsel etiket onun `InputDecoration.labelText` alanına bağlı değildir. `Semantics(label: ...)` ile alanı açıkça adlandır ve hata metnini ilişkilendir.
- Klavye türünü ve `textInputAction` değerini veriye göre seç; parolada `obscureText` kullan ama göster/gizle gerekiyorsa ayrı, adlandırılmış bir aksiyon ekle.
- Mobilde alanın üstte kalması ve klavye açıldığında kaydırma; masaüstünde mantıklı Tab sırası test edilmelidir.

```dart
MiuixTextField(
  controller: emailController,
  label: 'E-posta adresi',
  keyboardType: TextInputType.emailAddress,
  textInputAction: TextInputAction.next,
  onChanged: validateEmail,
)
```

## MiuixSwitch

49×28 dp capsule track, 20 dp thumb ve tıklama/yatay sürükleme ile anlık aç-kapat durumunu değiştiren ikili tercih kontrolü.

### Kullan

- Wi-Fi, bildirimler veya anında uygulanan ayar gibi binary tercihler için.
- Satırın tamamı da aynı switch'i değiştiriyorsa tercih satırı kompozisyonunda.

### Kullanma

- Çok seçenekli veya zaman alan bir form aksiyonu için.
- Ağ isteği başarısız olabilecek bir işlemi kullanıcı geri alana kadar görsel olarak “tamamlandı” gibi göstermek için.
- `value` değişmeden `onChanged` çağırarak yerel görsel durumdan bağımsız davranmak için.

### Önemli durumlar ve varyantlar

- `value`, `onChanged`, `enabled`, `colors` alanları vardır; etkinlik için `enabled` true ve `onChanged` null değil olmalıdır.
- Açık/kapalı thumb, track ve disabled renk ayrı ayrı `MiuixSwitchColors` içinde tanımlanır.
- Basılı/hover/sürükleme sırasında thumb 1.127 ölçeklenir; RTL'de konum ve sürükleme yönü miraslanır.
- Tıklama `lightImpact`; sürükleme yarı mesafeyi aşarsa durum değişir, aksi hâlde geri döner.

### Erişilebilirlik ve platform

- Bileşen `toggled`, `enabled`, `container` ve `onTap` semantiği verir; satırla birlikte kullanırken aynı kontrolün iki kez duyulmasını önle.
- Görsel ölçü 28 dp yüksekliğindedir; satır hedefi veya dış padding ile 48 dp'yi karşıla.
- Masaüstünde hover büyütmesi kontrastı azaltmamalıdır; odak sırasında `value` metnini de görünür tut.

```dart
MiuixSwitch(
  value: notificationsEnabled,
  onChanged: (value) => setState(() => notificationsEnabled = value),
)
```

## MiuixCheckbox

26 dp dairesel arka plan ve animasyonlu çizgi/çek işareti taşıyan; `null` değeriyle indeterminate görünen üç durumlu onay kutusu.

### Kullan

- Bağımsız koşulları, çoklu seçim listeleri ve onay ifadeleri için.
- `value == null` ile bir grup öğesinin kısmen seçili olduğunu göstermek için.
- Dış `MiuixBasicComponent` veya geniş bir onay etiketiyle birlikte kullanmak için.

### Kullanma

- Yalnızca bir seçenek seçilebilen durumlar için; radio kullan.
- Indeterminate'i kullanıcı tercihi gibi sunmak için; grup durumudur.
- `onChanged` içinde gelen `null` değerini dikkatsizce saklamak için; bu widget kendi dokunuşunda `null` üretmez, `null → true` geçişi yapar.

### Önemli durumlar ve varyantlar

- `bool? value`: `true` işaretli, `false` boş, `null` indeterminate.
- `MiuixCheckboxColors` seçili/seçili olmayan ve disabled foreground/background renklerini ayrı tutar.
- Etkinlik için `enabled` true ve `onChanged` null değil olmalıdır; disabled checkbox değişmez.
- Tıklama sırası `true → false`, `false → true`, `null → true` ve `lightImpact` üretir.

### Erişilebilirlik ve platform

- `MiuixPressable` button semantiği verir; bileşen checked/mixed durumunu ayrıca açıklayan `Semantics` ile sarmalanmalıdır.
- Etiket tıklanabiliyorsa kontrolle aynı eylemi birleştir; ekranda görünen ad ile semantik adı eşleştir.
- 26 dp görsel boyuta rağmen dış hit alanını 48 dp yap; uzun Türkçe etiketlerde satır kırpma yerine taşma yeniden test et.

```dart
Semantics(
  label: 'Kullanım koşullarını kabul et',
  checked: accepted,
  child: MiuixCheckbox(
    value: accepted,
    onChanged: (value) => setState(() => accepted = value ?? false),
  ),
)
```

## MiuixRadioButton

26 dp alanda seçildiğinde primary renkli animasyonlu çizgi gösteren; kendi başına seçimi bırakmayan tek seçim göstergesi.

### Kullan

- Aynı soruya ait birkaç seçenekten yalnızca birinin seçileceği gruplar için.
- Tercih satırında başlangıç veya bitiş konumuna yerleştirilen seçim işareti için.

### Kullanma

- Bağımsız onay kutuları için.
- Seçili öğeye tekrar tıklayarak seçimi kaldırmak istediğinde; `selected == true` iken callback çağrılmaz.
- Grup dışı hiçbir zaman seçilmeyen, zorunlu olmayan tek seçim için; açık bir “Seçilmedi” seçeneği veya başka desen kullan.

### Önemli durumlar ve varyantlar

- `selected` zorunlu, `onChanged` isteğe bağlıdır; callback yalnızca seçili olmayan öğeye tıklandığında `true` alır.
- `MiuixRadioButtonColors` yalnızca `selectedColor` ve `disabledSelectedColor` tanımlar.
- Seçili olmayan öğe görsel çizgi üretmez; disabled seçili öğe disabled primary kullanır.

### Erişilebilirlik ve platform

- `MiuixPressable` button rolü verir; radio grubu için `Semantics(inMutuallyExclusiveGroup: true, checked: ...)` gibi grup/state bilgisi eklenmelidir.
- Tek bir selected indeksini uygulamada tut; kontrolün kendi başına grup üyeliğini yönetmediğini varsayma.
- Mobilde satırın tamamını seçilebilir yap, masaüstünde ok tuşlarıyla grup gezinme isteniyorsa ek klavye davranışı sağla.

```dart
MiuixRadioButton(
  selected: themeIndex == index,
  onChanged: (_) => setState(() => themeIndex = index),
)
```

## MiuixSlider

Yatay primary ilerleme çizgisi, thumb, isteğe bağlı keypoint'ler ve basılı/hover/sürükleme animasyonları içeren tek değerli sürekli veya adımlı kaydırıcı.

### Kullan

- Parlaklık, ses veya yüzde gibi göreli değerler için.
- `steps`, `showKeyPoints` ve `magnetThreshold` ile anlamlı kesimlere sahip ölçümler için.
- `onValueChangeFinished` ile kaydırma bittiğinde bir kez kalıcı işlem yapmak için.

### Kullanma

- Kesin sayı girişi gereken alanların tek erişim yolu olarak.
- Küçük, ayrık seçenekleri gereksiz ince çizgide sunmak için.
- Her karede ağ isteği veya veritabanı yazımı başlatmak için; canlı önizlemeyi kalıcı işlemden ayır.

### Önemli durumlar ve varyantlar

- `value` `[min, max]` aralığına clamp edilir; `min < max` ve `steps >= 0` zorunludur.
- `steps: 0` süreklidir; pozitif `steps` aralık sayısıdır ve adımlı değerler üretir.
- `keyPoints` ölçek değerleridir (`min..max`), normalize edilmiş oran değil; `showKeyPoints` olmadan özel keypoint'ler hâlâ manyetik/semantik hesaplarda kullanılabilir.
- `reverseDirection` RTL ile birleşerek yönü çözer; `height` varsayılanı 28 dp'dir.
- `hapticEffect` `none`, `edge`, `step`; `onValueChangeFinished` sürükleme sonunda çalışır.

### Erişilebilirlik ve platform

- Kaynakta `Semantics` veya klavye ok/değer değiştirme eylemi yoktur. `Semantics(value: ..., onIncrease: ..., onDecrease: ...)` ile erişilebilir alternatif ekle.
- Görsel `value` metnini taşınabilir kısa bir başlıkta göster; yalnızca thumb konumuna dayanma.
- Mobilde kalın dış hedef ve `step` dokunuş hissi; masaüstünde focus + ok tuşları ve hover'ı ayrıca destekle.

```dart
MiuixSlider(
  value: brightness,
  min: 0.2,
  max: 1.0,
  steps: 7,
  onValueChanged: (value) => setState(() => brightness = value),
  onValueChangeFinished: persistBrightness,
)
```

## MiuixVerticalSlider

Alt veya üst yönünde değer artan, sabit yükseklik gerektiren dikey tek değerli slider; yatay sürümün adımlar/keypoint/haptic seçeneklerini korur.

### Kullan

- Dikey ses kontrolü veya uzun bir ayar panelinde yönü açıkça belirtilmiş ölçüm için.
- `reverseDirection` ile görsel yönü uygulamanın ölçeğine uyarlamak için.

### Kullanma

- Genel form alanında yatay yerine sebepsiz dikey kontrol kullanmak için.
- Yüksekliği belirsiz bir `Row`/`Column` içinde doğal ölçü beklemek için.
- Yalnızca `effect` parametresini açarak yeni bir görsel efekt beklemek için; 1.4.0'da bu parametre API uyumu için korunur ve çizimde kullanılmaz.

### Önemli durumlar ve varyantlar

- `width` varsayılanı 28 dp; gerçek yükseklik ebeveynin `constraints.maxHeight` değerinden alınır.
- Varsayılan yön alttan üste artar; `reverseDirection: true` üstten alta artırır.
- `steps`, `keyPoints`, `magnetThreshold`, `hapticEffect`, `onValueChangeFinished` vardır.
- Loose height constraint altında yükseklik sıfırlanabilir; showcase sabit `SizedBox(height: ...)` ve `crossAxisAlignment: stretch` kullanır.

### Erişilebilirlik ve platform

- Yatay slider ile aynı semantik/klavye eksikliği vardır; değer, artır ve azalt eylemlerini dışarıdan ekle.
- Dikey hareket fare tekerleğiyle otomatik değişmez; masaüstünde klavye veya başka erişilebilir kontrol sun.
- 48 dp'den dar bir dikey şerit görsel olarak ince kalabilir; hit alanını ayrı genişlet.

```dart
SizedBox(
  height: 160,
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      MiuixVerticalSlider(
        value: volume,
        onValueChanged: (value) => setState(() => volume = value),
      ),
    ],
  ),
)
```

## MiuixRangeSlider

Aralık dolgusu ve iki thumb taşıyan yatay çift değerli slider; callback `(double, double)` kaydı (`(start, end)`) döndürür.

### Kullan

- Fiyat aralığı, zaman aralığı veya iki sınır gerektiren filtreler için.
- Alt/üst sınırları bağımsız hareket ettirilebilir ölçümler için.

### Kullanma

- Tek merkez değer gerektiren durumlarda.
- İki bağımsız ayarın aynı ölçekte görünmesi için; bunlar ayrı slider olabilir.
- Kullanıcının sıralaması bozulabilecek çok dar alanda ek açıklama olmadan.

### Önemli durumlar ve varyantlar

- `startValue`, `endValue`, `min`, `max`, `steps`, `keyPoints`, `hapticEffect`, `height` vardır.
- `reverseDirection` parametresi yoktur; yönlü davranış `Directionality` üzerinden gelir.
- Her iki değer aralığa clamp edilir; uygulama modelinde `startValue <= endValue` düzenini koru.
- `onValueChangeFinished` her iki uçtan biri bırakıldığında çalışır; `showKeyPoints` ve `magnetThreshold` desteklenir.

### Erişilebilirlik ve platform

- İki uç için ayrı adlar ve değerler gerekir; tek “aralık” semantiği hangi ucun değiştiğini açıklamaz.
- Klavye ile hangi ucun aktif olduğunu ve `start` / `end` değerlerini duyur; kaynakta hazır slider semantiği yoktur.
- Mobilde uç thumb'ları birbirine yaklaştıran kullanıcı için minimum seçim aralığı/ayrı sayı alanları düşün.

```dart
MiuixRangeSlider(
  startValue: priceStart,
  endValue: priceEnd,
  min: 0,
  max: 1000,
  steps: 9,
  onValueChanged: (range) => setState(() {
    priceStart = range.$1;
    priceEnd = range.$2;
  }),
)
```

## MiuixSearchBar

Kapsüllü `inputField`, dışarıda isteğe bağlı bitiş aksiyonu ve `expanded` olduğunda açılan sonuç `content` alanını birleştiren genişleyebilir arama kabuğu.

### Kullan

- Uygulama içi arama ve öneri/sonuç listesi için.
- Genişlediğinde sonuçları aynı akışta göstermek ve sistem geri hareketiyle önce aramayı kapatmak için.
- `outsideEndAction` ile genişleyen alanda ek bir aksiyon sunmak için.

### Kullanma

- Zorunlu filtre seçimi veya veri düzenleme formu için.
- Sonuçları başka bir modal içinde açarken arama alanını gereksiz büyütmek için.
- `inputField` olarak düz `TextField` verip `expanded`, `onExpandedChange` ve odak durumunu birlikte yönetmeyi unutmak için.

### Önemli durumlar ve varyantlar

- `inputField`, `onExpandedChange`, `content` zorunludur; `expanded` kontrollüdür.
- Genişlerken sonuçlar `ClipRect` + `AnimatedAlign` + `AnimatedOpacity` ile açılır; geri çağrısı `onPopInvokedWithResult` ile önce `expanded: false` yapılır.
- `insideMargin` yalnızca üst satırdaki input çevresine uygulanır.
- Aynı dosyadaki **public** `MiuixInputField` yardımcı kontrolü `query`, `onQueryChange`, `onSearch`, `expanded`, `onExpandedChange`, `label`, `enabled`, `focusNode` ve özel icon'ları yönetir; varsayılan temizleme ikonu metin boşken kaybolur.

### Erişilebilirlik ve platform

- `MiuixInputField` `textField: true` semantiği verir; arama etiketi görsel olarak `label`den gelir, erişilebilir adı açıkça eklemek iyi olur.
- Varsayılan iç İngilizce açıklamaları yerelleştirmek için özel `leadingIcon` / `trailingIcon` ve anlamlı `contentDescription` kullan.
- Mobilde arama açılınca klavye ve sonuç kaydırmasını, masaüstünde Escape/geri kapatma ve Tab sırasını test et.

```dart
MiuixSearchBar(
  expanded: expanded,
  onExpandedChange: (value) => setState(() => expanded = value),
  inputField: MiuixInputField(
    query: query,
    onQueryChange: (value) => setState(() => query = value),
    onSearch: submitSearch,
    expanded: expanded,
    onExpandedChange: (value) => setState(() => expanded = value),
    label: 'Bileşen ara',
  ),
  content: resultsList,
)
```

## MiuixNumberPicker

Dikey sürüklemeyle merkezdeki değeri seçen, uzak öğeleri soluklaştırıp küçülten ve isteğe bağlı döngüsel seçenekler sunan sayı/etiket çarkı.

### Kullan

- Saat, dakika veya sınırlı sayı aralığı gibi dikey seçimler için.
- `label` ile her değere kısa bir biçim/birim vermek için.
- `wrapAround: true` ile döngüsel aralıklar kurmak için.

### Kullanma

- Çok uzun veya metin açıklaması gerektiren seçenekler için; liste/dropdown daha okunaklı olabilir.
- Sayı aralığı geniş ve kullanıcının kesin değeri bildiği durumlarda tek erişim yolu olarak.
- `visibleItemCount` çift veya 3'ten küçük vermek için; constructor bunları reddeder.

### Önemli durumlar ve varyantlar

- `min`, `max`, `value`, `visibleItemCount`, `itemHeight`, `wrapAround`, `label`, `textStyle`, `colors` vardır.
- `visibleItemCount` tek ve en az 3 olmalıdır; toplam yükseklik `itemHeight * visibleItemCount` olur.
- `value` `[min, max]` aralığına clamp edilir; `wrapAround: false` uçlarda durur.
- Callback yalnızca sürüklemeyi bıraktıktan ve spring snap tamamlandıktan sonra, değer gerçekten değişmişse çağrılır.
- `onValueChanged: null` etkileşimsiz yapar; `enabled: false` disabled metin renklerini seçer.

### Erişilebilirlik ve platform

- Kaynakta `Semantics`, focus veya klavye seçim eylemi yoktur. Mevcut değeri duyuran ve artır/azalt eden erişilebilir kontroller ekle.
- Seçili değeri görünür metinle özetle; merkez konumu tek başına yeterli değildir.
- Mobilde sürükleme alanını rahat bırak; masaüstünde tekerlek yalnızca sürükleme sırasında değil, doğrudan değer değişimi için desteklenmez.

```dart
MiuixNumberPicker(
  value: hour,
  min: 0,
  max: 23,
  wrapAround: true,
  label: (value) => value.toString().padLeft(2, '0'),
  onValueChanged: (value) => setState(() => hour = value),
)
```
