# Questopia Miuix Devam Gorevi

Bu dosya, 27 Kasim 2026 gecesi yapilan Miuix duzeltmelerinden sonra kalan isleri
bir sonraki ajana devretmek icin yazildi. Once bunu, sonra `AGENTS.md` dosyasini,
sonra `miuix-design/SKILL.md` dosyasini oku. Celiskide `AGENTS.md` kazanir.

## 0. Ortam ve Calistirma

- Proje: `/workspace/projects/Questopia-RE`
- Dogru SDK: `/tmp/flutter_sdk/flutter/bin/flutter` (Flutter 3.50.1, Dart 3.14.0)
- Her komutta `PUB_CACHE=/tmp/opencode/pubcache` kullan.
- `/opt/flutter` ve `/tmp/flutter` eski (Dart 3.5.4); bagimlilik cozumunu bozar, kullanma.
- Analiz komutu:

```bash
cd /workspace/projects/Questopia-RE
PUB_CACHE=/tmp/opencode/pubcache /tmp/flutter_sdk/flutter/bin/flutter analyze --no-fatal-infos
```

- Son durum: 0 error, 0 warning, 83 info. Info'larin hepsi yeni SDK'nin
  `package:flutter/material.dart` deprecation uyarisidir; bu gorev kapsaminda degil.
- `flutter test` kesinlikle yasak. Flutter build komutu da bu tasarim testi
  asamasinda yasak (AGENTS P9). Sadece `flutter analyze` calistir.
- `git push` yasak. Kullanici kendisi push edecek.

## 1. Degismez Kurallar

- Sadece istenen isi yap. Temizlik, refactor, ekstra restyling yok (AGENTS P2, P5).
- Ayni is icin iki varyant uretme (P3). Bitisik tasarim denemesi yapma (P7).
- Tum kullanici metinleri `app_en.arb` ve `app_ru.arb` icinde olmali; ekranda
  hardcoded string olmaz. Erisim `AppLocalizations.of(context)!` ile.
- Ampersand karakteri yasak; "and" veya "ve" yaz.
- Her kaynak dosya 300 satirin altinda kalmali. Buyuyen dosyayi alt widget
  dosyalarina bol.
- Kod yorumlari Ingilizce. Commit mesaji kullaniciya donuk, sade Ingilizce;
  dosya adi, yol, kod kimligi ve emoji yok.
- Mevcut calisan davranisi bozma. Her degisiklik sonrasi analiz calistir.

## 2. Bu Oturumda Tamamlananlar (bu commit ile geliyor)

1. Alt navigasyon cubugu (`lib/core/widgets/miuix_nav_bar.dart`)
   - Aktif pill eski committeki `secondaryContainer` rengine donduruldu.
   - Secili ikon `onSecondaryContainer`, secili olmayan `onSurfaceVariantActions`.
   - Cubuk yuksekligi 58, ikon boyu 24.
   - Tum `HapticFeedback` cagrilari kaldirildi.
   - Uzun basinca ve suruklerken %10 kuculme korundu; renk artik degismiyor.
2. Arama (`lib/features/library/presentation/widgets/miuix_library_shell.dart`)
   - Ozel `_MiuixSearchField` yerine `MiuixSearchBar` + `MiuixInputField` kullanildi.
   - Dis aksiyon `MiuixTextButton(cancelLabel, onPressed: onClear)`.
   - `MiuixInputField` kendi controller'ini yonetir; dis controller yok.
3. Sayfalama (`lib/features/library/presentation/widgets/catalog_pagination_bar.dart`)
   - Ozel primary renkli butonlar yerine varsayilan (secondary) `MiuixButton`.
   - Ikon 16, yukseklik 40, min genislik 88, haptik kaldirildi.
4. Blur ayari (`lib/features/settings/presentation/sections/miuix_appearance_general_section.dart`)
   - `steps: 18` yerine `steps: 9`; 10, 20, ..., 100 olmak uzere 10 secenek.
5. Ayar ikonlari (`lib/features/settings/presentation/widgets/miuix_settings_tiles.dart`)
   - `miuixSettingsIcon` artik 30x30, kose yaricapi 9, renkli kutu ve beyaz ikon.
   - Renkler `_kSettingsIconColors` haritasinda; bilinmeyen ikon `primary` alir.
6. Ayarlar ust bar (`miuix_library_shell.dart`)
   - `selectedTab == 2` iken blur zorunlu; yuzde `navBarBlurPercent`, kapaliysa 70.
7. Alt sayfa yuzeyi (`lib/core/helpers/sheet_helper.dart`)
   - Arka plan Miuix `colors.background`, 28 kose, kenarlik kaldirildi.
   - Baslik artik ortalanmis Miuix `title4` satiri; pill arka plani yok.
   - Tutamac 45 -> 55 px, 4 -> 4.6 px; haptik yok.
