import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/bloc/memory_list_bloc.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/memory_presentation.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/widgets/memory_actions.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/widgets/memory_list_item.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

/// Bir eserin Anı Köşesi (`/monument/:id/memory-corner`, herkese açık):
/// anı tarihine göre aylık gruplanmış zaman çizelgesi.
///
/// - Filtre: "Tümü", yıllar (sayılarıyla) ve özel tarih aralığı; sonuç
///   sayısı ekran okuyucuya duyurulur.
/// - İmleçle sayfalanır (sona 600 px kala sonraki sayfa), aşağı çekerek
///   yenilenir. [MemoryListBloc] üst ağaçtan sağlanır.
class MemoryCornerPage extends StatefulWidget {
  const MemoryCornerPage({
    required this.monumentId,
    required this.viewerId,
    required this.onShare,
    required this.onSignIn,
    this.monumentName,
    super.key,
  });

  final String monumentId;

  /// Eser detayından gelindiğinde başlıkta gösterilir; derin bağlantıda yok.
  final String? monumentName;
  final String? viewerId;
  final VoidCallback onShare;
  final ValueChanged<MemorySignInIntent> onSignIn;

  static const double loadMoreExtent = 600;

  @override
  State<MemoryCornerPage> createState() => _MemoryCornerPageState();
}

class _MemoryCornerPageState extends State<MemoryCornerPage> {
  MemoryListBloc get _bloc => context.read<MemoryListBloc>();

  /// Kullanıcı filtreyi değiştirdi; sonuç gelince sayısı duyurulur.
  bool _announceResult = false;

  @override
  void initState() {
    super.initState();
    _bloc.add(
      MemoryListEvent.started(
        monumentId: widget.monumentId,
        pageSize: MemoryRules.pageSize,
      ),
    );
  }

  @override
  void didUpdateWidget(MemoryCornerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewerId != widget.viewerId) {
      _bloc.add(const MemoryListEvent.refreshed());
    }
  }

  Future<void> _share() async {
    if (widget.viewerId != null) {
      widget.onShare();
      return;
    }
    if (await showMemorySignInSheet(context, MemorySignInIntent.share)) {
      widget.onSignIn(MemorySignInIntent.share);
    }
  }

  void _setRange(MemoryDateRange? range) {
    _announceResult = true;
    _bloc.add(MemoryListEvent.rangeChanged(range));
  }

  Future<void> _pickRange(MemoryDateRange? current) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final first = DateTime(MemoryRules.earliestVisitYear);
    final start = current?.from;
    final end = current?.to;
    // Başlangıç aralığı her zaman verilir (varsayılan: bu yıl). Boş
    // aralıkta pencere başlığı Türkçe yer tutucularla dar ekranda taşıyor.
    final initial = start != null && end != null
        ? DateTimeRange(start: start, end: end)
        : DateTimeRange(start: DateTime(today.year), end: today);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: first,
      lastDate: today,
      helpText: context.l10n.memoryFilterRangeHelp,
      initialDateRange: initial,
    );
    if (picked != null && mounted) {
      _setRange(MemoryDateRange(from: picked.start, to: picked.end));
    }
  }

  bool _onScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis == Axis.vertical &&
        metrics.extentAfter < MemoryCornerPage.loadMoreExtent) {
      _bloc.add(const MemoryListEvent.nextPageRequested());
    }
    return false;
  }

  Future<void> _refresh() async {
    _bloc.add(const MemoryListEvent.refreshed());
    await _bloc.stream.firstWhere(
      (state) => state.status != MemoryListStatus.loading,
    );
  }

  void _onResult(BuildContext context, MemoryListState state) {
    if (!_announceResult) {
      return;
    }
    _announceResult = false;
    unawaited(
      context.read<A11yAnnouncer>().announce(
        context.l10n.memoryFilterResult(state.total),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.memoryCornerTitle)),
      floatingActionButton: FloatingActionButton.extended(
        // Sekmeler aynı kabuk rotasında yaşadığından varsayılan hero
        // etiketi çakışır; FAB'lar arası paylaşılan öğe geçişi yoktur.
        heroTag: null,
        key: const Key('memory_corner_share_fab'),
        onPressed: () => unawaited(_share()),
        icon: const Icon(Icons.edit_note),
        label: Text(l10n.memoryShare),
      ),
      body: MemoryNoticeListener(
        child: BlocListener<MemoryListBloc, MemoryListState>(
          listenWhen: (previous, current) =>
              previous.status == MemoryListStatus.loading &&
              current.status == MemoryListStatus.success,
          listener: _onResult,
          child: BlocBuilder<MemoryListBloc, MemoryListState>(
            builder: (context, state) => switch (state.status) {
              // İlk açılış: henüz filtre ve sayı yok.
              MemoryListStatus.initial || MemoryListStatus.loading
                  when state.items.isEmpty && state.years.isEmpty =>
                LoadingStatusView(
                  key: const Key('memory_corner_loading'),
                  label: l10n.memoryLoading,
                ),
              MemoryListStatus.failure when state.years.isEmpty =>
                StatusMessageView(
                  key: const Key('memory_corner_error'),
                  tone: StatusMessageTone.error,
                  icon: Icons.cloud_off_outlined,
                  title: l10n.memoryLoadFailedTitle,
                  message: state.failure?.toUserMessage(l10n) ?? '',
                  actionLabel: l10n.commonRetry,
                  onAction: () =>
                      _bloc.add(const MemoryListEvent.retryRequested()),
                ),
              _ when state.isEmpty && state.range == null => StatusMessageView(
                key: const Key('memory_corner_empty'),
                icon: Icons.auto_stories_outlined,
                title: l10n.memoryEmptyTitle,
                message: l10n.memoryEmptyBody,
              ),
              _ => NotificationListener<ScrollNotification>(
                onNotification: _onScroll,
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: _TimelineView(
                    state: state,
                    monumentName: widget.monumentName,
                    viewerId: widget.viewerId,
                    onSignIn: widget.onSignIn,
                    onRangeSelected: _setRange,
                    onPickRange: () => unawaited(_pickRange(state.range)),
                    onRetry: () =>
                        _bloc.add(const MemoryListEvent.retryRequested()),
                  ),
                ),
              ),
            },
          ),
        ),
      ),
    );
  }
}

