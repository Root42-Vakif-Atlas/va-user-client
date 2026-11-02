import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Durum rozeti (anı moderasyonu, rapor durumu): ikon + metin; renk yalnızca
/// destekleyicidir (WCAG 1.4.1).
///
/// Durum renginin düz tonal zemininde durur, kenar çizgisi taşımaz; ikon
/// durum renginde, metin ön plan renginde kalır (kontrast her temada
/// ≥ 4.5:1). Yüksek kontrastta dört kenardan çerçevelenir.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.icon,
    required this.label,
    required this.color,
    super.key,
  });

  final IconData icon;
  final String label;

  /// Durumun semantik rengi (`colors.success`, `colors.warning` …).
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.tonal(color, over: colors.surfaceVariant, strength: 0.16),
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: colors.isHighContrast
            ? Border.all(color: color, width: AppSizes.borderThin)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon.decorative(icon, size: AppSizes.iconSm, color: color),
            const SizedBox(width: AppSpacing.xxs),
            Flexible(
              child: AppText(
                label,
                role: AppTextRole.labelMedium,
                color: colors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
