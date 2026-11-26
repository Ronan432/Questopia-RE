# Metin, Yüzey ve Görsel Hiyerarşi

Bu bölüm `flutter_miuix` **1.4.0** için hazırlanmıştır. Bileşenler `package:flutter_miuix/miuix.dart` üzerinden dışa aktarılır. Görsel boyutler Flutter'da mantıksal piksel olarak uygulanır; eski Miuix belgelerindeki “sp” ifadeleri burada metin ölçeği olarak değerlendirilmelidir.

## Hiyerarşi kuralları

- Önce içerik anlamı, sonra boyut: sayfa başlığı, bölüm başlığı, satır başlığı ve özet farklı rollere sahiptir.
- `MiuixText` varsayılanı `textStyles.main` (17) ile sakin gövde metni üretir; her metni `title` yapma.
- `MiuixSmallTitle` bölümü ayırır, `MiuixBasicComponent` satırı taşır, `MiuixCard` ilgili satırları tek yüzeyde gruplar.
- Vurguyu birkaç yerde kullanma: primary kart, primary badge ve primary başlık aynı alanda birbirini zayıflatır.
- `MiuixBadge` varsayılanı `error` olduğundan yalnızca gerçek hata/acil bildirim anlamında kullan; dekoratif “Yeni” rozeti için özel renk veya nötr içerik düşün.
- Mobilde tek sütun ve kısa satırlar; masaüstünde içerik genişliğini sınırla, satırları ekran boyunca boşaltma. Bileşenler kendiliğinden responsive sütun düzenine geçmez.

## MiuixText

Tema `textStyles.main` stillerini, `MiuixContentColor` rengini ve isteğe bağlı metin özelliklerini birleştiren Miuix metin bileşeni.

### Kullan

- Gövde, başlık ve özet metinlerinde tema tipografisini korumak için.
- `style: MiuixTheme.of(context).textStyles.body2` gibi anlamlı ölçek seçimleri için.
- `color` veya `fontSize`, `fontWeight`, `height`, `maxLines`, `overflow` ile kontrollü yerel vurgu yapmak için.

### Kullanma

- Her kısa metinde ham `Text` kullanıp tema ölçeğini kaybetmek için.
- Uzun kritik metni `footnote` boyutuna sığdırmak için.
- Yalnızca renkle hata, seçim veya durum anlatmak için.
- `MiuixBadge` içinde yazıyı büyütmek için; badge kendi küçük tipografisini sağlar.

### Önemli durumlar ve varyantlar

- `style` yoksa `main`; `color` yoksa `style.color`, o da yoksa `MiuixContentColor` kullanılır.
- `fontSize`, `fontWeight`, `fontFamily`, `letterSpacing`, `fontStyle`, `decoration`, `height` temel stili geçersiz kılar.
- `textAlign`, `maxLines`, `overflow`, `softWrap` desteklenir; kendi başına `bold`, `semanticsLabel` veya `textDirection` parametresi yoktur.
- `MiuixTextStyles`: `main` 17, `paragraph` 17, `body1` 16, `body2` 14, `button` 17, `footnote1` 13, `footnote2` 11, `headline1` 17, `headline2` 16, `subtitle` 14, `title1` 32, `title2` 24, `title3` 20, `title4` 18.

### Erişilebilirlik ve platform

- Alt Flutter `Text` metin semantiği verir; başlık olduğunda dışarıdan `Semantics(header: true)` ekle.
- Sistem yazı tipi büyütmesi ve `textScaler` davranışını test et; sabit yükseklikli kartta metnin kırpılmasını önle.
- Türkçe karakterler ve RTL gerektiren yabancı içeriklerde `Directionality` ile doğru hizayı kur; `TextDirection` parametresi yoktur.

```dart
MiuixText(
  'Sonuç bulunamadı',
  style: MiuixTheme.of(context).textStyles.body2,
  color: MiuixTheme.of(context).colors.onSurfaceVariantSummary,
)
```

## MiuixCard

Squircle köşeli, varsayılan `surfaceContainer` / `onSurfaceContainer` renkleriyle gelen ve içeriğe renk rolünü aktaran grup yüzeyi.

### Kullan

