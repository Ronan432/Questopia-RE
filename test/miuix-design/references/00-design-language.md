# Miuix Tasarım Dili

## 1. Görsel kimlik

Miuix; yumuşak squircle köşeler, sakin yüzeyler, kısa metinler, güçlü tipografi hiyerarşisi ve yay tabanlı hareket ile HyperOS/MIUIX hissini oluşturur. Tasarımı “Material’e renkli buton eklemek” olarak değil, tutarlı bir liste ve ayar sistemi olarak düşün.

### Temel ilkeler

- **Sakinlik:** Her ekranda tek bir baskın aksiyon ve tek bir ana içerik akışı bulunur.
- **Gruplama:** İlgili işlemler kart içinde toplanır; farklı bölümler `MiuixSmallTitle` ile ayrılır.
- **Anlaşılırlık:** İkonlar metinle desteklenir; kritik aksiyonlar yalnızca ikonla ifade edilmez.
- **Süreklilik:** Squircle, renk rolleri, metin stilleri ve motion paketten gelir; ekranlar arasında sabitlenir.
- **Platform uyumu:** Mobil dokunma, masaüstü hover/focus ve pencere davranışı ayrı değerlendirilir.

## 2. Renk sistemi

Renkleri `MiuixTheme.of(context).colors` üzerinden kullan.

| Rol | Kullanım | Kullanma |
|---|---|---|
| `primary` | Seçili durum, ana aksiyon, bağlantı | Büyük arka plan boyamak veya her öğeyi vurgulamak |
| `onPrimary` | Primary yüzey üzerindeki içerik | Normal metin rengi olarak |
| `secondary` | İkincil vurgu ve destekleyici durum | Primary ile rekabet eden aksiyon |
| `surface` | Sayfa ve kart yüzeyleri | Her katmanı farklı sabit renkle boyamak |
| `onSurface` | Ana içerik metni ve ikonlar | Düşük kontrastlı soluk metin |
| `onSurfaceVariantSummary` | İkincil açıklama ve özet | Uzun kritik metin |
| `error` | Hata, destructive aksiyon | Normal uyarı veya süs rengi |
| `outline` / ilgili rol | Ayırıcı ve sınır | Güçlü kart kenarı gerektirmeyen yerde |

### Kurallar

- Renk anlamını koru: primary her yerde aynı işlevi, error her yerde aynı riski anlatır.
- Sabit `Color(0xFF...)` yerine tema rolünü kullan.
- Cam efekti arkasındaki içerik okunabilir kalmalıdır; blur ile kontrastı düşürme.
- Dark theme’de siyah yerine `surface`; açık theme’de beyaz yerine yine tema yüzeyini kullan.
- Durum rengi tek başına yeterli değildir; ikon, metin veya şekille destekle.

## 3. Tipografi

`MiuixTheme.of(context).textStyles` stillerini kullan.

| Stil amacı | Tercih |
|---|---|
| Sayfa başlığı | App bar title stili |
| Bölüm başlığı | `MiuixSmallTitle` |
| Liste başlığı | Başlık/ağırlık stili |
| Ana içerik | Body stili |
| İkincil açıklama | Özet/variant body stili |
| Buton etiketi | Butonun varsayılan tipografisi |

### Kurallar

- Font boyutunu doğrudan pikselle sabitleme.
- Aynı satırda birden çok başlık boyutu kullanma.
- Uzun Türkçe metinlerde kelime kırpma yerine anlamlı kısaltma veya ikinci satır kullan.
- `MiuixText` ile temel metin stillerini koru; her yerde ham `Text` kullanmak gerekmez.
- Büyük harf, italik ve ağır font ağırlığını tasarım aksanı olarak değil, gerçek anlam ihtiyacı olduğunda kullan.

## 4. Şekil ve squircle

Miuix yüzeyleri `MiuixSquircleBorder` ile yumuşak ama köşeli görünür.

- Kart, buton, input ve popup yüzeylerinde paketin squircle border’ını kullan.
- `ClipRRect` ile birebir squircle taklit etme; içerik kırpma gerekiyorsa uygun squircle clipping yaklaşımını kullan.
- Köşe yarıçapını bileşenin boyutuna göre tutarlı tut; küçük öğede aşırı yuvarlak, büyük öğede aşırı keskin olmasın.
- Daire, sekme ve ikon gibi özel şekilleri genel kart şekline zorla.
- Cam efektli OS4 yüzeylerde shape ve border’ı aynı glass sistemi içinde çöz.

## 5. Yüzey, yükseklik ve ayırıcı

- Sayfa zemini `surface`; gruplar `MiuixCard`.
- Gölge yerine önce yüzey, sınır ve boşlukla hiyerarşi kur.
- `MiuixHorizontalDivider` satır gruplarını, `MiuixVerticalDivider` yalnızca gerçek yatay ayrımı olan alanları böler.
- Her satıra kutu çizme; liste görünümünü kart içinde topla.
- Floating toolbar, FAB ve popup yalnızca gerçekten yüzen katman olduğunda kullanılır.