/// Zaman çizelgesinin satırı: ay başlığı veya anı.
sealed class _Row {
  const _Row();
}

final class _MonthRow extends _Row {
  const _MonthRow(this.month);

  /// Ayın ilk günü.
  final DateTime month;
}

final class _MemoryRow extends _Row {
  const _MemoryRow(this.memory);

  final Memory memory;
}

List<_Row> _rowsOf(List<Memory> items) {
  final rows = <_Row>[];
  DateTime? current;
  for (var i = 0; i < items.length; i++) {
    final date = items[i].memoryDate;
    final month = DateTime(date.year, date.month);
    if (month != current) {
      rows.add(_MonthRow(month));
      current = month;
    }
    rows.add(_MemoryRow(items[i]));
  }
  return rows;
}

class _TimelineView extends StatelessWidget {
  const _TimelineView({
    required this.state,
    required this.monumentName,
    required this.viewerId,
    required this.onSignIn,
    required this.onRangeSelected,
    required this.onPickRange,
    required this.onRetry,
  });

  final MemoryListState state;
  final String? monumentName;
  final String? viewerId;
  final ValueChanged<MemorySignInIntent> onSignIn;
  final ValueChanged<MemoryDateRange?> onRangeSelected;
  final VoidCallback onPickRange;
  final VoidCallback onRetry;

