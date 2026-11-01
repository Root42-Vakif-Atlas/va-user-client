import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vakif_atlas/features/gamification/domain/entities/gamification_profile.dart';

part 'gamification_dtos.freezed.dart';
part 'gamification_dtos.g.dart';

@freezed
abstract class GamificationProfileDto with _$GamificationProfileDto {
  const factory GamificationProfileDto({
    required int level,
    required String levelTitle,
    required int xp,
    required int levelStartXp,
    int? nextLevelXp,
    @Default(<AchievementDto>[]) List<AchievementDto> achievements,
    @Default(<String>[]) List<String> unseen,
  }) = _GamificationProfileDto;

  const GamificationProfileDto._();

  factory GamificationProfileDto.fromJson(Map<String, dynamic> json) =>
      _$GamificationProfileDtoFromJson(json);

  /// `level:N` → seviye, diğerleri rozet kimliği; tanınmayan kimlik ve
  /// kilitli rozet atlanır. En yüksek seviye kutlanır, alt seviyeler yalnızca
  /// görüldü işaretlenir.
  GamificationProfile toDomain() {
    final parsed = [
      for (final achievement in achievements) achievement.toDomain(),
    ];
    final byId = {
      for (final achievement in parsed) achievement.id: achievement,
    };
    final unlocks = <GamificationUnlock>[];
    for (final id in unseen) {
      if (id.startsWith(_levelPrefix)) {
        final reached = int.tryParse(id.substring(_levelPrefix.length));
        if (reached != null && reached > 1 && reached <= level) {
          unlocks.add(LevelReached(reached));
        }
      } else if (byId[id] case final achievement? when achievement.isUnlocked) {
        unlocks.add(AchievementUnlocked(achievement));
      }
    }
    return GamificationProfile(
      level: level < 1 ? 1 : level,
      levelTitle: levelTitle,
      xp: xp < 0 ? 0 : xp,
      levelStartXp: levelStartXp,
      nextLevelXp: nextLevelXp,
      achievements: parsed,
      unseen: unlocks,
    );
  }

  static const String _levelPrefix = 'level:';
}

@freezed
abstract class AchievementDto with _$AchievementDto {
  const factory AchievementDto({
    required String id,
    required String title,
    required String description,
    required String icon,
    required int progress,
    required int target,
    DateTime? unlockedAt,
  }) = _AchievementDto;

  const AchievementDto._();

  factory AchievementDto.fromJson(Map<String, dynamic> json) =>
      _$AchievementDtoFromJson(json);

  Achievement toDomain() => Achievement(
    id: id,
    title: title.trim(),
    description: description.trim(),
    icon: _icons[icon] ?? AchievementIcon.generic,
    progress: progress.clamp(0, target < 1 ? 1 : target),
    target: target < 1 ? 1 : target,
    unlockedAt: unlockedAt,
  );

  static const Map<String, AchievementIcon> _icons = {
    'route': AchievementIcon.route,
    'route_master': AchievementIcon.routeMaster,
    'memory': AchievementIcon.memory,
    'memory_book': AchievementIcon.memoryBook,
    'report': AchievementIcon.report,
    'guardian': AchievementIcon.guardian,
    'explorer': AchievementIcon.explorer,
    'traveler': AchievementIcon.traveler,
  };
}
