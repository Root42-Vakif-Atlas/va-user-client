/// Kullanıcının kayıt sırasında onayladığı yasal metinler.
enum LegalDocumentType {
  /// Kullanım Koşulları — kabul edilir.
  termsOfUse('terms-of-use'),

  /// KVKK Aydınlatma Metni — okunduğu beyan edilir (6698 s. Kanun md. 10).
  privacyNotice('privacy-notice');

  const LegalDocumentType(this.slug);

  /// API ve uygulama içi rota tanımlayıcısı.
  final String slug;

  static LegalDocumentType? fromSlug(String? slug) {
    for (final type in values) {
      if (type.slug == slug) {
        return type;
      }
    }
    return null;
  }
}

/// Sunucudan alınan, sürümlü yasal metin.
///
/// Metnin içeriği ve sürümü sunucu tarafından yönetilir; kayıt sırasında
/// sunucu o anki sürümü kullanıcının onayıyla birlikte kaydeder.
final class LegalDocument {
  const LegalDocument({
    required this.type,
    required this.version,
    required this.title,
    required this.body,
    required this.effectiveDate,
  });

  final LegalDocumentType type;
  final String version;
  final String title;

  /// Paragrafları boş satırla ayrılmış düz metin.
  final String body;
  final DateTime effectiveDate;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LegalDocument &&
          other.type == type &&
          other.version == version &&
          other.title == title &&
          other.body == body &&
          other.effectiveDate == effectiveDate;

  @override
  int get hashCode => Object.hash(type, version, title, body, effectiveDate);
}
