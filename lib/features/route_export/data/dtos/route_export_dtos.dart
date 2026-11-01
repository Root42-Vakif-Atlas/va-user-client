import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_export.dart';

part 'route_export_dtos.freezed.dart';
part 'route_export_dtos.g.dart';

/// `GET route-exports` / `POST route-exports/{id}/complete` kaydı; aynı
/// biçim cihazdaki önbellek dizininde de tutulur.
@freezed
abstract class RouteExportRecordDto with _$RouteExportRecordDto {
  const factory RouteExportRecordDto({
    required String id,
    required String routeId,
    required String routeName,
    required String fileName,
    required DateTime createdAt,
    required int byteSize,
    required int stopCount,
  }) = _RouteExportRecordDto;

  const RouteExportRecordDto._();

  factory RouteExportRecordDto.fromJson(Map<String, dynamic> json) =>
      _$RouteExportRecordDtoFromJson(json);

  RouteExport toDomain() => RouteExport(
    id: id,
    routeId: routeId,
    routeName: routeName,
    fileName: fileName,
    createdAt: createdAt,
    byteSize: byteSize,
    stopCount: stopCount,
  );
}

/// `POST route-exports` gövdesi: sunucu boyutu, `%PDF-` imzasını ve
/// SHA-256 özetini yükleme tamamlanınca doğrular.
@freezed
abstract class RouteExportUploadRequestDto with _$RouteExportUploadRequestDto {
  const factory RouteExportUploadRequestDto({
    required String routeId,
    required String routeName,
    required String fileName,
    required int byteSize,
    required int stopCount,
    required String sha256,
  }) = _RouteExportUploadRequestDto;

  factory RouteExportUploadRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RouteExportUploadRequestDtoFromJson(json);
}

/// `201` — kısa ömürlü ön imzalı `PUT` adresi.
@freezed
abstract class RouteExportUploadTicketDto with _$RouteExportUploadTicketDto {
  const factory RouteExportUploadTicketDto({
    required String id,
    required String uploadUrl,
    required DateTime expiresAt,
    @Default(<String, String>{}) Map<String, String> uploadHeaders,
  }) = _RouteExportUploadTicketDto;

  factory RouteExportUploadTicketDto.fromJson(Map<String, dynamic> json) =>
      _$RouteExportUploadTicketDtoFromJson(json);
}

/// `GET route-exports` yanıtı (en yeni önce, imleçli).
@freezed
abstract class RouteExportPageDto with _$RouteExportPageDto {
  const factory RouteExportPageDto({
    required List<RouteExportRecordDto> items,
    String? nextCursor,
  }) = _RouteExportPageDto;

  factory RouteExportPageDto.fromJson(Map<String, dynamic> json) =>
      _$RouteExportPageDtoFromJson(json);
}

/// `GET route-exports/{id}/download` — kısa ömürlü ön imzalı `GET` adresi.
@freezed
abstract class RouteExportDownloadDto with _$RouteExportDownloadDto {
  const factory RouteExportDownloadDto({
    required String url,
    required DateTime expiresAt,
  }) = _RouteExportDownloadDto;

  factory RouteExportDownloadDto.fromJson(Map<String, dynamic> json) =>
      _$RouteExportDownloadDtoFromJson(json);

  const RouteExportDownloadDto._();

  RouteExportLink toLink() => RouteExportLink(url: url, expiresAt: expiresAt);
}