8. Sistem cubuklari
   - `lib/features/game/presentation/game_screen.dart`: `immersiveSticky` kaldirildi,
     her zaman `SystemUiMode.edgeToEdge`.
   - `immersive mode` ayari artik oyun basligini gizli baslatiyor
     (`_isHeaderVisible = !settings.isImmersiveMode`), sistem cubuklarini gizlemiyor.
   - `lib/features/library/presentation/library_screen.dart`: kutuphane acilisinda
     `edgeToEdge` tekrar uygulaniyor.

## 3. Dogrulama Adimlari

1. `flutter analyze --no-fatal-infos` calistir; error ve warning olmamali.
2. Uygulamayi kullanici build edip test edecek. Sen build alma.
3. Asagidaki ekran goruntuleriyle karsilastir:
   - `Screenshot_2026-11-27-02-09-47-690_com.android.deskclock.png`
     Alt navigasyon cubugu referansi: koyu yuzey, acik gri aktif pill, beyaz
     ikon ve etiket, yaklasik 57-58 yukseklik.
   - `Screenshot_2026-11-27-02-17-03-613_com.android.settings.jpg`
     Renkli yuvarlak-kare ayar ikonlari referansi.
   - `Screenshot_2026-11-26-22-25-25-933_com.questopia.re.jpg`
     Eski hatali durum: bozuk arama, mavi filtre cipleri, kotu ileri/geri,
     gizli durum cubugu.

## 4. Kalan Isler (oncelik sirasiyla)

### 4.1. Miuix bildirimsel overlay gecisi (en buyuk is)

Kullanici "cekmece menuleri yasak, Miuix'teki dogru hallerini kopyala" dedi.
Su an `showQuestopiaSheet` hala `ModalBottomSheetRoute` uzerine kurulu; sadece
yuzeyi Miuix'e benzetildi. Gercek Miuix cozumu bildirimsel overlay:

- `MiuixOverlayBottomSheet` ve `MiuixOverlayDialog` `package:flutter_miuix/miuix.dart`
  icinden gelir.
- Bunlar `show` bool ile calisan widget'lardir; agacta yasamalari ve root
  scaffold popup host'unu kullanmalari gerekir.
- `MiuixOverlayBottomSheet` alanlari: `show`, `title`, `startAction`, `endAction`,
  `backgroundColor`, `enableWindowDim`, `dimColor`, `surfaceBuilder`,
  `cornerRadius`, `sheetMaxWidth`, `onDismissRequest`, `onDismissFinished`,
  `outsideMargin`, `insideMargin`, `defaultWindowInsetsPadding`,
  `dragHandleColor`, `allowDismiss`, `enableNestedScroll`,
  `renderInRootScaffold`, `content`.
- Masaustu icin `MiuixWindowBottomSheet` var; mobil davranisi masaustunde taklit etme.
- Varsayilanlar: kose 28, max genislik 640, ic bosluk `Size(24, 0)`,
  arka plan `colors.background`, tutamac `onSurfaceVariantSummary` alpha 0.2.

Onerilen yaklasim: her cagri noktasini stateful bir host'a tasima yerine, once
en cok kullanilan 3-4 sheet'i (ayar secicileri, filtre, ice aktarma) tek tek
donustur. Her donusumde `show` durumunu ekranin state'inde tut, `onDismissRequest`
ile kapat, `onDismissFinished` ile state'i temizle. Eski `showQuestopiaSheet`
cagrilarini ayni anda degistirme; parca parca ilerle ve her adimda analiz calistir.

Kabul kriteri: en az ayar secici sheet'leri ve katalog filtre sheet'i gercek
`MiuixOverlayBottomSheet` ile acilmali; gorunen davranis ve geri tusu ayni kalmali.

### 4.2. Navigasyon cubugu birebir hizalama

- `lib/core/widgets/miuix_nav_bar.dart` mevcut durumu referans 1'e yaklasti.
- Kullanici hala "tam istedigim gibi degil" derse once olcu ve renk karsilastir:
  cubuk yuksekligi, pill yatay/dikey boslugu, ikon-etiket araligi, etiket punto.
- Rengi degistirme; `secondaryContainer` ve `onSecondaryContainer` kalsin.
- Uzun basinca kuculme ve surukleyerek secme korunmali.
- Haptik ekleme.

### 4.3. Arama davranisi

- Yeni `MiuixSearchBar` odak alinca aciliyor, `Cancel` ile kapaniyor.
- Kontrol et: katalogda arama gecmisi secildiginde `_searchQuery` alana yansiyor mu,
  `MiuixInputField` kendi controller'i ile senkron kaliyor mu.
- Arama sonucu filtreleme `onChanged` uzerinden ayni kalmali.
- Arama cubugu ust barda tasma veya iki satira kirilma yapmamali.

### 4.4. Sistem cubuklari

