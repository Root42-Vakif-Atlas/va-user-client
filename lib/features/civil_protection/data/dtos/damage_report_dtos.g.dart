// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damage_report_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportMonumentDto _$ReportMonumentDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ReportMonumentDto', json, ($checkedConvert) {
      final val = _ReportMonumentDto(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        city: $checkedConvert('city', (v) => v as String),
        district: $checkedConvert('district', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ReportMonumentDtoToJson(_ReportMonumentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'city': instance.city,
      'district': instance.district,
    };

_ReportPhotoDto _$ReportPhotoDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ReportPhotoDto', json, ($checkedConvert) {
      final val = _ReportPhotoDto(
        id: $checkedConvert('id', (v) => v as String),
        url: $checkedConvert('url', (v) => v as String),
        thumbnailUrl: $checkedConvert('thumbnailUrl', (v) => v as String),
        width: $checkedConvert('width', (v) => (v as num).toInt()),
        height: $checkedConvert('height', (v) => (v as num).toInt()),
        description: $checkedConvert('description', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ReportPhotoDtoToJson(_ReportPhotoDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'thumbnailUrl': instance.thumbnailUrl,
      'width': instance.width,
      'height': instance.height,
      'description': instance.description,
    };

_ReportLocationCheckDto _$ReportLocationCheckDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ReportLocationCheckDto', json, ($checkedConvert) {
  final val = _ReportLocationCheckDto(
    verification: $checkedConvert(
      'verification',
      (v) => $enumDecode(
        _$LocationVerificationEnumMap,
        v,
        unknownValue: LocationVerification.notProvided,
      ),
    ),
    distanceMeters: $checkedConvert(
      'distanceMeters',
      (v) => (v as num?)?.toInt(),
    ),
  );
  return val;
});

Map<String, dynamic> _$ReportLocationCheckDtoToJson(
  _ReportLocationCheckDto instance,
) => <String, dynamic>{
  'verification': _$LocationVerificationEnumMap[instance.verification]!,
  'distanceMeters': instance.distanceMeters,
};

const _$LocationVerificationEnumMap = {
  LocationVerification.notProvided: 'notProvided',
  LocationVerification.onSite: 'onSite',
  LocationVerification.distant: 'distant',
};

_DamageReportStatusChangeDto _$DamageReportStatusChangeDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_DamageReportStatusChangeDto', json, ($checkedConvert) {
  final val = _DamageReportStatusChangeDto(
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(
        _$DamageReportStatusEnumMap,
        v,
        unknownValue: DamageReportStatus.inReview,
      ),
    ),
    at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
    note: $checkedConvert('note', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$DamageReportStatusChangeDtoToJson(
  _DamageReportStatusChangeDto instance,
) => <String, dynamic>{
  'status': _$DamageReportStatusEnumMap[instance.status]!,
  'at': instance.at.toIso8601String(),
  'note': instance.note,
};

const _$DamageReportStatusEnumMap = {
  DamageReportStatus.received: 'received',
  DamageReportStatus.inReview: 'inReview',
  DamageReportStatus.forwarded: 'forwarded',
  DamageReportStatus.resolved: 'resolved',
  DamageReportStatus.closed: 'closed',
};

_DamageReportDto _$DamageReportDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_DamageReportDto', json, ($checkedConvert) {
  final val = _DamageReportDto(
    id: $checkedConvert('id', (v) => v as String),
    referenceCode: $checkedConvert('referenceCode', (v) => v as String),
    monument: $checkedConvert(
      'monument',
      (v) => ReportMonumentDto.fromJson(v as Map<String, dynamic>),
    ),
    category: $checkedConvert(
      'category',
      (v) => $enumDecode(
        _$DamageCategoryEnumMap,
        v,
        unknownValue: DamageCategory.other,
      ),
    ),
    urgency: $checkedConvert(
      'urgency',
      (v) => $enumDecode(
        _$ReportUrgencyEnumMap,
        v,
        unknownValue: ReportUrgency.medium,
      ),
    ),
    description: $checkedConvert('description', (v) => v as String),
    locationCheck: $checkedConvert(
      'locationCheck',
      (v) => ReportLocationCheckDto.fromJson(v as Map<String, dynamic>),
    ),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(
        _$DamageReportStatusEnumMap,
        v,
        unknownValue: DamageReportStatus.inReview,
      ),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    photos: $checkedConvert(
      'photos',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => ReportPhotoDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ReportPhotoDto>[],
    ),
    history: $checkedConvert(
      'history',
      (v) =>
          (v as List<dynamic>?)
              ?.map(
                (e) => DamageReportStatusChangeDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const <DamageReportStatusChangeDto>[],
    ),
  );
  return val;
});

Map<String, dynamic> _$DamageReportDtoToJson(_DamageReportDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'referenceCode': instance.referenceCode,
      'monument': instance.monument.toJson(),
      'category': _$DamageCategoryEnumMap[instance.category]!,
      'urgency': _$ReportUrgencyEnumMap[instance.urgency]!,
      'description': instance.description,
      'locationCheck': instance.locationCheck.toJson(),
      'status': _$DamageReportStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'photos': instance.photos.map((e) => e.toJson()).toList(),
      'history': instance.history.map((e) => e.toJson()).toList(),
    };

const _$DamageCategoryEnumMap = {
  DamageCategory.structuralDamage: 'structuralDamage',
  DamageCategory.collapseRisk: 'collapseRisk',
  DamageCategory.vandalism: 'vandalism',
  DamageCategory.theft: 'theft',
  DamageCategory.fireOrWater: 'fireOrWater',
  DamageCategory.unauthorizedWork: 'unauthorizedWork',
  DamageCategory.other: 'other',
};

const _$ReportUrgencyEnumMap = {
  ReportUrgency.low: 'low',
  ReportUrgency.medium: 'medium',
  ReportUrgency.high: 'high',
  ReportUrgency.critical: 'critical',
};

_DamageReportPageDto _$DamageReportPageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_DamageReportPageDto', json, ($checkedConvert) {
      final val = _DamageReportPageDto(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => DamageReportDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        total: $checkedConvert('total', (v) => (v as num).toInt()),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$DamageReportPageDtoToJson(
  _DamageReportPageDto instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'nextCursor': instance.nextCursor,
};

_ReportPhotoUploadRequestDto _$ReportPhotoUploadRequestDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ReportPhotoUploadRequestDto', json, ($checkedConvert) {
  final val = _ReportPhotoUploadRequestDto(
    contentType: $checkedConvert('contentType', (v) => v as String),
    byteSize: $checkedConvert('byteSize', (v) => (v as num).toInt()),
    width: $checkedConvert('width', (v) => (v as num).toInt()),
    height: $checkedConvert('height', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$ReportPhotoUploadRequestDtoToJson(
  _ReportPhotoUploadRequestDto instance,
) => <String, dynamic>{
  'contentType': instance.contentType,
  'byteSize': instance.byteSize,
  'width': instance.width,
  'height': instance.height,
};

_ReportPhotoUploadTicketDto _$ReportPhotoUploadTicketDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ReportPhotoUploadTicketDto', json, ($checkedConvert) {
  final val = _ReportPhotoUploadTicketDto(
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

Map<String, dynamic> _$ReportPhotoUploadTicketDtoToJson(
  _ReportPhotoUploadTicketDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'uploadUrl': instance.uploadUrl,
  'expiresAt': instance.expiresAt.toIso8601String(),
  'uploadHeaders': instance.uploadHeaders,
};

_ReportPhotoAttachmentDto _$ReportPhotoAttachmentDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ReportPhotoAttachmentDto', json, ($checkedConvert) {
  final val = _ReportPhotoAttachmentDto(
    uploadId: $checkedConvert('uploadId', (v) => v as String),
    description: $checkedConvert('description', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$ReportPhotoAttachmentDtoToJson(
  _ReportPhotoAttachmentDto instance,
) => <String, dynamic>{
  'uploadId': instance.uploadId,
  'description': ?instance.description,
};

_ReportLocationDto _$ReportLocationDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ReportLocationDto', json, ($checkedConvert) {
      final val = _ReportLocationDto(
        latitude: $checkedConvert('latitude', (v) => (v as num).toDouble()),
        longitude: $checkedConvert('longitude', (v) => (v as num).toDouble()),
        accuracyMeters: $checkedConvert(
          'accuracyMeters',
          (v) => (v as num).toDouble(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ReportLocationDtoToJson(_ReportLocationDto instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'accuracyMeters': instance.accuracyMeters,
    };

_SubmitDamageReportRequestDto _$SubmitDamageReportRequestDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_SubmitDamageReportRequestDto', json, ($checkedConvert) {
  final val = _SubmitDamageReportRequestDto(
    monumentId: $checkedConvert('monumentId', (v) => v as String),
    category: $checkedConvert(
      'category',
      (v) => $enumDecode(_$DamageCategoryEnumMap, v),
    ),
    urgency: $checkedConvert(
      'urgency',
      (v) => $enumDecode(_$ReportUrgencyEnumMap, v),
    ),
    description: $checkedConvert('description', (v) => v as String),
    photos: $checkedConvert(
      'photos',
      (v) =>
          (v as List<dynamic>?)
              ?.map(
                (e) => ReportPhotoAttachmentDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const <ReportPhotoAttachmentDto>[],
    ),
    location: $checkedConvert(
      'location',
      (v) => v == null
          ? null
          : ReportLocationDto.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$SubmitDamageReportRequestDtoToJson(
  _SubmitDamageReportRequestDto instance,
) => <String, dynamic>{
  'monumentId': instance.monumentId,
  'category': _$DamageCategoryEnumMap[instance.category]!,
  'urgency': _$ReportUrgencyEnumMap[instance.urgency]!,
  'description': instance.description,
  'photos': instance.photos.map((e) => e.toJson()).toList(),
  'location': ?instance.location?.toJson(),
};
