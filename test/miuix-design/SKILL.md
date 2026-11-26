---
name: miuix-design
description: Flutter_miuix 1.4.0 ile HyperOS/MIUIX tarzı arayüzler tasarlar ve uygular. Kullanıcı buton, form, liste, navigasyon, tema, animasyon, cam efekti veya başka bir miuix bileşeni sorduğunda; mevcut Flutter arayüzünü bu tasarım diline dönüştürürken kullan.
---

# Miuix Design Skill

## Amaç

Flutter uygulamalarında `flutter_miuix` bileşenlerini doğru hiyerarşi, tutarlı görsel dil ve platform kurallarıyla kullan. Bu skill yalnızca API adlarını değil, hangi bileşeni neden seçeceğini ve ne zaman kullanmayacağını da açıklar.

## Önce uygulanacak kurallar

1. `MiuixTheme.of(context)` renk, metin ve motion değerlerini al; sabit renk, font boyutu veya geçiş süresi uydurma.
2. Sayfa iskeleti için `MiuixScaffold` + `MiuixTopAppBar` kullan. İçeriği `MiuixCard`, `MiuixBasicComponent` ve preference bileşenleriyle grupla.
3. Görsel ağırlığı azaltan bileşeni seç: primary buton tek ve baskın; text/icon buton ikincil; FAB yalnızca tek yüzen ana aksiyon.
4. Squircle köşe için `MiuixSquircleBorder`; hareket için paketin motion/spring altyapısını kullan. `ClipRRect` ve rastgele `Duration` ile taklit etme.
5. Kullanıcı girdisini anlaşılır etiketle, dokunma hedeflerini koru, icon-only aksiyonlara tooltip ekle ve destructive aksiyonları geri bildirimle doğrula.
6. Önce mevcut sayfanın amacını belirle: ayar listesi mi, içerik ekranı mı, seçim mi, modal işlem mi? Buna uygun bileşen ailesini seç.
7. Referans dosyasındaki “Kullanma” kurallarını API uyumluluğu kadar önemli say.

## Bileşen seçim hızlı tablosu

| İhtiyaç | Tercih et | Kaçın |
|---|---|---|
| Ekranın tek ana aksiyonu | `MiuixButton` | Aynı ekranda birçok primary buton |
| Düşük önemli metin aksiyonu | `MiuixTextButton` | Kritik veya tek aksiyonun primary buton yerine geçmesi |
| Anlaşılır, tek ikonlu aksiyon | `MiuixIconButton` + tooltip | Belirsiz ikon, çok sayıda icon-only aksiyon |
| Tek yüzen ana aksiyon | `MiuixFloatingActionButton` | Form içinde, dialog içinde veya birden çok FAB |
| Ayar/satır listesi | `MiuixBasicComponent` veya uygun preference | Tercih bileşenini genel içerik kartı gibi kullanma |
| Kısa seçenek menüsü | `MiuixOverlayDropdownMenu` | Uzun formu veya çok seviyeli iş akışını menüye sıkıştırma |
| Sayısal, tarih veya renk seçimi | `MiuixSlider`, `MiuixNumberPicker`, `MiuixDatePicker`, `MiuixColorPicker` | Gereksiz gelişmiş renk uzayı veya aşırı seçenek |
| Renk seçimi | `MiuixColorPicker` + `MiuixColorPalette` | HSV/OkLab/OkLCH seçicisini anlamsız renk işi için kullanma |
| Mobil alt işlem paneli | `MiuixOverlayBottomSheet` | Uzun formu veya kritik onayı bottom sheet içine sıkıştırma |
| Masaüstünde bağlamsal panel | `MiuixWindowBottomSheet` | Mobil davranışı desktop pencerede taklit etme |
| Kısa geçici bilgi | `MiuixSnackbar` | Kalıcı veya kritik hata için snackbar |
| Kısa açıklama | `MiuixTooltipBox` + `MiuixPlainTooltip`; zengin açıklama için `MiuixRichTooltipBox` | Tooltip içine uzun talimat veya etkileşimli form koyma |
| Sekmeli aynı düzey içerik | `MiuixTabRow` | Ardışık adımları veya farklı navigasyon hedeflerini sekmeye dönüştürme |
| Masaüstü ana bölümler | `MiuixNavigationRail` | Çok sayıda alt sayfayı rail içinde gizleme |
| Mobil ana bölümler | `MiuixNavigationBar` | Aynı anda dörtten çok ana hedef |
| Cam efekti | OS4 glass bileşenleri veya `MiuixTextureBlur` | Düşük kontrast, ağır blur veya desteklenmeyen platformda zorunlu cam |

## Sayfa kompozisyonu

- `MiuixScaffold` içinde tek bir ana içerik akışı oluştur.
- Başlık ve kısa açıklama için `MiuixTopAppBar`; bölüm başlıkları için `MiuixSmallTitle` kullan.
- İlgili satırları `MiuixCard` içinde topla; satırlar arasında `MiuixHorizontalDivider` kullan.
- Tercih listelerinde başlık, özet, değer ve aksiyon aynı satırda kısa tutulur.
- Mobilde içerik tek sütun; masaüstünde `MiuixNavigationRail` + sınırlı içerik genişliği kullan.
- Uzun listelerde scrollbar, pull-to-refresh ve boş/yükleniyor/hata durumlarını ayrı tasarla.

## Buton hiyerarşisi

