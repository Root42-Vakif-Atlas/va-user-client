import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/monument_dtos.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/route_planner/data/polyline_codec.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';

part 'route_dtos.freezed.dart';
part 'route_dtos.g.dart';

/// Ulaşım türü. Eserler farklı illerde olduğundan şimdilik yalnızca araç.
abstract final class RouteTravelModes {
  static const String driving = 'driving';
}

@freezed
abstract class RouteBreakDto with _$RouteBreakDto {
  const factory RouteBreakDto({
    @JsonKey(unknownEnumValue: RouteBreakKind.rest)
    required RouteBreakKind kind,
    required int minutes,
  }) = _RouteBreakDto;

  const RouteBreakDto._();

  factory RouteBreakDto.fromJson(Map<String, dynamic> json) =>
      _$RouteBreakDtoFromJson(json);

  factory RouteBreakDto.fromDomain(RouteBreak pause) =>
      RouteBreakDto(kind: pause.kind, minutes: pause.duration.inMinutes);

  RouteBreak toDomain() => RouteBreak(
    kind: kind,
    duration: Duration(minutes: minutes),
  );
}

@freezed
abstract class RouteStopPlanDto with _$RouteStopPlanDto {
  const factory RouteStopPlanDto({
    required String monumentId,
    required int visitMinutes,
    @Default(<RouteBreakDto>[]) List<RouteBreakDto> breaks,
  }) = _RouteStopPlanDto;

  const RouteStopPlanDto._();

  factory RouteStopPlanDto.fromJson(Map<String, dynamic> json) =>
      _$RouteStopPlanDtoFromJson(json);

  factory RouteStopPlanDto.fromDomain(RouteStopPlan stop) => RouteStopPlanDto(
    monumentId: stop.monumentId,
    visitMinutes: stop.visit.inMinutes,
    breaks: [for (final pause in stop.breaks) RouteBreakDto.fromDomain(pause)],
  );

  RouteStopPlan toDomain() => RouteStopPlan(
    monumentId: monumentId,
    visit: Duration(minutes: visitMinutes),
    breaks: [for (final pause in breaks) pause.toDomain()],
  );
}

/// `POST routes` / `PUT routes/{id}` gövdesi.
@freezed
abstract class RoutePlanRequestDto with _$RoutePlanRequestDto {
  const factory RoutePlanRequestDto({
    required String name,
    required List<RouteStopPlanDto> stops,
    @Default(RouteTravelModes.driving) String travelMode,
  }) = _RoutePlanRequestDto;

  const RoutePlanRequestDto._();

  factory RoutePlanRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RoutePlanRequestDtoFromJson(json);

  factory RoutePlanRequestDto.fromDomain(RoutePlan plan) => RoutePlanRequestDto(
    name: plan.name.trim(),
    stops: [for (final stop in plan.stops) RouteStopPlanDto.fromDomain(stop)],
  );

  RoutePlan toDomain() =>
      RoutePlan(name: name, stops: [for (final stop in stops) stop.toDomain()]);
}

@freezed
abstract class RouteStopDto with _$RouteStopDto {
  const factory RouteStopDto({
    required String monumentId,
    required String name,
    required String city,
    required String district,
    @JsonKey(unknownEnumValue: MonumentCategory.other)
    required MonumentCategory category,
    required GeoPointDto location,
    required int visitMinutes,
    @Default(<RouteBreakDto>[]) List<RouteBreakDto> breaks,
  }) = _RouteStopDto;

  const RouteStopDto._();

  factory RouteStopDto.fromJson(Map<String, dynamic> json) =>
      _$RouteStopDtoFromJson(json);

  RouteStop toDomain() => RouteStop(
    monumentId: monumentId,
    name: name,
    city: city,
    district: district,
    category: category,
    location: location.toDomain(),
    visit: Duration(minutes: visitMinutes),
    breaks: [for (final pause in breaks) pause.toDomain()],
  );
}

@freezed
abstract class RouteLegDto with _$RouteLegDto {
  const factory RouteLegDto({
    required int distanceMeters,
    required int durationSeconds,

    /// Encoded polyline (hassasiyet 5).
    required String geometry,
  }) = _RouteLegDto;

  const RouteLegDto._();

  factory RouteLegDto.fromJson(Map<String, dynamic> json) =>
      _$RouteLegDtoFromJson(json);

  /// Bozuk geometri [FormatException] fırlatır.
  RouteLeg toDomain() => RouteLeg(
    distanceMeters: distanceMeters,
    duration: Duration(seconds: durationSeconds),
    geometry: PolylineCodec.decode(geometry),
  );
}

