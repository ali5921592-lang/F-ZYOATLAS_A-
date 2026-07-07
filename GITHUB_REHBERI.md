# GitHub'a Yükleme ve Otomatik APK/AAB Rehberi

## 1) Projeyi açın
```bash
cd fizyoatlas_ai
flutter pub get
```

`android/` klasörü artık projede hazır (Flutter 3.24 uyumlu, AGP 8.5.0,
Kotlin 2.1.0, Gradle 8.7). Sadece iki şey sizin makinenizde otomatik
oluşturulacak (bilerek repo'ya eklenmediler, çünkü kişiye/makineye özel
veya binary dosyalar):

**a) `android/local.properties`** — Flutter SDK yolunuzu içerir, ilk
`flutter pub get` veya Android Studio'da projeyi açtığınızda otomatik
oluşur. Elle oluşturmanız gerekirse:
```properties
sdk.dir=/Users/KULLANICI_ADINIZ/flutter-sdk-yolunuz
flutter.sdk=/Users/KULLANICI_ADINIZ/flutter/bin/cache
```

**b) Gradle wrapper jar'ı** — repo'da tutulmuyor (binary dosya, Git
diff'lerinde anlamsız yer kaplar). Yerelde bir kere şunu çalıştırın:
```bash
cd android
gradle wrapper --gradle-version 8.7 --distribution-type all
cd ..
```
(Sisteminizde Gradle CLI yoksa: Android Studio'da `android/` klasörünü
bir kere açmanız yeterli, IDE wrapper'ı otomatik indirir.)

Bundan sonra normal şekilde çalıştırabilirsiniz:
```bash
flutter run
```

## 2) (Opsiyonel ama önerilir) Release imzalama
Play Store'a yüklenebilir gerçek bir AAB istiyorsanız `signing/` klasöründeki
`build.gradle.snippet.md` dosyasındaki adımları uygulayın. Uygulamazsanız da
CI çalışır, sadece üretilen APK/AAB "debug" imzalı olur (test için sorun
değil, Play Store için yeterli değil).

## 3) GitHub'a yükleyin
```bash
git init
git add .
git commit -m "İlk sürüm: FizyoAtlas AI"
git branch -M main
git remote add origin https://github.com/KULLANICI_ADINIZ/fizyoatlas-ai.git
git push -u origin main
```

## 4) Otomatik build nasıl tetiklenir
`.github/workflows/flutter_ci.yml` şu durumlarda otomatik çalışır:
- `main` dalına her `push`
- Her pull request (derleme bozulmuş mu diye test eder)
- Actions sekmesinden "Run workflow" ile manuel
- **`v` ile başlayan bir tag push'landığında** ayrıca bir GitHub Release
  açar ve APK/AAB dosyalarını doğrudan o release'e ekler:
  ```bash
  git tag v1.0.0
  git push origin v1.0.0
  ```

## 5) Derlenen dosyaları nereden indiririm?
- **Her push'ta:** Repo > **Actions** sekmesi > ilgili çalışma > en altta
  "Artifacts" bölümünden `fizyoatlas-ai-apk` ve `fizyoatlas-ai-aab` zip'lerini
  indirebilirsiniz.
- **Tag push'unda:** Repo > **Releases** sekmesinde APK ve AAB dosyaları
  doğrudan indirilebilir halde durur.

## 6) İmzalama secret'ları nereye eklenir
Repo > **Settings > Secrets and variables > Actions > New repository secret**:
- `KEYSTORE_BASE64`
- `KEYSTORE_PASSWORD`
- `KEY_ALIAS`
- `KEY_PASSWORD`

Detaylar `signing/build.gradle.snippet.md` içinde.

## Sırada ne var
- İlk push'tan sonra Actions sekmesinde build'in yeşil (başarılı) olduğunu
  doğrulayın; kırmızıysa "View logs" ile hatayı görüp bana iletebilirsiniz.
- Play Store'a yüklemeden önce imzalı AAB + `android/app/build.gradle`
  içindeki `applicationId`'yi kendi paket adınızla güncellemeyi unutmayın.