## 6. Boşluk ve yerleşim

- Ekran kenarlarından tutarlı iç boşluk bırak; 12–16 dp başlangıç değerleri yaygındır.
- Bölümler arasında satır içi boşluktan daha büyük boşluk kullan.
- Liste satırında başlık, özet ve değer hizasını koru.
- Mobilde tek sütun; masaüstünde rail + sınırlı içerik genişliği kullan.
- Uzun ekranlarda içeriği 720 dp gibi okunabilir bir genişliğe sınırla.
- Boşlukla hizalama yap; çizgi veya arka plan rengiyle hizalama taklit etme.

## 7. Hareket

- Hareket durum değişimini açıklar: hover, pressed, selected, expanded, dismissed.
- Yay tabanlı geçişler `MiuixMotion` ve ilgili spring altyapısından gelir.
- Her öğeye farklı süre verme; aynı eylem aynı ritimde olur.
- Kullanıcı azaltılmış hareket istiyorsa animasyonu azalt veya kapat.
- Sürekli dönen, nefes alan veya dikkat dağıtan animasyon kullanma.
- Sayfa geçişinde geriye dönük hareketi koru; rastgele slide/fade karıştırma.

## 8. İkonlar

- `MiuixIcon` + `MiuixBasicIcons` / `MiuixExtendedIcons` kullan.
- İkon kalınlığı, rengi ve boyutu komponentin varsayılanına uy.
- Icon-only aksiyonda tooltip ve semantik etiket zorunludur.
- Aynı eylem için aynı ikonu kullan; farklı eylemler için birbirini karıştıran ikon seçme.
- Destructive ikonları yalnızca gerçekten destructive aksiyonlarda kullan.
- Metinli butonda gereksiz ikon ekleme.

## 9. Bileşen anatomisi

### Buton

Etiket merkezde, yatay padding yeterli, pressed/hover/disabled durumları açık. Primary buton yalnızca ekranın ana aksiyonıdır.

### Liste satırı

Sol tarafta isteğe bağlı ikon; ortada başlık ve kısa özet; sağda değer, switch, chevron veya aksiyon. Satır tümüyle tıklanabilirse içindeki switch ayrı etkileşimliyse çift davranış belirtilmelidir.

### Input

Görünür etiket, alan, yardım/hata metni ve isteğe bağlı trailing aksiyon. Placeholder etiketin yerine geçmez.

### Kart

İlgili öğeleri tek yüzeyde toplar; kart içinde kart kullanma.

### App bar

Sayfa başlığı, isteğe bağlı geri/navigation aksiyonu ve birkaç kısa aksiyon. Çok sayıda aksiyonu toolbar’a taşı.

### Popup / sheet

Net başlık, kısa açıklama, seçim veya aksiyon listesi ve belirgin kapatma yolu. İç içe modal açma.

## 10. Erişilebilirlik

- Dokunma hedeflerini en az 48 dp tut.
- Renk dışında metin, ikon ve durum göstergesi kullan.
- Kontrastı cam efekti ve disabled durumda yeniden kontrol et.
- Klavye ile tüm aksiyonlara erişim ve görünür focus sağla.
- `Semantics` ile icon-only buton, switch, slider ve özel preference durumlarını adlandır.
- Hata mesajını ilgili alanla ilişkilendir.
- Hareket azaltma tercihini destekle.

## 11. Mobil ve masaüstü farkları

| Konu | Mobil | Masaüstü |
|---|---|---|
| Ana navigasyon | `MiuixNavigationBar` | `MiuixNavigationRail` |
| Alt işlem paneli | `MiuixOverlayBottomSheet` | `MiuixWindowBottomSheet` |
| Etkileşim | Dokunma ve büyük hedefler | Hover, focus, kısayollar |
| İçerik genişliği | Tek sütun | Sınırlı, okunabilir alan |
| Cam efekti | Performansı dikkatli kullan | Daha geniş backdrop ile değerlendir |
| Klavye/IME | Odak ve ekran kaplaması | Tab sırası ve kısayollar |

## 12. Sık yapılan tasarım hataları

- Her butonu primary yapmak.
- Icon-only aksiyonlara tooltip vermemek.
- Preference bileşenini genel içerik kartı gibi kullanmak.
- Sekmeleri ardışık işlem adımlarına dönüştürmek.
- Snackbar’ı kalıcı hata mesajı yapmak.
- Cam efekti üzerine düşük kontrastlı metin koymak.
- Sabit renk, font ve animasyon süreleri kullanmak.
- Mobil listeyi masaüstünde ekran genişliğine boşaltmak.
- Destructive aksiyonu onaysız ve geri alınamaz yapmak.
- Klavye, IME ve uzun Türkçe metinleri test etmemek.
