// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_monument_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavedMonumentDto _$SavedMonumentDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SavedMonumentDto', json, ($checkedConvert) {
      final val = _SavedMonumentDto(
        monumentId: $checkedConvert('monumentId', (v) => v as String),
        savedAt: $checkedConvert('savedAt', (v) => DateTime.parse(v as String)),
      );
      return val;
    });

Map<String, dynamic> _$SavedMonumentDtoToJson(_SavedMonumentDto instance) =>
    <String, dynamic>{
      'monumentId': instance.monumentId,
      'savedAt': instance.savedAt.toIso8601String(),
    };

_SavedMonumentListDto _$SavedMonumentListDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_SavedMonumentListDto', json, ($checkedConvert) {
  final val = _SavedMonumentListDto(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => SavedMonumentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$SavedMonumentListDtoToJson(
  _SavedMonumentListDto instance,
) => <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
