import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_shadows.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';

/// Harita üzerinde yüzen kontrollerin ortak zemini (arama çubuğu, katman,
/// yakınlaştırma, konum).
///
/// Her altlıkta ayrışması için gölge, koyu ve yüksek kontrast temalarda da
/// ≥ 3:1 kontur taşır (WCAG 1.4.11). Mürekkep (ink) efekti şekle kırpılır.
class MapControlSurface extends StatelessWidget {
  const MapControlSurface({
    required this.child,
    this.color,
    this.circle = false,
    super.key,
  });

  final Widget child;

  /// `null` → tema `surfaceElevated`.
  final Color? color;

  /// `true` → daire (birincil eylem), aksi halde yuvarlatılmış kare.
  final bool circle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final showBorder =
        colors.isHighContrast || colors.brightness == Brightness.dark;
    final side = showBorder
        ? BorderSide(
            color: colors.outline,
            width: colors.isHighContrast
                ? AppSizes.borderThick
                : AppSizes.borderThin,
          )
        : BorderSide.none;
    final ShapeBorder shape = circle
        ? CircleBorder(side: side)
        : RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: side,
          );
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color ?? colors.surfaceElevated,
        shadows: AppShadows.cardShadow,
        shape: shape,
      ),
      child: Material(
        type: MaterialType.transparency,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}

/// Harita üzerindeki tek dokunuşlu kontrol (56×56 dp).
///
/// [tooltip] aynı zamanda ekran okuyucu etiketidir. [toggled] verildiğinde
/// buton aç/kapa durumunu ekran okuyucuya bildirir (ör. konum takibi).
class MapControlButton extends StatelessWidget {
  const MapControlButton({
    required this.tooltip,
    required this.onPressed,
    this.icon,
    this.child,
    this.primary = false,
    this.circle = false,
    this.toggled,
    super.key,
  }) : assert(
         (icon == null) != (child == null),
         'Buton ya ikon ya da özel içerik gösterir.',
       );

  final String tooltip;
  final VoidCallback? onPressed;
  final IconData? icon;

  /// İkon yerine gösterilen içerik (ör. yükleme göstergesi).
  final Widget? child;

  /// `true` → birincil renk dolgu (ana eylem).
  final bool primary;
  final bool circle;
  final bool? toggled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = primary ? colors.onPrimary : colors.onSurface;
    // Tek düğüm: etiket (tooltip), buton ve aç/kapa durumu birlikte okunur.
    return MergeSemantics(
      child: MapControlSurface(
        color: primary ? colors.primary : null,
        circle: circle,
        child: Semantics(
          toggled: toggled,
          child: IconButton(
            tooltip: tooltip,
            onPressed: onPressed,
            color: foreground,
            icon: child ?? Icon(icon, color: foreground),
            style: IconButton.styleFrom(
              minimumSize: const Size.square(AppSizes.mapControl),
              shape: circle
                  ? const CircleBorder()
                  : RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
