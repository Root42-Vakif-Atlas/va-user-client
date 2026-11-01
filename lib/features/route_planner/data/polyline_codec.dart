import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';

/// Encoded Polyline Algorithm Format (hassasiyet 5) — OSRM, Valhalla ve
/// GraphHopper'ın ortak yol geometrisi biçimi.
///
/// Bozuk girdi [FormatException] fırlatır (Data katmanında `Failure`'a
/// dönüştürülür).
abstract final class PolylineCodec {
  static const double _factor = 1e5;

  static List<GeoPoint> decode(String encoded) {
    final points = <GeoPoint>[];
    var index = 0;
    var latitude = 0;
    var longitude = 0;

    int nextValue() {
      var result = 0;
      var shift = 0;
      int byte;
      do {
        if (index >= encoded.length) {
          throw const FormatException('Eksik polyline verisi');
        }
        byte = encoded.codeUnitAt(index++) - 63;
        if (byte < 0 || byte > 63) {
          throw const FormatException('Geçersiz polyline karakteri');
        }
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      return (result & 1) != 0 ? ~(result >> 1) : result >> 1;
    }

    while (index < encoded.length) {
      latitude += nextValue();
      longitude += nextValue();
      points.add(
        GeoPoint(latitude: latitude / _factor, longitude: longitude / _factor),
      );
    }
    return points;
  }

  static String encode(List<GeoPoint> points) {
    final buffer = StringBuffer();
    var previousLatitude = 0;
    var previousLongitude = 0;

    void write(int value) {
      var shifted = value < 0 ? ~(value << 1) : value << 1;
      while (shifted >= 0x20) {
        buffer.writeCharCode((0x20 | (shifted & 0x1f)) + 63);
        shifted >>= 5;
      }
      buffer.writeCharCode(shifted + 63);
    }

    for (final point in points) {
      final latitude = (point.latitude * _factor).round();
      final longitude = (point.longitude * _factor).round();
      write(latitude - previousLatitude);
      write(longitude - previousLongitude);
      previousLatitude = latitude;
      previousLongitude = longitude;
    }
    return buffer.toString();
  }
}
