# Flutter DevTools Demo

Flutter DevTools'un sekmelerini canlı göstermek için hazırlanmış küçük bir uygulama.
Açılış menüsünde her DevTools sekmesi için ayrı bir ekran var.

| Ekran | DevTools sekmesi | Ne denenir |
|---|---|---|
| Sepet | Inspector, Debugger, Debug console, Logging | Taşma hatası ve `Expanded` ile düzeltme, breakpoint, `log()` kayıtları |
| Performance | Performance | "Yavaş build" anahtarı ile takılma (jank) üretme |
| CPU Profiler | CPU Profiler | `fib(36)` ağır hesabı, `UserTag` ile filtreleme |
| Memory | Memory | Bilinçli sızıntı (`static` liste), snapshot karşılaştırma |
| Network | Network | `HttpClient` ile GET isteği |
| Logging | Logging | Farklı seviyelerde `log()` ve `debugPrint` |

## Çalıştırma

```bash
flutter pub get
flutter run -d windows
```

Terminalde çıkan **DevTools** adresini tarayıcıda açın.

- Performance, CPU Profiler ve Memory ölçümleri için profile mod önerilir: `flutter run -d windows --profile`
  (profile modda Inspector ve Debugger sekmeleri görünmez).
- CPU Profiler ve Network sekmeleri web'de çalışmaz; Windows (veya Android/iOS) kullanın.
- Windows'ta derlemek için Visual Studio "Desktop development with C++" gerekir (`flutter doctor` ile kontrol edin).
- Network ekranı internet bağlantısı ister.

## Demo akışı

1. **Inspector:** Sepet > "Taşma hatası göster" aç, sarı-siyah bandı gör; "Düzelt (Expanded kullan)" ile düzelt.
2. **Performance:** Performance ekranında "Yavaş build" aç; frame chart'ta kırmızı frame'e tıkla, Frame Analysis'e bak.
3. **CPU Profiler:** Record'a bas, "Ağır hesabı çalıştır", Stop; Bottom Up'ta en üstte `fib`.
4. **Memory:** Diff Snapshots'ta snapshot al, "Sızıntı ekle"ye 5 kez bas, tekrar snapshot al ve karşılaştır; "Temizle" + GC ile bellek geri iner.
5. **Network:** "GET isteği at", istekte status 200 ve JSON cevabı.
6. **Debugger + Debug console:** `lib/sepet_sayfasi.dart` içinde `indirimliFiyat` satırına breakpoint koy, indirime bas, konsolda `onceki * 0.8` yaz.
7. **Logging:** İndirime iki kez bas, `SEPET` loglarında 400 → 320 → 256.
8. **App size:** `flutter build windows --analyze-size`, çıkan JSON'u DevTools > App Size'a yükle.

## Kaynak

[Flutter DevTools dokümantasyonu](https://docs.flutter.dev/tools/devtools)
