/// Eser fotoğrafı ve lisans künyesi.
///
/// [altText] ekran okuyucular için görselin betimidir (WCAG 1.1.1); ileride
/// yapay zeka betimlemesiyle sunucuda üretilir.
final class MonumentImage {
  const MonumentImage({
    required this.url,
    required this.thumbnailUrl,
    required this.altText,
    required this.author,
    required this.license,
    required this.sourceName,
    this.sourceUrl,
    this.title,
  });

  /// Tam ekran ve galeri görünümü için görsel.
  final String url;

  /// Liste ve önizleme kartları için küçük görsel.
  final String thumbnailUrl;
  final String altText;

  /// Fotoğrafı çeken / hak sahibi.
  final String author;

  /// Lisansın kısa adı (ör. `CC BY-SA 4.0`).
  final String license;

  /// Görselin kaynağı (ör. `Wikimedia Commons`, `VGM Arşivi`).
  final String sourceName;

  /// Kaynak sayfası (lisans atfı için).
  final String? sourceUrl;

  /// Görsel başlığı (VGM verisi, isteğe bağlı).
  final String? title;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonumentImage &&
          other.url == url &&
          other.thumbnailUrl == thumbnailUrl &&
          other.altText == altText &&
          other.author == author &&
          other.license == license &&
          other.sourceName == sourceName &&
          other.sourceUrl == sourceUrl &&
          other.title == title;

  @override
  int get hashCode => Object.hash(
    url,
    thumbnailUrl,
    altText,
    author,
    license,
    sourceName,
    sourceUrl,
    title,
  );
}
