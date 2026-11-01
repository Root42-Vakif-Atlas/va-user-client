import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/molecules/map_control_surface.dart';

/// Haritanın tek dokunuşlu kontrolleri: yakınlaştır, uzaklaştır, tümünü göster.
///
/// İki parmakla yakınlaştırma ve sürükleme hareketlerine alternatif sunar
/// (WCAG 2.5.1 İşaretçi Hareketleri, 2.5.7 Sürükleme Hareketleri). Butonlar
/// 56×56 dp'dir ve tek bir yüzen kartta gruplanır.
class A11yMapControls extends StatelessWidget {
  const A11yMapControls({
    required this.onZoomIn,
    required this.onZoomOut,
    this.onShowAll,
    super.key,
  });

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  /// `null` → "tümünü göster" butonu gösterilmez.
  final VoidCallback? onShowAll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final divider = Divider(
      height: AppSizes.borderThin,
      thickness: AppSizes.borderThin,
      color: context.colors.outlineVariant,
    );
    final showAll = onShowAll;
    return Semantics(
      container: true,
      label: l10n.mapControlsSemantics,
      explicitChildNodes: true,
      child: SizedBox(
        width: AppSizes.mapControl,
        child: MapControlSurface(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _GroupedButton(
                key: const Key('map_zoom_in_button'),
                icon: Icons.add,
                label: l10n.mapZoomIn,
                onPressed: onZoomIn,
              ),
              divider,
              _GroupedButton(
                key: const Key('map_zoom_out_button'),
                icon: Icons.remove,
                label: l10n.mapZoomOut,
                onPressed: onZoomOut,
              ),
              if (showAll != null) ...[
                divider,
                _GroupedButton(
                  key: const Key('map_show_all_button'),
                  icon: Icons.zoom_out_map,
                  label: l10n.mapShowAll,
                  onPressed: showAll,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupedButton extends StatelessWidget {
  const _GroupedButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: label,
      onPressed: onPressed,
      color: context.colors.onSurface,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        minimumSize: const Size.square(AppSizes.mapControl),
        shape: const RoundedRectangleBorder(),
      ),
    );
  }
}
