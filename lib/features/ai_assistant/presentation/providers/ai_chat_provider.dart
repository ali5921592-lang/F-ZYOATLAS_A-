import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_strings.dart';
import '../../data/repositories/ai_assistant_repository.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/services/triage_service.dart';

/// Sohbet ekranının tüm state'i: mesaj listesi + yükleniyor durumu.
class AiChatState {
  final List<ChatMessage> messages;
  final bool isLoading;

  const AiChatState({this.messages = const [], this.isLoading = false});

  AiChatState copyWith({List<ChatMessage>? messages, bool? isLoading}) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final aiAssistantRepositoryProvider = Provider<AiAssistantRepository>((ref) {
  // Gerçek uygulamada endpoint/key .env veya remote config'ten okunur.
  return ClaudeAiAssistantRepository(
    apiEndpoint: 'https://api.anthropic.com/v1/messages',
    apiKey: 'BACKEND_TARAFINDAN_YONETILMELI',
  );
});

final triageServiceProvider = Provider<TriageService>((ref) => TriageService());

final aiChatProvider =
    StateNotifierProvider<AiChatNotifier, AiChatState>((ref) {
  return AiChatNotifier(
    repository: ref.watch(aiAssistantRepositoryProvider),
    triageService: ref.watch(triageServiceProvider),
  );
});

class AiChatNotifier extends StateNotifier<AiChatState> {
  final AiAssistantRepository _repository;
  final TriageService _triageService;
  final _uuid = const Uuid();

  /// Bu oturumda daha önce bahsedilen şikayet anahtar kelimeleri
  /// (basit tekrarlayan şikayet tespiti için).
  final Set<String> _seenComplaintTopics = {};

  AiChatNotifier({
    required AiAssistantRepository repository,
    required TriageService triageService,
  })  : _repository = repository,
        _triageService = triageService,
        super(const AiChatState());

  Future<void> sendMessage(
    String text, {
    int? painScore,
    int? painDurationDays,
  }) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: _uuid.v4(),
      text: text,
      sender: ChatSender.user,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    final topicKey = _extractTopicKey(text);
    final isRecurring = _seenComplaintTopics.contains(topicKey);
    _seenComplaintTopics.add(topicKey);

    final triage = _triageService.evaluate(
      userText: text,
      painScore: painScore,
      painDurationDays: painDurationDays,
      isRecurringComplaint: isRecurring,
    );

    if (triage.isRedFlag) {
      _appendAssistantMessage(
        AppStrings.redFlagWarning,
        isRedFlagWarning: true,
      );
      // Fizyoterapist iletişim bilgisi her cevabın sonunda sabit olarak eklenir.
      _appendAssistantMessage(
        AppStrings.physioReferralMessage,
        triggersPhysioReferral: true,
      );
      state = state.copyWith(isLoading: false);
      return; // AI'ye hiç istek gönderilmiyor.
    }

    try {
      final history = state.messages
          .where((m) => m.sender != ChatSender.system)
          .map((m) => {
                'role': m.sender == ChatSender.user ? 'user' : 'assistant',
                'content': m.text,
              })
          .toList();

      final aiText = await _repository.getResponse(
        userMessage: text,
        conversationHistory: history,
      );

      _appendAssistantMessage(aiText);

      // Fizyoterapist iletişim bilgisi artık her cevabın sonunda sabit
      // olarak gösterilir; triage sadece mesaj metnini belirler.
      final referralText = triage.shouldReferToPhysio
          ? AppStrings.physioReferralMessage
          : AppStrings.physioContactFooter;
      _appendAssistantMessage(referralText, triggersPhysioReferral: true);
    } catch (e) {
      _appendAssistantMessage(
        'Şu anda cevap veremiyorum, lütfen tekrar deneyin.',
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void _appendAssistantMessage(
    String text, {
    bool isRedFlagWarning = false,
    bool triggersPhysioReferral = false,
  }) {
    final message = ChatMessage(
      id: _uuid.v4(),
      text: text,
      sender: ChatSender.assistant,
      timestamp: DateTime.now(),
      isRedFlagWarning: isRedFlagWarning,
      triggersPhysioReferral: triggersPhysioReferral,
    );
    state = state.copyWith(messages: [...state.messages, message]);
  }

  /// Çok basit bir konu anahtarı çıkarımı (ör. "diz", "bel", "omuz")
  /// tekrarlayan şikayeti yakalamak için. İleride NLP ile geliştirilebilir.
  String _extractTopicKey(String text) {
    const bodyParts = [
      'diz', 'bel', 'omuz', 'boyun', 'kalça', 'dirsek', 'bilek', 'ayak',
    ];
    final lower = text.toLowerCase();
    for (final part in bodyParts) {
      if (lower.contains(part)) return part;
    }
    return 'genel';
  }
}
