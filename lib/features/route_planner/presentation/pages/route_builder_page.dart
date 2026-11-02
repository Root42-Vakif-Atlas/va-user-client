import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/l10n/measure_format.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/presentation/bloc/monument_search_bloc.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/features/route_planner/presentation/bloc/route_builder_bloc.dart';
import 'package:vakif_atlas/features/route_planner/presentation/pages/route_monument_picker_page.dart';
import 'package:vakif_atlas/features/route_planner/presentation/route_presentation.dart';
import 'package:vakif_atlas/features/route_planner/presentation/widgets/builder_summary_bar.dart';
import 'package:vakif_atlas/features/route_planner/presentation/widgets/route_builder_sheets.dart';
import 'package:vakif_atlas/features/route_planner/presentation/widgets/route_map_preview.dart';
import 'package:vakif_atlas/features/route_planner/presentation/widgets/stop_editor_card.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_text_field.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

/// Rota oluşturucu (`/route-planner/new`) ve düzenleyici
/// (`/route-planner/:routeId/edit`).
///
/// Eserler haritadakiyle aynı sunucu araması ve filtrelerle seçilir
/// ([RouteMonumentPickerPage]), sıralanır, ziyaret süreleri ve molalar
/// ayarlanır; gönderimde rota `POST /routes` (düzenlemede
/// `PUT /routes/{id}`) ile kaydedilir ve karayolu süresi sunucudan gelir.
/// `RouteBuilderBloc` ve `MonumentSearchBloc` üst ağaçtan sağlanır.
class RouteBuilderPage extends StatefulWidget {
  const RouteBuilderPage({
    required this.onSaved,
    this.editingRouteId,
    super.key,
  });

  /// `null` ise yeni rota taslağı düzenlenir.
  final String? editingRouteId;

  /// Kaydetme başarılı; yeni rotada taslak bu çağrıdan önce temizlenir.
  final ValueChanged<TravelRoute> onSaved;

  @override
  State<RouteBuilderPage> createState() => _RouteBuilderPageState();
}

class _RouteBuilderPageState extends State<RouteBuilderPage> {
  final TextEditingController _name = TextEditingController();
  String? _languageCode;

  RouteBuilderBloc get _bloc => context.read<RouteBuilderBloc>();

  @override
  void initState() {
    super.initState();
    _name.text = _bloc.state.name;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode == _languageCode) {
      return;
    }
    final firstLoad = _languageCode == null;
    _languageCode = languageCode;
    final routeId = widget.editingRouteId;
    // Düzenlemede rota yalnızca ilk açılışta yüklenir; dil değişiminde
    // yalnızca eser adları yenilenir, kaydedilmemiş değişiklikler korunur.
    _bloc.add(
      routeId != null && firstLoad
          ? RouteBuilderEvent.editRequested(
              routeId: routeId,
              languageCode: languageCode,
            )
          : RouteBuilderEvent.started(languageCode: languageCode),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _retry() {
    final languageCode = _languageCode;
    final routeId = widget.editingRouteId;
    if (languageCode == null) {
      return;
    }
    _bloc.add(
      routeId != null
          ? RouteBuilderEvent.editRequested(
              routeId: routeId,
              languageCode: languageCode,
            )
          : RouteBuilderEvent.started(languageCode: languageCode),
    );
  }

  void _announce(String message, {bool assertive = false}) => unawaited(
    context.read<A11yAnnouncer>().announce(message, assertive: assertive),
  );

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
    _announce(message);
  }

  String _stopName(String monumentId) =>
      _bloc.state.monument(monumentId)?.name ?? monumentId;

  void _toggleMonument(MonumentPin monument) {
    final l10n = context.l10n;
    final name = monument.name;
    final wasIncluded = _bloc.state.contains(monument.id);
    _bloc.add(
      RouteBuilderEvent.monumentToggled(monument.id, monument: monument),
    );
    unawaited(context.read<HapticFeedbackService>().selection());
    _announce(
      wasIncluded
          ? l10n.routeStopRemovedAnnouncement(name)
          : l10n.routeStopAddedAnnouncement(name),
    );
  }

  void _moveStop(int from, int to) {
    final stops = _bloc.state.stops;
    if (from == to || to < 0 || to >= stops.length) {
      return;
    }
    final name = _stopName(stops[from].monumentId);
    _bloc.add(RouteBuilderEvent.stopMoved(from: from, to: to));
    _announce(context.l10n.routeStopMovedAnnouncement(name, to + 1));
  }