- Bir ekranda normalde tek primary aksiyon bulunur.
- `MiuixTextButton` ve `MiuixIconButton` aynı aksiyon için birlikte kullanılmaz; gerekiyorsa metin + ikon tek bileşende çözülür.
- Destructive aksiyonlar kırmızı/error vurgusu kullanır; yanlışlıkla tetarlemeyi önlemek için onay veya geri al sunar.
- Disabled durum yalnızca aksiyon gerçekten uygulanamazken kullanılır; loading varsa kullanıcıya ilerleme gösterilir.
- Icon-only butonlarda `MiuixTooltipBox` + `MiuixPlainTooltip` ve anlamlı `Semantics` etiketi kullan.

## Form ve tercih listeleri

- Etiketleri placeholder yerine görünür tut.
- `MiuixTextField` için Material ancestor bulundur; özel içerik ekranlarında `Material(type: MaterialType.transparency)` uygun olabilir.
- Switch açık/kapalı, checkbox çoklu seçim, radio tek seçim içindir; birbirinin yerine kullanma.
- Slider sürekli sayısal aralık, number picker ayrık veya hassas seçim içindir.
- Preference bileşenleri ayar/liste bağlamındadır; zengin içerik, grafik veya serbest form yerine kullanma.
- Klavye/IME, odak sırası ve hata mesajlarını mobil ile masaüstünde ayrı doğrula.

## Navigasyon ve katmanlar

- `MiuixNavigationBar` mobil ana hedefler, `MiuixNavigationRail` masaüstü ana bölümler içindir.
- `MiuixTabRow` aynı bağlamdaki görünümleri, `MiuixBreadcrumbBar` hiyerarşik içerik yolunu anlatır.
- Dialog onay/kısa karar, bottom sheet bağlamsal seçim/işlem, snackbar geçici bilgi içindir.
- Popup, dialog ve bottom sheet iç içe açma; odak kaybı ve geri tuşu davranışını test et.
- `MiuixFloatingToolbar` yalnızca gerçekten yüzen, bağlama duyarlı araç seti gerektiğinde kullan.

## Tema ve görsel dil

- Açık/koyu tema için `MiuixSystemTheme`; özel tema için `MiuixTheme` ve `MiuixThemeController`.
- Renk rollerini semantik kullan: primary ana aksiyon, error hata, surface yüzey, onSurface içerik.
- Metin boyutları için `MiuixTextStyles`; tipografi hiyerarşisini doğrudan font pikseliyle kurma.
- Motion yalnızca durum değişimini açıklamak için kullan; sürekli hareket ve gereksiz spring azaltır.
- Cam efekti arka planı gerçekten okunur bırakmalıdır; blur performansı ve düşük kontrast riski değerlendirilir.

## Platform ve performans

- Android’de dinamik renk varsa kullan; Linux/Windows/web’de seed color fallback beklenir.
- Shader tabanlı cam efektlerde Impeller/OpenGL ve düşük donanım performansını test et.
- Mobil dokunma hedefleri en az 48 dp olmalı; masaüstünde hover/focus durumları ayrı gösterilir.
- Küçük ekranda yatay taşma ve uzun etiketler için ellipsis/kısaltma stratejisi uygula.
- Türkçe karakterler ve uzun metinlerle layout testi yap.

## Bilinen tuzaklar

- `flutter_miuix 1.4.0` içindeki `MiuixScrollBar`, ilk layout sırasında animation controller değerini değiştirip `setState` tetikleyebilir. Bu projedeki çözüm `WidgetsBinding.instance.addPostFrameCallback` ile ilk değeri erteler.
- `MiuixTextField` içeren özel sayfalarda Material ancestor eksikliği hata verir.
- Overlay kapanırken animasyon dispose edilmiş olabilir; önce overlay’i kaldır, sonra controller/focus node temizle.
- Cam shaderları yalnızca ilgili paket varlıkları bundle edildiğinde çalışır; pubspec shader listesini koru.

## Doğrulama

- `flutter analyze --no-fatal-infos`
- `flutter test`
- Linux: `flutter build linux --release`
- Android: `flutter build apk --release`
- Cihaz: `adb install -r build/app/outputs/flutter-apk/app-release.apk`
- Her kategori sayfasını aç; boş, loading, error, disabled ve uzun metin durumlarını kontrol et.

## Referanslar

- `references/00-design-language.md` — tasarım tokenları, hiyerarşi ve kompozisyon.
- `references/10-buttons.md` — butonlar ve temel kart/satır bileşenleri.
- `references/20-inputs.md` — metin, seçim, slider, arama ve number picker.
- `references/30-display.md` — metin, rozet, ayırıcı ve başlık bileşenleri.
- `references/40-preferences.md` — ayar ve tercih listeleri.
- `references/45-menus-pickers.md` — dropdown, cascading menu, spinner, renk ve tarih seçiciler.
- `references/50-navigation.md` — scaffold, app bar, rail, tab ve breadcrumb.
- `references/60-feedback-overlays.md` — snackbar, tooltip, dialog, sheet, popup ve progress.
- `references/70-utility.md` — arama, scrollbar, pull-to-refresh ve surface.
- `references/80-theme-motion-icons.md` — tema, renk, tipografi, motion ve ikonlar.
- `references/90-foundation-blur-os4.md` — squircle, pressable, blur ve OS4 cam sistemi.
- `references/95-platform-testing.md` — platform farkları, bilinen hatalar ve test komutları.
