import 'package:vakif_atlas/core/utils/list_equality.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';

/// Coğrafi dikdörtgen (WGS 84 derece).
final class GeoBounds {
  const GeoBounds({
    required this.south,
    required this.west,
    required this.north,
    required this.east,
  });

  final double south;
  final double west;
  final double north;
  final double east;

  GeoPoint get center =>
      GeoPoint(latitude: (south + north) / 2, longitude: (west + east) / 2);

  /// Alan bir noktaya inmişse (aynı konumdaki eserler) yakınlaştırmak
  /// ayırmaz.
  bool get isPoint =>
      (north - south).abs() < samePlaceDegrees &&
      (east - west).abs() < samePlaceDegrees;

  /// Bu mesafeden yakın konumlar "aynı yer" sayılır (~5 m).
  static const double samePlaceDegrees = 0.00005;

  GeoBounds union(GeoBounds other) => GeoBounds(
    south: south < other.south ? south : other.south,
    west: west < other.west ? west : other.west,
    north: north > other.north ? north : other.north,
    east: east > other.east ? east : other.east,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeoBounds &&
          other.south == south &&
          other.west == west &&
          other.north == north &&
          other.east == east;

  @override
  int get hashCode => Object.hash(south, west, north, east);

  @override
  String toString() => 'GeoBounds($south, $west, $north, $east)';
}

/// Bir harita karosundaki öğe: sunucu kümesi veya tekil eser.
sealed class MapTileItem {
  const MapTileItem();

  GeoPoint get location;
}

/// Sunucunun ızgara hücresinde topladığı eserler.
final class MapTileCluster extends MapTileItem {
  const MapTileCluster({
    required this.key,
    required this.count,
    required this.location,
    required this.bounds,
  });

  /// Seviye içinde kararlı kimlik (ör. `6/36/24/1/2`).
  final String key;
  final int count;

  /// Üyelerin ortalama konumu.
  @override
  final GeoPoint location;

  /// Üyelerin sınırı: dokununca bu alana yakınlaşılır.
  final GeoBounds bounds;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapTileCluster &&
          other.key == key &&
          other.count == count &&
          other.location == location &&
          other.bounds == bounds;

  @override
  int get hashCode => Object.hash(key, count, location, bounds);
}

final class MapTileMonument extends MapTileItem {
  const MapTileMonument(this.pin);

  final MonumentPin pin;

  /// Karo öğeleri her zaman konumludur (sunucu konumsuz eseri karoya koymaz).
  @override
  GeoPoint get location => pin.location!;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MapTileMonument && other.pin == pin;

  @override
  int get hashCode => pin.hashCode;
}

/// Külliye: uzak/orta zum'da tek işaretçi (üyeleri içinde), yakın zum'da
/// ([MapTiles.complexExpandZoom]) [footprint] çokgeni + üyelerin pinleri.
final class MapTileComplex extends MapTileItem {
  MapTileComplex(this.pin, {List<GeoPoint> footprint = const []})
    : footprint = List.unmodifiable(footprint);

  /// Külliyenin kendi kaydı; [MonumentPin.memberCount] dolu.
  final MonumentPin pin;

  /// Yalnızca yakın zum karolarında dolu.
  final List<GeoPoint> footprint;

  @override
  GeoPoint get location => pin.location!;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapTileComplex &&
          other.pin == pin &&
          elementsEqual(other.footprint, footprint);

  @override
  int get hashCode => Object.hash(pin, Object.hashAll(footprint));
}

/// Sorguya uyan eserlerin toplamı ve kapsadığı alan.
final class MapExtent {
  const MapExtent({required this.total, required this.version, this.bounds});

  final int total;

  /// `null` → eşleşen eser yok.
  final GeoBounds? bounds;

  /// Katalog sürümü; karo isteklerine eklenir (önbellek anahtarı).
  final String version;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapExtent &&
          other.total == total &&
          other.bounds == bounds &&
          other.version == version;

  @override
  int get hashCode => Object.hash(total, bounds, version);
}
