# Düğmeler ve Aksiyon Yüzeyleri

Bu bölüm `flutter_miuix` **1.4.0** için hazırlanmıştır. Tüm sınıflar `package:flutter_miuix/miuix.dart` üzerinden dışa aktarılır. Örneklerde `MiuixTheme` ve uygun `MiuixScaffold`/Material kökünün bulunduğu varsayılır.

## Tasarım kararları

- Ekranda genellikle **bir primary aksiyon** olsun. `MiuixButton` varsayılanı secondary görünümündedir; primary görünüm `MiuixButtonDefaults.buttonColorsPrimary(context)` ile seçilir.
- `MiuixTextButton` bir metin düğmesidir; adına rağmen şeffaf bir Material metin düğmesi değildir, `MiuixButton` üzerine kuruludur.
- Yıkıcı işlemlerde `error` / `onError` renk çiftini kullan, eylem adını açık yaz ve gerekiyorsa onay veya geri alma sun. Kırmızı renk tek başına riski anlatmaz.
- Pakette düğme başına `loading` durumu yoktur. İşlem sürerken düğmeyi `onPressed: null` yapıp yanına açıklayıcı bir durum metni/`MiuixProgressIndicator` koyabilirsin; bunu düğmenin yerleşik özelliği gibi sunma.
- Varsayılan `MiuixButton` / `MiuixIconButton` minimum yüksekliği **40 dp**, FAB ise **60 dp** dir. Dokunma hedefi için dışarıdan en az 48 dp'lik alan ayır; özellikle yoğun toolbar'larda 40 dp'yi kural olarak görme.
- Mobilde tek ana aksiyon ve geniş etiketler; masaüstünde hover/focus, kısayollar ve sınırlı içerik genişliği önemlidir. Bileşenler platforma göre otomatik masaüstü düzenine dönüşmez.

## MiuixButton

Yumuşak squircle arka planlı, ortalanmış etiket/çocuk içeren genel aksiyon düğmesi; varsayılanı secondary renklerle gelir ve minimum 58×40 dp ölçüsüyle içerik etrafında kalır.

### Kullan

- Formun tekil gönderim/onay aksiyonu için.
- Başka bir aksiyonla karşılaştırılması gereken, dolguya sahip aksiyonlar için.
- İkon + metin gibi zengin `child` kompozisyonu gerektiğinde.
- `MiuixButtonDefaults.buttonColorsPrimary(context)` ile ana aksiyon hiyerarşisi kurmak için.
- Yıkıcı aksiyonda `MiuixButtonColors` ile `error` arka plan ve `onError` içerik rengini eşleştirmek için.

### Kullanma

- Her kart veya satır için primary düğme koyma.
- Yalnızca gezinme için; gezinme tercihi `MiuixArrowPreference` olmalıdır.
- İşlem devam ederken aynı düğmeye tekrar tıklatma; kalıcı durum yönetimini uygulamada sağla.
- Küçük metni tek satıra sığdırmak için `minWidth` değerini düşürme.
- `MiuixCard` içinde kartın tamamı zaten tıklanabiliyorsa ikinci bir ana düğme ekleme.

### Önemli durumlar ve varyantlar

- `colors == null`: secondary görünüm. Primary görünüm için `buttonColorsPrimary`.
- `enabled` true ve `onPressed` null değilse etkin; `onPressed: null` veya `enabled: false` disabled renkleri ve etkileşimsizliği seçer.
- `cornerRadius`, `minWidth`, `minHeight`, `insideMargin` ve özel `colors` ölçeklenebilir.
- Basılı/hover/focus görünümü `MiuixPressable` üzerinden gelir. Paket `loading`, `selected` veya `destructive` enum'u tanımlamaz.

### Erişilebilirlik ve platform

- Alt `MiuixPressable`, etkin düğmeyi `button: true` ve `enabled` semantiğiyle sunar; etiketi çocuk metinden alır. Yalnızca ikonluysa erişilebilir etiket ekle.
- `MiuixPressable` Enter, Space ve Numpad Enter ile aktive edilebilir ve görünür focus kullanır.
- İçerik rengi `MiuixContentColor` ile `MiuixText` / `MiuixIcon` çocuklara aktarılır; düz `Text` için `DefaultTextStyle` de güncellenir.

```dart
MiuixButton(
  onPressed: save,
  colors: MiuixButtonDefaults.buttonColorsPrimary(context),
  child: const Text('Değişiklikleri kaydet'),
)
```

## MiuixTextButton

`MiuixButton` üzerine kurulu, metin etiket alan kısa aksiyon düğmesi; aynı squircle biçimini ve varsayılan secondary renkleri kullanır.

### Kullan

