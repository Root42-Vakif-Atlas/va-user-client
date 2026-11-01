import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/memory_presentation.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Anının moderasyon durumu ("İncelemede" / "Yayınlanmadı"): ikon + metin,
/// renk yalnızca destekleyicidir (WCAG 1.4.1); `ReportStatusBadge` ile aynı
/// görünüm. Metin nötr yüzeyde ön plan renginde kalır.
class MemoryStatusBadge extends StatelessWidget {
  const MemoryStatusBadge({required this.status, super.key});

  final MemoryModerationStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border(
          left: BorderSide(color: status.color(colors), width: AppSpacing.xxs),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon.decorative(
              status.icon,
              size: AppSizes.iconSm,
              color: status.color(colors),
            ),
            const SizedBox(width: AppSpacing.xxs),
            Flexible(
              child: AppText(
                status.label(context.l10n),
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
