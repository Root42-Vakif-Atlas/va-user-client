import 'dart:math' as math;

/// WGS 84 koordinatı (enlem / boylam, derece).
///
/// Koordinatlar VGM'nin doğruladığı katalog verisinden gelir; istemci
/// adresten koordinat türetmez.
final class GeoPoint {
  const GeoPoint({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  /// Sonlu ve geçerli aralıkta (enlem ±90°, boylam ±180°) mı?
  bool get isValid =>
      latitude.isFinite &&
      longitude.isFinite &&
      latitude >= -90 &&
      latitude <= 90 &&
      longitude >= -180 &&
      longitude <= 180;

  /// Ortalama Dünya yarıçapı (IUGG), metre.
  static const double earthRadiusMeters = 6371008.8;

  /// [other] noktasına kuş uçuşu (büyük daire, haversine) mesafe, metre.
  double distanceTo(GeoPoint other) {
    double radians(double degrees) => degrees * math.pi / 180;
    final dLat = radians(other.latitude - latitude);
    final dLon = radians(other.longitude - longitude);
    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(radians(latitude)) *
            math.cos(radians(other.latitude)) *
            math.pow(math.sin(dLon / 2), 2);
    return 2 * earthRadiusMeters * math.asin(math.min(1, math.sqrt(a)));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeoPoint &&
          other.latitude == latitude &&
          other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() => 'GeoPoint($latitude, $longitude)';
}
