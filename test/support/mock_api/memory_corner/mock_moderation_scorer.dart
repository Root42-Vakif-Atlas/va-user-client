/// YZ moderasyonunun sahtesi (ADR 58): gerçek servis Detoxify çok dilli
/// modeli + Türkçe sözlükle 0–1 skor üretir; Memories servisi skoru
/// eşiklerle karşılaştırır. Burada skor, metindeki deterministik işaret
/// sözcüklerinden gelir; eşikler sunucuyla aynıdır.
abstract final class MockModerationScorer {
  /// Sunucu varsayılanları (`Memories:Moderation:Ai`, calibration.json).
  static const double approveBelow = 0.31;
  static const double rejectFrom = 0.96;

  /// Açık hakaret / küfür → otomatik kaldırma bandı.
  static const List<String> abusive = ['salak', 'aptal', 'puşt', 'siktir'];

  /// Olumsuz ama bağlama bağlı ifade → inceleme bandı.
  static const List<String> borderline = ['berbat', 'rezalet', 'gebertirim'];

  static double score(String text) {
    final lower = text.toLowerCase();
    if (abusive.any(lower.contains)) {
      return 0.98;
    }
    if (borderline.any(lower.contains)) {
      return 0.62;
    }
    return 0.02;
  }

  /// `approved` / `pending` / `rejected`.
  static String statusFor(Iterable<String> texts) {
    final worst = texts.map(score).fold<double>(0, (a, b) => a > b ? a : b);
    if (worst >= rejectFrom) {
      return 'rejected';
    }
    return worst >= approveBelow ? 'pending' : 'approved';
  }
}
