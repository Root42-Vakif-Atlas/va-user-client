import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/gamification/domain/entities/gamification_profile.dart';
import 'package:vakif_atlas/features/gamification/presentation/widgets/achievement_visuals.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Rozet satırı: simge, ad, nasıl kazanılacağı ve durum (kazanıldı tarihi
/// veya ilerleme). Tek semantik düğüm olarak okunur.
class AchievementTile extends StatelessWidget {
  const AchievementTile({required this.achievement, super.key});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final unlockedAt = achievement.unlockedAt;
    final status = unlockedAt == null
        ? l10n.gamificationLockedProgress(
            achievement.progress,
            achievement.target,
          )
        : l10n.gamificationUnlockedOn(
            DateFormat.yMMMd(l10n.localeName).format(unlockedAt.toLocal()),
          );
    return MergeSemantics(
      child: Padding(
        key: Key('achievement_${achievement.id}'),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AchievementBadge(
              icon: achievement.icon,
              unlocked: achievement.isUnlocked,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppText(achievement.title, role: AppTextRole.titleMedium),
                  AppText(
                    achievement.description,
                    role: AppTextRole.bodyMedium,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  AppText(status, role: AppTextRole.labelLarge),
                  if (!achievement.isUnlocked && achievement.target > 1) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    ExcludeSemantics(
                      child: LinearProgressIndicator(
                        value: achievement.progress / achievement.target,
                        minHeight: AppSpacing.xs,
                        backgroundColor: colors.surfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
