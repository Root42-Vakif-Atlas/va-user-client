import 'dart:ui';

/// Açık bir altlığı koyu, soğuk nötr bir haritaya dönüştüren renk matrisi.
///
/// Pikselin parlaklığı (Rec. 709) ters çevrilip [shadow] → [highlight]
/// aralığına eşlenir: açık zemin [shadow], koyu çizgi ve yazılar
/// [highlight] olur. [chroma] > 0 iken kaynağın renk bileşeni
/// (`piksel − parlaklık`) ters çevrilmeden, ölçeklenerek eklenir; su mavimsi,
/// park yeşilimsi kalır ve kara/su/yeşil alan yalnızca parlaklığa
/// dayanmadan ayrışır. Uç renkler yüzey renklerinden bağımsız seçilir, bu
/// yüzden harita uygulamanın marka yeşiline boyanmaz.
ColorFilter duotoneTileFilter({
  required Color shadow,
  required Color highlight,
  double chroma = 0,
}) => ColorFilter.matrix(
  duotoneTileMatrix(shadow: shadow, highlight: highlight, chroma: chroma),
);

/// [duotoneTileFilter] için 4×5 renk matrisi (ofsetler 0–255 ölçeğinde).
List<double> duotoneTileMatrix({
  required Color shadow,
  required Color highlight,
  double chroma = 0,
}) {
  const red = 0.2126;
  const green = 0.7152;
  const blue = 0.0722;
  const channelMax = 255.0;

  // [own]: satırın kendi kanalı (0 kırmızı, 1 yeşil, 2 mavi). Renk bileşeni
  // `chroma · (kanal − parlaklık)` olduğundan kendi katsayısına +chroma,
  // her katsayıdan parlaklık ağırlığı × chroma çıkarılır.
  List<double> row(int own, double shadowChannel, double highlightChannel) {
    final span = shadowChannel - highlightChannel;
    double weight(double luma, int channel) =>
        span * luma + chroma * ((channel == own ? 1 : 0) - luma);
    return [
      weight(red, 0),
      weight(green, 1),
      weight(blue, 2),
      0,
      highlightChannel * channelMax,
    ];
  }

  return [
    ...row(0, shadow.r, highlight.r),
    ...row(1, shadow.g, highlight.g),
    ...row(2, shadow.b, highlight.b),
    0, 0, 0, 1, 0, //
  ];
}
