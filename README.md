# 🇹🇳 Tunus Arapçası — Günlük İfadeler

Tunus Arapçası (Darija) öğrenmek isteyenler için geliştirilmiş, Türkçe arayüzlü bir Flutter mobil uygulaması. Günlük hayatta kullanılan yüzlerce ifadeyi sesli telaffuz, Latin okunuş ve Arap alfabesiyle birlikte sunar.

---

## ✨ Özellikler

- 📖 **Kategorilere göre filtreleme** — Selamlama, yemek, ulaşım, acil durum ve daha fazlası
- 🔍 **Üç dilli arama** — Türkçe, Latin okunuş veya Arap alfabesiyle arama yapabilirsiniz
- 🔊 **Sesli telaffuz** — `flutter_tts` ile Tunus Arapçası (ar-TN) sesi; cihaz desteklemiyorsa otomatik olarak standart Arapçaya geri döner
- ⭐ **Favoriler** — Sık kullandığınız ifadeleri kaydedin; tercihler cihazda kalıcı olarak saklanır
- ⚙️ **Ses ayarları** — Konuşma hızı ve perde ayarını dilediğiniz gibi özelleştirin
- 📱 **Material 3 tasarım** — Temiz, modern ve sade arayüz

---

## 📸 Ekran Görüntüleri

> _(Yakında eklenecek)_

---

## 🚀 Kurulum ve Çalıştırma

### Gereksinimler

| Araç | Sürüm |
|---|---|
| Flutter | ≥ 3.x (SDK `^3.8.1`) |
| Dart | `^3.8.1` |
| Android SDK | API 21+ |

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

| Paket | Amaç |
|---|---|
| [`flutter_tts`](https://pub.dev/packages/flutter_tts) | Sesli telaffuz (Text-to-Speech) |
| [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) | Durum yönetimi (BLoC / Cubit) |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | Favori ifadelerin kalıcı saklanması |
| [`equatable`](https://pub.dev/packages/equatable) | Durum nesnelerinin değer karşılaştırması |

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

| Alan | Açıklama |
|---|---|
| `cat` | Kategori adı |
| `tr` | Türkçe karşılık |
| `latin` | Latin alfabesiyle okunuş |
| `ar` | Tunus Arapçasıyla yazılış |

---

## 🤝 Katkı

Her türlü katkı memnuniyetle karşılanır!

1. Fork'layın
2. Yeni bir dal oluşturun: `git checkout -b ozellik/yeni-ifadeler`
3. Değişikliklerinizi commit'leyin: `git commit -m 'feat: yeni ifadeler eklendi'`
4. Dalınızı push'layın: `git push origin ozellik/yeni-ifadeler`
5. Pull Request açın

---

## 📄 Lisans

Bu proje [MIT Lisansı](LICENSE) ile lisanslanmıştır.
