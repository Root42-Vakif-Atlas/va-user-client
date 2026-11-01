import 'dart:math' as math;

/// Külliye yerleşim alanı — backend `ComplexGeometry`'nin birebir karşılığı:
/// noktaların dış bükey örtüsü (Andrew monotone chain), her köşe ağırlık
/// merkezinden [bufferMeters] dışa kaydırılır. Üçten az farklı nokta → boş.
abstract final class MockComplexGeometry {
  static const double bufferMeters = 25;
  static const double _metersPerDegree = 111320;

  /// `[[lat, lng], …]`, saat yönünün tersine, 6 ondalık.
  static List<List<double>> footprint(List<(double, double)> points) {
    final unique = {for (final (lat, lng) in points) (lng, lat)}.toList()
      ..sort(
        (a, b) => a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$2.compareTo(b.$2),
      );
    if (unique.length < 3) {
      return const [];
    }
    double cross((double, double) o, (double, double) a, (double, double) b) =>
        (a.$1 - o.$1) * (b.$2 - o.$2) - (a.$2 - o.$2) * (b.$1 - o.$1);
    final lower = <(double, double)>[];
    for (final point in unique) {
      while (lower.length >= 2 &&
          cross(lower[lower.length - 2], lower.last, point) <= 0) {
        lower.removeLast();
      }
      lower.add(point);
    }
    final upper = <(double, double)>[];
    for (final point in unique.reversed) {
      while (upper.length >= 2 &&
          cross(upper[upper.length - 2], upper.last, point) <= 0) {
        upper.removeLast();
      }
      upper.add(point);
    }
    final hull = [
      ...lower.sublist(0, lower.length - 1),
      ...upper.sublist(0, upper.length - 1),
    ];
    if (hull.length < 3) {
      return const [];
    }
    final centerLng =
        hull.map((p) => p.$1).reduce((a, b) => a + b) / hull.length;
    final centerLat =
        hull.map((p) => p.$2).reduce((a, b) => a + b) / hull.length;
    final lngScale = math.cos(centerLat * math.pi / 180);
    return [
      for (final (lng, lat) in hull)
        _offset(lat, lng, centerLat, centerLng, lngScale),
    ];
  }

  static List<double> _offset(
    double lat,
    double lng,
    double centerLat,
    double centerLng,
    double lngScale,
  ) {
    // Metre cinsinden yön vektörü, birim uzunluğa indirgenip tampon kadar.
    final dy = (lat - centerLat) * _metersPerDegree;
    final dx = (lng - centerLng) * _metersPerDegree * lngScale;
    final length = math.sqrt(dx * dx + dy * dy);
    if (length == 0) {
      return [_round(lat), _round(lng)];
    }
    final scale = bufferMeters / length;
    return [
      _round(lat + dy * scale / _metersPerDegree),
      _round(lng + dx * scale / (_metersPerDegree * lngScale)),
    ];
  }

  static double _round(double value) => (value * 1e6).roundToDouble() / 1e6;
}
