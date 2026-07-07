import 'dart:convert';
import 'package:http/http.dart' as http;

/// AI Fizyo Asistan için LLM çağrılarını yöneten repository.
/// Bu katman değiştirilebilir olacak şekilde soyutlanmıştır: yarın
/// OpenAI yerine başka bir sağlayıcıya geçilirse sadece bu dosya değişir.
abstract class AiAssistantRepository {
  Future<String> getResponse({
    required String userMessage,
    required List<Map<String, String>> conversationHistory,
  });
}

class ClaudeAiAssistantRepository implements AiAssistantRepository {
  final String _apiEndpoint;
  final String _apiKey;

  ClaudeAiAssistantRepository({
    required String apiEndpoint,
    required String apiKey,
  })  : _apiEndpoint = apiEndpoint,
        _apiKey = apiKey;

  /// AI'nin her zaman uyması gereken güvenlik kuralları. Bu prompt,
  /// TriageService zaten "kırmızı bayrak yok" dediği mesajlar için
  /// kullanılır — yani AI'ye hiçbir zaman kırmızı bayraklı bir mesaj
  /// gönderilmez, bu yüzden burada tekrar reddetme davranışı da
  /// ek bir güvenlik katmanı olarak tutulur.
  static const String _systemPrompt = '''
Sen FizyoAtlas AI uygulamasının fizyoterapi bilgilendirme asistanısın.

KESİN KURALLAR:
- Asla teşhis koyma, hastalık adı kesin olarak söyleme.
- Kullanıcıyı korkutacak ifadeler kullanma.
- Yalnızca genel bilgilendirme, güvenli genel egzersiz önerileri,
  korunma yöntemleri ve yaşam tarzı önerileri ver.
- Kullanıcının anlattığı belirtiler ciddi görünüyorsa (şiddetli ağrı,
  uzun süredir devam eden şikayet, tekrarlayan şikayet, kişiye özel
  program talebi, manuel terapi/reformer pilates sorusu) mutlaka
  fizyoterapiste başvurmasını öner.
- Cevaplarını kısa, sıcak ve anlaşılır tut.
''';

  @override
  Future<String> getResponse({
    required String userMessage,
    required List<Map<String, String>> conversationHistory,
  }) async {
    final response = await http.post(
      Uri.parse(_apiEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-sonnet-4-6',
        'max_tokens': 500,
        'system': _systemPrompt,
        'messages': [
          ...conversationHistory,
          {'role': 'user', 'content': userMessage},
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('AI Asistan cevap veremedi (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final content = data['content'] as List<dynamic>;
    final textBlock = content.firstWhere(
      (block) => block['type'] == 'text',
      orElse: () => {'text': ''},
    );
    return textBlock['text'] as String;
  }
}
