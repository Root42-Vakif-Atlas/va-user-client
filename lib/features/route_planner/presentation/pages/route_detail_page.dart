import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/features/route_planner/presentation/cubit/route_detail_cubit.dart';
import 'package:vakif_atlas/features/route_planner/presentation/route_presentation.dart';
import 'package:vakif_atlas/features/route_planner/presentation/widgets/route_map_preview.dart';
import 'package:vakif_atlas/features/route_planner/presentation/widgets/route_summary_panel.dart';
import 'package:vakif_atlas/features/route_planner/presentation/widgets/route_timeline.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/atoms/diamond_divider.dart';
import 'package:vakif_atlas/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

/// Rota detayının üst çubuğuna eklenen dışa aktarma eylemi; [enabled]
/// rota silinirken `false`'tur.
typedef RouteExportActionBuilder = Widget Function(
  BuildContext context,
  TravelRoute route, {
  required bool enabled,
});

/// Rota detayı (`/route-planner/:routeId`): harita, süre özeti ve
/// adım adım plan. Düzenlenip kaydedildiğinde kendini yeniler.
///
/// "PDF olarak dışa aktar" eylemi `route_export` feature'ındadır ve
/// yönlendiricide [exportActionBuilder] yuvasına verilir (rota planlayıcı
/// dışa aktarmaya bağımlı değildir). `RouteDetailCubit` üst ağaçtan sağlanır.
class RouteDetailPage extends StatefulWidget {
  const RouteDetailPage({
    required this.routeId,
    required this.onEdit,
    required this.onDeleted,
    required this.onBackToList,
    this.exportActionBuilder,
    super.key,
  });

  final String routeId;
  final VoidCallback onEdit;
  final VoidCallback onDeleted;

  /// Rota bulunamadığında listeye dönüş.
  final VoidCallback onBackToList;

  /// Verilmezse dışa aktarma eylemi gösterilmez.
  final RouteExportActionBuilder? exportActionBuilder;

  @override
  State<RouteDetailPage> createState() => _RouteDetailPageState();
}

class _RouteDetailPageState extends State<RouteDetailPage> {
  String? _languageCode;

  RouteDetailCubit get _cubit => context.read<RouteDetailCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode != _languageCode) {
      _languageCode = languageCode;
      _load();
    }
  }

  @override
  void didUpdateWidget(RouteDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.routeId != widget.routeId) {
      _load();
    }
  }

  void _load() {
    final languageCode = _languageCode;
    if (languageCode != null) {
      unawaited(_cubit.load(id: widget.routeId, languageCode: languageCode));
    }
  }

  Future<void> _confirmDelete(TravelRoute route) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.routeDeleteConfirmTitle),
        content: Text(l10n.routeDeleteConfirmBody(route.name)),
        actions: [
          TextButton(
            key: const Key('route_delete_cancel_button'),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            key: const Key('route_delete_confirm_button'),
            style: TextButton.styleFrom(foregroundColor: context.colors.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.routeDelete),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await _cubit.delete();
    }
  }

  void _onStateChanged(BuildContext context, RouteDetailState state) {
    final l10n = context.l10n;
    final announcer = context.read<A11yAnnouncer>();
    final haptics = context.read<HapticFeedbackService>();
    switch (state) {
      case RouteDetailState(status: RouteDetailStatus.deleted):
        unawaited(haptics.success());
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.routeDeletedMessage)));
        unawaited(announcer.announce(l10n.routeDeletedMessage));
        widget.onDeleted();
      case RouteDetailState(deleteFailure: final failure?):
        unawaited(haptics.error());
        final message = failure.toUserMessage(l10n);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
        unawaited(announcer.announce(message, assertive: true));
      case RouteDetailState(status: RouteDetailStatus.failure, :final failure?):
        unawaited(
          announcer.announce(
            state.isNotFound
                ? l10n.routeNotFoundTitle
                : failure.toUserMessage(l10n),
            assertive: true,
          ),
        );
      case _:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<RouteDetailCubit, RouteDetailState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.deleteFailure != current.deleteFailure,
      listener: _onStateChanged,
      builder: (context, state) {
        final route = state.route;
        if (route != null) {
          final isDeleting = state.status == RouteDetailStatus.deleting;
          return _RouteDetailView(
            route: route,
            isDeleting: isDeleting,
            exportAction: widget.exportActionBuilder?.call(
              context,
              route,
              enabled: !isDeleting,
            ),
            onEdit: widget.onEdit,
            onDelete: () => unawaited(_confirmDelete(route)),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text(l10n.routeDetailTitle)),
          body: switch (state.status) {
            RouteDetailStatus.failure when state.isNotFound =>
              StatusMessageView(
                key: const Key('route_detail_not_found'),
                icon: Icons.search_off_outlined,
                title: l10n.routeNotFoundTitle,
                message: l10n.routeNotFoundBody,
                actionLabel: l10n.routeBackToList,
                onAction: widget.onBackToList,
              ),
            RouteDetailStatus.failure => StatusMessageView(
              key: const Key('route_detail_error'),
              tone: StatusMessageTone.error,
              icon: Icons.cloud_off_outlined,
              title: l10n.routeDetailErrorTitle,
              message: state.failure!.toUserMessage(l10n),
              actionLabel: l10n.commonRetry,
              onAction: () => unawaited(_cubit.retry()),
            ),
            _ => LoadingStatusView(
              key: const Key('route_detail_loading'),
              label: l10n.routeDetailLoading,
            ),
          },
        );
      },
    );
  }
}

class _RouteDetailView extends StatelessWidget {
  const _RouteDetailView({
    required this.route,
    required this.isDeleting,
    required this.exportAction,
    required this.onEdit,
    required this.onDelete,
  });

  final TravelRoute route;
  final bool isDeleting;
  final Widget? exportAction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final cities = [for (final stop in route.stops) stop.city];
    return Scaffold(
      body: CustomScrollView(
        key: const Key('route_detail_scroll'),
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              route.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              ?exportAction,
              IconButton(
                key: const Key('route_edit_button'),
                tooltip: l10n.routeEdit,
                icon: const Icon(Icons.edit_outlined),
                onPressed: isDeleting ? null : onEdit,
              ),
              IconButton(
                key: const Key('route_delete_button'),
                tooltip: l10n.routeDelete,
                icon: const Icon(Icons.delete_outline),
                onPressed: isDeleting ? null : onDelete,
              ),
            ],
            bottom: isDeleting
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(AppSizes.borderHeavy),
                    child: Semantics(
                      liveRegion: true,
                      label: l10n.routeDeleting,
                      child: LinearProgressIndicator(
                        minHeight: AppSizes.borderHeavy,
                        color: colors.accentText,
                      ),
                    ),
                  )
                : null,
          ),
          SliverToBoxAdapter(child: RouteMapPreview(route: route)),
          SliverSafeArea(
            top: false,
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSizes.maxContentWidth,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.xl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppText(
                          route.name,
                          role: AppTextRole.headlineMedium,
                          isHeading: true,
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        AppText(
                          routeCityChain(l10n, cities),
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        RouteSummaryPanel(summary: route.summary),
                        const SizedBox(height: AppSpacing.lg),
                        const DiamondDivider(),
                        const SizedBox(height: AppSpacing.lg),
                        AppText(
                          l10n.routeStepsHeading,
                          role: AppTextRole.titleLarge,
                          isHeading: true,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        RouteTimeline(route: route),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
