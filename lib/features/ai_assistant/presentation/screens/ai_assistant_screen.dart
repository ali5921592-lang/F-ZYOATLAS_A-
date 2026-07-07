import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/chat_message.dart';
import '../providers/ai_chat_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/physio_referral_card.dart';
import '../widgets/safety_banner.dart';

class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  /// Kullanıcının bu mesaj için bildirdiği ağrı şiddeti (0-10).
  /// Gerçek uygulamada bir slider ile ayrı toplanabilir; burada
  /// basit tutmak için opsiyonel bırakıldı.
  int? _currentPainScore;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _textController.text;
    ref.read(aiChatProvider.notifier).sendMessage(
          text,
          painScore: _currentPainScore,
        );
    _textController.clear();
    _currentPainScore = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiChatProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.aiAssistantTitle)),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            padding: const EdgeInsets.all(12),
            child: Text(
              AppStrings.generalDisclaimer,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: chatState.messages.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: chatState.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatState.messages[index];
                      if (message.isRedFlagWarning) {
                        return SafetyBanner(message: message.text);
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ChatBubble(message: message),
                          if (message.triggersPhysioReferral)
                            const PhysioReferralCard(),
                        ],
                      );
                    },
                  ),
          ),
          if (chatState.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          _MessageInputBar(controller: _textController, onSend: _send),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Şikayetinizi anlatın, size genel bilgilendirme ve güvenli '
          'öneriler sunayım.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _MessageInputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: AppStrings.chatInputHint,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: onSend,
              icon: const Icon(Icons.send),
              tooltip: 'Gönder',
            ),
          ],
        ),
      ),
    );
  }
}
