// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GamificationProfileDto _$GamificationProfileDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_GamificationProfileDto', json, ($checkedConvert) {
  final val = _GamificationProfileDto(
    level: $checkedConvert('level', (v) => (v as num).toInt()),
    levelTitle: $checkedConvert('levelTitle', (v) => v as String),
    xp: $checkedConvert('xp', (v) => (v as num).toInt()),
    levelStartXp: $checkedConvert('levelStartXp', (v) => (v as num).toInt()),
    nextLevelXp: $checkedConvert('nextLevelXp', (v) => (v as num?)?.toInt()),
    achievements: $checkedConvert(
      'achievements',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => AchievementDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AchievementDto>[],
    ),
    unseen: $checkedConvert(
      'unseen',
      (v) =>
          (v as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
    ),
  );
  return val;
});

Map<String, dynamic> _$GamificationProfileDtoToJson(
  _GamificationProfileDto instance,
) => <String, dynamic>{
  'level': instance.level,
  'levelTitle': instance.levelTitle,
  'xp': instance.xp,
  'levelStartXp': instance.levelStartXp,
  'nextLevelXp': instance.nextLevelXp,
  'achievements': instance.achievements.map((e) => e.toJson()).toList(),
  'unseen': instance.unseen,
};

_AchievementDto _$AchievementDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_AchievementDto', json, ($checkedConvert) {
      final val = _AchievementDto(
        id: $checkedConvert('id', (v) => v as String),
        title: $checkedConvert('title', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String),
        icon: $checkedConvert('icon', (v) => v as String),
        progress: $checkedConvert('progress', (v) => (v as num).toInt()),
        target: $checkedConvert('target', (v) => (v as num).toInt()),
        unlockedAt: $checkedConvert(
          'unlockedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AchievementDtoToJson(_AchievementDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'icon': instance.icon,
      'progress': instance.progress,
      'target': instance.target,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
    };
