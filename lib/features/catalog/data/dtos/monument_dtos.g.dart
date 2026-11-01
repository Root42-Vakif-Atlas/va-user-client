// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monument_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeoPointDto _$GeoPointDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GeoPointDto', json, ($checkedConvert) {
      final val = _GeoPointDto(
        latitude: $checkedConvert('latitude', (v) => (v as num).toDouble()),
        longitude: $checkedConvert('longitude', (v) => (v as num).toDouble()),
      );
      return val;
    });

Map<String, dynamic> _$GeoPointDtoToJson(_GeoPointDto instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_MonumentImageDto _$MonumentImageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MonumentImageDto', json, ($checkedConvert) {
      final val = _MonumentImageDto(
        url: $checkedConvert('url', (v) => v as String),
        thumbnailUrl: $checkedConvert('thumbnailUrl', (v) => v as String),
        author: $checkedConvert('author', (v) => v as String),
        license: $checkedConvert('license', (v) => v as String),
        sourceName: $checkedConvert('sourceName', (v) => v as String),
        altText: $checkedConvert('altText', (v) => v as String?),
        sourceUrl: $checkedConvert('sourceUrl', (v) => v as String?),
        title: $checkedConvert('title', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$MonumentImageDtoToJson(_MonumentImageDto instance) =>
    <String, dynamic>{
      'url': instance.url,
      'thumbnailUrl': instance.thumbnailUrl,
      'author': instance.author,
      'license': instance.license,
      'sourceName': instance.sourceName,
      'altText': instance.altText,
      'sourceUrl': instance.sourceUrl,
      'title': instance.title,
    };

_CityRefDto _$CityRefDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_CityRefDto', json, ($checkedConvert) {
      final val = _CityRefDto(
        code: $checkedConvert('code', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$CityRefDtoToJson(_CityRefDto instance) =>
    <String, dynamic>{'code': instance.code, 'name': instance.name};

_ComplexRefDto _$ComplexRefDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ComplexRefDto', json, ($checkedConvert) {
      final val = _ComplexRefDto(
        key: $checkedConvert('key', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ComplexRefDtoToJson(_ComplexRefDto instance) =>
    <String, dynamic>{'key': instance.key, 'name': instance.name};

_MonumentSummaryDto _$MonumentSummaryDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_MonumentSummaryDto', json, ($checkedConvert) {
  final val = _MonumentSummaryDto(
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
    period: $checkedConvert(
      'period',
      (v) => $enumDecode(
        _$HistoricalPeriodEnumMap,
        v,
        unknownValue: HistoricalPeriod.other,
      ),
    ),
    city: $checkedConvert(
      'city',
      (v) => CityRefDto.fromJson(v as Map<String, dynamic>),
    ),
    slug: $checkedConvert('slug', (v) => v as String?),
    nickname: $checkedConvert('nickname', (v) => v as String?),
    district: $checkedConvert('district', (v) => v as String?),
    address: $checkedConvert('address', (v) => v as String?),
    location: $checkedConvert(
      'location',
      (v) => v == null ? null : GeoPointDto.fromJson(v as Map<String, dynamic>),
    ),
    shortDescription: $checkedConvert('shortDescription', (v) => v as String?),
    thumbnailUrl: $checkedConvert('thumbnailUrl', (v) => v as String?),
    complex: $checkedConvert(
      'complex',
      (v) =>
          v == null ? null : ComplexRefDto.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$MonumentSummaryDtoToJson(_MonumentSummaryDto instance) =>
    <String, dynamic>{
      'key': instance.key,
      'title': instance.title,
      'category': _$MonumentCategoryEnumMap[instance.category]!,
      'period': _$HistoricalPeriodEnumMap[instance.period]!,
      'city': instance.city.toJson(),
      'slug': instance.slug,
      'nickname': instance.nickname,
      'district': instance.district,
      'address': instance.address,
      'location': instance.location?.toJson(),
      'shortDescription': instance.shortDescription,
      'thumbnailUrl': instance.thumbnailUrl,
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

const _$HistoricalPeriodEnumMap = {
  HistoricalPeriod.seljuk: 'seljuk',
  HistoricalPeriod.beylik: 'beylik',
  HistoricalPeriod.ottoman: 'ottoman',
  HistoricalPeriod.other: 'other',
};

_MonumentDetailDto _$MonumentDetailDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_MonumentDetailDto', json, ($checkedConvert) {
  final val = _MonumentDetailDto(
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
    period: $checkedConvert(
      'period',
      (v) => $enumDecode(
        _$HistoricalPeriodEnumMap,
        v,
        unknownValue: HistoricalPeriod.other,
      ),
    ),
    city: $checkedConvert(
      'city',
      (v) => CityRefDto.fromJson(v as Map<String, dynamic>),
    ),
    slug: $checkedConvert('slug', (v) => v as String?),
    nickname: $checkedConvert('nickname', (v) => v as String?),
    district: $checkedConvert('district', (v) => v as String?),
    address: $checkedConvert('address', (v) => v as String?),
    location: $checkedConvert(
      'location',
      (v) => v == null ? null : GeoPointDto.fromJson(v as Map<String, dynamic>),
    ),
    shortDescriptionTitle: $checkedConvert(
      'shortDescriptionTitle',
      (v) => v as String?,
    ),
    shortDescription: $checkedConvert('shortDescription', (v) => v as String?),
    history: $checkedConvert('history', (v) => v as String?),
    constructionDate: $checkedConvert('constructionDate', (v) => v as String?),
    founder: $checkedConvert('founder', (v) => v as String?),
    architect: $checkedConvert('architect', (v) => v as String?),
    isUnescoWorldHeritage: $checkedConvert(
      'isUnescoWorldHeritage',
      (v) => v as bool? ?? false,
    ),
    images: $checkedConvert(
      'images',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => MonumentImageDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MonumentImageDto>[],
    ),
    parts: $checkedConvert(
      'parts',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => MonumentPartDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MonumentPartDto>[],
    ),
    complex: $checkedConvert(
      'complex',
      (v) =>
          v == null ? null : ComplexRefDto.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$MonumentDetailDtoToJson(_MonumentDetailDto instance) =>
    <String, dynamic>{
      'key': instance.key,
      'title': instance.title,
      'category': _$MonumentCategoryEnumMap[instance.category]!,
      'period': _$HistoricalPeriodEnumMap[instance.period]!,
      'city': instance.city.toJson(),
      'slug': instance.slug,
      'nickname': instance.nickname,
      'district': instance.district,
      'address': instance.address,
      'location': instance.location?.toJson(),
      'shortDescriptionTitle': instance.shortDescriptionTitle,
      'shortDescription': instance.shortDescription,
      'history': instance.history,
      'constructionDate': instance.constructionDate,
      'founder': instance.founder,
      'architect': instance.architect,
      'isUnescoWorldHeritage': instance.isUnescoWorldHeritage,
      'images': instance.images.map((e) => e.toJson()).toList(),
      'parts': instance.parts.map((e) => e.toJson()).toList(),
      'complex': instance.complex?.toJson(),
    };

_MonumentPartDto _$MonumentPartDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MonumentPartDto', json, ($checkedConvert) {
      final val = _MonumentPartDto(
        description: $checkedConvert('description', (v) => v as String?),
        title: $checkedConvert('title', (v) => v as String?),
        images: $checkedConvert(
          'images',
          (v) =>
              (v as List<dynamic>?)
                  ?.map(
                    (e) => MonumentImageDto.fromJson(e as Map<String, dynamic>),
                  )
                  .toList() ??
              const <MonumentImageDto>[],
        ),
      );
      return val;
    });

Map<String, dynamic> _$MonumentPartDtoToJson(_MonumentPartDto instance) =>
    <String, dynamic>{
      'description': instance.description,
      'title': instance.title,
      'images': instance.images.map((e) => e.toJson()).toList(),
    };

_ComplexMembersPageDto _$ComplexMembersPageDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ComplexMembersPageDto', json, ($checkedConvert) {
  final val = _ComplexMembersPageDto(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => MonumentSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    total: $checkedConvert('total', (v) => (v as num?)?.toInt() ?? 0),
    nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$ComplexMembersPageDtoToJson(
  _ComplexMembersPageDto instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'nextCursor': instance.nextCursor,
};

_ComplexDetailDto _$ComplexDetailDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ComplexDetailDto', json, ($checkedConvert) {
  final val = _ComplexDetailDto(
    key: $checkedConvert('key', (v) => v as String),
    name: $checkedConvert('name', (v) => v as String),
    city: $checkedConvert(
      'city',
      (v) => CityRefDto.fromJson(v as Map<String, dynamic>),
    ),
    workCount: $checkedConvert('workCount', (v) => (v as num).toInt()),
    works: $checkedConvert(
      'works',
      (v) => ComplexMembersPageDto.fromJson(v as Map<String, dynamic>),
    ),
    district: $checkedConvert('district', (v) => v as String?),
    address: $checkedConvert('address', (v) => v as String?),
    location: $checkedConvert(
      'location',
      (v) => v == null ? null : GeoPointDto.fromJson(v as Map<String, dynamic>),
    ),
    images: $checkedConvert(
      'images',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => MonumentImageDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MonumentImageDto>[],
    ),
    footprint: $checkedConvert(
      'footprint',
      (v) => v == null ? const <List<double>>[] : footprintFromJson(v),
    ),
    bounds: $checkedConvert(
      'bounds',
      (v) => (v as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$ComplexDetailDtoToJson(_ComplexDetailDto instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'city': instance.city.toJson(),
      'workCount': instance.workCount,
      'works': instance.works.toJson(),
      'district': instance.district,
      'address': instance.address,
      'location': instance.location?.toJson(),
      'images': instance.images.map((e) => e.toJson()).toList(),
      'footprint': instance.footprint,
      'bounds': instance.bounds,
    };
