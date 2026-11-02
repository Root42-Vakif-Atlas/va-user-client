import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/gamification/presentation/cubit/gamification_cubit.dart';
import 'package:vakif_atlas/features/gamification/presentation/widgets/achievement_visuals.dart';
import 'package:vakif_atlas/features/gamification/presentation/widgets/level_progress_card.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/shared/widgets/molecules/section_header.dart';

/// Profildeki seviye, XP ve son kazanılan rozetler.
/// `GamificationCubit` üst ağaçtan sağlanır.
class GamificationProfileSection extends StatelessWidget {
  const GamificationProfileSection({
    required this.onOpenAchievements,
    super.key,
  });

  final VoidCallback onOpenAchievements;

  static const int _recentCount = 3;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final state = context.watch<GamificationCubit>().state;
    final profile = state.profile;
    // Oturum kapalıyken (profil sayfası korumalıdır; çıkış anı) gösterilmez.
    if (state.status == GamificationStatus.inactive) {
      return const SizedBox.shrink();
    }
    final children = <Widget>[
      SectionHeader(l10n.gamificationSectionTitle),
      const SizedBox(height: AppSpacing.sm),
    ];
    if (profile == null) {
      children.add(
        state.status == GamificationStatus.failure
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InlineMessage(
                    message:
                        '${l10n.gamificationLoadFailed} '
                        '${state.failure?.toUserMessage(l10n) ?? ''}',
                    type: InlineMessageType.error,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton.secondary(
                    key: const Key('gamification_retry'),
                    label: l10n.commonRetry,
                    icon: Icons.refresh,
                    onPressed: () =>
                        unawaited(context.read<GamificationCubit>().refresh()),
                  ),
                ],
              )
            : Semantics(
                label: l10n.gamificationLoading,
                liveRegion: true,
                excludeSemantics: true,
                child: const LinearProgressIndicator(),
              ),
      );
      return Column(
        key: const Key('gamification_section'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    }
    final recent = profile.unlockedAchievements.take(_recentCount).toList();
    children.addAll([
      LevelProgressCard(profile: profile),
      const SizedBox(height: AppSpacing.md),
      AppText(l10n.gamificationRecentBadges, role: AppTextRole.labelLarge),
      const SizedBox(height: AppSpacing.xs),
      if (recent.isEmpty)
        AppText(
          l10n.gamificationNoBadges,
          role: AppTextRole.bodyMedium,
          color: colors.onSurfaceVariant,
        )
      else
        for (final achievement in recent)
          MergeSemantics(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                children: [
                  AchievementBadge(icon: achievement.icon, unlocked: true),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppText(
                      achievement.title,
                      role: AppTextRole.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
      const SizedBox(height: AppSpacing.xs),
      AppButton.secondary(
        key: const Key('gamification_all_badges'),
        label: l10n.gamificationAllBadges(
          profile.unlockedAchievements.length,
          profile.achievements.length,
        ),
        icon: Icons.emoji_events_outlined,
        expand: true,
        onPressed: onOpenAchievements,
      ),
    ]);
    return Column(
      key: const Key('gamification_section'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
