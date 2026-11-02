import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';

/// Belirsiz ilerleme göstergesi: hareket azaltma (cihaz veya uygulama içi
/// "Animasyonları durdur") açıkken dönen halka yerine sabit kum saati ikonu
/// gösterir (WCAG 2.3.3). Anlam, çağıran taraftaki `Semantics` etiketindedir.
class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({
    this.size,
    this.strokeWidth = AppSizes.spinnerStroke,
    this.color,
    super.key,
  });

  /// `null` ise ana eksende içeriğe göre boyutlanır (Material varsayılanı).
  final double? size;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) {
      return AppIcon.decorative(
        Icons.hourglass_top_outlined,
        size: size ?? AppSizes.iconMd,
        color: color ?? context.colors.onSurfaceVariant,
      );
    }
    final indicator = CircularProgressIndicator(
      strokeWidth: strokeWidth,
      color: color,
    );
    final dimension = size;
    return dimension == null
        ? indicator
        : SizedBox.square(dimension: dimension, child: indicator);
  }
}