- Tercih satırlarını `Column` içinde tek kartta toplamak için.
- Başlık ve kısa açıklamalardan oluşan ilgili bir içerik bloğu göstermek için.
- `MiuixCardColors` ile anlamlı ve kontrastlı primary vurgu kartı kurmak için.
- `onPressed` / `onLongPress` yalnızca kart gerçekten tek bir etkileşim birimi olduğunda.

### Kullanma

- Her liste satırını ayrı kart yapmak veya kart içinde kart kullanmak için.
- Statik bilgiyi tıklanabilir göstermek için.
- Kartın tamamını tıklanırken içindeki ayrı düğmelerin etkileşimini belirsiz bırakmak için.
- `insideMargin` varsayılanının 16 olduğunu varsaymak için; varsayılanı sıfırdır.

### Önemli durumlar ve varyantlar

- `cornerRadius` varsayılanı 16; `insideMargin` varsayılanı `EdgeInsets.zero`.
- `onPressed` veya `onLongPress` varsa `MiuixPressable` devreye girer.
- `feedbackType: none` basılı kaplama, `sink` hafif küçültme, `tilt` dokunma konumuna göre eğilmedir.
- `MiuixCardColors` hem `color` hem `contentColor` gerektirir; özel renkte ikili kontrastı birlikte ayarla.

### Erişilebilirlik ve platform

- Tıklanabilir kart button semantiği ve Enter/Space aktivasyonu alır; dekoratif kart semantik rol üretmez.
- Tüm kart tek aksiyonsa alt metinlerin ayrı ayrı aynı eylemi duyurmasını engelle; tek bir anlamlı etiket ve mantıklı child semantiği kullan.
- Masaüstünde hover/focus ve `tilt` hareketini kontrol et; azaltılmış hareket tercihinde `tilt` yerine `none` kullan.

```dart
MiuixCard(
  insideMargin: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      MiuixText('Hesap özeti', style: theme.textStyles.title3),
      MiuixText('Son oturum: bugün', style: theme.textStyles.body2),
    ],
  ),
)
```

## MiuixBadge

İçeriği yoksa 6×6 dp nokta, varsa en az 16×16 dp capsule üreten; varsayılan `error` / `onError` renklerine sahip küçük bildirim/rozet.

### Kullan

- Okunmamış durum için nokta göstermek için.
- Kısa sayı veya `99+` biçimlendirilmiş bildirim sayısı için.
- `MiuixBadgedBox` içinde bir ikonun veya aksiyonun köşesine yerleştirmek için.

### Kullanma

- Uzun cümle, açıklama veya tek başına tıklanabilir aksiyon taşımak için.
- Her sekme/ayar için süs amaçlı kırmızı nokta kullanmak için.
- Yalnızca sayıyı değiştirerek kritik durumu açıklamak için; metin veya ikonla destekle.
- Renkli rozeti `onError` dışındaki içerik rengiyle kontrastsız bırakmak için.

### Önemli durumlar ve varyantlar

- `child == null` nokta; `child != null` metin/içerik için capsule ve 11'lik badge tipografisi.
- `containerColor` ve `contentColor` özelleştirilebilir; varsayılan container `error`, içerik `onError`.
- Badge `Semantics(container: true)` taşır; yalnızca kendisi tıklanabilir değildir.

### Erişilebilirlik ve platform

- Nokta görünümünde ekran okuyucu için görünür bir “yeni bildirim” alternatifi veya `Semantics(label: ...)` gerekir.
- Sayıyı bağlamıyla birlikte duyur: “8 okunmamış mesaj” gibi; yalnızca “8” yeterli değildir.
- Çok büyük metin ölçeğinde rozetin ikonu örtmemesi ve kırpılmaması için sınır/test yap.

```dart
MiuixBadge(
  containerColor: theme.colors.primary,
  contentColor: theme.colors.onPrimary,
  child: const MiuixText('Yeni'),
)
```

## MiuixBadgedBox

Boyutunu tamamen `child` ile belirleyen, `badge` öğesini LTR'de sağ üst köşeye, RTL'de sol üst köşeye taşıyan ve rozetin sınır dışına çıkmasına izin veren konumlandırıcı.

### Kullan

- Mesaj, e-posta veya ayar ikonuna rozet ilişkilendirmek için.
- `topBound` / `endBound` ile rozetin belirli bir sınırın ötesine taşınmasını kısıtlamak için.