- Kısa, kendini açıklayan metin içeren eylemler için.
- Birden çok aksiyon arasında görsel ağırlığı primary düğmeye göre düşük tutmak için.
- `textStyle` ile uygulamanın mevcut metin ölçeğine uyum sağlamak için.

### Kullanma

- Şeffaf, sade link aksiyonu beklerken; bu bileşen dolgulu düğmedir.
- Uzun cümleleri düğmeye sığdırmak için.
- Aynı satırda çok sayıda eşit primary görünümlü aksiyon oluşturmak için.

### Önemli durumlar ve varyantlar

- İlk pozisyon parametre `String text`; `child` yoktur.
- `colors`, `textStyle`, `enabled`, `cornerRadius`, minimum ölçüler ve `insideMargin` desteklenir.
- `enabled: false` ve `onPressed: null` birlikte kullanılsa da etkinlik koşulu ikisini birlikte gerektirir.

### Erişilebilirlik ve platform

- Semantik ve klavye davranışı `MiuixButton` ile aynıdır; metin etiketi doğal olarak erişilebilir ad olur.
- Masaüstünde Tab sırasını kısa tut; dokunmatik ekranda en az 48 dp'lük hit alanı ver.

```dart
MiuixTextButton('Vazgeç', onPressed: cancel)
```

## MiuixIconButton

40×40 dp minimum alanda, isteğe bağlı şeffaf veya renkli arka plan üzerinde tek bir ikon/çocuk barındıran kompakt aksiyon düğmesi.

### Kullan

- Toolbar, app bar veya görsel olarak tanımlı tekrar eden ikon aksiyonları için.
- `backgroundColor` yalnızca tek bir ikon aksiyonuna gerçekten vurgu gerektiğinde.
- `holdDownState: true` ile açık bir menü/popup sırasında düğmenin basılı görünmesini korumak için.

### Kullanma

- Yalnızca sil, paylaş, daha fazla gibi kritik aksiyonlarda tooltip ve semantik etiket olmadan.
- Normal bir metin aksiyonunu gereksiz yere ikona çevirmek için.
- Ardışık birkaç ikonu 40 dp hedeflerle yan yana sıkıştırmak için.

### Önemli durumlar ve varyantlar

- `backgroundColor == null` şeffaftır; varsayılan `cornerRadius` 40 ile yuvarlak görünüm üretir.
- `onPressed: null` etkileşimi kapatır; `enabled: false` de aynı sonucu verir.
- `holdDownState` yalnızca etkin durumda basılılık kaplaması ekler.
- Özel `backgroundColor` verildiğinde bileşen otomatik disabled arka plan/ikon rengi üretmez; gerekirse kendi renk çözümlemeni yap.

### Erişilebilirlik ve platform

- `MiuixPressable` düğme semantiği ve klavye aktivasyonu sağlar, ancak ikonun kendi `contentDescription` alanı düğme adını tamamlar. Tooltip ve anlamlı etiket birlikte kullan.
- `MiuixIcon` için `contentDescription` doğrudan desteklenir; dekoratif ikonda `null` bırak.
- Masaüstünde hover/focus görünürlüğünü, mobilde 48 dp'ye çıkarılmış dış hit alanını test et.

```dart
MiuixIconButton(
  onPressed: openSettings,
  child: MiuixIcon(
    vector: MiuixIcons.extended.byName('settings')!,
    contentDescription: 'Ayarları aç',
  ),
)
```

## MiuixFloatingActionButton

İçerik boyutuna göre büyüyen, minimum 60×60 dp ve varsayılan stadium şekilli; primary yüzey ve hafif gölgeyle ekranın üzerinde yüzen tek ana aksiyon.

### Kullan

- Sayfanın baskın, tek ve hızlı oluşturma aksiyonu için.
- İçerik arka planından net biçimde ayrılması gereken yüzen aksiyon için.

### Kullanma

- Birden çok FAB'ı aynı görünür alanda yarıştırmak için.
- Form gönderimi, silme onayı gibi zorunlu akışın tek başına giriş noktası yapmak için.
- Uzun metin veya çok sayıda aksiyon taşımak için.

### Önemli durumlar ve varyantlar

- `containerColor`, `shape`, `shadowElevation`, `minWidth`, `minHeight` özelleştirilebilir.
- `onPressed: null` veya `enabled: false` etkileşimi kapatır; arka plan ve gölge için ayrı disabled renk hesabı yoktur.
- Varsayılan içerik rengi `onSurface`, `onPrimary` değildir. Renkli `containerColor` üzerinde `MiuixIcon.tint` ile uygun `onPrimary`, `onSecondary` veya `onError` rengini açıkça ver.

### Erişilebilirlik ve platform

