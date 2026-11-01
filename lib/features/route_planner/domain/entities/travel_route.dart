import 'package:vakif_atlas/core/utils/list_equality.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';

/// Rotadaki durak: eserin anlık görüntüsü (ad, konum) ve plan bilgileri.
final class RouteStop {
  RouteStop({
    required this.monumentId,
    required this.name,
    required this.city,
    required this.district,
    required this.category,
    required this.location,
    required this.visit,
    List<RouteBreak> breaks = const [],
  }) : breaks = List.unmodifiable(breaks);

  final String monumentId;
  final String name;
  final String city;
  final String district;
  final MonumentCategory category;
  final GeoPoint location;
  final Duration visit;

  /// Bu duraktan sonra verilen molalar.
  final List<RouteBreak> breaks;

  Duration get breakTotal =>
      breaks.fold(Duration.zero, (total, pause) => total + pause.duration);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteStop &&
          other.monumentId == monumentId &&
          other.name == name &&
          other.city == city &&
          other.district == district &&
          other.category == category &&
          other.location == location &&
          other.visit == visit &&
          elementsEqual(other.breaks, breaks);

  @override
  int get hashCode => Object.hash(
    monumentId,
    name,
    city,
    district,
    category,
    location,
    visit,
    Object.hashAll(breaks),
  );
}

/// İki ardışık durak arasındaki yolculuk (`stops[i]` → `stops[i + 1]`).
final class RouteLeg {
  RouteLeg({
    required this.distanceMeters,
    required this.duration,
    required List<GeoPoint> geometry,
  }) : geometry = List.unmodifiable(geometry);

  final int distanceMeters;
  final Duration duration;

  /// Yolu izleyen çizgi (haritada gösterilir).
  final List<GeoPoint> geometry;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteLeg &&
          other.distanceMeters == distanceMeters &&
          other.duration == duration &&
          elementsEqual(other.geometry, geometry);

  @override
  int get hashCode =>
      Object.hash(distanceMeters, duration, Object.hashAll(geometry));
}

/// Rotanın süre ve mesafe dökümü.
final class RouteSummary {
  const RouteSummary({
    required this.distanceMeters,
    required this.travel,
    required this.visit,
    required this.breaks,
  });

  final int distanceMeters;

  /// Mesafeye göre hesaplanan yolculuk süresi.
  final Duration travel;
  final Duration visit;
  final Duration breaks;

  Duration get total => travel + visit + breaks;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteSummary &&
          other.distanceMeters == distanceMeters &&
          other.travel == travel &&
          other.visit == visit &&
          other.breaks == breaks;

  @override
  int get hashCode => Object.hash(distanceMeters, travel, visit, breaks);
}

/// Kayıtlı kültür rotası.
final class TravelRoute {
  TravelRoute({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required List<RouteStop> stops,
    required List<RouteLeg> legs,
    required this.summary,
  }) : stops = List.unmodifiable(stops),
       legs = List.unmodifiable(legs);

  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<RouteStop> stops;

  /// `legs.length == stops.length - 1`.
  final List<RouteLeg> legs;
  final RouteSummary summary;

  /// Düzenleme için rotanın tanımı.
  RoutePlan toPlan() => RoutePlan(
    name: name,
    stops: [
      for (final stop in stops)
        RouteStopPlan(
          monumentId: stop.monumentId,
          visit: stop.visit,
          breaks: stop.breaks,
        ),
    ],
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TravelRoute &&
          other.id == id &&
          other.name == name &&
          other.createdAt == createdAt &&
          other.updatedAt == updatedAt &&
          elementsEqual(other.stops, stops) &&
          elementsEqual(other.legs, legs) &&
          other.summary == summary;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    createdAt,
    updatedAt,
    Object.hashAll(stops),
    Object.hashAll(legs),
    summary,
  );

  @override
  String toString() => 'TravelRoute($id)';
}

/// Rota listesindeki öğe (geometri içermez).
final class RouteOverview {
  RouteOverview({
    required this.id,
    required this.name,
    required this.createdAt,
    required List<String> cities,
    required this.stopCount,
    required this.summary,
  }) : cities = List.unmodifiable(cities);

  final String id;
  final String name;
  final DateTime createdAt;

  /// Durakların illeri, rota sırasıyla.
  final List<String> cities;
  final int stopCount;
  final RouteSummary summary;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteOverview &&
          other.id == id &&
          other.name == name &&
          other.createdAt == createdAt &&
          elementsEqual(other.cities, cities) &&
          other.stopCount == stopCount &&
          other.summary == summary;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    createdAt,
    Object.hashAll(cities),
    stopCount,
    summary,
  );
}

enum RouteChangeType {
  created,
  updated,
  deleted,

  /// Oturum açıldı / kapandı: görünen rotalar (hesabın veya kurulumun)
  /// değişti; `routeId` boştur.
  scopeChanged,
}

/// Rota deposundaki değişiklik bildirimi (liste ve detay ekranları
/// kendini yeniler).
final class RouteChange {
  const RouteChange(this.type, this.routeId);

  final RouteChangeType type;
  final String routeId;

  @override
  bool operator ==(Object other) =>
      other is RouteChange && other.type == type && other.routeId == routeId;

  @override
  int get hashCode => Object.hash(type, routeId);
}
