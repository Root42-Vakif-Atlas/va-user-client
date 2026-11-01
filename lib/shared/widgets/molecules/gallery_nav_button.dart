import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';

/// Fotoğraf üzerinde kullanılan önceki/sonraki butonu (48×48 dp).
class GalleryNavButton extends StatelessWidget {
  const GalleryNavButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  static const double backdropOpacity = 0.9;

  final IconData icon;
  final String tooltip;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final background = colors.surface.withValues(alpha: backdropOpacity);
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: background,
        foregroundColor: colors.onSurface,
        minimumSize: const Size.square(AppSizes.minTouchTarget),
        side: BorderSide(color: colors.outline, width: AppSizes.borderThin),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    );
  }
}
