// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RouteBreakDto _$RouteBreakDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_RouteBreakDto', json, ($checkedConvert) {
      final val = _RouteBreakDto(
        kind: $checkedConvert(
          'kind',
          (v) => $enumDecode(
            _$RouteBreakKindEnumMap,
            v,
            unknownValue: RouteBreakKind.rest,
          ),
        ),
        minutes: $checkedConvert('minutes', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$RouteBreakDtoToJson(_RouteBreakDto instance) =>
    <String, dynamic>{
      'kind': _$RouteBreakKindEnumMap[instance.kind]!,
      'minutes': instance.minutes,
    };

const _$RouteBreakKindEnumMap = {
  RouteBreakKind.shortBreak: 'shortBreak',
  RouteBreakKind.meal: 'meal',
  RouteBreakKind.rest: 'rest',
  RouteBreakKind.overnight: 'overnight',
};

_RouteStopPlanDto _$RouteStopPlanDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_RouteStopPlanDto', json, ($checkedConvert) {
  final val = _RouteStopPlanDto(
    monumentId: $checkedConvert('monumentId', (v) => v as String),
    visitMinutes: $checkedConvert('visitMinutes', (v) => (v as num).toInt()),
    breaks: $checkedConvert(
      'breaks',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => RouteBreakDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <RouteBreakDto>[],
    ),
  );
  return val;
});

Map<String, dynamic> _$RouteStopPlanDtoToJson(_RouteStopPlanDto instance) =>
    <String, dynamic>{
      'monumentId': instance.monumentId,
      'visitMinutes': instance.visitMinutes,
      'breaks': instance.breaks.map((e) => e.toJson()).toList(),
    };

_RoutePlanRequestDto _$RoutePlanRequestDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_RoutePlanRequestDto', json, ($checkedConvert) {
      final val = _RoutePlanRequestDto(
        name: $checkedConvert('name', (v) => v as String),
        stops: $checkedConvert(
          'stops',
          (v) => (v as List<dynamic>)
              .map((e) => RouteStopPlanDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        travelMode: $checkedConvert(
          'travelMode',
          (v) => v as String? ?? RouteTravelModes.driving,
        ),
      );
      return val;
    });

Map<String, dynamic> _$RoutePlanRequestDtoToJson(
  _RoutePlanRequestDto instance,
) => <String, dynamic>{
  'name': instance.name,
  'stops': instance.stops.map((e) => e.toJson()).toList(),
  'travelMode': instance.travelMode,
};

_RouteStopDto _$RouteStopDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_RouteStopDto', json, ($checkedConvert) {
  final val = _RouteStopDto(
    monumentId: $checkedConvert('monumentId', (v) => v as String),
    name: $checkedConvert('name', (v) => v as String),
    city: $checkedConvert('city', (v) => v as String),
    district: $checkedConvert('district', (v) => v as String),
    category: $checkedConvert(
      'category',
      (v) => $enumDecode(
        _$MonumentCategoryEnumMap,
        v,
        unknownValue: MonumentCategory.other,
      ),
    ),
    location: $checkedConvert(
      'location',
      (v) => GeoPointDto.fromJson(v as Map<String, dynamic>),
    ),
    visitMinutes: $checkedConvert('visitMinutes', (v) => (v as num).toInt()),
    breaks: $checkedConvert(
      'breaks',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => RouteBreakDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <RouteBreakDto>[],
    ),
  );
  return val;
});

Map<String, dynamic> _$RouteStopDtoToJson(_RouteStopDto instance) =>
    <String, dynamic>{
      'monumentId': instance.monumentId,
      'name': instance.name,
      'city': instance.city,
      'district': instance.district,
      'category': _$MonumentCategoryEnumMap[instance.category]!,
      'location': instance.location.toJson(),
      'visitMinutes': instance.visitMinutes,
      'breaks': instance.breaks.map((e) => e.toJson()).toList(),
    };

const _$MonumentCategoryEnumMap = {
  MonumentCategory.mosque: 'mosque',
  MonumentCategory.complex: 'complex',
  MonumentCategory.madrasa: 'madrasa',
  MonumentCategory.inn: 'inn',
  MonumentCategory.caravanserai: 'caravanserai',
  MonumentCategory.bath: 'bath',
  MonumentCategory.fountain: 'fountain',
  MonumentCategory.tomb: 'tomb',
  MonumentCategory.hospital: 'hospital',
  MonumentCategory.imaret: 'imaret',
  MonumentCategory.other: 'other',
};

