import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/gamification/domain/entities/gamification_profile.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Seviye, XP ve sonraki seviyeye ilerleme.
///
/// İlerleme çubuğu "değer" semantiğiyle okunur ("140 / 250 XP"); kalan XP
/// ayrıca metin olarak yazılır (WCAG 1.1.1, 1.4.1).
class LevelProgressCard extends StatelessWidget {
  const LevelProgressCard({required this.profile, super.key});

  final GamificationProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final next = profile.nextLevelXp;
    final xpText = next == null
        ? l10n.gamificationXpTotal(profile.xp)
        : l10n.gamificationXpProgress(profile.xp, next);
    return DecoratedBox(
      key: const Key('gamification_level_card'),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ExcludeSemantics(
                  child: Container(
                    width: AppSizes.minTouchTarget,
                    height: AppSizes.minTouchTarget,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primary,
                    ),
                    child: AppText(
                      '${profile.level}',
                      role: AppTextRole.titleLarge,
                      color: colors.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppText(
                    l10n.gamificationLevelTitle(
                      profile.level,
                      profile.levelTitle,
                    ),
                    role: AppTextRole.titleMedium,
                    isHeading: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Semantics(
              label: l10n.gamificationProgressSemantics,
              value: xpText,
              child: ExcludeSemantics(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: LinearProgressIndicator(
                    key: const Key('gamification_xp_bar'),
                    value: profile.levelProgress,
                    minHeight: AppSpacing.sm,
                    backgroundColor: colors.surfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            ExcludeSemantics(
              child: AppText(xpText, role: AppTextRole.labelLarge),
            ),
            AppText(
              profile.isMaxLevel
                  ? l10n.gamificationMaxLevel
                  : l10n.gamificationXpToNext(profile.xpToNextLevel),
              role: AppTextRole.bodyMedium,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