### Kullanma

- Badge'i normal satır hizasında içerik gibi yerleştirmek için.
- Çok sayıda rozeti aynı küçük hedefe bindirmek için.
- `MiuixBadge` yerine doğrudan metin verip rozet şeklini kaybetmek için.

### Önemli durumlar ve varyantlar

- `badge` ve `child` zorunludur; constructor `const` değildir.
- İçerikli badge varsayılan olarak sağdan 12, üstten 14 birim taşar; nokta badge 6 birim taşar.
- `topBound` ve `endBound` isteğe bağlı clamp sınırlarıdır; varsayılanı `null`.
- Dış boyut `child` ölçüsüne eşittir; badge hit testine katılabilir ama kendi başına bir aksiyon değildir.

### Erişilebilirlik ve platform

- Çocuk ikonun `contentDescription` alanını badge ile birlikte anlamlı kıl: “Mesajlar, 8 okunmamış” gibi.
- RTL'de otomatik aynalama vardır; Türkçe LTR ve RTL testlerinde taşma sınırlarını ayrı doğrula.
- Masaüstünde hover/focus çevresindeki rozet kontrastı, mobilde parmak hedefinin rozetle örtülmemesi önemlidir.

```dart
MiuixBadgedBox(
  badge: MiuixBadge(child: MiuixText('$unreadCount')),
  child: MiuixIcon(
    vector: MiuixIcons.extended.byName('messages')!,
    contentDescription: '$unreadCount okunmamış mesaj',
  ),
)
```

## MiuixHorizontalDivider

Tema `dividerLine` rengiyle, varsayılan 0,75 dp kalınlıkta tam genişlik yatay çizgi çizen dekoratif ayırıcı.

### Kullan

- Aynı kart içindeki satırları bölmek için.
- Başlık/özet gibi bağımsız içerik bloklarını görsel olarak ayırmak için.
- `Padding` ile satır metnine hizalanmış girintili çizgi oluşturmak için.

### Kullanma

- Her satırın etrafına kutu çizmek için.
- Boşluk ihtiyacını yalnızca çizgiyle çözmek için.
- Eylem veya durum anlatımı için.

### Önemli durumlar ve varyantlar

- `thickness` ve `color` özelleştirilebilir; varsayılan renk `MiuixDividerDefaults.dividerColor(context)`.
- `SizedBox(width: double.infinity, height: thickness)` üretir; ebeveynin genişliği sınırlı olmalıdır.
- Kendi `indent` parametresi yoktur; girinti dış `Padding` ile yapılır. Showcase'daki `IndentDivider` bir demo yardımcısıdır, paket API'si değildir.

### Erişilebilirlik ve platform

- Dekoratif olduğundan ekran okuyucudan gizlemek için `ExcludeSemantics` kullanılabilir.
- Yüksek kontrast ve koyu temada `dividerLine` görünürlüğünü kontrol et.
- RTL'de satırın başına göre girinti verirken `EdgeInsetsDirectional` tercih et; `IndentDivider` helper'ı yalnızca `left` kullanır.

## MiuixVerticalDivider

Tema `dividerLine` rengiyle, varsayılan 0,75 dp kalınlıkta tam yükseklik dikey çizgi çizen dekoratif ayırıcı.

### Kullan

- İki gerçekten yan yana olan içerik grubunu ayırmak için.
- Dar bir `Row` içinde metin veya ikon alanlarını ayırmak için.

### Kullanma

- Dikey akıştaki satırları bölmek için.
- Ebeveyn yüksekliği belirsizken sonsuz yükseklik beklemek için.
- Dekorasyon veya kart kenarı yerine kullanmak için.

### Önemli durumlar ve varyantlar

- `thickness` ve `color` alanları vardır.
- `SizedBox(height: double.infinity, width: thickness)` üretir; `Row` içinde `SizedBox(height: ...)` gibi sınırlı yükseklik verilmelidir.
- `indent` veya kendi başına margin özelliği yoktur.

### Erişilebilirlik ve platform

- Dekoratif çizgiyi `ExcludeSemantics` ile gizle.
- Yatay grupları mobilde gereksiz ince bölmelere ayırma; dar ekranda iki grubu alt alta geçirmek daha okunaklı olabilir.
- Masaüstünde geniş `Row` içinde çizgiye gereğinden fazla yükseklik verme.

