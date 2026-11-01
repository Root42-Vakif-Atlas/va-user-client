// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_tile_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapTileClusterDto _$MapTileClusterDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MapTileClusterDto', json, ($checkedConvert) {
      final val = MapTileClusterDto(
        key: $checkedConvert('key', (v) => v as String),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        lat: $checkedConvert('lat', (v) => (v as num).toDouble()),
        lng: $checkedConvert('lng', (v) => (v as num).toDouble()),
        bounds: $checkedConvert(
          'bounds',
          (v) =>
              (v as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
        ),
        $type: $checkedConvert('type', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'type'});

Map<String, dynamic> _$MapTileClusterDtoToJson(MapTileClusterDto instance) =>
    <String, dynamic>{
      'key': instance.key,
      'count': instance.count,
      'lat': instance.lat,
      'lng': instance.lng,
      'bounds': instance.bounds,
      'type': instance.$type,
    };

MapTileMonumentDto _$MapTileMonumentDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MapTileMonumentDto', json, ($checkedConvert) {
      final val = MapTileMonumentDto(
        key: $checkedConvert('key', (v) => v as String),
        title: $checkedConvert('title', (v) => v as String),
        category: $checkedConvert(
          'category',
          (v) => $enumDecode(
            _$MonumentCategoryEnumMap,
            v,
            unknownValue: MonumentCategory.other,
          ),
        ),
        city: $checkedConvert(
          'city',
          (v) => CityRefDto.fromJson(v as Map<String, dynamic>),
        ),
        lat: $checkedConvert('lat', (v) => (v as num).toDouble()),
        lng: $checkedConvert('lng', (v) => (v as num).toDouble()),
        slug: $checkedConvert('slug', (v) => v as String?),
        district: $checkedConvert('district', (v) => v as String?),
        complex: $checkedConvert(
          'complex',
          (v) => v == null
              ? null
              : ComplexRefDto.fromJson(v as Map<String, dynamic>),
        ),
        $type: $checkedConvert('type', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'type'});

Map<String, dynamic> _$MapTileMonumentDtoToJson(MapTileMonumentDto instance) =>
    <String, dynamic>{
      'key': instance.key,
      'title': instance.title,
      'category': _$MonumentCategoryEnumMap[instance.category]!,
      'city': instance.city.toJson(),
      'lat': instance.lat,
      'lng': instance.lng,
      'slug': instance.slug,
      'district': instance.district,
      'complex': instance.complex?.toJson(),
      'type': instance.$type,
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

MapTileComplexDto _$MapTileComplexDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MapTileComplexDto', json, ($checkedConvert) {
      final val = MapTileComplexDto(
        key: $checkedConvert('key', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        city: $checkedConvert(
          'city',
          (v) => CityRefDto.fromJson(v as Map<String, dynamic>),
        ),
        lat: $checkedConvert('lat', (v) => (v as num).toDouble()),
        lng: $checkedConvert('lng', (v) => (v as num).toDouble()),
        workCount: $checkedConvert('workCount', (v) => (v as num).toInt()),
        district: $checkedConvert('district', (v) => v as String?),
        footprint: $checkedConvert(
          'footprint',
          (v) => v == null ? const <List<double>>[] : footprintFromJson(v),
        ),
        $type: $checkedConvert('type', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'type'});

Map<String, dynamic> _$MapTileComplexDtoToJson(MapTileComplexDto instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'city': instance.city.toJson(),
      'lat': instance.lat,
      'lng': instance.lng,
      'workCount': instance.workCount,
      'district': instance.district,
      'footprint': instance.footprint,
      'type': instance.$type,
    };

MapTileUnknownDto _$MapTileUnknownDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MapTileUnknownDto', json, ($checkedConvert) {
      final val = MapTileUnknownDto(
        $type: $checkedConvert('type', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'type'});

Map<String, dynamic> _$MapTileUnknownDtoToJson(MapTileUnknownDto instance) =>
    <String, dynamic>{'type': instance.$type};

_MapTileResponseDto _$MapTileResponseDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MapTileResponseDto', json, ($checkedConvert) {
      final val = _MapTileResponseDto(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => MapTileItemDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$MapTileResponseDtoToJson(_MapTileResponseDto instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};

_MapExtentDto _$MapExtentDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MapExtentDto', json, ($checkedConvert) {
      final val = _MapExtentDto(
        total: $checkedConvert('total', (v) => (v as num).toInt()),
        version: $checkedConvert('version', (v) => v as String),
        bounds: $checkedConvert(
          'bounds',
          (v) =>
              (v as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$MapExtentDtoToJson(_MapExtentDto instance) =>
    <String, dynamic>{
      'total': instance.total,
      'version': instance.version,
      'bounds': instance.bounds,
    };