_RouteLegDto _$RouteLegDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_RouteLegDto', json, ($checkedConvert) {
      final val = _RouteLegDto(
        distanceMeters: $checkedConvert(
          'distanceMeters',
          (v) => (v as num).toInt(),
        ),
        durationSeconds: $checkedConvert(
          'durationSeconds',
          (v) => (v as num).toInt(),
        ),
        geometry: $checkedConvert('geometry', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$RouteLegDtoToJson(_RouteLegDto instance) =>
    <String, dynamic>{
      'distanceMeters': instance.distanceMeters,
      'durationSeconds': instance.durationSeconds,
      'geometry': instance.geometry,
    };

_RouteSummaryDto _$RouteSummaryDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_RouteSummaryDto', json, ($checkedConvert) {
  final val = _RouteSummaryDto(
    distanceMeters: $checkedConvert(
      'distanceMeters',
      (v) => (v as num).toInt(),
    ),
    travelSeconds: $checkedConvert('travelSeconds', (v) => (v as num).toInt()),
    visitSeconds: $checkedConvert('visitSeconds', (v) => (v as num).toInt()),
    breakSeconds: $checkedConvert('breakSeconds', (v) => (v as num).toInt()),
    totalSeconds: $checkedConvert('totalSeconds', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$RouteSummaryDtoToJson(_RouteSummaryDto instance) =>
    <String, dynamic>{
      'distanceMeters': instance.distanceMeters,
      'travelSeconds': instance.travelSeconds,
      'visitSeconds': instance.visitSeconds,
      'breakSeconds': instance.breakSeconds,
      'totalSeconds': instance.totalSeconds,
    };

_TravelRouteDto _$TravelRouteDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_TravelRouteDto', json, ($checkedConvert) {
  final val = _TravelRouteDto(
    id: $checkedConvert('id', (v) => v as String),
    name: $checkedConvert('name', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    stops: $checkedConvert(
      'stops',
      (v) => (v as List<dynamic>)
          .map((e) => RouteStopDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    legs: $checkedConvert(
      'legs',
      (v) => (v as List<dynamic>)
          .map((e) => RouteLegDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    summary: $checkedConvert(
      'summary',
      (v) => RouteSummaryDto.fromJson(v as Map<String, dynamic>),
    ),
    travelMode: $checkedConvert(
      'travelMode',
      (v) => v as String? ?? RouteTravelModes.driving,
    ),
  );
  return val;
});

Map<String, dynamic> _$TravelRouteDtoToJson(_TravelRouteDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'stops': instance.stops.map((e) => e.toJson()).toList(),
      'legs': instance.legs.map((e) => e.toJson()).toList(),
      'summary': instance.summary.toJson(),
      'travelMode': instance.travelMode,
    };

_RouteOverviewDto _$RouteOverviewDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_RouteOverviewDto', json, ($checkedConvert) {
      final val = _RouteOverviewDto(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        stopCount: $checkedConvert('stopCount', (v) => (v as num).toInt()),
        cities: $checkedConvert(
          'cities',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        summary: $checkedConvert(
          'summary',
          (v) => RouteSummaryDto.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$RouteOverviewDtoToJson(_RouteOverviewDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'stopCount': instance.stopCount,
      'cities': instance.cities,
      'summary': instance.summary.toJson(),
    };

_RouteListResponseDto _$RouteListResponseDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_RouteListResponseDto', json, ($checkedConvert) {
  final val = _RouteListResponseDto(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => RouteOverviewDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$RouteListResponseDtoToJson(
  _RouteListResponseDto instance,
) => <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};

_RoutePreviewDto _$RoutePreviewDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_RoutePreviewDto', json, ($checkedConvert) {
      final val = _RoutePreviewDto(
        legs: $checkedConvert(
          'legs',
          (v) => (v as List<dynamic>)
              .map((e) => RouteLegDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        distanceMeters: $checkedConvert(
          'distanceMeters',
          (v) => (v as num).toInt(),
        ),
        travelSeconds: $checkedConvert(
          'travelSeconds',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$RoutePreviewDtoToJson(_RoutePreviewDto instance) =>
    <String, dynamic>{
      'legs': instance.legs.map((e) => e.toJson()).toList(),
      'distanceMeters': instance.distanceMeters,
      'travelSeconds': instance.travelSeconds,
    };

_TravelMatrixDto _$TravelMatrixDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_TravelMatrixDto', json, ($checkedConvert) {
  final val = _TravelMatrixDto(
    durationSeconds: $checkedConvert(
      'durationSeconds',
      (v) => (v as List<dynamic>)
          .map(
            (e) => (e as List<dynamic>).map((e) => (e as num).toInt()).toList(),
          )
          .toList(),
    ),
    distanceMeters: $checkedConvert(
      'distanceMeters',
      (v) => (v as List<dynamic>)
          .map(
            (e) => (e as List<dynamic>).map((e) => (e as num).toInt()).toList(),
          )
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$TravelMatrixDtoToJson(_TravelMatrixDto instance) =>
    <String, dynamic>{
      'durationSeconds': instance.durationSeconds,
      'distanceMeters': instance.distanceMeters,
    };
