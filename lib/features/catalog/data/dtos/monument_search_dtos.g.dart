// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monument_search_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonumentSearchResponseDto _$MonumentSearchResponseDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_MonumentSearchResponseDto', json, ($checkedConvert) {
  final val = _MonumentSearchResponseDto(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => MonumentSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    total: $checkedConvert('total', (v) => (v as num).toInt()),
    nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
    places: $checkedConvert(
      'places',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => MonumentPlaceDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MonumentPlaceDto>[],
    ),
    facets: $checkedConvert(
      'facets',
      (v) => v == null
          ? null
          : MonumentFacetsDto.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$MonumentSearchResponseDtoToJson(
  _MonumentSearchResponseDto instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'nextCursor': instance.nextCursor,
  'places': instance.places.map((e) => e.toJson()).toList(),
  'facets': instance.facets?.toJson(),
};

_MonumentPlaceDto _$MonumentPlaceDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MonumentPlaceDto', json, ($checkedConvert) {
      final val = _MonumentPlaceDto(
        city: $checkedConvert(
          'city',
          (v) => CityRefDto.fromJson(v as Map<String, dynamic>),
        ),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        district: $checkedConvert('district', (v) => v as String?),
        bounds: $checkedConvert(
          'bounds',
          (v) =>
              (v as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$MonumentPlaceDtoToJson(_MonumentPlaceDto instance) =>
    <String, dynamic>{
      'city': instance.city.toJson(),
      'count': instance.count,
      'district': instance.district,
      'bounds': instance.bounds,
    };

_CityFacetDto _$CityFacetDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_CityFacetDto', json, ($checkedConvert) {
      final val = _CityFacetDto(
        code: $checkedConvert('code', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$CityFacetDtoToJson(_CityFacetDto instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'count': instance.count,
    };

_MonumentFacetsDto _$MonumentFacetsDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MonumentFacetsDto', json, ($checkedConvert) {
      final val = _MonumentFacetsDto(
        category: $checkedConvert(
          'category',
          (v) =>
              (v as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const <String, int>{},
        ),
        period: $checkedConvert(
          'period',
          (v) =>
              (v as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const <String, int>{},
        ),
        city: $checkedConvert(
          'city',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => CityFacetDto.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const <CityFacetDto>[],
        ),
      );
      return val;
    });

Map<String, dynamic> _$MonumentFacetsDtoToJson(_MonumentFacetsDto instance) =>
    <String, dynamic>{
      'category': instance.category,
      'period': instance.period,
      'city': instance.city.map((e) => e.toJson()).toList(),
    };

_MonumentPinDto _$MonumentPinDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_MonumentPinDto', json, ($checkedConvert) {
  final val = _MonumentPinDto(
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
    slug: $checkedConvert('slug', (v) => v as String?),
    district: $checkedConvert('district', (v) => v as String?),
    location: $checkedConvert(
      'location',
      (v) => v == null ? null : GeoPointDto.fromJson(v as Map<String, dynamic>),
    ),
    complex: $checkedConvert(
      'complex',
      (v) =>
          v == null ? null : ComplexRefDto.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$MonumentPinDtoToJson(_MonumentPinDto instance) =>
    <String, dynamic>{
      'key': instance.key,
      'title': instance.title,
      'category': _$MonumentCategoryEnumMap[instance.category]!,
      'city': instance.city.toJson(),
      'slug': instance.slug,
      'district': instance.district,
      'location': instance.location?.toJson(),
      'complex': instance.complex?.toJson(),
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

_MonumentPinPageDto _$MonumentPinPageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MonumentPinPageDto', json, ($checkedConvert) {
      final val = _MonumentPinPageDto(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => MonumentPinDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        total: $checkedConvert('total', (v) => (v as num?)?.toInt() ?? 0),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$MonumentPinPageDtoToJson(_MonumentPinPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'nextCursor': instance.nextCursor,
    };
