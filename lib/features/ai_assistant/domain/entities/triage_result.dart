/// Kullanıcı mesajının (ve varsa ağrı puanı/süresinin) güvenlik
/// değerlendirmesi sonucudur. AI cevabı üretilmeden ÖNCE hesaplanır;
/// böylece kırmızı bayrak durumunda AI'ye hiç istek atılmaz.
class TriageResult {
  /// Acil/ciddi belirti tespit edildi mi? true ise egzersiz önerilmez.
  final bool isRedFlag;

  /// Hangi kırmızı bayrak(lar) tetiklendi (loglama ve UI için).
  final List<String> matchedRedFlags;

  /// Kırmızı bayrak yoksa ama fizyoterapiste yönlendirme uygun mu?
  final bool shouldReferToPhysio;

  /// Yönlendirme nedeni (UI'da opsiyonel gösterim için).
  final String? referralReason;

  const TriageResult({
    required this.isRedFlag,
    this.matchedRedFlags = const [],
    this.shouldReferToPhysio = false,
    this.referralReason,
  });

  factory TriageResult.safe() => const TriageResult(isRedFlag: false);
}
