import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/bloc/memory_list_bloc.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/memory_presentation.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/account_avatar.dart';

/// Eser detayındaki Anı Köşesi girişi: eser bilgisinden ayrı, kendi
/// sayfasında (zaman çizelgesi) açılan tıklanabilir kart.
///
/// Toplam anı sayısını ve en son anıdan kısa bir alıntıyı gösterir; kartın
/// tamamı tek bir butondur (ekran okuyucu: "Anı Köşesi, 5 anı, zaman
/// çizelgesini aç"). [MemoryListBloc] üst ağaçtan sağlanır.
class MonumentMemoriesSection extends StatefulWidget {
  const MonumentMemoriesSection({
    required this.monumentId,
    required this.viewerId,
    required this.onOpen,
    super.key,
  });

  final String monumentId;

  /// Değiştiğinde (giriş / çıkış) sayı yenilenir: bildirilen anılar
  /// kullanıcıya gösterilmez.
  final String? viewerId;
  final VoidCallback onOpen;

  /// Kart yalnızca en son anıyı gösterir.
  static const int previewSize = 1;

  @override
  State<MonumentMemoriesSection> createState() =>
      _MonumentMemoriesSectionState();
}

class _MonumentMemoriesSectionState extends State<MonumentMemoriesSection> {
  MemoryListBloc get _bloc => context.read<MemoryListBloc>();

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(MonumentMemoriesSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.monumentId != widget.monumentId) {
      _start();
    } else if (oldWidget.viewerId != widget.viewerId) {
      _bloc.add(const MemoryListEvent.refreshed());
    }
  }

  void _start() => _bloc.add(
    MemoryListEvent.started(
      monumentId: widget.monumentId,
      pageSize: MonumentMemoriesSection.previewSize,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      key: const Key('monument_memories_section'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          l10n.memoryCornerTitle,
          role: AppTextRole.headlineMedium,
          isHeading: true,
        ),
        const SizedBox(height: AppSpacing.sm),
        BlocBuilder<MemoryListBloc, MemoryListState>(
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.total != current.total ||
              previous.items != current.items,
          builder: (context, state) =>
              _EntryCard(state: state, onOpen: widget.onOpen),
        ),
      ],
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.state, required this.onOpen});

  final MemoryListState state;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final loaded = state.status == MemoryListStatus.success;
    final latest = loaded && state.items.isNotEmpty ? state.items.first : null;
    final String summary;
    if (loaded) {
      summary = state.total == 0
          ? l10n.memoryEmptyTitle
          : l10n.memoryCount(state.total);
    } else if (state.status == MemoryListStatus.failure) {
      summary = l10n.memoryLoadFailedTitle;
    } else {
      summary = l10n.memoryLoading;
    }
    final subtitle = loaded && state.total == 0
        ? l10n.memoryEmptyBody
        : l10n.memoryCornerSubtitle;
    final semantics = [
      if (loaded) l10n.memoryEntrySemantics(state.total) else summary,
      if (latest != null)
        '${l10n.memoryEntryLatest}: ${latest.author.displayName}, '
            '${MemoryDates.visited(l10n, latest.memoryDate)}',
    ].join('. ');

    return Semantics(
      button: true,
      label: semantics,
      onTapHint: l10n.memoryEntryOpenHint,
      onTap: onOpen,
      excludeSemantics: true,
      child: Material(
        color: colors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(
            color: colors.outlineVariant,
            width: AppSizes.borderThin,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: const Key('memory_entry_card'),
          onTap: onOpen,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: AppSizes.minTouchTarget,
                      height: AppSizes.minTouchTarget,
                      decoration: BoxDecoration(
                        color: colors.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: AppIcon.decorative(
                        Icons.auto_stories_outlined,
                        color: colors.accentText,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            summary,
                            key: const Key('memory_entry_summary'),
                            role: AppTextRole.titleMedium,
                          ),
                          AppText(
                            subtitle,
                            role: AppTextRole.bodySmall,
                            color: colors.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    if (state.status == MemoryListStatus.loading ||
                        state.status == MemoryListStatus.initial)
                      const _SmallProgress()
                    else
                      AppIcon.decorative(
                        Icons.chevron_right,
                        color: colors.onSurfaceVariant,
                      ),
                  ],
                ),
                if (latest != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  const Divider(height: AppSizes.borderThin),
                  const SizedBox(height: AppSpacing.sm),
                  _LatestMemory(memory: latest),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LatestMemory extends StatelessWidget {
  const _LatestMemory({required this.memory});

  final Memory memory;

  static const double _avatarSize = 32;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AccountAvatar(
          displayName: memory.author.displayName,
          size: _avatarSize,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                '${memory.author.displayName} · '
                '${MemoryDates.visited(l10n, memory.memoryDate)}',
                role: AppTextRole.labelLarge,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.xxs),
              AppText(
                memory.text,
                key: const Key('memory_entry_excerpt'),
                role: AppTextRole.bodyMedium,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmallProgress extends StatelessWidget {
  const _SmallProgress();

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) {
      return AppIcon.decorative(
        Icons.hourglass_top,
        color: context.colors.onSurfaceVariant,
      );
    }
    return const SizedBox.square(
      dimension: AppSizes.spinner,
      child: CircularProgressIndicator(strokeWidth: AppSizes.spinnerStroke),
    );
  }
}
