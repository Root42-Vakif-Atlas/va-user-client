import 'dart:ui';

/// Açık bir altlığı iki tema rengiyle koyu, tek renk tonlu (duotone) bir
/// haritaya dönüştüren renk matrisi.
///
/// Pikselin parlaklığı (Rec. 709) ters çevrilip [shadow] → [highlight]
/// aralığına eşlenir: açık zemin [shadow], koyu çizgi ve yazılar
/// [highlight] olur. Böylece koyu stil sunmayan sağlayıcılarda da harita,
/// uygulamanın koyu ve yüksek kontrast temalarıyla aynı renk ailesinde
/// görünür; pinler bu sakin zeminde öne çıkar.
ColorFilter duotoneTileFilter({
  required Color shadow,
  required Color highlight,
}) =>
    ColorFilter.matrix(duotoneTileMatrix(shadow: shadow, highlight: highlight));

/// [duotoneTileFilter] için 4×5 renk matrisi (ofsetler 0–255 ölçeğinde).
List<double> duotoneTileMatrix({
  required Color shadow,
  required Color highlight,
}) {
  const red = 0.2126;
  const green = 0.7152;
  const blue = 0.0722;
  const channelMax = 255.0;

  List<double> row(double shadowChannel, double highlightChannel) {
    final span = shadowChannel - highlightChannel;
    return [
      span * red,
      span * green,
      span * blue,
      0,
      highlightChannel * channelMax,
    ];
  }

  return [
    ...row(shadow.r, highlight.r),
    ...row(shadow.g, highlight.g),
    ...row(shadow.b, highlight.b),
    0, 0, 0, 1, 0, //
  ];
}
