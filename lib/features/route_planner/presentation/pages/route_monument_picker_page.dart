import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_durations.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/features/catalog/presentation/bloc/monument_search_bloc.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/features/catalog/presentation/widgets/monument_search_view.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/features/route_planner/presentation/bloc/route_builder_bloc.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Rotaya eser seçimi: haritadaki aramanın aynısı (sunucu tarafı arama,
/// filtre çipleri, kaydırdıkça yüklenen sayfalı liste); satırlar onay
/// kutuludur ve seçim anında taslağa yansır.
///
/// Binlerce eserlik katalog indirilmez; yalnızca görüntülenen sayfalar
/// istenir. Durak sınırına ulaşınca seçilmemiş satırlar devre dışı kalır
/// ve nedeni alt çubukta yazılır. `RouteBuilderBloc` ve
/// `MonumentSearchBloc` üst ağaçtan sağlanır; arama bloğu oluşturucu
/// boyunca yaşadığından seçici yeniden açıldığında son arama korunur.
class RouteMonumentPickerPage extends StatelessWidget {
  const RouteMonumentPickerPage({required this.onToggled, super.key});

  /// Seçim değişti; duyuru ve titreşim çağıran tarafta yapılır.
  final ValueChanged<MonumentPin> onToggled;

  /// Hareket azaltmaya duyarlı, alttan açılan tam ekran rota.
  static Route<void> route(
    BuildContext context, {
    required RouteBuilderBloc builder,
    required MonumentSearchBloc search,
    required ValueChanged<MonumentPin> onToggled,
  }) {
    final duration = context.motionDuration(AppDurations.medium);
    return PageRouteBuilder<void>(
      fullscreenDialog: true,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) =>
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: builder),
              BlocProvider.value(value: search),
            ],
            child: RouteMonumentPickerPage(onToggled: onToggled),
          ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeOutCubic)),
            ),
            child: child,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MonumentSearchView(
      hintText: context.l10n.routePickerSearchHint,
      // Liste ve filtreler önce görünür; klavye alana dokununca açılır.
      autofocus: false,
      itemBuilder: (context, monument) =>
          _PickTile(monument: monument, onToggled: onToggled),
      bottomBar: const _PickerBar(),
    );
  }
}

class _PickTile extends StatelessWidget {
  const _PickTile({required this.monument, required this.onToggled});

  final MonumentSummary monument;
  final ValueChanged<MonumentPin> onToggled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (position, isFull) = context.select<RouteBuilderBloc, (int, bool)>((
      bloc,
    ) {
      final stops = bloc.state.stops;
      return (
        stops.indexWhere((stop) => stop.monumentId == monument.id),
        bloc.state.isFull,
      );
    });
    final selected = position >= 0;
    // Konumu girilmemiş eser (VGM verisi) rotaya eklenemez; satır nedenini söyler.
    final located = monument.location?.isValid ?? false;
    final details = located
        ? monument.listSubtitle(l10n)
        : l10n.routePickerNoLocation(monument.listSubtitle(l10n));
    return CheckboxListTile(
      key: Key('route_pick_${monument.id}'),
      value: selected,
      onChanged: selected || (!isFull && located)
          ? (_) => onToggled(MonumentPin.fromSummary(monument))
          : null,
      secondary: MonumentSearchLeadingIcon(icon: monument.category.icon),
      title: Text(monument.name),
      subtitle: Text(
        selected
            ? l10n.routePickerStopSubtitle(details, position + 1)
            : details,
      ),
    );
  }
}

/// Seçilen durak sayısı, sınır bilgisi ve "Tamam".
class _PickerBar extends StatelessWidget {
  const _PickerBar();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final (count, isFull) = context.select<RouteBuilderBloc, (int, bool)>(
      (bloc) => (bloc.state.stops.length, bloc.state.isFull),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Align(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.maxContentWidth,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppText(
                    l10n.routeStopsHeading(count, RoutePlanRules.maxStops),
                    key: const Key('route_picker_count'),
                    role: AppTextRole.titleMedium,
                  ),
                  if (isFull)
                    AppText(
                      l10n.routeLimitReached(RoutePlanRules.maxStops),
                      key: const Key('route_picker_full_hint'),
                      role: AppTextRole.bodyMedium,
                      color: colors.onSurfaceVariant,
                    ),
                  const SizedBox(height: AppSpacing.xs),
                  AppButton.primary(
                    key: const Key('route_picker_done_button'),
                    label: l10n.routePickerDone,
                    expand: true,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
