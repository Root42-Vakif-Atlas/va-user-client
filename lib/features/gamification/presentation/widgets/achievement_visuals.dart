import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/gamification/domain/entities/gamification_profile.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';

extension AchievementIconData on AchievementIcon {
  IconData get data => switch (this) {
    AchievementIcon.route => Icons.route_outlined,
    AchievementIcon.routeMaster => Icons.alt_route,
    AchievementIcon.memory => Icons.photo_album_outlined,
    AchievementIcon.memoryBook => Icons.auto_stories_outlined,
    AchievementIcon.report => Icons.visibility_outlined,
    AchievementIcon.guardian => Icons.shield_outlined,
    AchievementIcon.explorer => Icons.location_city_outlined,
    AchievementIcon.traveler => Icons.travel_explore,
    AchievementIcon.generic => Icons.emoji_events_outlined,
  };
}

/// Rozet simgesi. Kazanılmış rozet dolgulu marka vurgusuyla, kilitli rozet
/// konturla ve kilit işaretiyle gösterilir (durum yalnızca renkle değil).
class AchievementBadge extends StatelessWidget {
  const AchievementBadge({
    required this.icon,
    required this.unlocked,
    this.size = AppSizes.minTouchTarget,
    super.key,
  });

  final AchievementIcon icon;
  final bool unlocked;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox.square(
      dimension: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: unlocked
                    ? colors.secondaryContainer
                    : colors.surfaceVariant,
                border: Border.all(
                  color: unlocked ? colors.brandAccent : colors.outline,
                  width: AppSizes.borderThick,
                ),
              ),
              child: Center(
                child: AppIcon.decorative(
                  icon.data,
                  color: unlocked
                      ? colors.onSecondaryContainer
                      : colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
          if (!unlocked)
            PositionedDirectional(
              end: -AppSpacing.xxs,
              bottom: -AppSpacing.xxs,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.surface,
                  border: Border.all(color: colors.outline),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxs),
                  child: AppIcon.decorative(
                    Icons.lock_outline,
                    size: AppSizes.iconSm,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
