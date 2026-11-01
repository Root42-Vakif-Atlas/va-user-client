// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemoryAuthorDto _$MemoryAuthorDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MemoryAuthorDto', json, ($checkedConvert) {
      final val = _MemoryAuthorDto(
        id: $checkedConvert('id', (v) => v as String),
        displayName: $checkedConvert('displayName', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$MemoryAuthorDtoToJson(_MemoryAuthorDto instance) =>
    <String, dynamic>{'id': instance.id, 'displayName': instance.displayName};

_MemoryPhotoDto _$MemoryPhotoDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MemoryPhotoDto', json, ($checkedConvert) {
      final val = _MemoryPhotoDto(
        id: $checkedConvert('id', (v) => v as String),
        url: $checkedConvert('url', (v) => v as String),
        thumbnailUrl: $checkedConvert('thumbnailUrl', (v) => v as String),
        width: $checkedConvert('width', (v) => (v as num).toInt()),
        height: $checkedConvert('height', (v) => (v as num).toInt()),
        description: $checkedConvert('description', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$MemoryPhotoDtoToJson(_MemoryPhotoDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'thumbnailUrl': instance.thumbnailUrl,
      'width': instance.width,
      'height': instance.height,
      'description': instance.description,
    };

_MemoryDto _$MemoryDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_MemoryDto', json, ($checkedConvert) {
  final val = _MemoryDto(
    id: $checkedConvert('id', (v) => v as String),
    monumentId: $checkedConvert('monumentId', (v) => v as String),
    author: $checkedConvert(
      'author',
      (v) => MemoryAuthorDto.fromJson(v as Map<String, dynamic>),
    ),
    text: $checkedConvert('text', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    photos: $checkedConvert(
      'photos',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => MemoryPhotoDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MemoryPhotoDto>[],
    ),
    visitedOn: $checkedConvert('visitedOn', (v) => v as String?),
    memoryDate: $checkedConvert('memoryDate', (v) => v as String?),
    status: $checkedConvert(
      'status',
      (v) =>
          $enumDecodeNullable(
            _$MemoryModerationStatusEnumMap,
            v,
            unknownValue: MemoryModerationStatus.pending,
          ) ??
          MemoryModerationStatus.approved,
    ),
  );
  return val;
});

Map<String, dynamic> _$MemoryDtoToJson(_MemoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'monumentId': instance.monumentId,
      'author': instance.author.toJson(),
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
      'photos': instance.photos.map((e) => e.toJson()).toList(),
      'visitedOn': instance.visitedOn,
      'memoryDate': instance.memoryDate,
      'status': _$MemoryModerationStatusEnumMap[instance.status]!,
    };

const _$MemoryModerationStatusEnumMap = {
  MemoryModerationStatus.approved: 'approved',
  MemoryModerationStatus.pending: 'pending',
  MemoryModerationStatus.rejected: 'rejected',
};

_MemoryYearCountDto _$MemoryYearCountDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MemoryYearCountDto', json, ($checkedConvert) {
      final val = _MemoryYearCountDto(
        year: $checkedConvert('year', (v) => (v as num).toInt()),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$MemoryYearCountDtoToJson(_MemoryYearCountDto instance) =>
    <String, dynamic>{'year': instance.year, 'count': instance.count};

_MemoryFacetsDto _$MemoryFacetsDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MemoryFacetsDto', json, ($checkedConvert) {
      final val = _MemoryFacetsDto(
        years: $checkedConvert(
          'years',
          (v) =>
              (v as List<dynamic>?)
                  ?.map(
                    (e) =>
                        MemoryYearCountDto.fromJson(e as Map<String, dynamic>),
                  )
                  .toList() ??
              const <MemoryYearCountDto>[],
        ),
      );
      return val;
    });

Map<String, dynamic> _$MemoryFacetsDtoToJson(_MemoryFacetsDto instance) =>
    <String, dynamic>{'years': instance.years.map((e) => e.toJson()).toList()};

_MemoryPageDto _$MemoryPageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MemoryPageDto', json, ($checkedConvert) {
      final val = _MemoryPageDto(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => MemoryDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        total: $checkedConvert('total', (v) => (v as num).toInt()),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
        facets: $checkedConvert(
          'facets',
          (v) => v == null
              ? null
              : MemoryFacetsDto.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$MemoryPageDtoToJson(_MemoryPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'nextCursor': instance.nextCursor,
      'facets': instance.facets?.toJson(),
    };

_PhotoUploadRequestDto _$PhotoUploadRequestDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_PhotoUploadRequestDto', json, ($checkedConvert) {
  final val = _PhotoUploadRequestDto(
    contentType: $checkedConvert('contentType', (v) => v as String),
    byteSize: $checkedConvert('byteSize', (v) => (v as num).toInt()),
    width: $checkedConvert('width', (v) => (v as num).toInt()),
    height: $checkedConvert('height', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$PhotoUploadRequestDtoToJson(
  _PhotoUploadRequestDto instance,
) => <String, dynamic>{
  'contentType': instance.contentType,
  'byteSize': instance.byteSize,
  'width': instance.width,
  'height': instance.height,
};

_PhotoUploadTicketDto _$PhotoUploadTicketDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_PhotoUploadTicketDto', json, ($checkedConvert) {
  final val = _PhotoUploadTicketDto(
    id: $checkedConvert('id', (v) => v as String),
    uploadUrl: $checkedConvert('uploadUrl', (v) => v as String),
    expiresAt: $checkedConvert('expiresAt', (v) => DateTime.parse(v as String)),
    uploadHeaders: $checkedConvert(
      'uploadHeaders',
      (v) =>
          (v as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
    ),
  );
  return val;
});

Map<String, dynamic> _$PhotoUploadTicketDtoToJson(
  _PhotoUploadTicketDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'uploadUrl': instance.uploadUrl,
  'expiresAt': instance.expiresAt.toIso8601String(),
  'uploadHeaders': instance.uploadHeaders,
};

_MemoryPhotoAttachmentDto _$MemoryPhotoAttachmentDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_MemoryPhotoAttachmentDto', json, ($checkedConvert) {
  final val = _MemoryPhotoAttachmentDto(
    uploadId: $checkedConvert('uploadId', (v) => v as String),
    description: $checkedConvert('description', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$MemoryPhotoAttachmentDtoToJson(
  _MemoryPhotoAttachmentDto instance,
) => <String, dynamic>{
  'uploadId': instance.uploadId,
  'description': ?instance.description,
};

_CreateMemoryRequestDto _$CreateMemoryRequestDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_CreateMemoryRequestDto', json, ($checkedConvert) {
  final val = _CreateMemoryRequestDto(
    monumentId: $checkedConvert('monumentId', (v) => v as String),
    text: $checkedConvert('text', (v) => v as String),
    photos: $checkedConvert(
      'photos',
      (v) =>
          (v as List<dynamic>?)
              ?.map(
                (e) => MemoryPhotoAttachmentDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const <MemoryPhotoAttachmentDto>[],
    ),
    visitedOn: $checkedConvert('visitedOn', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$CreateMemoryRequestDtoToJson(
  _CreateMemoryRequestDto instance,
) => <String, dynamic>{
  'monumentId': instance.monumentId,
  'text': instance.text,
  'photos': instance.photos.map((e) => e.toJson()).toList(),
  'visitedOn': ?instance.visitedOn,
};

_MemoryReportRequestDto _$MemoryReportRequestDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_MemoryReportRequestDto', json, ($checkedConvert) {
  final val = _MemoryReportRequestDto(
    reason: $checkedConvert(
      'reason',
      (v) => $enumDecode(_$MemoryReportReasonEnumMap, v),
    ),
    note: $checkedConvert('note', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$MemoryReportRequestDtoToJson(
  _MemoryReportRequestDto instance,
) => <String, dynamic>{
  'reason': _$MemoryReportReasonEnumMap[instance.reason]!,
  'note': ?instance.note,
};

const _$MemoryReportReasonEnumMap = {
  MemoryReportReason.offensive: 'offensive',
  MemoryReportReason.inappropriate: 'inappropriate',
  MemoryReportReason.spam: 'spam',
  MemoryReportReason.personalInfo: 'personalInfo',
  MemoryReportReason.unrelated: 'unrelated',
  MemoryReportReason.other: 'other',
};
