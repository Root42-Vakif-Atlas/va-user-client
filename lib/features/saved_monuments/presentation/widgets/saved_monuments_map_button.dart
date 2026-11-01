import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/molecules/map_control_surface.dart';

/// Harita üst çubuğunda arama çubuğunun sağındaki "Kaydedilenler" butonu.
/// Kayıt sayısı rozet ve semantik etiketle verilir (renk tek başına değil).
class SavedMonumentsMapButton extends StatelessWidget {
  const SavedMonumentsMapButton({
    required this.count,
    required this.onPressed,
    super.key,
  });

  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final label = l10n.savedMonumentsButton(count);
    return MapControlSurface(
      child: Semantics(
        button: true,
        label: label,
        onTap: onPressed,
        excludeSemantics: true,
        child: SizedBox.square(
          dimension: AppSizes.mapSearchBar,
          child: IconButton(
            key: const Key('map_saved_button'),
            tooltip: label,
            onPressed: onPressed,
            color: colors.onSurface,
            icon: Badge(
              isLabelVisible: count > 0,
              backgroundColor: colors.primary,
              textColor: colors.onPrimary,
              label: Text('$count', textScaler: TextScaler.noScaling),
              child: Icon(count > 0 ? Icons.bookmark : Icons.bookmark_border),
            ),
          ),
        ),
      ),
    );
  }
}
