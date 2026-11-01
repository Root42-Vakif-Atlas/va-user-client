import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_shadows.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';

/// Harita kümesi: içerdiği eser sayısını gösteren, dokununca yakınlaşan
/// (veya listeyi açan) işaretçi.
///
/// Pinlerle aynı marka vurgusunu (Antik Altın) taşır; boyutu sayıyla büyür.
/// Sayı kısaltılır ("1,2 B"); tam sayı ve eylem ekran okuyucu etiketindedir.
/// Dokunma alanı en az 48×48 dp.
class MapClusterMarker extends StatelessWidget {
  const MapClusterMarker({
    required this.count,
    required this.semanticsLabel,
    required this.onTap,
    this.semanticsOrder,
    super.key,
  });

  final int count;
  final String semanticsLabel;
  final VoidCallback onTap;
  final double? semanticsOrder;

  /// `Marker` kutusunun kenarı.
  static double extent(int count) => switch (count) {
    < 10 => AppSizes.mapClusterSmall,
    < 100 => AppSizes.mapClusterMedium,
    _ => AppSizes.mapClusterLarge,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final side = extent(count) - AppSpacing.xs;
    final label = NumberFormat.compact(
      locale: Localizations.localeOf(context).toLanguageTag(),
    ).format(count);
    final order = semanticsOrder;
    return Semantics(
      container: true,
      button: true,
      sortKey: order == null ? null : OrdinalSortKey(order),
      label: semanticsLabel,
      onTap: onTap,
      excludeSemantics: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Center(
            child: Container(
              width: side,
              height: side,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.brandAccent,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: colors.onBrandAccent,
                  width: AppSizes.borderThick,
                ),
                boxShadow: AppShadows.cardShadow,
              ),
              child: Text(
                label,
                // Küme içi sayı sabit boyutludur; tam bilgi etikettedir.
                textScaler: TextScaler.noScaling,
                style: context.textStyles.labelLarge.copyWith(
                  color: colors.onBrandAccent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