  void _removeStop(int index) {
    final name = _stopName(_bloc.state.stops[index].monumentId);
    _bloc.add(RouteBuilderEvent.stopRemoved(index));
    _announce(context.l10n.routeStopRemovedAnnouncement(name));
  }

  Future<void> _openMonumentPicker() => Navigator.of(context).push(
    RouteMonumentPickerPage.route(
      context,
      builder: _bloc,
      search: context.read<MonumentSearchBloc>(),
      onToggled: _toggleMonument,
    ),
  );

  Future<void> _addBreak(int stopIndex) async {
    final kind = await showModalBottomSheet<RouteBreakKind>(
      context: context,
      sheetAnimationStyle: context.motionAnimationStyle,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const BreakPickerSheet(),
    );
    if (kind != null && mounted) {
      _bloc.add(RouteBuilderEvent.breakAdded(stopIndex: stopIndex, kind: kind));
      _announce(
        context.l10n.routeBreakSemantics(
          kind.label(context.l10n),
          context.l10n.durationLong(kind.defaultDuration),
        ),
      );
    }
  }

  void _submit() {
    final languageCode = _languageCode;
    if (languageCode == null) {
      return;
    }
    _bloc.add(
      RouteBuilderEvent.submitted(
        languageCode: languageCode,
        fallbackName: suggestedRouteName(context.l10n, _bloc.state.cities),
      ),
    );
  }

  void _onSaved(TravelRoute route) {
    final l10n = context.l10n;
    unawaited(context.read<HapticFeedbackService>().success());
    _announce(
      widget.editingRouteId == null
          ? l10n.routeCreatedAnnouncement(
              l10n.routeStopCount(route.stops.length),
              l10n.distance(route.summary.distanceMeters),
              l10n.durationLong(route.summary.total),
            )
          : l10n.routeUpdatedAnnouncement,
    );
    if (widget.editingRouteId == null) {
      _bloc.add(const RouteBuilderEvent.reset());
    }
    widget.onSaved(route);
  }

  /// Bildirimler: sınır, optimizasyon, doğrulama, kaydetme sonucu.
  List<BlocListener<RouteBuilderBloc, RouteBuilderState>> _listeners() => [
    BlocListener<RouteBuilderBloc, RouteBuilderState>(
      listenWhen: (previous, current) => previous.name != current.name,
      listener: (context, state) {
        if (_name.text != state.name) {
          _name.text = state.name;
        }
      },
    ),
    BlocListener<RouteBuilderBloc, RouteBuilderState>(
      listenWhen: (previous, current) =>
          current.limitNotices > previous.limitNotices,
      listener: (context, state) =>
          _showMessage(context.l10n.routeLimitReached(RoutePlanRules.maxStops)),
    ),
    BlocListener<RouteBuilderBloc, RouteBuilderState>(
      listenWhen: (previous, current) =>
          current.optimization != null &&
          current.optimization?.sequence != previous.optimization?.sequence,
      listener: (context, state) {
        final outcome = state.optimization!;
        final l10n = context.l10n;
        String travel(double seconds) =>
            l10n.durationShort(Duration(seconds: seconds.round()));
        _showMessage(switch (outcome) {
          RouteOptimizationOutcome(changed: false) =>
            l10n.routeOptimizedUnchanged,
          RouteOptimizationOutcome(
            basis: RouteOptimizationBasis.roadTravelSeconds,
          ) =>
            l10n.routeOptimizedRoadAnnouncement(
              travel(outcome.before),
              travel(outcome.after),
            ),
          RouteOptimizationOutcome() => l10n.routeOptimizedAnnouncement(
            l10n.distance(outcome.before),
            l10n.distance(outcome.after),
          ),
        });
      },
    ),
    BlocListener<RouteBuilderBloc, RouteBuilderState>(
      listenWhen: (previous, current) =>
          current.invalidSubmissions > previous.invalidSubmissions,
      listener: (context, state) {
        final error = state.validationError(
          suggestedRouteName(context.l10n, state.cities),
        );
        if (error != null) {
          unawaited(context.read<HapticFeedbackService>().error());
          _announce(error.message(context.l10n), assertive: true);
        }
      },
    ),
    BlocListener<RouteBuilderBloc, RouteBuilderState>(
      listenWhen: (previous, current) =>
          current.saveFailure != null &&
          previous.saveFailure != current.saveFailure,
      listener: (context, state) {
        unawaited(context.read<HapticFeedbackService>().error());
        _announce(
          state.saveFailure!.toUserMessage(context.l10n),
          assertive: true,
        );
      },
    ),
    BlocListener<RouteBuilderBloc, RouteBuilderState>(
      listenWhen: (previous, current) =>
          previous.status != RouteBuilderStatus.saved &&
          current.status == RouteBuilderStatus.saved &&
          current.savedRoute != null,
      listener: (context, state) => _onSaved(state.savedRoute!),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: _listeners(),
      child: BlocBuilder<RouteBuilderBloc, RouteBuilderState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.isBlockedByLoadFailure != current.isBlockedByLoadFailure,
        builder: (context, state) {
          final status = _statusView(state);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.editingRouteId == null
                    ? l10n.routeBuilderNewTitle
                    : l10n.routeBuilderEditTitle,
              ),
            ),
            body:
                status ??
                _BuilderBody(
                  nameController: _name,
                  onNameChanged: (name) =>
                      _bloc.add(RouteBuilderEvent.nameChanged(name)),
                  onAddMonuments: () => unawaited(_openMonumentPicker()),
                  onOptimize: () =>
                      _bloc.add(const RouteBuilderEvent.orderOptimized()),
                  onMove: _moveStop,
                  onRemove: _removeStop,
                  onAddBreak: (index) => unawaited(_addBreak(index)),
                ),
            // Alt gezinme yuvası: SnackBar'lar gönderim butonunu örtmez.
            bottomNavigationBar: status == null
                ? _BuilderSummary(onSubmit: _submit)
                : null,
          );
        },
      ),
    );
  }

  /// Yükleme / hata görünümü; içerik gösterilecekse `null`.
  Widget? _statusView(RouteBuilderState state) {
    final l10n = context.l10n;
    final loadFailure = state.loadFailure;
    if (state.status == RouteBuilderStatus.loading) {
      return LoadingStatusView(
        key: const Key('route_builder_loading'),
        label: l10n.routeBuilderLoading,
      );
    }
    if (state.isRouteMissing) {
      return StatusMessageView(
        key: const Key('route_builder_not_found'),
        icon: Icons.search_off_outlined,
        title: l10n.routeNotFoundTitle,
        message: l10n.routeNotFoundBody,
      );
    }
    if (loadFailure != null && state.isBlockedByLoadFailure) {
      return StatusMessageView(
        key: const Key('route_builder_error'),
        tone: StatusMessageTone.error,
        icon: Icons.cloud_off_outlined,
        title: l10n.routeDetailErrorTitle,
        message: loadFailure.toUserMessage(l10n),
        actionLabel: l10n.commonRetry,
        onAction: _retry,
      );
    }
    return null;
  }
}