  /// Son kartın genişletilmiş FAB'ın altında kalmaması için.
  static const double _fabClearance = AppSpacing.x4l + AppSpacing.md;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rows = _rowsOf(state.items);
    final filtering =
        state.status == MemoryListStatus.loading && state.items.isEmpty;
    final filteredFailure =
        state.status == MemoryListStatus.failure && state.items.isEmpty;
    final filteredEmpty = state.isEmpty && state.range != null;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
        child: CustomScrollView(
          key: const Key('memory_corner_list'),
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(
                      monumentName: monumentName,
                      total: state.allTimeTotal,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _TimeFilterBar(
                      years: state.years,
                      total: state.allTimeTotal,
                      range: state.range,
                      onSelected: onRangeSelected,
                      onPickRange: onPickRange,
                    ),
                  ],
                ),
              ),
            ),
            if (filtering)
              const SliverToBoxAdapter(child: _InlineProgress())
            else if (filteredFailure)
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.md),
                sliver: SliverToBoxAdapter(
                  child: _RetryMessage(
                    message: state.failure?.toUserMessage(l10n) ?? '',
                    onRetry: onRetry,
                  ),
                ),
              )
            else if (filteredEmpty)
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.md),
                sliver: SliverToBoxAdapter(
                  child: _FilteredEmpty(onClear: () => onRangeSelected(null)),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverList.builder(
                  itemCount: rows.length,
                  itemBuilder: (context, index) => switch (rows[index]) {
                    _MonthRow(:final month) => _MonthHeader(
                      month: month,
                      isFirst: index == 0,
                    ),
                    _MemoryRow(:final memory) => _TimelineEntry(
                      isLast: index == rows.length - 1 && !state.hasMore,
                      child: MemoryListItem(
                        key: ValueKey(memory.id),
                        memory: memory,
                        viewerId: viewerId,
                        onSignIn: onSignIn,
                      ),
                    ),
                  },
                ),
              ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                MediaQuery.paddingOf(context).bottom + _fabClearance,
              ),
              sliver: SliverToBoxAdapter(
                child: _ListFooter(state: state, onRetry: onRetry),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.monumentName, required this.total});

  final String? monumentName;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final name = monumentName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (name != null)
          AppText(name, role: AppTextRole.titleLarge, isHeading: true),
        AppText(
          '${l10n.memoryCornerSubtitle} · ${l10n.memoryCount(total)}',
          color: colors.onSurfaceVariant,
        ),
        const SizedBox(height: AppSpacing.xxs),
        AppText(
          l10n.memoryTimelineHint,
          role: AppTextRole.bodySmall,
          color: colors.onSurfaceVariant,
        ),
      ],
    );
  }
}

/// "Tümü", yıllar (sayılarıyla, en yeni önce) ve özel tarih aralığı.
/// Çipler sığmadığında alt satıra geçer (%200 metin ölçeğinde de yatay
/// kaydırma gerekmez).
class _TimeFilterBar extends StatelessWidget {
  const _TimeFilterBar({
    required this.years,
    required this.total,
    required this.range,
    required this.onSelected,
    required this.onPickRange,
  });

  final List<MemoryYearCount> years;
  final int total;
  final MemoryDateRange? range;
  final ValueChanged<MemoryDateRange?> onSelected;
  final VoidCallback onPickRange;

  String _rangeLabel(AppLocalizations l10n, MemoryDateRange range) {
    final from = range.from;
    final to = range.to;
    return [
      if (from != null) MemoryDates.posted(l10n, from),
      if (to != null) MemoryDates.posted(l10n, to),
    ].join(' – ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = range;
    final selectedYear = current?.year;
    final customRange = current != null && selectedYear == null;
    return Semantics(
      container: true,
      label: l10n.memoryFilterHeading,
      explicitChildNodes: true,
      child: Wrap(
        key: const Key('memory_time_filter'),
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: [
          ChoiceChip(
            key: const Key('memory_filter_all'),
            label: Text(l10n.memoryFilterAll(total)),
            selected: current == null,
            onSelected: (_) => onSelected(null),
          ),
          for (final year in years)
            ChoiceChip(
              key: Key('memory_filter_year_${year.year}'),
              label: Text(
                l10n.memoryFilterYear('${year.year}', year.count),
                semanticsLabel: l10n.memoryFilterYearSemantics(
                  '${year.year}',
                  year.count,
                ),
              ),
              selected: selectedYear == year.year,
              onSelected: (_) => onSelected(MemoryDateRange.year(year.year)),
            ),
          if (customRange)
            InputChip(
              key: const Key('memory_filter_range'),
              avatar: const Icon(Icons.date_range, size: AppSizes.iconSm),
              label: Text(_rangeLabel(l10n, current)),
              selected: true,
              onPressed: onPickRange,
              onDeleted: () => onSelected(null),
              deleteButtonTooltipMessage: l10n.memoryFilterClearRange,
            )
          else
            ActionChip(
              key: const Key('memory_filter_range'),
              avatar: const Icon(Icons.date_range, size: AppSizes.iconSm),
              label: Text(l10n.memoryFilterRange),
              onPressed: onPickRange,
            ),
        ],
      ),
    );
  }
}

/// Zaman çizelgesi çizgisinin genişliği ve işaretlerin konumu.
abstract final class _Rail {
  static const double width = AppSpacing.lg;
  static const double line = AppSizes.borderThick;
  static const double monthDot = 12;
  static const double entryDot = 10;