@freezed
abstract class RouteSummaryDto with _$RouteSummaryDto {
  const factory RouteSummaryDto({
    required int distanceMeters,
    required int travelSeconds,
    required int visitSeconds,
    required int breakSeconds,
    required int totalSeconds,
  }) = _RouteSummaryDto;

  const RouteSummaryDto._();

  factory RouteSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$RouteSummaryDtoFromJson(json);

  RouteSummary toDomain() => RouteSummary(
    distanceMeters: distanceMeters,
    travel: Duration(seconds: travelSeconds),
    visit: Duration(seconds: visitSeconds),
    breaks: Duration(seconds: breakSeconds),
  );
}

/// `POST routes`, `GET/PUT routes/{id}` yanıtı.
@freezed
abstract class TravelRouteDto with _$TravelRouteDto {
  const factory TravelRouteDto({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<RouteStopDto> stops,
    required List<RouteLegDto> legs,
    required RouteSummaryDto summary,
    @Default(RouteTravelModes.driving) String travelMode,
  }) = _TravelRouteDto;

  const TravelRouteDto._();

  factory TravelRouteDto.fromJson(Map<String, dynamic> json) =>
      _$TravelRouteDtoFromJson(json);

  TravelRoute toDomain() => TravelRoute(
    id: id,
    name: name,
    createdAt: createdAt,
    updatedAt: updatedAt,
    stops: [for (final stop in stops) stop.toDomain()],
    legs: [for (final leg in legs) leg.toDomain()],
    summary: summary.toDomain(),
  );
}

@freezed
abstract class RouteOverviewDto with _$RouteOverviewDto {
  const factory RouteOverviewDto({
    required String id,
    required String name,
    required DateTime createdAt,
    required int stopCount,
    required List<String> cities,
    required RouteSummaryDto summary,
  }) = _RouteOverviewDto;

  const RouteOverviewDto._();

  factory RouteOverviewDto.fromJson(Map<String, dynamic> json) =>
      _$RouteOverviewDtoFromJson(json);

  RouteOverview toDomain() => RouteOverview(
    id: id,
    name: name,
    createdAt: createdAt,
    cities: cities,
    stopCount: stopCount,
    summary: summary.toDomain(),
  );
}

/// `GET routes` yanıt gövdesi.
@freezed
abstract class RouteListResponseDto with _$RouteListResponseDto {
  const factory RouteListResponseDto({required List<RouteOverviewDto> items}) =
      _RouteListResponseDto;

  factory RouteListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RouteListResponseDtoFromJson(json);
}

/// `POST routes/preview` yanıtı.
@freezed
abstract class RoutePreviewDto with _$RoutePreviewDto {
  const factory RoutePreviewDto({
    required List<RouteLegDto> legs,
    required int distanceMeters,
    required int travelSeconds,
  }) = _RoutePreviewDto;

  const RoutePreviewDto._();

  factory RoutePreviewDto.fromJson(Map<String, dynamic> json) =>
      _$RoutePreviewDtoFromJson(json);

  /// Bozuk geometri [FormatException] fırlatır.
  RoutePreview toDomain(List<String> monumentIds) => RoutePreview(
    monumentIds: monumentIds,
    legs: [for (final leg in legs) leg.toDomain()],
    distanceMeters: distanceMeters,
    travel: Duration(seconds: travelSeconds),
  );
}

/// `POST routes/matrix` yanıtı.
@freezed
abstract class TravelMatrixDto with _$TravelMatrixDto {
  const factory TravelMatrixDto({
    required List<List<int>> durationSeconds,
    required List<List<int>> distanceMeters,
  }) = _TravelMatrixDto;

  const TravelMatrixDto._();

  factory TravelMatrixDto.fromJson(Map<String, dynamic> json) =>
      _$TravelMatrixDtoFromJson(json);

  /// Kare olmayan matris [FormatException] fırlatır.
  TravelMatrix toDomain(int size) {
    bool square(List<List<int>> rows) =>
        rows.length == size && rows.every((row) => row.length == size);
    if (!square(durationSeconds) || !square(distanceMeters)) {
      throw const FormatException('Geçersiz yolculuk matrisi');
    }
    return TravelMatrix(
      durations: [
        for (final row in durationSeconds)
          [for (final seconds in row) Duration(seconds: seconds)],
      ],
      distances: distanceMeters,
    );
  }
}
