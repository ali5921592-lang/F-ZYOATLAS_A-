import '../../../../core/services/red_flag_detector.dart';
import '../entities/triage_result.dart';

/// Kullanıcının mesajını ve (varsa) bildirdiği ağrı puanı/süresini
/// değerlendirip AI'nin nasıl davranacağına karar veren servis.
///
/// Sıra önemli: önce kırmızı bayrak kontrol edilir (varsa hiçbir
/// egzersiz/öneri üretilmez), sonra fizyoterapiste yönlendirme
/// kriterleri kontrol edilir.
class TriageService {
  final RedFlagDetector _redFlagDetector;

  TriageService({RedFlagDetector? redFlagDetector})
      : _redFlagDetector = redFlagDetector ?? RedFlagDetector();

  static const List<String> _manualTherapyKeywords = [
    'manuel terapi',
    'reformer pilates',
    'reformer',
  ];

  static const List<String> _personalProgramKeywords = [
    'bana özel program',
    'kişiye özel program',
    'benim için program',
    'özel egzersiz programı',
  ];

  /// [painScore] 0-10 arası, bilinmiyorsa null.
  /// [painDurationDays] şikayetin kaç gündür sürdüğü, bilinmiyorsa null.
  /// [isRecurringComplaint] aynı şikayetin daha önce de bildirilip
  /// bildirilmediğini çağıran taraf (sohbet geçmişine bakarak) belirler.
  TriageResult evaluate({
    required String userText,
    int? painScore,
    int? painDurationDays,
    bool isRecurringComplaint = false,
  }) {
    final redFlags = _redFlagDetector.scan(userText);
    if (redFlags.isNotEmpty) {
      return TriageResult(isRedFlag: true, matchedRedFlags: redFlags);
    }

    final normalized = userText.toLowerCase();
    final mentionsManualTherapy =
        _manualTherapyKeywords.any((k) => normalized.contains(k));
    final wantsPersonalProgram =
        _personalProgramKeywords.any((k) => normalized.contains(k));

    String? reason;
    if (painScore != null && painScore >= 7) {
      reason = 'Ağrı şiddeti 7/10 veya üzerinde bildirildi.';
    } else if (painDurationDays != null && painDurationDays > 14) {
      reason = 'Şikayet 2 haftadan uzun süredir devam ediyor.';
    } else if (wantsPersonalProgram) {
      reason = 'Kullanıcı kişiye özel program talep etti.';
    } else if (isRecurringComplaint) {
      reason = 'Aynı şikayet tekrar bildirildi.';
    } else if (mentionsManualTherapy) {
      reason = 'Manuel terapi / reformer pilates hakkında bilgi istendi.';
    }

    if (reason != null) {
      return TriageResult(
        isRedFlag: false,
        shouldReferToPhysio: true,
        referralReason: reason,
      );
    }

    return TriageResult.safe();
  }
}
