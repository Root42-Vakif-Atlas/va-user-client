// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_export_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RouteExportRecordDto _$RouteExportRecordDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_RouteExportRecordDto', json, ($checkedConvert) {
  final val = _RouteExportRecordDto(
    id: $checkedConvert('id', (v) => v as String),
    routeId: $checkedConvert('routeId', (v) => v as String),
    routeName: $checkedConvert('routeName', (v) => v as String),
    fileName: $checkedConvert('fileName', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    byteSize: $checkedConvert('byteSize', (v) => (v as num).toInt()),
    stopCount: $checkedConvert('stopCount', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$RouteExportRecordDtoToJson(
  _RouteExportRecordDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'routeId': instance.routeId,
  'routeName': instance.routeName,
  'fileName': instance.fileName,
  'createdAt': instance.createdAt.toIso8601String(),
  'byteSize': instance.byteSize,
  'stopCount': instance.stopCount,
};

_RouteExportUploadRequestDto _$RouteExportUploadRequestDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_RouteExportUploadRequestDto', json, ($checkedConvert) {
  final val = _RouteExportUploadRequestDto(
    routeId: $checkedConvert('routeId', (v) => v as String),
    routeName: $checkedConvert('routeName', (v) => v as String),
    fileName: $checkedConvert('fileName', (v) => v as String),
    byteSize: $checkedConvert('byteSize', (v) => (v as num).toInt()),
    stopCount: $checkedConvert('stopCount', (v) => (v as num).toInt()),
    sha256: $checkedConvert('sha256', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$RouteExportUploadRequestDtoToJson(
  _RouteExportUploadRequestDto instance,
) => <String, dynamic>{
  'routeId': instance.routeId,
  'routeName': instance.routeName,
  'fileName': instance.fileName,
  'byteSize': instance.byteSize,
  'stopCount': instance.stopCount,
  'sha256': instance.sha256,
};

_RouteExportUploadTicketDto _$RouteExportUploadTicketDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_RouteExportUploadTicketDto', json, ($checkedConvert) {
  final val = _RouteExportUploadTicketDto(
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

Map<String, dynamic> _$RouteExportUploadTicketDtoToJson(
  _RouteExportUploadTicketDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'uploadUrl': instance.uploadUrl,
  'expiresAt': instance.expiresAt.toIso8601String(),
  'uploadHeaders': instance.uploadHeaders,
};

_RouteExportPageDto _$RouteExportPageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_RouteExportPageDto', json, ($checkedConvert) {
      final val = _RouteExportPageDto(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map(
                (e) => RouteExportRecordDto.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$RouteExportPageDtoToJson(_RouteExportPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': instance.nextCursor,
    };

_RouteExportDownloadDto _$RouteExportDownloadDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_RouteExportDownloadDto', json, ($checkedConvert) {
  final val = _RouteExportDownloadDto(
    url: $checkedConvert('url', (v) => v as String),
    expiresAt: $checkedConvert('expiresAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$RouteExportDownloadDtoToJson(
  _RouteExportDownloadDto instance,
) => <String, dynamic>{
  'url': instance.url,
  'expiresAt': instance.expiresAt.toIso8601String(),
};