- Oyun icinde ve kutuphanede durum cubugu ile navigasyon cubugu gorunmeli.
- `immersiveSticky` hicbir yerde kalmamali; `grep -rn "immersiveSticky" lib` bos olmali.
- Oyun basligi immersive ayari ile gizli basliyor; kullanici dokununca geri geliyor.
- Geri donuste `edgeToEdge` korunuyor mu kontrol et.

### 4.5. Onceki/sonraki butonlari

- `catalog_pagination_bar.dart` artik varsayilan `MiuixButton`.
- Kullanici hala kotu derse genislikleri esitle, sayfa gostergesini ortada tut,
  disabled rengi `disabledOnSecondaryVariant` kalsin.
- Primary renge geri donme.

### 4.6. Blur ayari

- 10-100 arasi 10 adim tamam. `setNavBarBlurPercent` zaten 10-100 araligina
  kenetliyor (`lib/core/providers/settings_provider.dart`).
- `GlassEffect.getSigma` 10-100 araligini 1-18 sigma'ya esliyor; degistirme.

### 4.7. Renkli ayar ikonlari

- `_kSettingsIconColors` haritasini yeni ikon adlari eklenirse guncelle.
- Renkler HyperOS tarzi canli ama beyaz ikonla okunakli olmali.
- Karanlik temada kutular parlamamali; gerekirse tonlari koyulastir.

### 4.8. Ayarlar ust blur

- `miuix_library_shell.dart` icinde `selectedTab == 2` icin blur zorunlu.
- Kullanici "ayarlarin en tepesi" derken baska bir alani kastediyorsa
  `miuix_settings_screen.dart` icindeki `isInline` dalina bak; ayri ekran
  kullaniliyorsa `MiuixSmallTopAppBar` uzerine ayni cam efektini uygula.

## 5. Bilinen Tuzaklar

- `MiuixTextButton` ilk argumani konumsal `String text`; `child:` parametresi yok.
- `MiuixButton` ise `child:` alir. Ikisini karistirma.
- `MiuixColors` icinde `onSurfaceVariant` yok. Kullanilabilir olanlar:
  `onSurface`, `onSurfaceVariantActions`, `onSurfaceVariantSummary`,
  `onSecondaryContainer`, `secondaryContainer`.
- `MiuixInputField` dis controller kabul etmez; `query` ve `focusNode` ile calisir.
- `MiuixSearchBar` `inputField`, `onExpandedChange`, `content` ister.
- Sheet ve dialogda `insidePadding` degil `insideMargin` kullanilir.
- `M3ETheme` icin `package:material_3_expressive/material_3_expressive.dart`
  importu gerekir.
- `flutter analyze` yaklasik 1.5-2.5 dakika surer; sabirli ol.
- Repo kokunde `miuix-design/` bir skill klasoru; once `SKILL.md` ve
  `references/45-menus-pickers.md`, `60-feedback-overlays.md` oku.
- Ekran goruntuleri ve `miuix-design/` su an takip edilmiyor; commit'e ekleme.

## 6. Degisen Dosyalar (bu commit)

- `lib/core/widgets/miuix_nav_bar.dart`
- `lib/features/library/presentation/widgets/miuix_library_shell.dart`
- `lib/features/library/presentation/widgets/catalog_pagination_bar.dart`
- `lib/features/library/presentation/library_screen.dart`
- `lib/features/settings/presentation/sections/miuix_appearance_general_section.dart`
- `lib/features/settings/presentation/widgets/miuix_settings_tiles.dart`
- `lib/core/helpers/sheet_helper.dart`
- `lib/features/game/presentation/game_screen.dart`
- `task.md`
- `miuix.md`

## 7. Son Durum (27 Kasim 2026)

- **Katalog & Ana Sayfa:** KoWSU tarzi 2 kartli bento (`Installed Games` yesil tik + `Favorites` kalp filigranli/kirmizi aktif), dairesel kalin `+` FAB, `MiuixCatalogGameRow` liste tasarimi, `IndexedStack` ile animasyonsuz/kaydirmasiz sekme gecisi.
- **Arama & Ust Cubuk:** `SuperSearchBar.kt` kapsul arama (`SizedBox(height: 45)`, normal kalinlik `Cancel`), Katalog ve Ayarlar'da kaydirinca daralan ve sag ustte kalin arama ikonuna donusen baslik + `GlassEffect` blur.
- **Ayarlar & Oyun Menuleri:** `SingleChildScrollView` + `Column` ile `MiuixOverlayDropdownPreference` dispose hatasi cozuldu; Envanter, Kayit Slotlari, Hile Motoru, Notlar ve Katalog Arama Gecmisi Miuix bilesenlerine gecirildi.
- **Renderer:** `AndroidManifest.xml` icinde `EnableImpeller = false` (Skia) ayarlandi (yeni APK/cold run'da aktif olur).
- **Dokumantasyon:** Tum Miuix mimarisi, tuzaklar ve bilesen eslesmeleri `miuix.md` dosyasina eklendi.
