import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';

part 'memory_dtos.freezed.dart';
part 'memory_dtos.g.dart';

/// Takvim günü (`YYYY-MM-DD`, saat dilimsiz) ↔ yerel `DateTime`.
abstract final class CalendarDateJson {
  static DateTime? parse(String? value) {
    if (value == null) {
      return null;
    }
    final parts = value.split('-');
    if (parts.length != 3) {
      throw FormatException('Invalid calendar date', value);
    }
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  static String? format(DateTime? date) {
    if (date == null) {
      return null;
    }
    String two(int value) => value.toString().padLeft(2, '0');
    return '${date.year.toString().padLeft(4, '0')}-'
        '${two(date.month)}-${two(date.day)}';
  }
}

@freezed
abstract class MemoryAuthorDto with _$MemoryAuthorDto {
  const factory MemoryAuthorDto({
    required String id,
    required String displayName,
  }) = _MemoryAuthorDto;

  const MemoryAuthorDto._();

  factory MemoryAuthorDto.fromJson(Map<String, dynamic> json) =>
      _$MemoryAuthorDtoFromJson(json);

  MemoryAuthor toDomain() => MemoryAuthor(id: id, displayName: displayName);
}

@freezed
abstract class MemoryPhotoDto with _$MemoryPhotoDto {
  const factory MemoryPhotoDto({
    required String id,
    required String url,
    required String thumbnailUrl,
    required int width,
    required int height,
    String? description,
  }) = _MemoryPhotoDto;

  const MemoryPhotoDto._();

  factory MemoryPhotoDto.fromJson(Map<String, dynamic> json) =>
      _$MemoryPhotoDtoFromJson(json);

  MemoryPhoto toDomain() {
    final text = description?.trim();
    return MemoryPhoto(
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
abstract class MemoryDto with _$MemoryDto {
  const factory MemoryDto({
    required String id,
    required String monumentId,
    required MemoryAuthorDto author,
    required String text,
    required DateTime createdAt,
    @Default(<MemoryPhotoDto>[]) List<MemoryPhotoDto> photos,
    String? visitedOn,

    /// Zaman çizelgesi günü (ziyaret, yoksa paylaşım günü — sunucu saat
    /// diliminde). Eski yanıtlarda yoksa istemcide türetilir.
    String? memoryDate,
    // Bilinmeyen durum herkese açık sayılmaz.
    @JsonKey(unknownEnumValue: MemoryModerationStatus.pending)
    @Default(MemoryModerationStatus.approved)
    MemoryModerationStatus status,
  }) = _MemoryDto;

  const MemoryDto._();

  factory MemoryDto.fromJson(Map<String, dynamic> json) =>
      _$MemoryDtoFromJson(json);

  Memory toDomain() => Memory(
    id: id,
    monumentId: monumentId,
    author: author.toDomain(),
    text: text,
    photos: [for (final photo in photos) photo.toDomain()],
    createdAt: createdAt,
    visitedOn: CalendarDateJson.parse(visitedOn),
    memoryDate: CalendarDateJson.parse(memoryDate),
    status: status,
  );
}

@freezed
abstract class MemoryYearCountDto with _$MemoryYearCountDto {
  const factory MemoryYearCountDto({required int year, required int count}) =
      _MemoryYearCountDto;

  const MemoryYearCountDto._();

  factory MemoryYearCountDto.fromJson(Map<String, dynamic> json) =>
      _$MemoryYearCountDtoFromJson(json);

  MemoryYearCount toDomain() => MemoryYearCount(year: year, count: count);
}

/// `include=facets` ile ilk sayfada gelen sayılar.
@freezed
abstract class MemoryFacetsDto with _$MemoryFacetsDto {
  const factory MemoryFacetsDto({
    @Default(<MemoryYearCountDto>[]) List<MemoryYearCountDto> years,
  }) = _MemoryFacetsDto;

  factory MemoryFacetsDto.fromJson(Map<String, dynamic> json) =>
      _$MemoryFacetsDtoFromJson(json);
}

/// `GET memories` yanıtı.
@freezed
abstract class MemoryPageDto with _$MemoryPageDto {
  const factory MemoryPageDto({
    required List<MemoryDto> items,
    required int total,
    String? nextCursor,
    MemoryFacetsDto? facets,
  }) = _MemoryPageDto;

  const MemoryPageDto._();

  factory MemoryPageDto.fromJson(Map<String, dynamic> json) =>
      _$MemoryPageDtoFromJson(json);

  MemoryPage toDomain() => MemoryPage(
    items: [for (final item in items) item.toDomain()],
    total: total,
    nextCursor: nextCursor,
    years: facets == null
        ? null
        : [for (final year in facets!.years) year.toDomain()],
  );
}

/// `POST memories/photo-uploads` gövdesi.
@freezed
abstract class PhotoUploadRequestDto with _$PhotoUploadRequestDto {
  const factory PhotoUploadRequestDto({
    required String contentType,
    required int byteSize,
    required int width,
    required int height,
  }) = _PhotoUploadRequestDto;

  factory PhotoUploadRequestDto.fromJson(Map<String, dynamic> json) =>
      _$PhotoUploadRequestDtoFromJson(json);
}

/// Kısa ömürlü, ön imzalı yükleme adresi.
@freezed
abstract class PhotoUploadTicketDto with _$PhotoUploadTicketDto {
  const factory PhotoUploadTicketDto({
    required String id,
    required String uploadUrl,
    required DateTime expiresAt,
    @Default(<String, String>{}) Map<String, String> uploadHeaders,
  }) = _PhotoUploadTicketDto;

  factory PhotoUploadTicketDto.fromJson(Map<String, dynamic> json) =>
      _$PhotoUploadTicketDtoFromJson(json);
}

@freezed
abstract class MemoryPhotoAttachmentDto with _$MemoryPhotoAttachmentDto {
  const factory MemoryPhotoAttachmentDto({
    required String uploadId,
    @JsonKey(includeIfNull: false) String? description,
  }) = _MemoryPhotoAttachmentDto;

  factory MemoryPhotoAttachmentDto.fromJson(Map<String, dynamic> json) =>
      _$MemoryPhotoAttachmentDtoFromJson(json);
}

/// `POST memories` gövdesi.
@freezed
abstract class CreateMemoryRequestDto with _$CreateMemoryRequestDto {
  const factory CreateMemoryRequestDto({
    required String monumentId,
    required String text,
    @Default(<MemoryPhotoAttachmentDto>[])
    List<MemoryPhotoAttachmentDto> photos,
    @JsonKey(includeIfNull: false) String? visitedOn,
  }) = _CreateMemoryRequestDto;

  factory CreateMemoryRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateMemoryRequestDtoFromJson(json);
}

/// `POST memories/{id}/reports` gövdesi.
@freezed
abstract class MemoryReportRequestDto with _$MemoryReportRequestDto {
  const factory MemoryReportRequestDto({
    required MemoryReportReason reason,
    @JsonKey(includeIfNull: false) String? note,
  }) = _MemoryReportRequestDto;

  factory MemoryReportRequestDto.fromJson(Map<String, dynamic> json) =>
      _$MemoryReportRequestDtoFromJson(json);
}
