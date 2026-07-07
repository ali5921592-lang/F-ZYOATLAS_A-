# Release İmzalama (android/app/build.gradle zaten hazır)

`android/app/build.gradle` dosyasına signingConfig mantığı **zaten
eklendi** — `android/key.properties` dosyası varsa gerçek keystore ile,
yoksa debug imzasıyla derler. Yani aşağıdaki adımlardan sadece
keystore'u oluşturup secret'ları tanımlamanız yeterli; build.gradle'ı
elle düzenlemenize gerek yok.


## 1) Kendi keystore'unuzu oluşturun

```bash
keytool -genkey -v -keystore release-keystore.jks -keyalg RSA \
  -keysize 2048 -validity 10000 -alias upload
```

Oluşan `release-keystore.jks` dosyasını `android/app/` içine koyun
(bu dosya `.gitignore`'da olduğu için commit'lenmez).

## 2) Yerelde imzalı build almak için

`signing/key.properties.example` dosyasını `android/key.properties`
olarak kopyalayıp gerçek şifrelerinizle doldurun (bu dosya da
commit'lenmez).

## 3) GitHub Actions'ta imzalı build almak için

Keystore'u base64'e çevirip GitHub secret olarak ekleyin:

```bash
base64 -i android/app/release-keystore.jks | pbcopy   # Mac
base64 -w0 android/app/release-keystore.jks            # Linux
```

GitHub reposunda **Settings > Secrets and variables > Actions** altında:
- `KEYSTORE_BASE64` → yukarıdaki base64 çıktısı
- `KEYSTORE_PASSWORD` → keystore şifreniz
- `KEY_ALIAS` → `upload` (veya kullandığınız alias)
- `KEY_PASSWORD` → key şifreniz

Bu 4 secret tanımlıysa workflow otomatik olarak imzalı APK/AAB üretir.