## MiuixSmallTitle

14 dp kalın `subtitle` stilleri ve varsayılan `onBackgroundVariant` rengiyle, 28 dp yatay ve 8 dp dikey iç boşluk taşıyan bölüm başlığı.

### Kullan

- Ayar sayfasında bir kart grubunun üstünde bölüm adı göstermek için.
- Kartın sol kenarıyla hizalı kısa bir grup başlığı oluşturmak için.
- `textColor` yalnızca bölümün gerçekten vurgulanması gerektiğinde.

### Kullanma

- Sayfanın ana başlığı yerine.
- Her satırın üstünde tekrar eden etiket olarak.
- `insideMargin` varsayılanını ek kart dolgusuna ekleyip çift boşluk üretmek için.

### Önemli durumlar ve varyantlar

- İlk parametre `String text`; `textColor` ve `insideMargin` özelleştirilebilir.
- Varsayılan yatay iç boşluk 28, dikey 8 dp'dir.
- Altında `MiuixText` kullandığı için tipografi ve renk teması devralınır.

### Erişilebilirlik ve platform

- Başlık rolü için `Semantics(header: true)` ile sarmala; `MiuixSmallTitle` kendisi header semantiği üretmez.
- Çok uzun bölüm adında iki satıra kaymayı ve kartla hizayı test et.
- Masaüstünda bölüm başlığını sütun başlangıcıyla, mobilde güvenli alan ve sayfa dolgusuyla hizala.

```dart
Semantics(
  header: true,
  child: MiuixSmallTitle('Bildirimler'),
)
```

## MiuixBasicComponent

Başlangıç slotu, başlık/özet, bitiş slotu ve alt alanı olan; minimum 56 dp yüksekliğinde ve tam genişlikte çalışan temel liste satırı.

### Kullan

- Bir ayar/liste satırının ana içerik iskeleti için.
- `startAction` ikon, `endActions` değer/rozet ve `bottomAction` geniş kontrol yerleştirmek için.
- `onClickLabel` ve `role` ile özel bir tercih satırı oluşturmak için.

### Kullanma

- Kartın kendisi veya bölüm başlığı yerine.
- Çok uzun özet, birden çok satır eylem veya karmaşık form için.
- İçindeki switch zaten etkileşimliyken satırın tamamını farkında olmadan aynı eyleme bağlamak için.

### Önemli durumlar ve varyantlar

- `title`, `summary`, `content`, `startAction`, `endActions`, `bottomAction` vardır.
- `insideMargin` varsayılanı `EdgeInsets.all(16)`; `enabled` varsayılanı `true`.
- Etkinlik için `enabled` true ve `onClick` null değil olmalıdır; `holdDownState` dış kaynaklı basılı görünümü zorlar.
- `role`: `button`, `checkbox`, `radioButton`, `switchControl`, `tab`, `dropdownList`; `onClickLabel` özel eylem adıdır.
- Yan slotlar varsa özel render düzeni başlangıç öğesini, bitiş için kalan genişliğin en fazla %60'ını ve merkezi kalan alanı ölçer.

### Erişilebilirlik ve platform

- `Semantics(container: true)` ve etkin/tıklanabilir rol bilgisi vardır; `onClickLabel` eklenebilir.
- `checkbox`, `radioButton`, `switchControl` rollerinde satır semantiği `checked` değerini gerçek seçim durumundan dinamik olarak çözmez; iç kontrolün ve özel satırın durumunu ayrıca test et.
- Dekoratif ikonda semantik yok; anlamlı ikonda `contentDescription` kullan.
- Mobilde uzun değerler için kısaltma/ikinci satır, masaüstünde satır genişliği sınırı ve klavye sırası önemlidir.

```dart
MiuixCard(
  child: Column(
    children: [
      MiuixBasicComponent(
        title: 'Wi-Fi',
        summary: 'Bağlı',
        insideMargin: const EdgeInsets.all(16),
        onClick: openWifiSettings,
      ),
      const MiuixHorizontalDivider(),
      MiuixBasicComponent(
        title: 'Sürüm',
        summary: '1.4.0',
        insideMargin: const EdgeInsets.all(16),
      ),
    ],
  ),
)
```
