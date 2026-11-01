import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/gamification/domain/entities/gamification_profile.dart';
import 'package:vakif_atlas/features/gamification/presentation/cubit/gamification_cubit.dart';
import 'package:vakif_atlas/features/gamification/presentation/widgets/achievement_visuals.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Yeni seviye ve rozetleri uygulamanın neresinde olunursa olunsun kutlar:
/// diyalog + ekran okuyucu duyurusu + başarı titreşimi. Diyalog kapanınca
/// kazanımlar görüldü işaretlenir.
///
/// Uygulama kabuğunda (Navigator'ın üstünde) durduğundan diyalog
/// [navigatorKey] bağlamında açılır. `GamificationCubit`, `A11yAnnouncer` ve
/// `HapticFeedbackService` üst ağaçtan sağlanır.
class GamificationCelebrations extends StatefulWidget {
  const GamificationCelebrations({
    required this.navigatorKey,
    required this.onOpenAchievements,
    required this.child,
    super.key,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final VoidCallback onOpenAchievements;
  final Widget child;

  @override
  State<GamificationCelebrations> createState() =>
      _GamificationCelebrationsState();
}

class _GamificationCelebrationsState extends State<GamificationCelebrations> {
  bool _showing = false;

  Future<void> _celebrate(GamificationState state) async {
    final profile = state.profile;
    final dialogContext = widget.navigatorKey.currentContext;
    if (_showing ||
        profile == null ||
        state.pendingUnlocks.isEmpty ||
        dialogContext == null) {
      return;
    }
    _showing = true;
    final cubit = context.read<GamificationCubit>();
    final unlocks = state.pendingUnlocks;
    final lines = celebrationLines(context.l10n, profile, unlocks);
    unawaited(context.read<HapticFeedbackService>().success());
    unawaited(
      context.read<A11yAnnouncer>().announce(
        [context.l10n.gamificationCelebrationTitle, ...lines].join('. '),
      ),
    );
    final viewBadges = await showDialog<bool>(
      context: dialogContext,
      builder: (_) =>
          GamificationCelebrationDialog(profile: profile, unlocks: unlocks),
    );
    _showing = false;
    await cubit.acknowledge(unlocks);
    if ((viewBadges ?? false) && mounted) {
      widget.onOpenAchievements();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GamificationCubit, GamificationState>(
      listenWhen: (previous, current) =>
          current.pendingUnlocks.isNotEmpty &&
          !_sameIds(previous.pendingUnlocks, current.pendingUnlocks),
      listener: (context, state) => unawaited(_celebrate(state)),
      child: widget.child,
    );
  }

  static bool _sameIds(
    List<GamificationUnlock> a,
    List<GamificationUnlock> b,
  ) =>
      a.length == b.length &&
      {for (final unlock in a) unlock.id}
          .containsAll([for (final unlock in b) unlock.id]);
}

/// Kutlama satırları: en yüksek yeni seviye + yeni rozetler.
List<String> celebrationLines(
  AppLocalizations l10n,
  GamificationProfile profile,
  List<GamificationUnlock> unlocks,
) {
  final levels = [
    for (final unlock in unlocks)
      if (unlock is LevelReached) unlock.level,
  ];
  return [
    if (levels.isNotEmpty)
      l10n.gamificationLevelReached(profile.level, profile.levelTitle),
    for (final unlock in unlocks)
      if (unlock case AchievementUnlocked(:final achievement))
        l10n.gamificationBadgeEarned(achievement.title),
  ];
}

class GamificationCelebrationDialog extends StatelessWidget {
  const GamificationCelebrationDialog({
    required this.profile,
    required this.unlocks,
    super.key,
  });

  final GamificationProfile profile;
  final List<GamificationUnlock> unlocks;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final levelUp = unlocks.any((unlock) => unlock is LevelReached);
    return AlertDialog(
      key: const Key('gamification_celebration'),
      icon: AppIcon.decorative(
        Icons.emoji_events_outlined,
        size: AppSizes.iconXl,
        color: colors.accentText,
      ),
      title: Text(l10n.gamificationCelebrationTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (levelUp)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AppText(
                  l10n.gamificationLevelReached(
                    profile.level,
                    profile.levelTitle,
                  ),
                  role: AppTextRole.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            for (final unlock in unlocks)
              if (unlock case AchievementUnlocked(:final achievement))
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: MergeSemantics(
                    child: Row(
                      children: [
                        AchievementBadge(
                          icon: achievement.icon,
                          unlocked: true,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: AppText(
                            l10n.gamificationBadgeEarned(achievement.title),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
      actions: [
        TextButton(
          key: const Key('gamification_celebration_badges'),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.gamificationCelebrationViewBadges),
        ),
        FilledButton(
          key: const Key('gamification_celebration_close'),
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.gamificationCelebrationClose),
        ),
      ],
    );
  }
}
