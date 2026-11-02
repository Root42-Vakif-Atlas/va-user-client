import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/atoms/leading_icon_tile.dart';

/// "Bir sorun mu gördünüz?": eser seçili Sivil Koruma bildirimine geçiş.
///
/// Sayfa Sivil Koruma'ya bağımlı olmasın diye yalnızca geri çağrı alır;
/// yönlendirme kompozisyon kökünde yapılır.
class MonumentReportDamageSection extends StatelessWidget {
  const MonumentReportDamageSection({required this.onReport, super.key});

  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Column(
      key: const Key('monument_report_damage_section'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MergeSemantics(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LeadingIconTile(
                icon: Icons.shield_outlined,
                tone: LeadingIconTone.danger,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      l10n.monumentReportTitle,
                      role: AppTextRole.titleMedium,
                      isHeading: true,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    AppText(
                      l10n.monumentReportBody,
                      role: AppTextRole.bodyMedium,
                      color: colors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: AppButton.secondary(
            key: const Key('monument_report_damage_button'),
            label: l10n.cpNewReport,
            icon: Icons.add_alert_outlined,
            onPressed: onReport,
          ),
        ),
      ],
    );
  }
}
