import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/accessibility/presentation/accessibility_presentation.dart';
import 'package:vakif_atlas/features/settings/domain/entities/accessibility_preferences.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Erişilebilirlik panelinin kutucuğu: ikon, ad ve (çok seviyeli
/// özelliklerde) seviye noktaları. Her dokunuş bir sonraki seviyeye geçer.
///
/// Durum yalnızca renkle verilmez (WCAG 1.4.1): açıkken kalın çerçeve, köşede
/// onay ikonu ve dolu noktalar; ekran okuyucu ad + seviye adı + "Seviye n / m"
/// okur, açma/kapama kutucukları `toggled` bildirir.
class AccessibilityTile extends StatelessWidget {
  const AccessibilityTile({
    required this.feature,
    required this.level,
    required this.onTap,
    this.lockedState,
    super.key,
  });

  final AccessibilityFeature feature;
  final int level;
  final VoidCallback onTap;

  /// Verilirse özellik cihaz ayarıyla zaten açıktır: kutucuk açık ve
  /// devre dışı gösterilir, durum metni bunu açıklar.
  final String? lockedState;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final locked = lockedState != null;
    final active = level > 0 || locked;
    final foreground = active ? colors.onSecondaryContainer : colors.onSurface;
    final state = lockedState ?? feature.levelLabel(l10n, level);
    return Semantics(
      key: Key('a11y_tile_${feature.name}'),
      button: true,
      toggled: feature.isToggle ? active : null,
      label: feature.label(l10n),
      enabled: !locked,
      value: feature.isToggle || !active || locked
          ? state
          : '$state, ${l10n.a11yTileLevel(level, feature.levels)}',
      onTapHint: l10n.a11yTileHint,
      // Alt ağacın semantiği (InkWell) dışlandığından eylem burada verilir;
      // aksi halde ekran okuyucu kutucuğu etkinleştiremez.
      onTap: locked ? null : onTap,
      excludeSemantics: true,
      child: Material(
        color: active ? colors.secondaryContainer : colors.surfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(
            color: active ? colors.accentText : colors.outlineVariant,
            width: active ? AppSizes.borderHeavy : AppSizes.borderThin,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: locked ? null : onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSizes.minTouchTarget * 2,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxs,
                    vertical: AppSpacing.sm,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppIcon.decorative(
                        feature.icon,
                        size: AppSizes.iconLg,
                        color: active ? foreground : colors.accentText,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppText(
                        feature.label(l10n),
                        role: AppTextRole.labelMedium,
                        color: foreground,
                        textAlign: TextAlign.center,
                      ),
                      if (!feature.isToggle) ...[
                        const SizedBox(height: AppSpacing.xs),
                        _LevelDots(
                          levels: feature.levels,
                          level: level,
                          color: active ? foreground : colors.outline,
                        ),
                      ],
                    ],
                  ),
                ),
                if (active)
                  PositionedDirectional(
                    top: AppSpacing.xxs,
                    end: AppSpacing.xxs,
                    child: AppIcon.decorative(
                      Icons.check_circle,
                      size: AppSizes.iconSm,
                      color: foreground,
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

class _LevelDots extends StatelessWidget {
  const _LevelDots({
    required this.levels,
    required this.level,
    required this.color,
  });

  final int levels;
  final int level;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.xxs,
      runSpacing: AppSpacing.xxs,
      children: [
        for (var index = 0; index < levels; index++)
          Container(
            width: AppSpacing.md,
            height: AppSpacing.xxs,
            decoration: BoxDecoration(
              color: index < level ? color : null,
              border: Border.all(color: color, width: AppSizes.borderThin),
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
          ),
      ],
    );
  }
}
