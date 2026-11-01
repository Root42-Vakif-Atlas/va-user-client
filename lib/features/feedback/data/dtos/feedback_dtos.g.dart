// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeedbackRequestDto _$FeedbackRequestDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_FeedbackRequestDto', json, ($checkedConvert) {
      final val = _FeedbackRequestDto(
        category: $checkedConvert('category', (v) => v as String),
        message: $checkedConvert('message', (v) => v as String),
        rating: $checkedConvert('rating', (v) => (v as num?)?.toInt()),
        appVersion: $checkedConvert('appVersion', (v) => v as String?),
        platform: $checkedConvert('platform', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$FeedbackRequestDtoToJson(_FeedbackRequestDto instance) =>
    <String, dynamic>{
      'category': instance.category,
      'message': instance.message,
      'rating': ?instance.rating,
      'appVersion': ?instance.appVersion,
      'platform': ?instance.platform,
    };
