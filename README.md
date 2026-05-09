# 🇹🇳 Tunus Arapçası — Günlük İfadeler

Sosyal sorumluluk projeleri için gittiğim Tunus’ta, yerel lehçe olan Darija’yı öğrenmenin zorluğunu bir fırsata dönüştürdüm. Flutter ile geliştirdiğim bu mobil uygulama, Türkçe konuşan kullanıcıların Tunus günlük hayatına hızla adapte olmasını sağlıyor. İçeriğinde yüzlerce ifadenin sesli ve yazılı karşılığını barındıran bu araç, kültürel etkileşimi teknolojiyle desteklemek amacıyla tasarlandı.

---

## ✨ Özellikler

- 📖 **Kategorilere göre filtreleme** — Selamlama, yemek, ulaşım, acil durum ve daha fazlası
- 🔍 **Üç dilli arama** — Türkçe, Latin okunuş veya Arap alfabesiyle arama yapabilirsiniz
- 🔊 **Sesli telaffuz** — `flutter_tts` ile Tunus Arapçası (ar-TN) sesi; cihaz desteklemiyorsa otomatik olarak standart Arapçaya geri döner
- ⭐ **Favoriler** — Sık kullandığınız ifadeleri kaydedin; tercihler cihazda kalıcı olarak saklanır
- ⚙️ **Ses ayarları** — Konuşma hızı ve perde ayarını dilediğiniz gibi özelleştirin
- 📱 **Material 3 tasarım** — Temiz, modern ve sade arayüz

### Gereksinimler

| Araç        | Sürüm                |
| ----------- | -------------------- |
| Flutter     | ≥ 3.x (SDK `^3.8.1`) |
| Dart        | `^3.8.1`             |
| Android SDK | API 21+              |

### Adımlar

```bash
# Repoyu klonlayın
git clone https://github.com/KULLANICI_ADI/tunusian_arabic.git
cd tunusian_arabic

# Bağımlılıkları yükleyin
flutter pub get

# Uygulamayı çalıştırın
flutter run
```

---

## 🛠️ Kullanılan Teknolojiler

| Paket                                                               | Amaç                                     |
| ------------------------------------------------------------------- | ---------------------------------------- |
| [`flutter_tts`](https://pub.dev/packages/flutter_tts)               | Sesli telaffuz (Text-to-Speech)          |
| [`flutter_bloc`](https://pub.dev/packages/flutter_bloc)             | Durum yönetimi (BLoC / Cubit)            |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | Favori ifadelerin kalıcı saklanması      |
| [`equatable`](https://pub.dev/packages/equatable)                   | Durum nesnelerinin değer karşılaştırması |

---

## 📂 Proje Yapısı

```
tunusian_arabic/
├── lib/
│   └── main.dart          # Tüm uygulama kodu (widget'lar, Cubit, modeller)
├── assets/
│   └── data/
│       └── phrases.json   # İfade veritabanı (Türkçe, Latin, Arapça)
└── pubspec.yaml
```

---

## 📝 Veri Formatı

`assets/data/phrases.json` dosyası aşağıdaki yapıdaki nesnelerden oluşur:

```json
{
  "cat": "Selamlama",
  "tr": "Merhaba",
  "latin": "Aslema",
  "ar": "أسلامة"
}
```
