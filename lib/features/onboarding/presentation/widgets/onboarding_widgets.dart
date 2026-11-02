import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/atoms/leading_icon_tile.dart';

/// Tanıtım adımlarının bölümlü ilerleme çubuğu.
///
/// Görseldir; adım bilgisi ekran okuyucuya üst çubuktaki "Adım n / N"
/// metniyle verilir.
class OnboardingProgress extends StatelessWidget {
  const OnboardingProgress({
    required this.current,
    required this.total,
    super.key,
  });

  /// 0 tabanlı geçerli adım.
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.xs,
        ),
        child: Row(
          children: [
            for (var index = 0; index < total; index++) ...[
              if (index > 0) const SizedBox(width: AppSpacing.xxs),
              Expanded(
                child: Container(
                  key: Key('onboarding_progress_$index'),
                  height: AppSizes.stepIndicator,
                  decoration: BoxDecoration(
                    color: index <= current
                        ? colors.primary
                        : colors.outlineVariant,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Adım başlığı: ikon, başlık (ekran okuyucu başlık gezinmesinde) ve
/// açıklama.
class OnboardingStepHeader extends StatelessWidget {
  const OnboardingStepHeader({
    required this.title,
    required this.description,
    this.icon,
    this.leading,
    super.key,
  });

  final IconData? icon;

  /// İkon yerine gösterilecek görsel (ör. amblem).
  final Widget? leading;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final symbol = icon;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null)
            leading!
          else if (symbol != null)
            LeadingIconTile(
              icon: symbol,
              tone: LeadingIconTone.primary,
              size: AppSizes.onboardingIcon,
            ),
          const SizedBox(height: AppSpacing.md),
          AppText(title, role: AppTextRole.headlineLarge, isHeading: true),
          const SizedBox(height: AppSpacing.xs),
          AppText(description, color: colors.onSurfaceVariant),
        ],
      ),
    );
  }
}

/// "Nasıl kullanılır" adımındaki tek özellik satırı; ekran okuyucu başlığı
/// ve açıklamayı tek öğe olarak okur.
class OnboardingFeatureRow extends StatelessWidget {
  const OnboardingFeatureRow({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppIcon.decorative(icon, color: colors.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(title, role: AppTextRole.titleMedium),
                  const SizedBox(height: AppSpacing.xxs),
                  AppText(
                    description,
                    role: AppTextRole.bodyMedium,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Adım içindeki açıklayıcı küçük not.
class OnboardingNote extends StatelessWidget {
  const OnboardingNote(this.text, {this.icon = Icons.info_outlined, super.key});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIcon.decorative(
            icon,
            size: AppSizes.iconInline,
            color: colors.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: AppText(
              text,
              role: AppTextRole.bodyMedium,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
