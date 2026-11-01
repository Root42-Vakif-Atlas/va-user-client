import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/tokens/app_durations.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/presentation/bloc/monument_search_bloc.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/features/catalog/presentation/widgets/monument_search_view.dart';

/// Bildirim için tek eser seçimi: haritadaki aramanın aynısı (sunucu tarafı
/// arama, filtreler, sayfalı liste). Seçilen eserle kapanır.
/// [MonumentSearchBloc] çağıran taraftan verilir.
class ReportMonumentPickerPage extends StatelessWidget {
  const ReportMonumentPickerPage({super.key});

  /// Hareket azaltmaya duyarlı, alttan açılan tam ekran rota.
  static Route<MonumentPin> route(
    BuildContext context, {
    required MonumentSearchBloc search,
  }) {
    final duration = context.motionDuration(AppDurations.medium);
    return PageRouteBuilder<MonumentPin>(
      fullscreenDialog: true,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) =>
          BlocProvider.value(
            value: search,
            child: const ReportMonumentPickerPage(),
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
    final l10n = context.l10n;
    return MonumentSearchView(
      hintText: l10n.cpMonumentPickerHint,
      autofocus: false,
      itemBuilder: (context, monument) {
        return ListTile(
          key: Key('report_pick_${monument.id}'),
          leading: MonumentSearchLeadingIcon(icon: monument.category.icon),
          title: Text(monument.name),
          subtitle: Text(monument.listSubtitle(l10n)),
          onTap: () =>
              Navigator.of(context).pop(MonumentPin.fromSummary(monument)),
        );
      },
    );
  }
}
