/// Kullanıcı serbest metninde acil/ciddi belirti (kırmızı bayrak)
/// arayan basit ama genişletilebilir anahtar kelime tabanlı tarayıcı.
///
/// NOT: Bu, tıbbi bir teşhis aracı DEĞİLDİR. Sadece "bu mesajda AI'nin
/// egzersiz önermemesi gereken bir ifade var mı?" sorusuna cevap arar.
/// Yanlış negatif riskini azaltmak için kural seti geniş tutulmuştur;
/// şüpheli her durumda kırmızı bayrak tarafına yatık davranılır.
class RedFlagDetector {
  RedFlagDetector();

  /// Kategori -> anahtar kelime/ifade listesi.
  /// Küçük harfe çevrilmiş, Türkçe karakter varyasyonlarıyla eşleşir.
  static final Map<String, List<String>> _redFlagPatterns = {
    'travma': ['travma', 'düştüm', 'darbe aldı', 'kaza geçirdim', 'çarptı'],
    'kırık şüphesi': ['kırık', 'çatlak olabilir', 'kemik kırıldı'],
    'ileri şişlik': ['aşırı şişlik', 'çok fazla şişti', 'balon gibi şişti'],
    'ileri kızarıklık': ['aşırı kızarıklık', 'mosmor oldu', 'yanık gibi kızardı'],
    'idrar/dışkı kaçırma': [
      'idrar kaçırma',
      'idrarımı tutamıyorum',
      'dışkı kaçırma',
      'tuvalet kontrolü kaybettim',
    ],
    'felç belirtisi': ['felç', 'yüzüm kaydı', 'konuşamıyorum', 'kolum tutmuyor'],
    'ilerleyen güç kaybı': [
      'gittikçe güçsüzleşiyor',
      'giderek zayıflıyor',
      'yürüyemez hale geldim',
    ],
    'yüksek ateş': ['yüksek ateş', 'ateşim çok yüksek', '39 derece', '40 derece'],
    'gece ağrısı': ['gece uyandırıyor', 'uykudan uyandıran ağrı', 'gece ağrısı'],
    'kanser öyküsü': ['kanser geçmişim var', 'kanser tedavisi gördüm', 'kanser hastasıyım'],
  };

  /// Metni tarar, eşleşen kategori adlarını döndürür (boşsa kırmızı bayrak yok).
  List<String> scan(String userText) {
    final normalized = userText.toLowerCase().trim();
    if (normalized.isEmpty) return const [];

    final matches = <String>[];
    _redFlagPatterns.forEach((category, keywords) {
      final hasMatch = keywords.any((k) => normalized.contains(k));
      if (hasMatch) matches.add(category);
    });
    return matches;
  }

  bool hasRedFlag(String userText) => scan(userText).isNotEmpty;
}