class _BuilderBody extends StatelessWidget {
  const _BuilderBody({
    required this.nameController,
    required this.onNameChanged,
    required this.onAddMonuments,
    required this.onOptimize,
    required this.onMove,
    required this.onRemove,
    required this.onAddBreak,
  });

  final TextEditingController nameController;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onAddMonuments;
  final VoidCallback onOptimize;
  final void Function(int from, int to) onMove;
  final ValueChanged<int> onRemove;
  final ValueChanged<int> onAddBreak;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<RouteBuilderBloc>();
    return BlocBuilder<RouteBuilderBloc, RouteBuilderState>(
      builder: (context, state) {
        final fallbackName = suggestedRouteName(l10n, state.cities);
        final validation = state.showValidation
            ? state.validationError(fallbackName)
            : null;
        final locations = state.stopLocations;
        final preview = state.currentPreview;
        return ReorderableListView.builder(
          key: const Key('route_builder_list'),
          buildDefaultDragHandles: false,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          header: _BuilderHeader(
            nameController: nameController,
            nameHint: fallbackName,
            nameError: validation == RoutePlanError.nameTooLong
                ? validation?.message(l10n)
                : null,
            stopCount: state.stops.length,
            canOptimize: state.stops.length > 2 && locations != null,
            isOptimizing: state.isOptimizing,
            onNameChanged: onNameChanged,
            onAddMonuments: onAddMonuments,
            onOptimize: onOptimize,
          ),
          // Karayolu önizlemesi düzenlenen durakların altındadır.
          footer: preview == null || locations == null
              ? null
              : _BuilderMap(
                  map: RouteMapPreview(
                    key: const Key('route_builder_map'),
                    stops: [
                      for (final (index, location) in locations.indexed)
                        (
                          location: location,
                          name:
                              state
                                  .monument(state.stops[index].monumentId)
                                  ?.name ??
                              state.stops[index].monumentId,
                        ),
                    ],
                    legs: preview.legs,
                  ),
                ),
          itemCount: state.stops.length,
          onReorderItem: onMove,
          itemBuilder: (context, index) {
            final stop = state.stops[index];
            final isLast = index == state.stops.length - 1;
            return Padding(
              key: ValueKey(stop.monumentId),
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: StopEditorCard(
                index: index,
                count: state.stops.length,
                stop: stop,
                monument: state.monument(stop.monumentId),
                straightLineToNextMeters: isLast || locations == null
                    ? null
                    : locations[index].distanceTo(locations[index + 1]),
                nextLeg: isLast ? null : preview?.legs[index],
                onMoveUp: () => onMove(index, index - 1),
                onMoveDown: () => onMove(index, index + 1),
                onRemove: () => onRemove(index),
                onVisitChanged: (visit) => bloc.add(
                  RouteBuilderEvent.visitChanged(index: index, visit: visit),
                ),
                onAddBreak: () => onAddBreak(index),
                onBreakChanged: (breakIndex, duration) => bloc.add(
                  RouteBuilderEvent.breakChanged(
                    stopIndex: index,
                    breakIndex: breakIndex,
                    duration: duration,
                  ),
                ),
                onBreakRemoved: (breakIndex) => bloc.add(
                  RouteBuilderEvent.breakRemoved(
                    stopIndex: index,
                    breakIndex: breakIndex,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _BuilderSummary extends StatelessWidget {
  const _BuilderSummary({required this.onSubmit});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<RouteBuilderBloc, RouteBuilderState>(
      builder: (context, state) {
        final validation = state.showValidation
            ? state.validationError(suggestedRouteName(l10n, state.cities))
            : null;
        final preview = state.currentPreview;
        return BuilderSummaryBar(
          stopCount: state.stops.length,
          straightLineMeters: state.straightLineMeters,
          roadMeters: preview?.distanceMeters,
          travel: preview?.travel,
          visitTotal: state.visitTotal,
          breakTotal: state.breakTotal,
          isEditing: state.isEditing,
          isSubmitting: state.isSubmitting,
          // Ad hatası alanın altında gösterilir.
          errorMessage:
              state.saveFailure?.toUserMessage(l10n) ??
              (validation == RoutePlanError.nameTooLong
                  ? null
                  : validation?.message(l10n)),
          onSubmit: onSubmit,
        );
      },
    );
  }
}

class _BuilderHeader extends StatelessWidget {
  const _BuilderHeader({
    required this.nameController,
    required this.nameHint,
    required this.nameError,
    required this.stopCount,
    required this.canOptimize,
    required this.isOptimizing,
    required this.onNameChanged,
    required this.onAddMonuments,
    required this.onOptimize,
  });

  final TextEditingController nameController;
  final String nameHint;
  final String? nameError;
  final int stopCount;
  final bool canOptimize;
  final bool isOptimizing;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onAddMonuments;
  final VoidCallback onOptimize;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          key: const Key('route_name_field'),
          controller: nameController,
          label: l10n.routeNameLabel,
          hint: nameHint,
          helperText: l10n.routeNameHelper,
          errorText: nameError,
          textInputAction: TextInputAction.done,
          onChanged: onNameChanged,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppText(
          l10n.routeStopsHeading(stopCount, RoutePlanRules.maxStops),
          role: AppTextRole.titleLarge,
          isHeading: true,
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            AppButton.secondary(
              key: const Key('route_add_monuments_button'),
              label: l10n.routeAddMonuments,
              icon: Icons.add_location_alt_outlined,
              onPressed: onAddMonuments,
            ),
            Tooltip(
              message: l10n.routeOptimizeHint,
              child: AppButton.ghost(
                key: const Key('route_optimize_button'),
                label: l10n.routeOptimize,
                icon: Icons.auto_fix_high_outlined,
                isLoading: isOptimizing,
                onPressed: canOptimize && !isOptimizing ? onOptimize : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        AppText(
          l10n.routeBuilderTravelNote,
          role: AppTextRole.bodySmall,
          color: colors.onSurfaceVariant,
        ),
        const SizedBox(height: AppSpacing.md),
        if (stopCount < RoutePlanRules.minStops) ...[
          InlineMessage(
            key: const Key('route_builder_empty_hint'),
            message: l10n.routeEmptyStops,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

/// Durak dizisinin karayolu ön hesabı (bizim OSRM) haritada; metin karşılığı
/// durak kartlarındaki "Sonraki durağa karayolu" satırlarıdır.
class _BuilderMap extends StatelessWidget {
  const _BuilderMap({required this.map});

  final Widget map;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.sm),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          context.l10n.routeBuilderMapHeading,
          role: AppTextRole.titleMedium,
          isHeading: true,
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: map,
        ),
      ],
    ),
  );
}
