import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/features/route_planner/presentation/cubit/route_list_cubit.dart';
import 'package:vakif_atlas/features/route_planner/presentation/widgets/route_card.dart';
import 'package:vakif_atlas/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

/// "Rotalarım" (`/route-planner`): bu cihazda oluşturulan rotalar.
///
/// Rota oluşturulduğunda, düzenlendiğinde veya silindiğinde liste kendini
/// yeniler. Yarım kalan taslak üstte bir şeritle hatırlatılır.
class RouteListPage extends StatefulWidget {
  const RouteListPage({
    required this.onOpenRoute,
    required this.onOpenDraft,
    this.draftStopCount = 0,
    this.actions = const [],
    super.key,
  });

  final ValueChanged<String> onOpenRoute;

  /// Yeni rota oluşturucu (taslak varsa kaldığı yerden).
  final VoidCallback onOpenDraft;
  final int draftStopCount;
  final List<Widget> actions;

  @override
  State<RouteListPage> createState() => _RouteListPageState();
}

class _RouteListPageState extends State<RouteListPage> {
  String? _languageCode;

  RouteListCubit get _cubit => context.read<RouteListCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode != _languageCode) {
      _languageCode = languageCode;
      unawaited(_cubit.load(languageCode));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.routeListTitle), actions: widget.actions),
      floatingActionButton: FloatingActionButton.extended(
        // Sekmeler aynı kabuk rotasında yaşadığından varsayılan hero
        // etiketi çakışır; FAB'lar arası paylaşılan öğe geçişi yoktur.
        heroTag: null,
        key: const Key('route_new_button'),
        onPressed: widget.onOpenDraft,
        icon: const Icon(Icons.add_road),
        label: Text(l10n.routeNewButton),
      ),
      body: BlocConsumer<RouteListCubit, RouteListState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == RouteListStatus.failure,
        listener: (context, state) => unawaited(
          context.read<A11yAnnouncer>().announce(
            state.failure!.toUserMessage(context.l10n),
            assertive: true,
          ),
        ),
        builder: (context, state) => Column(
          children: [
            if (widget.draftStopCount > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  0,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSizes.maxContentWidth,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: RouteDraftBanner(
                      stopCount: widget.draftStopCount,
                      onContinue: widget.onOpenDraft,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: _RouteListBody(
                state: state,
                onOpenRoute: widget.onOpenRoute,
                onOpenDraft: widget.onOpenDraft,
                onRefresh: _cubit.refresh,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteListBody extends StatelessWidget {
  const _RouteListBody({
    required this.state,
    required this.onOpenRoute,
    required this.onOpenDraft,
    required this.onRefresh,
  });

  final RouteListState state;
  final ValueChanged<String> onOpenRoute;
  final VoidCallback onOpenDraft;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final routes = state.routes;
    if (routes.isEmpty) {
      return switch (state.status) {
        RouteListStatus.initial || RouteListStatus.loading => LoadingStatusView(
          key: const Key('route_list_loading'),
          label: l10n.routeListLoading,
        ),
        RouteListStatus.failure => StatusMessageView(
          key: const Key('route_list_error'),
          tone: StatusMessageTone.error,
          icon: Icons.cloud_off_outlined,
          title: l10n.routeListErrorTitle,
          message: state.failure!.toUserMessage(l10n),
          actionLabel: l10n.commonRetry,
          onAction: () => unawaited(onRefresh()),
        ),
        RouteListStatus.success => StatusMessageView(
          key: const Key('route_list_empty'),
          icon: Icons.route_outlined,
          title: l10n.routeListEmptyTitle,
          message: l10n.routeListEmptyBody,
          actionLabel: l10n.routeNewButton,
          onAction: onOpenDraft,
        ),
      };
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: _RouteCards(routes: routes, onOpenRoute: onOpenRoute),
    );
  }
}

class _RouteCards extends StatelessWidget {
  const _RouteCards({required this.routes, required this.onOpenRoute});

  final List<RouteOverview> routes;
  final ValueChanged<String> onOpenRoute;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: const Key('route_list'),
      physics: const AlwaysScrollableScrollPhysics(),
      // Alt boşluk: genişletilmiş FAB son kartın üstünü örtmesin.
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.x4l + AppSpacing.md,
      ),
      itemCount: routes.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final route = routes[index];
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: RouteCard(route: route, onTap: () => onOpenRoute(route.id)),
          ),
        );
      },
    );
  }
}
