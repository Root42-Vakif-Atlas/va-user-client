import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/entities/saved_monument.dart';

part 'saved_monument_dtos.freezed.dart';
part 'saved_monument_dtos.g.dart';

@freezed
abstract class SavedMonumentDto with _$SavedMonumentDto {
  const factory SavedMonumentDto({
    required String monumentId,
    required DateTime savedAt,
  }) = _SavedMonumentDto;

  const SavedMonumentDto._();

  factory SavedMonumentDto.fromJson(Map<String, dynamic> json) =>
      _$SavedMonumentDtoFromJson(json);

  factory SavedMonumentDto.fromDomain(SavedMonument monument) =>
      SavedMonumentDto(
        monumentId: monument.monumentId,
        savedAt: monument.savedAt.toUtc(),
      );

  SavedMonument toDomain() =>
      SavedMonument(monumentId: monumentId, savedAt: savedAt.toUtc());
}

/// `GET saved-monuments` yanıtı ve `PUT saved-monuments` gövdesi.
@freezed
abstract class SavedMonumentListDto with _$SavedMonumentListDto {
  const factory SavedMonumentListDto({required List<SavedMonumentDto> items}) =
      _SavedMonumentListDto;

  factory SavedMonumentListDto.fromJson(Map<String, dynamic> json) =>
      _$SavedMonumentListDtoFromJson(json);
}
