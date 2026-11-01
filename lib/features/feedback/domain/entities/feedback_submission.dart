/// Geri bildirimin konusu (sunucu sözleşmesindeki değerler).
enum FeedbackCategory {
  suggestion('suggestion'),
  bug('bug'),
  accessibility('accessibility'),
  content('content'),
  other('other');

  const FeedbackCategory(this.wireName);

  final String wireName;
}

/// Kullanıcının gönderdiği geri bildirim. Uygulama sürümü ve platform
/// gönderimde Data katmanında eklenir.
final class FeedbackSubmission {
  const FeedbackSubmission({
    required this.category,
    required this.message,
    this.rating,
  });

  final FeedbackCategory category;

  /// Genel deneyim puanı (1–5); isteğe bağlı.
  final int? rating;
  final String message;

  @override
  bool operator ==(Object other) =>
      other is FeedbackSubmission &&
      other.category == category &&
      other.rating == rating &&
      other.message == message;

  @override
  int get hashCode => Object.hash(category, rating, message);

  /// Metin kişisel veri içerebilir; loglara yazılmaz.
  @override
  String toString() => 'FeedbackSubmission($category, rating: $rating)';
}

enum FeedbackIssue { ratingOrMessageRequired, messageTooLong }

/// Sunucuyla aynı kurallar (`FeedbackRules`, Feedback servisi).
abstract final class FeedbackRules {
  static const int maxMessage = 2000;
  static const int minRating = 1;
  static const int maxRating = 5;

  static FeedbackIssue? validate({
    required int? rating,
    required String message,
  }) {
    final text = message.trim();
    if (text.length > maxMessage) {
      return FeedbackIssue.messageTooLong;
    }
    if (rating == null && text.isEmpty) {
      return FeedbackIssue.ratingOrMessageRequired;
    }
    return null;
  }
}
