# AI Fizyo Asistan Modülü — Entegrasyon Notları

## Gerekli paketler (`pubspec.yaml`)
```yaml
dependencies:
  flutter_riverpod: ^2.5.1
  http: ^1.2.0
  uuid: ^4.4.0
  url_launcher: ^6.3.0
```

## Akış
1. Kullanıcı mesaj gönderir → `AiChatNotifier.sendMessage`.
2. `TriageService.evaluate` çalışır:
   - **Kırmızı bayrak varsa** → AI'ye hiçbir istek atılmaz, doğrudan
     `SafetyBanner` gösterilir (`AppStrings.redFlagWarning`).
   - **Kırmızı bayrak yoksa** → `AiAssistantRepository` üzerinden
     LLM'e istek atılır, cevap sohbete eklenir.
   - Ek olarak, ağrı ≥7, süre >14 gün, tekrarlayan şikayet, kişiye
     özel program talebi veya manuel terapi/reformer pilates sorusu
     varsa `PhysioReferralCard` cevabın altına eklenir.

## Neden bu ayrım önemli
`RedFlagDetector` ve `TriageService` saf (side-effect'siz) sınıflardır —
UI'dan ve ağ katmanından tamamen bağımsız, bu yüzden birim testi çok
kolay: `TriageService().evaluate(userText: '...')` çağırıp sonucu
doğrudan assert edebilirsiniz.

## API anahtarı güvenliği
`ClaudeAiAssistantRepository` içindeki `apiKey` **asla** client'a
gömülmemeli. Gerçek üründe bu çağrı bir backend proxy (Cloud Function /
Firebase Functions) üzerinden yapılmalı; mobil uygulama sadece kendi
backend'inize istek atmalı.

## Sırada ne var
- `RedFlagDetector` kural setini genişletmek (eş anlamlılar, yazım
  hataları için basit fuzzy match).
- Ağrı puanı/süresi girişini ayrı bir UI bileşeni ile toplamak
  (şu an opsiyonel parametre olarak bırakıldı).
- `TriageService` için birim testleri (`test/` klasörü).
