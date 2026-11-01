import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_dtos.freezed.dart';
part 'feedback_dtos.g.dart';

@freezed
abstract class FeedbackRequestDto with _$FeedbackRequestDto {
  const factory FeedbackRequestDto({
    required String category,
    required String message,
    @JsonKey(includeIfNull: false) int? rating,
    @JsonKey(includeIfNull: false) String? appVersion,
    @JsonKey(includeIfNull: false) String? platform,
  }) = _FeedbackRequestDto;

  factory FeedbackRequestDto.fromJson(Map<String, dynamic> json) =>
      _$FeedbackRequestDtoFromJson(json);
}
