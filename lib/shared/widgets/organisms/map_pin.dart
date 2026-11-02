import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_durations.dart';
import 'package:vakif_atlas/core/theme/tokens/app_shadows.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';

/// Pusula/karo (◇) biçimli harita pini (Design System §1.1).
///
/// Marka vurgusu Antik Altın'la (`brandAccent`) çizilir: arayüz kontrolleri
/// yeşil, ilgi noktaları altın olduğundan harita üzerinde ayrışır.
///
/// - Her altlıkta ayırt edilebilir: dolgu + koyu/açık kontur (WCAG 1.4.11).
/// - Seçili durum yalnızca renkle değil boyut, kalın kontur ve ekran okuyucu
///   "seçili" bilgisiyle de belirtilir (WCAG 1.4.1).
/// - Dokunma alanı en az 48×48 dp; klavyeyle odaklanıp Enter ile seçilir.
class MapPin extends StatelessWidget {
  const MapPin({
    required this.semanticsLabel,
    this.icon,
    this.label,
    this.selected = false,
    this.memberOfComplex = false,
    this.onTap,
    this.semanticsOrder,
    super.key,
  }) : assert(
         (icon == null) != (label == null),
         'Pin ya ikon ya da kısa etiket (ör. durak sırası) gösterir.',
       );

  final IconData? icon;

  /// İkon yerine gösterilen kısa metin (ör. rota durak sırası "3").
  final String? label;
  final String semanticsLabel;
  final bool selected;

  /// Bir külliyenin yapısı: kontur külliye rengindedir (`complexAccent`),
  /// yerleşim alanının içinde külliyeye ait olduğu görülür. Üyelik ekran
  /// okuyucu etiketinde de söylenir.
  final bool memberOfComplex;
  final VoidCallback? onTap;

  /// Ekran okuyucunun pinleri ekrandaki konumdan bağımsız, öngörülebilir
  /// sırada (ör. liste sırası) okuması için.
  final double? semanticsOrder;

  /// `Marker` kutusunun kenarı.
  static double extent({required bool selected}) =>
      selected ? AppSizes.mapPinSelectedExtent : AppSizes.minTouchTarget;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final side = selected ? AppSizes.mapPinSelectedSide : AppSizes.mapPinSide;
    final dimension = extent(selected: selected);

    final diamond = Transform.rotate(
      angle: math.pi / 4,
      child: AnimatedContainer(
        duration: context.motionDuration(AppDurations.fast),
        width: side,
        height: side,
        decoration: BoxDecoration(
          color: selected ? colors.onSurface : colors.brandAccent,
          border: Border.all(
            color: selected
                ? colors.brandAccent
                : memberOfComplex
                ? colors.complexAccent
                : colors.onBrandAccent,
            width: selected || memberOfComplex
                ? AppSizes.borderHeavy
                : AppSizes.borderThick,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xs),
          boxShadow: AppShadows.marker(colors),
        ),
      ),
    );

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
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: SizedBox.square(
            dimension: dimension,
            child: Stack(
              alignment: Alignment.center,
              children: [
                diamond,
                if (label case final text?)
                  Text(
                    text,
                    // Pin içi sıra numarası sabit boyutludur; ekran okuyucu
                    // ve adım listesi tam bilgiyi sunar.
                    textScaler: TextScaler.noScaling,
                    style: context.textStyles.labelLarge.copyWith(
                      color: selected ? colors.surface : colors.onBrandAccent,
                    ),
                  )
                else
                  Icon(
                    icon,
                    size: selected ? AppSizes.iconMd : AppSizes.iconInline,
                    color: selected ? colors.surface : colors.onBrandAccent,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
