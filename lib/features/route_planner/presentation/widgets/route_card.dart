import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/l10n/measure_format.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/features/route_planner/presentation/route_presentation.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/info_chip.dart';

/// "Rotalarım" listesindeki rota kartı.
///
/// Ekran okuyucu kartı tek bir buton olarak, tüm özetiyle okur.
class RouteCard extends StatelessWidget {
  const RouteCard({required this.route, required this.onTap, super.key});

  final RouteOverview route;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final summary = route.summary;
    final stops = l10n.routeStopCount(route.stopCount);
    final distance = l10n.distance(summary.distanceMeters);
    final created = l10n.routeCreatedOn(
      DateFormat.yMMMMd(l10n.localeName).format(route.createdAt.toLocal()),
    );
    final radius = BorderRadius.circular(AppRadius.md);

    return Semantics(
      button: true,
      label: l10n.routeCardSemantics(
        route.name,
        stops,
        route.cities.join(', '),
        distance,
        l10n.durationLong(summary.total),
        created,
      ),
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: colors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: colors.outlineVariant,
            width: AppSizes.borderThin,
          ),
        ),
        child: InkWell(
          key: Key('route_card_${route.id}'),
          borderRadius: radius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppIcon.decorative(Icons.route, color: colors.accentText),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppText(route.name, role: AppTextRole.titleLarge),
                    ),
                    AppIcon.decorative(
                      Icons.chevron_right,
                      color: colors.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText(
                  routeCityChain(l10n, route.cities),
                  role: AppTextRole.bodyMedium,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    InfoChip(
                      icon: Icons.place_outlined,
                      label: stops,
                      semanticsLabel: stops,
                    ),
                    InfoChip(
                      icon: Icons.straighten,
                      label: distance,
                      semanticsLabel: l10n.routeTotalDistanceSemantics(
                        distance,
                      ),
                    ),
                    InfoChip(
                      icon: Icons.schedule,
                      label: l10n.durationShort(summary.total),
                      semanticsLabel: l10n.routeTotalDurationSemantics(
                        l10n.durationLong(summary.total),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppText(created, role: AppTextRole.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Listede, kaydedilmemiş taslak rota hatırlatması.
class RouteDraftBanner extends StatelessWidget {
  const RouteDraftBanner({
    required this.stopCount,
    required this.onContinue,
    super.key,
  });

  final int stopCount;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final message = l10n.routeDraftBanner(stopCount);
    final radius = BorderRadius.circular(AppRadius.md);
    // Şeridin tamamı tek dokunma hedefidir: %200 metinde ayrı bir buton
    // metni daraltmaz.
    return Semantics(
      button: true,
      label: '$message. ${l10n.routeDraftContinue}',
      excludeSemantics: true,
      onTap: onContinue,
      child: Material(
        color: colors.surfaceElevated,
        borderRadius: radius,
        child: InkWell(
          key: const Key('route_draft_continue_button'),
          borderRadius: radius,
          onTap: onContinue,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                AppIcon.decorative(
                  Icons.edit_note_outlined,
                  color: colors.accentText,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(message),
                      AppText(
                        l10n.routeDraftContinue,
                        role: AppTextRole.labelLarge,
                        color: colors.accentText,
                      ),
                    ],
                  ),
                ),
                AppIcon.decorative(
                  Icons.chevron_right,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
