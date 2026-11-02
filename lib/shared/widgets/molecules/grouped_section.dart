import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';

/// Ayarlar ve profil gibi satır listelerinin tek yüzeyi: satırlar tek bir
/// yükseltilmiş yüzeyde, aralarında hizalı ince ayırıcıyla durur (her satır
/// ayrı kart olmaz).
///
/// Satırlar genellikle `ListTile`dır; yüzey bir `Material` olduğundan
/// dokunma efekti köşelerde kırpılır. Satırlar arasındaki ayırıcı ikon
/// sütununun sonundan başlar ([dividerIndent]).
class GroupedSection extends StatelessWidget {
  const GroupedSection({
    required this.children,
    this.dividerIndent = AppSizes.minTouchTarget + AppSpacing.md * 2,
    super.key,
  });

  final List<Widget> children;
  final double dividerIndent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surfaceElevated,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: colors.isHighContrast ? colors.outline : colors.outlineVariant,
          width: AppSizes.borderThin,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Divider(
                height: AppSizes.borderThin,
                thickness: AppSizes.borderThin,
                indent: dividerIndent,
                color: colors.outlineVariant,
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}
