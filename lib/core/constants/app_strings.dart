/// Uygulama genelinde kullanılan sabit metinler.
/// Tüm tıbbi-hukuki dil burada tek noktadan yönetilir; içerik ekibi
/// başka hiçbir dosyaya dokunmadan bu metinleri güncelleyebilir.
class AppStrings {
  AppStrings._();

  /// Her sayfada gösterilmesi zorunlu genel sorumluluk reddi.
  static const String generalDisclaimer =
      'Bu uygulama yalnızca genel bilgilendirme amacıyla hazırlanmıştır. '
      'Tıbbi teşhis veya tedavi yerine geçmez. Şikayetleriniz uzun sürüyor, '
      'şiddetleniyor veya travma sonrası başladıysa mutlaka doktor veya '
      'fizyoterapiste başvurunuz.';

  /// Kırmızı bayrak tespit edildiğinde gösterilen kritik uyarı.
  static const String redFlagWarning =
      'Bu belirtiler ciddi bir sağlık sorununa işaret edebilir. Lütfen en '
      'kısa sürede sağlık kuruluşuna başvurunuz.';

  /// Fizyoterapiste yönlendirme mesajı (kırmızı bayrak değil, ama
  /// kişiye özel değerlendirme gereken durumlar için).
  static const String physioReferralMessage =
      'Bu durumda kişiye özel değerlendirme daha uygun olacaktır. '
      'İsterseniz Fizyoterapist Leyla Tekin ile iletişime geçebilirsiniz.';

  static const String aiAssistantTitle = 'AI Fizyo Asistan';

  static const String chatInputHint =
      'Şikayetinizi yazın (örn. "Sağ dizim merdiven inerken ağrıyor")';

  /// Kırmızı bayrak/yönlendirme kriteri tetiklenmediğinde, her cevabın
  /// sonuna eklenen sabit fizyoterapist iletişim mesajı.
  static const String physioContactFooter =
      'Sorularınız için Fizyoterapist Leyla Tekin ile de iletişime '
      'geçebilirsiniz.';

  static const String physioName = 'Leyla Tekin';
  static const String physioPhone = '+905016052822';
  static const String physioInstagram = 'fztleylatekin';
}
