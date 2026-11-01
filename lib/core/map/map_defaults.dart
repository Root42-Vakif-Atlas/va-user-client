import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Harita kamerası sabitleri.
abstract final class MapDefaults {
  /// Türkiye'nin coğrafi merkezine yakın başlangıç noktası.
  static const LatLng turkeyCenter = LatLng(39, 35.2);

  /// Telefon ekranında tüm Türkiye'nin göründüğü yakınlaştırma.
  static const double overviewZoom = 5;

  static const double minZoom = 4;
  static const double maxZoom = 18;

  /// Seçilen eserin çevresiyle birlikte göründüğü yakınlaştırma.
  static const double focusZoom = 15;

  /// "Konumuma git" yakınlaştırması (sokak ölçeği).
  static const double locateZoom = 15;

  /// Tek dokunuşla yakınlaştır / uzaklaştır adımı.
  static const double zoomStep = 1;

  /// Kamera merkezinin çıkamayacağı bölge: kullanıcı haritada
  /// kaybolmaz (WCAG 2.2 bilişsel erişilebilirlik).
  static final LatLngBounds region = LatLngBounds(
    const LatLng(33.5, 23.5),
    const LatLng(44.5, 47.5),
  );
}