- `Semantics(button: true)` vardır; `MiuixPressable` klavye aktivasyonunu tamamlar.
- İkonlu FAB'a `contentDescription` ekle; mümkünse kısa metinli extended FAB örneğinde olduğu gibi anlamlı `child` kullan.
- Mobilde içerik ve bottom bar tarafından örtülmeyecek yerde konumlandır; masaüstünde tek FAB yeterli olabilir ve hover/focus kontrastını doğrula.

```dart
MiuixFloatingActionButton(
  onPressed: addItem,
  child: MiuixIcon(
    vector: MiuixIcons.extended.byName('add')!,
    tint: MiuixTheme.of(context).colors.onPrimary,
    contentDescription: 'Yeni öğe ekle',
  ),
)
```

## MiuixBasicComponent

Başlangıç eylemi, başlık/özet, bitiş eylemleri ve isteğe bağlı alt içerikten oluşan; minimum 56 dp yüksekliğinde, genişliği kapsayan esnek liste satırıdır.

### Kullan

- Ayar ve liste satırlarının temel iskeleti olarak.
- Başlık + özet + değer/ikon/rozet gibi basit bir satır kompozisyonu için.
- `bottomAction` ile slider gibi geniş bir alt kontrol yerleştirmek için.
- Kendi tercih satırını `MiuixBasicComponent` üzerinde oluştururken.

### Kullanma

- Tek başına bir sayfa başlığı veya kart içeriği yerine.
- İçinde bağımsız tıklanabilir kontrol varsa satırın tamamını da aynı aksiyona bağlamak zorunda değilsen.
- `onClick` var ama içindeki switch aynı durumu değiştiriyorsa kullanıcıya çift etkileşim hissini önlemek için tek kaynak kullan.
- Çok uzun, kritik metni `summary` içinde saklamak için.

### Önemli durumlar ve varyantlar

- `title`, `summary`, `content`, `startAction`, `endActions`, `bottomAction` alanları vardır.
- `onClick == null` veya `enabled: false` satırı etkileşimsiz yapar.
- `holdDownState` açık menü gibi dış kaynaklı basılı görünümü tutar.
- `MiuixBasicComponentRole` rollerini ve `onClickLabel` kullanır; bu roller `checkbox`, `radioButton`, `switchControl`, `dropdownList`, `button`, `tab` değerlerini alabilir.

### Erişilebilirlik ve platform

- `Semantics(container: true)`, etkinlik, tıklama ve rol bilgisi verir. `onClickLabel` özel bir eylem adı ekler.
- İç kontrol kendi semantiğini korumalıdır; satırı ayrıca `ExcludeSemantics` ile gizlemek gerçek durumun kaybına yol açabilir.
- Masaüstünde geniş ekranı doldurmak yerine okunabilir satır genişliği kullan; mobilde `endActions` alanının uzun değer için kısaltma/ellipsis stratejisini test et.

## MiuixCard

Squircle yüzeyli, tema renklerini içeriğe aktaran ve isteğe bağlı tıklama/uzun basma ile `sink` veya `tilt` geri bildirimi sunan içerik grubu.

### Kullan

- İlgili ayar satırlarını `Column` içinde tek yüzeyde toplamak için.
- Başlık, özet ve birkaç ilgili eylemi birlikte göstermek için.
- `colors` ile primary gibi anlamlı bir vurgu kartı oluşturmak için.

### Kullanma

- Liste satırlarının her birini ayrı kart yapmak için.
- İç içe kartlarla gereksiz katman ve boşluk üretmek için.
- Dekoratif kartta `feedbackType` tanımlayıp tıklama olmadığı izlenimi vermek için.
- Kartın tamamı tıklanırken içinde bağımsız düğmeler varsa etkileşim sınırlarını netleştirmeden.

### Önemli durumlar ve varyantlar

- Varsayılan `insideMargin` sıfırdır; iç satırlar kendi dolgusunu yönetir.
- `onPressed` veya `onLongPress` varsa `MiuixPressable` ile etkileşimli olur.
- `feedbackType: none` yalnızca basılı kaplama; `sink` küçültme; `tilt` dokunmatik konuma göre 3B eğilmedir.
- `MiuixCardColors` hem yüzey hem `contentColor` ister; özel yüzeyde içerik kontrastını birlikte ayarla.

### Erişilebilirlik ve platform

- Tıklanabilir kart `MiuixPressable` üzerinden button semantiği ve klavye aktivasyonu alır; dekoratif kart rol üretmez.
- Kartı tek bir aksiyon olarak sunuyorsan alt öğelerin aynı aksiyonu ikinci kez duyurmasını engelle.
- Masaüstünde hover/focus ve tilt hareketini gözle; azaltılmış hareket tercihinde `tilt` yerine `none` veya `sink` kullan.

```dart
MiuixCard(
  insideMargin: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      MiuixText('Başlık', style: theme.textStyles.title3),
      MiuixText('Kısa açıklama', style: theme.textStyles.body2),
    ],
  ),
)
```
