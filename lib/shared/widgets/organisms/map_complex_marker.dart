import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_durations.dart';
import 'package:vakif_atlas/core/theme/tokens/app_shadows.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';

/// Külliye işaretçisi: İznik mavisi (`complexAccent`) daire, külliye ikonu
/// ve üye yapı sayısı rozeti.
///
/// Eser pininden (altın ◇) ve kümeden (altın kare) yalnızca renkle değil
/// şekil (daire), ikon ve rozetle de ayrışır (WCAG 1.4.1); tam bilgi ekran
/// okuyucu etiketindedir. Dokunma alanı en az 48×48 dp.
class MapComplexMarker extends StatelessWidget {
  const MapComplexMarker({
    required this.memberCount,
    required this.semanticsLabel,
    required this.onTap,
    this.selected = false,
    this.semanticsOrder,
    super.key,
  });

  final int memberCount;
  final String semanticsLabel;
  final VoidCallback onTap;
  final bool selected;
  final double? semanticsOrder;

  /// `Marker` kutusunun kenarı (rozet dahil).
  static double extent({required bool selected}) =>
      selected ? AppSizes.mapComplexSelectedExtent : AppSizes.mapComplexExtent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final side = selected
        ? AppSizes.mapComplexSelectedSide
        : AppSizes.mapComplexSide;
    final fill = selected ? colors.onSurface : colors.complexAccent;
    final onFill = selected ? colors.surface : colors.onComplexAccent;
    final count = NumberFormat.compact(
      locale: Localizations.localeOf(context).toLanguageTag(),
    ).format(memberCount);
    final order = semanticsOrder;
    return Semantics(
      container: true,
      button: true,
      selected: selected,
      sortKey: order == null ? null : OrdinalSortKey(order),
      label: semanticsLabel,
      onTap: onTap,
      excludeSemantics: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox.square(
            dimension: extent(selected: selected),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: context.motionDuration(AppDurations.fast),
                  width: side,
                  height: side,
                  decoration: BoxDecoration(
                    color: fill,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? colors.complexAccent
                          : colors.onComplexAccent,
                      width: selected
                          ? AppSizes.borderHeavy
                          : AppSizes.borderThick,
                    ),
                    boxShadow: AppShadows.cardShadow,
                  ),
                  child: Icon(
                    Icons.account_balance_outlined,
                    size: selected ? AppSizes.iconMd : AppSizes.iconInline,
                    color: onFill,
                  ),
                ),
                if (memberCount > 0)
                  PositionedDirectional(
                    top: 0,
                    end: 0,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: AppSizes.badgeMinSize,
                        minHeight: AppSizes.badgeMinSize,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxs,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                        border: Border.all(
                          color: colors.complexAccent,
                          width: AppSizes.borderThick,
                        ),
                      ),
                      child: Text(
                        count,
                        // Rozet sayısı sabit boyutludur; tam bilgi
                        // etikettedir.
                        textScaler: TextScaler.noScaling,
                        style: context.textStyles.labelSmall.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
