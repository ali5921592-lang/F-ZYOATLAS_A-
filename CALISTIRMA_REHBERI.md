# Telefonda Çalıştırma — Adım Adım

Bu artık eksiksiz, çalıştırılabilir bir Flutter projesi (`main.dart` dahil).
Şu an tek ekranı var: AI Fizyo Asistan (diğer ekranlar eklenmedi).

## Gereken tek şey: bilgisayarınıza Flutter SDK kurmak
(Windows, Mac veya Linux — hepsinde çalışır. Android telefon için Mac gerekmez.)

### 1) Flutter'ı kurun (bir kere yapılır)
- https://docs.flutter.dev/get-started/install adresine gidin
- İşletim sisteminize uygun kurulumu indirip talimatları izleyin
- Kurulum bitince terminalde şunu çalıştırıp kontrol edin:
```
flutter doctor
```

### 2) Projeyi açın
Bu zip'i bilgisayarınıza indirip bir klasöre çıkarın, sonra terminalde
o klasöre girin:
```
cd fizyoatlas_ai
flutter pub get
```

### 3) Gradle wrapper'ı oluşturun (yerelde bir kez)
`android/` klasörü zaten projede (Flutter 3.24, Kotlin 2.1.0, Gradle 8.7
ile hazırlandı), sadece binary wrapper jar repo'da tutulmuyor:
```
cd android
gradle wrapper --gradle-version 8.7 --distribution-type all
cd ..
```
(Sisteminizde `gradle` yoksa Android Studio'da `android/` klasörünü bir
kez açmanız yeterli — IDE otomatik indirir.)

### 4) Telefonunuzu bağlayın
**Android:**
1. Telefonda Ayarlar > Telefon Hakkında > "Yapı Numarası"na 7 kez
   dokunun (Geliştirici Seçenekleri açılır)
2. Ayarlar > Geliştirici Seçenekleri > "USB Hata Ayıklama"yı açın
3. Telefonu USB kabloyla bilgisayara bağlayın, telefonda çıkan
   izin isteğini onaylayın

**iPhone:** Mac + Xcode gerekir, ayrıca Apple Developer hesabı ile
cihaz kaydı yapılması gerekir (bu adım Android'den daha uzun).

### 5) Çalıştırın
```
flutter devices
```
Telefonunuzun listede göründüğünü doğrulayın, sonra:
```
flutter run
```
Uygulama birkaç dakika içinde derlenip telefonunuzda açılacak.

## Notlar
- AI Asistan ekranındaki gerçek yapay zeka cevapları için geçerli bir
  API anahtarı/backend gerekir (`ai_assistant_repository.dart` içinde
  şu an yer tutucu var). Anahtar olmadan da uygulama açılır, kırmızı
  bayrak/tetikleyici mantığı çalışır; sadece AI'nin ürettiği serbest
  metin cevabı yerine hata mesajı görürsünüz.
- Telefonsuz, hızlıca önizlemek isterseniz bilgisayarınızda
  `flutter run -d chrome` ile tarayıcıda da açabilirsiniz.
