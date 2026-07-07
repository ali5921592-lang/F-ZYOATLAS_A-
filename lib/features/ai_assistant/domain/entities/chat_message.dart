enum ChatSender { user, assistant, system }

/// Sohbet ekranındaki tek bir mesajı temsil eder.
class ChatMessage {
  final String id;
  final String text;
  final ChatSender sender;
  final DateTime timestamp;

  /// Bu mesaj bir kırmızı bayrak uyarısı mı? (UI'da farklı stil için)
  final bool isRedFlagWarning;

  /// Bu mesaj bir fizyoterapiste yönlendirme kartı tetikliyor mu?
  final bool triggersPhysioReferral;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.isRedFlagWarning = false,
    this.triggersPhysioReferral = false,
  });

  ChatMessage copyWith({
    String? text,
    bool? isRedFlagWarning,
    bool? triggersPhysioReferral,
  }) {
    return ChatMessage(
      id: id,
      text: text ?? this.text,
      sender: sender,
      timestamp: timestamp,
      isRedFlagWarning: isRedFlagWarning ?? this.isRedFlagWarning,
      triggersPhysioReferral:
          triggersPhysioReferral ?? this.triggersPhysioReferral,
    );
  }
}
