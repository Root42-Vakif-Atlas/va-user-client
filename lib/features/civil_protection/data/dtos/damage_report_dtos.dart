import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report_draft.dart';

part 'damage_report_dtos.freezed.dart';
part 'damage_report_dtos.g.dart';

@freezed
abstract class ReportMonumentDto with _$ReportMonumentDto {
  const factory ReportMonumentDto({
    required String id,
    required String name,
    required String city,
    required String district,
  }) = _ReportMonumentDto;

  const ReportMonumentDto._();

  factory ReportMonumentDto.fromJson(Map<String, dynamic> json) =>
      _$ReportMonumentDtoFromJson(json);

  ReportMonument toDomain() =>
      ReportMonument(id: id, name: name, city: city, district: district);
}

@freezed
abstract class ReportPhotoDto with _$ReportPhotoDto {
  const factory ReportPhotoDto({
    required String id,
    required String url,
    required String thumbnailUrl,
    required int width,
    required int height,
    String? description,
  }) = _ReportPhotoDto;

  const ReportPhotoDto._();

  factory ReportPhotoDto.fromJson(Map<String, dynamic> json) =>
      _$ReportPhotoDtoFromJson(json);

  ReportPhoto toDomain() {
    final text = description?.trim();
    return ReportPhoto(
      id: id,
      url: url,
      thumbnailUrl: thumbnailUrl,
      width: width,
      height: height,
      description: text == null || text.isEmpty ? null : text,
    );
  }
}

@freezed
abstract class ReportLocationCheckDto with _$ReportLocationCheckDto {
  const factory ReportLocationCheckDto({
    @JsonKey(unknownEnumValue: LocationVerification.notProvided)
    required LocationVerification verification,
    int? distanceMeters,
  }) = _ReportLocationCheckDto;

  const ReportLocationCheckDto._();

  factory ReportLocationCheckDto.fromJson(Map<String, dynamic> json) =>
      _$ReportLocationCheckDtoFromJson(json);

  ReportLocationCheck toDomain() => ReportLocationCheck(
    verification: verification,
    distanceMeters: distanceMeters,
  );
}

@freezed
abstract class DamageReportStatusChangeDto with _$DamageReportStatusChangeDto {
  const factory DamageReportStatusChangeDto({
    @JsonKey(unknownEnumValue: DamageReportStatus.inReview)
    required DamageReportStatus status,
    required DateTime at,
    String? note,
  }) = _DamageReportStatusChangeDto;

  const DamageReportStatusChangeDto._();

  factory DamageReportStatusChangeDto.fromJson(Map<String, dynamic> json) =>
      _$DamageReportStatusChangeDtoFromJson(json);

  DamageReportStatusChange toDomain() =>
      DamageReportStatusChange(status: status, at: at, note: note);
}

@freezed
abstract class DamageReportDto with _$DamageReportDto {
  const factory DamageReportDto({
    required String id,
    required String referenceCode,
    required ReportMonumentDto monument,
    @JsonKey(unknownEnumValue: DamageCategory.other)
    required DamageCategory category,
    @JsonKey(unknownEnumValue: ReportUrgency.medium)
    required ReportUrgency urgency,
    required String description,
    required ReportLocationCheckDto locationCheck,
    // Bilinmeyen yeni durum "inceleniyor" gösterilir.
    @JsonKey(unknownEnumValue: DamageReportStatus.inReview)
    required DamageReportStatus status,
    required DateTime createdAt,
    @Default(<ReportPhotoDto>[]) List<ReportPhotoDto> photos,
    @Default(<DamageReportStatusChangeDto>[])
    List<DamageReportStatusChangeDto> history,
  }) = _DamageReportDto;

  const DamageReportDto._();

  factory DamageReportDto.fromJson(Map<String, dynamic> json) =>
      _$DamageReportDtoFromJson(json);

  DamageReport toDomain() => DamageReport(
    id: id,
    referenceCode: referenceCode,
    monument: monument.toDomain(),
    category: category,
    urgency: urgency,
    description: description,
    photos: [for (final photo in photos) photo.toDomain()],
    locationCheck: locationCheck.toDomain(),
    status: status,
    history: [for (final change in history) change.toDomain()],
    createdAt: createdAt,
  );
}

/// `GET civil-protection/reports` yanıtı.
@freezed
abstract class DamageReportPageDto with _$DamageReportPageDto {
  const factory DamageReportPageDto({
    required List<DamageReportDto> items,
    required int total,
    String? nextCursor,
  }) = _DamageReportPageDto;

  const DamageReportPageDto._();

  factory DamageReportPageDto.fromJson(Map<String, dynamic> json) =>
      _$DamageReportPageDtoFromJson(json);

  DamageReportPage toDomain() => DamageReportPage(
    items: [for (final item in items) item.toDomain()],
    total: total,
    nextCursor: nextCursor,
  );
}

/// `POST civil-protection/photo-uploads` gövdesi.
@freezed
abstract class ReportPhotoUploadRequestDto with _$ReportPhotoUploadRequestDto {
  const factory ReportPhotoUploadRequestDto({
    required String contentType,
    required int byteSize,
    required int width,
    required int height,
  }) = _ReportPhotoUploadRequestDto;

  factory ReportPhotoUploadRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ReportPhotoUploadRequestDtoFromJson(json);
}

@freezed
abstract class ReportPhotoUploadTicketDto with _$ReportPhotoUploadTicketDto {
  const factory ReportPhotoUploadTicketDto({
    required String id,
    required String uploadUrl,
    required DateTime expiresAt,
    @Default(<String, String>{}) Map<String, String> uploadHeaders,
  }) = _ReportPhotoUploadTicketDto;

  factory ReportPhotoUploadTicketDto.fromJson(Map<String, dynamic> json) =>
      _$ReportPhotoUploadTicketDtoFromJson(json);
}

@freezed
abstract class ReportPhotoAttachmentDto with _$ReportPhotoAttachmentDto {
  const factory ReportPhotoAttachmentDto({
    required String uploadId,
    @JsonKey(includeIfNull: false) String? description,
  }) = _ReportPhotoAttachmentDto;

  factory ReportPhotoAttachmentDto.fromJson(Map<String, dynamic> json) =>
      _$ReportPhotoAttachmentDtoFromJson(json);
}

@freezed
abstract class ReportLocationDto with _$ReportLocationDto {
  const factory ReportLocationDto({
    required double latitude,
    required double longitude,
    required double accuracyMeters,
  }) = _ReportLocationDto;

  const ReportLocationDto._();

  factory ReportLocationDto.fromJson(Map<String, dynamic> json) =>
      _$ReportLocationDtoFromJson(json);

  factory ReportLocationDto.fromDomain(ReportLocation location) =>
      ReportLocationDto(
        latitude: location.latitude,
        longitude: location.longitude,
        accuracyMeters: location.accuracyMeters,
      );
}

/// `POST civil-protection/reports` gövdesi.
@freezed
abstract class SubmitDamageReportRequestDto
    with _$SubmitDamageReportRequestDto {
  const factory SubmitDamageReportRequestDto({
    required String monumentId,
    required DamageCategory category,
    required ReportUrgency urgency,
    required String description,
    @Default(<ReportPhotoAttachmentDto>[])
    List<ReportPhotoAttachmentDto> photos,
    @JsonKey(includeIfNull: false) ReportLocationDto? location,
  }) = _SubmitDamageReportRequestDto;

  factory SubmitDamageReportRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SubmitDamageReportRequestDtoFromJson(json);
}
