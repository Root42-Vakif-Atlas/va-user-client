import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';

/// Eser bağlamında kaydet / kaydedilenlerden çıkar (yer işareti).
///
/// Durum ikon (dolu / boş) + ipucu + semantik "seçili" değeriyle verilir
/// (WCAG 1.4.1, 4.1.2); etiket eser adını içerir. Kaydetme mantığı
/// kompozisyon kökündedir; düğme yalnızca değer ve geri çağrı taşır.
class MonumentSaveButton extends StatelessWidget {
  const MonumentSaveButton({
    required this.isSaved,
    required this.monumentName,
    required this.onPressed,
    super.key,
  });

  final bool isSaved;
  final String monumentName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      button: true,
      toggled: isSaved,
      label: isSaved
          ? l10n.monumentUnsaveSemantics(monumentName)
          : l10n.monumentSaveSemantics(monumentName),
      onTap: onPressed,
      excludeSemantics: true,
      child: IconButton(
        key: const Key('monument_save_button'),
        tooltip: isSaved ? l10n.monumentUnsave : l10n.monumentSave,
        isSelected: isSaved,
        constraints: const BoxConstraints(
          minWidth: AppSizes.minTouchTarget,
          minHeight: AppSizes.minTouchTarget,
        ),
        onPressed: onPressed,
        icon: const Icon(Icons.bookmark_border),
        selectedIcon: const Icon(Icons.bookmark),
      ),
    );
  }
}
