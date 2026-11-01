import 'package:vakif_atlas/core/utils/list_equality.dart';

/// Rozet simgesi. Sunucu yalnızca anahtar gönderir; simge istemcide izinli
/// listeden seçilir (sunucudan görsel adresi alınmaz).
enum AchievementIcon {
  route,
  routeMaster,
  memory,
  memoryBook,
  report,
  guardian,
  explorer,
  traveler,

  /// Tanınmayan anahtar (sunucu yeni rozet eklediğinde).
  generic,
}

/// Başarım rozeti; başlık ve açıklama sunucuda arayüz dilinde gelir.
final class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.progress,
    required this.target,
    this.unlockedAt,
  });

  final String id;
  final String title;

  /// Kilitliyken nasıl kazanılacağını anlatır.
  final String description;
  final AchievementIcon icon;
  final int progress;
  final int target;
  final DateTime? unlockedAt;

  bool get isUnlocked => unlockedAt != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Achievement &&
          other.id == id &&
          other.title == title &&
          other.description == description &&
          other.icon == icon &&
          other.progress == progress &&
          other.target == target &&
          other.unlockedAt == unlockedAt;

  @override
  int get hashCode =>
      Object.hash(id, title, description, icon, progress, target, unlockedAt);

  @override
  String toString() => 'Achievement($id, $progress/$target)';
}

/// Kullanıcıya kutlanacak, henüz görülmemiş kazanım.
sealed class GamificationUnlock {
  const GamificationUnlock();

  /// Görüldü bildirimi için sunucudaki kimlik.
  String get id;
}

final class LevelReached extends GamificationUnlock {
  const LevelReached(this.level);

  final int level;

  @override
  String get id => 'level:$level';

  @override
  bool operator ==(Object other) =>
      other is LevelReached && other.level == level;

  @override
  int get hashCode => Object.hash(LevelReached, level);
}

final class AchievementUnlocked extends GamificationUnlock {
  const AchievementUnlocked(this.achievement);

  final Achievement achievement;

  @override
  String get id => achievement.id;

  @override
  bool operator ==(Object other) =>
      other is AchievementUnlocked && other.achievement == achievement;

  @override
  int get hashCode => Object.hash(AchievementUnlocked, achievement);
}

/// Oturum açık kullanıcının seviye, XP ve rozetleri. XP sunucuda katkı
/// olaylarından hesaplanır; istemci yalnızca okur.
final class GamificationProfile {
  const GamificationProfile({
    required this.level,
    required this.levelTitle,
    required this.xp,
    required this.levelStartXp,
    required this.nextLevelXp,
    required this.achievements,
    this.unseen = const [],
  });

  final int level;
  final String levelTitle;
  final int xp;
  final int levelStartXp;

  /// `null` → en yüksek seviye.
  final int? nextLevelXp;
  final List<Achievement> achievements;
  final List<GamificationUnlock> unseen;

  bool get isMaxLevel => nextLevelXp == null;

  /// Bu seviyedeki ilerleme (0–1).
  double get levelProgress {
    final next = nextLevelXp;
    if (next == null || next <= levelStartXp) {
      return 1;
    }
    return ((xp - levelStartXp) / (next - levelStartXp)).clamp(0, 1);
  }

  /// Sonraki seviyeye kalan XP; en yüksek seviyede 0.
  int get xpToNextLevel {
    final next = nextLevelXp;
    return next == null ? 0 : (next - xp).clamp(0, next);
  }

  List<Achievement> get unlockedAchievements => [
    for (final achievement in achievements)
      if (achievement.isUnlocked) achievement,
  ]..sort((a, b) => b.unlockedAt!.compareTo(a.unlockedAt!));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GamificationProfile &&
          other.level == level &&
          other.levelTitle == levelTitle &&
          other.xp == xp &&
          other.levelStartXp == levelStartXp &&
          other.nextLevelXp == nextLevelXp &&
          elementsEqual(other.achievements, achievements) &&
          elementsEqual(other.unseen, unseen);

  @override
  int get hashCode => Object.hash(
    level,
    levelTitle,
    xp,
    levelStartXp,
    nextLevelXp,
    Object.hashAll(achievements),
    Object.hashAll(unseen),
  );

  @override
  String toString() => 'GamificationProfile(level: $level, xp: $xp)';
}
