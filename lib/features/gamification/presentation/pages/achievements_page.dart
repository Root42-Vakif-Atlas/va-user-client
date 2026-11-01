import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/gamification/domain/entities/gamification_profile.dart';
import 'package:vakif_atlas/features/gamification/presentation/cubit/gamification_cubit.dart';
import 'package:vakif_atlas/features/gamification/presentation/widgets/achievement_tile.dart';
import 'package:vakif_atlas/features/gamification/presentation/widgets/level_progress_card.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

/// Rozetler (`/profile/achievements`): seviye, kazanılan ve kazanılacak
/// rozetler, XP kuralları. Tek sütun liste; %200 metinde taşmaz.
/// `GamificationCubit` üst ağaçtan sağlanır.
class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final state = context.watch<GamificationCubit>().state;
    final profile = state.profile;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.gamificationAchievementsTitle)),
      body: switch (profile) {
        null when state.status == GamificationStatus.failure =>
          StatusMessageView(
            key: const Key('achievements_error'),
            tone: StatusMessageTone.error,
            icon: Icons.emoji_events_outlined,
            title: l10n.gamificationLoadFailed,
            message: state.failure?.toUserMessage(l10n) ?? '',
            actionLabel: l10n.commonRetry,
            onAction: () =>
                unawaited(context.read<GamificationCubit>().refresh()),
          ),
        null => LoadingStatusView(label: l10n.gamificationLoading),
        final profile => SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.maxContentWidth,
              ),
              child: ListView(
                key: const Key('achievements_list'),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: LevelProgressCard(profile: profile),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: AppText(
                      l10n.gamificationAchievementsSummary(
                        profile.unlockedAchievements.length,
                        profile.achievements.length,
                      ),
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  ..._section(
                    l10n.gamificationEarnedSection,
                    profile.unlockedAchievements,
                  ),
                  ..._section(l10n.gamificationLockedSection, [
                    for (final achievement in profile.achievements)
                      if (!achievement.isUnlocked) achievement,
                  ]),
                  const Divider(height: AppSpacing.xl),
                  _HowToEarn(),
                ],
              ),
            ),
          ),
        ),
      },
    );
  }

  static List<Widget> _section(String title, List<Achievement> achievements) {
    if (achievements.isEmpty) {
      return const [];
    }
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.xs,
        ),
        child: AppText(title, role: AppTextRole.titleMedium, isHeading: true),
      ),
      for (final achievement in achievements)
        AchievementTile(achievement: achievement),
    ];
  }
}

class _HowToEarn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final rules = [
      (Icons.route_outlined, l10n.gamificationHowToRoute),
      (Icons.photo_album_outlined, l10n.gamificationHowToMemory),
      (Icons.add_alert_outlined, l10n.gamificationHowToReport),
      (Icons.location_city_outlined, l10n.gamificationHowToCity),
    ];
    return Padding(
      key: const Key('achievements_how_to'),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText(
            l10n.gamificationHowToTitle,
            role: AppTextRole.titleMedium,
            isHeading: true,
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final (icon, text) in rules)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(child: Icon(icon, color: colors.primary)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: AppText(text)),
                ],
              ),
            ),
          AppText(
            l10n.gamificationHowToNote,
            role: AppTextRole.bodySmall,
            color: colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
