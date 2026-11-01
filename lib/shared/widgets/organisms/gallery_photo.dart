import 'package:flutter/foundation.dart';

/// Galeride gösterilen fotoğraf.
@immutable
class GalleryPhoto {
  const GalleryPhoto({
    required this.url,
    required this.thumbnailUrl,
    required this.description,
    required this.credit,
    required this.creditSemanticsLabel,
  });

  final String url;
  final String thumbnailUrl;

  /// Görselin betimi; ekran okuyucuya okunur ve tam ekranda altyazı olur.
  final String description;

  /// Görünür lisans künyesi (ör. "Yazar · CC BY-SA 4.0 · Wikimedia Commons").
  final String credit;
  final String creditSemanticsLabel;
}