  /// Anı işaretinin kart başlığı (avatar) hizası.
  static const double entryDotTop = AppSpacing.lg;
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({required this.month, required this.isFirst});

  final DateTime month;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = MemoryDates.visited(context.l10n, month);
    return Stack(
      children: [
        PositionedDirectional(
          start: (_Rail.width - _Rail.line) / 2,
          top: isFirst ? AppSpacing.md : 0,
          bottom: 0,
          width: _Rail.line,
          child: ColoredBox(color: colors.outlineVariant),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.sm,
            bottom: AppSpacing.sm,
          ),
          child: Row(
            children: [
              SizedBox(
                width: _Rail.width,
                child: Center(
                  child: Container(
                    width: _Rail.monthDot,
                    height: _Rail.monthDot,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppText(
                  label,
                  key: Key('memory_month_${month.year}_${month.month}'),
                  role: AppTextRole.titleMedium,
                  isHeading: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({required this.child, required this.isLast});

  final Widget child;

  /// Çizelgenin son kaydı: çizgi işaretin altında devam etmez.
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Stack(
      children: [
        PositionedDirectional(
          start: (_Rail.width - _Rail.line) / 2,
          top: 0,
          bottom: isLast ? null : 0,
          height: isLast ? _Rail.entryDotTop : null,
          width: _Rail.line,
          child: ColoredBox(color: colors.outlineVariant),
        ),
        PositionedDirectional(
          start: (_Rail.width - _Rail.entryDot) / 2,
          top: _Rail.entryDotTop - _Rail.entryDot / 2,
          child: Container(
            width: _Rail.entryDot,
            height: _Rail.entryDot,
            decoration: BoxDecoration(
              color: colors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: colors.primary,
                width: AppSizes.borderThick,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: _Rail.width + AppSpacing.sm,
            bottom: AppSpacing.sm,
          ),
          child: child,
        ),
      ],
    );
  }
}

class _FilteredEmpty extends StatelessWidget {
  const _FilteredEmpty({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: StatusMessageContent(
        key: const Key('memory_corner_filtered_empty'),
        compact: true,
        icon: Icons.event_busy_outlined,
        title: l10n.memoryFilterEmptyTitle,
        message: l10n.memoryFilterEmptyBody,
        actionKey: const Key('memory_filter_clear'),
        actionLabel: l10n.memoryFilterClear,
        actionIcon: Icons.filter_alt_off_outlined,
        onAction: onClear,
      ),
    );
  }
}

class _RetryMessage extends StatelessWidget {
  const _RetryMessage({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InlineMessage(
          message: '${l10n.memoryLoadFailedTitle}. $message',
          type: InlineMessageType.error,
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: AppButton.ghost(
            label: l10n.commonRetry,
            icon: Icons.refresh,
            onPressed: onRetry,
          ),
        ),
      ],
    );
  }
}

class _ListFooter extends StatelessWidget {
  const _ListFooter({required this.state, required this.onRetry});

  final MemoryListState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (state.loadMoreFailure != null) {
      return Column(
        key: const Key('memory_corner_load_more_error'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InlineMessage(
            message: l10n.memoryLoadMoreFailed,
            type: InlineMessageType.error,
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppButton.ghost(
              label: l10n.commonRetry,
              icon: Icons.refresh,
              onPressed: onRetry,
            ),
          ),
        ],
      );
    }
    return state.isLoadingMore
        ? const _InlineProgress()
        : const SizedBox.shrink();
  }
}

class _InlineProgress extends StatelessWidget {
  const _InlineProgress();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.memoryLoading,
      liveRegion: true,
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: context.reduceMotion
              ? const Icon(Icons.hourglass_top)
              : const SizedBox.square(
                  dimension: AppSizes.spinner,
                  child: CircularProgressIndicator(
                    strokeWidth: AppSizes.spinnerStroke,
                  ),
                ),
        ),
      ),
    );
  }
}
