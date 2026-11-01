// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AskGuideRequestDto _$AskGuideRequestDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_AskGuideRequestDto', json, ($checkedConvert) {
      final val = _AskGuideRequestDto(
        message: $checkedConvert('message', (v) => v as String),
        conversationId: $checkedConvert('conversationId', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$AskGuideRequestDtoToJson(_AskGuideRequestDto instance) =>
    <String, dynamic>{
      'message': instance.message,
      'conversationId': ?instance.conversationId,
    };

_GuideReplyDto _$GuideReplyDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GuideReplyDto', json, ($checkedConvert) {
      final val = _GuideReplyDto(
        conversationId: $checkedConvert('conversationId', (v) => v as String),
        message: $checkedConvert(
          'message',
          (v) => GuideMessageDto.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$GuideReplyDtoToJson(_GuideReplyDto instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'message': instance.message.toJson(),
    };

_GuideMessageDto _$GuideMessageDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_GuideMessageDto', json, ($checkedConvert) {
  final val = _GuideMessageDto(
    id: $checkedConvert('id', (v) => v as String),
    text: $checkedConvert('text', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    sources: $checkedConvert(
      'sources',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => GuideSourceDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GuideSourceDto>[],
    ),
    actions: $checkedConvert(
      'actions',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => GuideActionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GuideActionDto>[],
    ),
    suggestions: $checkedConvert(
      'suggestions',
      (v) =>
          (v as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
    ),
    notice: $checkedConvert('notice', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$GuideMessageDtoToJson(_GuideMessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
      'sources': instance.sources.map((e) => e.toJson()).toList(),
      'actions': instance.actions.map((e) => e.toJson()).toList(),
      'suggestions': instance.suggestions,
      'notice': instance.notice,
    };

_GuideSourceDto _$GuideSourceDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GuideSourceDto', json, ($checkedConvert) {
      final val = _GuideSourceDto(
        monumentId: $checkedConvert('monumentId', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        city: $checkedConvert('city', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$GuideSourceDtoToJson(_GuideSourceDto instance) =>
    <String, dynamic>{
      'monumentId': instance.monumentId,
      'name': instance.name,
      'city': instance.city,
    };

_GuideActionDto _$GuideActionDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GuideActionDto', json, ($checkedConvert) {
      final val = _GuideActionDto(
        type: $checkedConvert('type', (v) => v as String),
        monumentId: $checkedConvert('monumentId', (v) => v as String?),
        monumentName: $checkedConvert('monumentName', (v) => v as String?),
        destination: $checkedConvert('destination', (v) => v as String?),
        q: $checkedConvert('q', (v) => v as String?),
        categories: $checkedConvert(
          'categories',
          (v) =>
              (v as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
        ),
        periods: $checkedConvert(
          'periods',
          (v) =>
              (v as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
        ),
        cities: $checkedConvert(
          'cities',
          (v) =>
              (v as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
        ),
        total: $checkedConvert('total', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$GuideActionDtoToJson(_GuideActionDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'monumentId': instance.monumentId,
      'monumentName': instance.monumentName,
      'destination': instance.destination,
      'q': instance.q,
      'categories': instance.categories,
      'periods': instance.periods,
      'cities': instance.cities,
      'total': instance.total,
    };
