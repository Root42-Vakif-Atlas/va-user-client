import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/bloc/memory_list_bloc.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/cubit/my_memories_cubit.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/widgets/memory_actions.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/widgets/memory_card.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/widgets/my_memories_section.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_progress_indicator.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/widgets/memory_status_badge.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/memory_presentation.dart';

/// "Anılarım" (`/profile/memories`): kullanıcının paylaştığı tüm anılar, en
/// son paylaşılan önce. Her anının üstünde eseri ve Anı Köşesi'ne geçiş
/// vardır; anı buradan silinebilir. Sona yaklaşınca sonraki sayfa yüklenir.
/// `MyMemoriesCubit` üst ağaçtan sağlanır.
class MyMemoriesPage extends StatefulWidget {
  const MyMemoriesPage({
    required this.onOpenMonumentMemories,
    required this.onExplore,
    super.key,
  });

  final OpenMonumentMemories onOpenMonumentMemories;

  /// Boş listede "Haritada keşfet" (anı bir eserin sayfasından paylaşılır).
  final VoidCallback onExplore;

  @override
  State<MyMemoriesPage> createState() => _MyMemoriesPageState();
}

class _MyMemoriesPageState extends State<MyMemoriesPage> {
  /// Sona bu kadar kala sonraki sayfa istenir (ADR 25 ile aynı).
  static const double _loadMoreExtent = 600;

  String? _languageCode;

  MyMemoriesCubit get _cubit => context.read<MyMemoriesCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode != _languageCode) {
      _languageCode = languageCode;
      unawaited(_cubit.load(languageCode: languageCode));
    }
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.extentAfter < _loadMoreExtent) {
      unawaited(_cubit.loadMore());
    }
    return false;
  }

  Future<void> _delete(Memory memory) async {
    if (await confirmMemoryDelete(context)) {
      await _cubit.delete(memory);
    }
  }

  void _onNotice(BuildContext context, MyMemoriesState state) {
    final notice = state.notice;
    if (notice == null) {
      return;
    }
    final l10n = context.l10n;
    final message = switch (notice.kind) {
      MemoryNoticeKind.deleted => l10n.memoryDeleted,
      MemoryNoticeKind.reported => l10n.memoryReported,
      MemoryNoticeKind.actionFailed =>
        notice.failure?.toUserMessage(l10n) ?? l10n.errorUnexpected,
    };
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
    unawaited(
      context.read<A11yAnnouncer>().announce(
        message,
        assertive: notice.kind == MemoryNoticeKind.actionFailed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.myMemoriesTitle)),
      body: BlocConsumer<MyMemoriesCubit, MyMemoriesState>(
        listenWhen: (previous, current) =>
            current.noticeCount != previous.noticeCount,
        listener: _onNotice,
        builder: (context, state) => switch (state.status) {
          MyMemoriesStatus.loading => LoadingStatusView(
            label: l10n.myMemoriesLoading,
          ),
          MyMemoriesStatus.failure => StatusMessageView(
            key: const Key('my_memories_error'),
            tone: StatusMessageTone.error,
            icon: Icons.photo_library_outlined,
            title: l10n.myMemoriesLoadFailed,
            message: state.failure?.toUserMessage(l10n) ?? '',
            actionLabel: l10n.commonRetry,
            onAction: () => unawaited(
              _cubit.load(languageCode: _languageCode ?? l10n.localeName),
            ),
          ),
          MyMemoriesStatus.ready when state.items.isEmpty => StatusMessageView(
            key: const Key('my_memories_empty'),
            icon: Icons.photo_library_outlined,
            title: l10n.myMemoriesEmptyTitle,
            message: l10n.myMemoriesEmptyBody,
            actionLabel: l10n.emptyStateExploreMap,
            actionIcon: Icons.map_outlined,
            onAction: widget.onExplore,
          ),
          MyMemoriesStatus.ready => NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: _MemoryList(
              state: state,
              onOpenMonumentMemories: widget.onOpenMonumentMemories,
              onDelete: (memory) => unawaited(_delete(memory)),
              onRetryMore: () => unawaited(_cubit.loadMore()),
            ),
          ),
        },
      ),
    );
  }
}

class _MemoryList extends StatelessWidget {
  const _MemoryList({
    required this.state,
    required this.onOpenMonumentMemories,
    required this.onDelete,
    required this.onRetryMore,
  });

  final MyMemoriesState state;
  final OpenMonumentMemories onOpenMonumentMemories;
  final ValueChanged<Memory> onDelete;
  final VoidCallback onRetryMore;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = state.items;
    return SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: ListView.builder(
            key: const Key('my_memories_list'),
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: items.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: AppText(
                    l10n.memoryCount(state.total),
                    role: AppTextRole.titleMedium,
                    isHeading: true,
                  ),
                );
              }
              if (index == items.length + 1) {
                return _ListFooter(state: state, onRetry: onRetryMore);
              }
              final memory = items[index - 1];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: _OwnMemory(
                  memory: memory,
                  monumentName:
                      state.monumentNames[memory.monumentId] ??
                      l10n.myMemoriesUnknownMonument,
                  isBusy: state.busyIds.contains(memory.id),
                  onOpenMonumentMemories: onOpenMonumentMemories,
                  onDelete: () => onDelete(memory),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Eser başlığı + Anı Köşesi bağlantısı, durum (inceleniyor / yayınlanmadı)
/// ve anı kartı.
class _OwnMemory extends StatelessWidget {
  const _OwnMemory({
    required this.memory,
    required this.monumentName,
    required this.isBusy,
    required this.onOpenMonumentMemories,
    required this.onDelete,
  });

  final Memory memory;
  final String monumentName;
  final bool isBusy;
  final OpenMonumentMemories onOpenMonumentMemories;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final status = memory.status.description(l10n);
    return Column(
      key: Key('my_memory_${memory.id}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(monumentName, role: AppTextRole.titleMedium, isHeading: true),
        // Yayında olmayan anı Anı Köşesi'nde görünmez; bağlantı yanıltırdı.
        if (memory.status == MemoryModerationStatus.approved)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppButton.ghost(
              key: Key('my_memory_open_${memory.id}'),
              label: l10n.myMemoriesOpenCorner,
              semanticsLabel: l10n.myMemoriesOpenCornerSemantics(monumentName),
              icon: Icons.photo_library_outlined,
              onPressed: () =>
                  onOpenMonumentMemories(memory.monumentId, monumentName),
            ),
          ),
        if (status != null) ...[
          MergeSemantics(
            key: Key('my_memory_status_${memory.id}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MemoryStatusBadge(status: memory.status),
                const SizedBox(height: AppSpacing.xxs),
                AppText(
                  status,
                  role: AppTextRole.bodySmall,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        MemoryCard(
          memory: memory,
          isOwn: true,
          isBusy: isBusy,
          onDelete: onDelete,
        ),
      ],
    );
  }
}

class _ListFooter extends StatelessWidget {
  const _ListFooter({required this.state, required this.onRetry});

  final MyMemoriesState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (state.loadMoreFailure != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InlineMessage(
            message: l10n.memoryLoadMoreFailed,
            type: InlineMessageType.error,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton.secondary(
            key: const Key('my_memories_load_more_retry'),
            label: l10n.commonRetry,
            icon: Icons.refresh,
            onPressed: onRetry,
          ),
        ],
      );
    }
    if (state.isLoadingMore) {
      return Semantics(
        label: l10n.myMemoriesLoading,
        liveRegion: true,
        excludeSemantics: true,
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Center(child: AppProgressIndicator(strokeWidth: 4)),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
