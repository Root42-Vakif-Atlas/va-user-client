import 'dart:ui' show Brightness;

import 'package:flutter/painting.dart';
import 'package:vakif_atlas/core/theme/extensions/app_color_scheme.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';

/// Gölge ve kenarlık token'ları (Design System §2.5).
abstract final class AppShadows {
  /// Koyu temalarda bulanık gölge yerine ince kenarlık tercih edilir.
  ///
  /// [color] tema renginden (`AppColorScheme.outlineVariant`) verilir.
  static BoxDecoration cardBorder({required Color color}) => BoxDecoration(
    border: Border.all(color: color, width: AppSizes.borderThin),
    borderRadius: BorderRadius.circular(AppRadius.sm),
  );

  /// Harita işaretçisinin gölgesi.
  ///
  /// Açık temada yumuşak gölge; koyu temada gölge görünmez olduğundan
  /// işaretçiyi koyu altlıktan ayıran ince, açık bir hale (WCAG 1.4.11).
  /// Yüksek kontrastta hale kalın ve tam kontrasttadır.
  static List<BoxShadow> marker(AppColorScheme colors) {
    if (colors.brightness == Brightness.light && !colors.isHighContrast) {
      return cardShadow;
    }
    return [
      BoxShadow(
        color: colors.onSurface,
        spreadRadius: colors.isHighContrast
            ? AppSizes.borderThick
            : AppSizes.borderThin,
      ),
    ];
  }

  /// Açık temalar için gerçek gölge.
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 2),
  ];
}
