import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/auth/domain/validation/password_policy.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/validation_messages.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Şifre gücü göstergesi.
///
/// Güç yalnızca renkle değil, dolu bölüm sayısı ve metin etiketiyle de
/// gösterilir (WCAG 1.4.1); ekran okuyucu "Şifre gücü: İyi" olarak okur.
class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({required this.strength, super.key});

  final PasswordStrength strength;

  static const int _segments = 4;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final label = l10n.passwordStrengthLabel(strength);
    final filled = strength.index + 1;
    final color = switch (strength) {
      PasswordStrength.weak => colors.error,
      PasswordStrength.fair => colors.warning,
      PasswordStrength.good => colors.info,
      PasswordStrength.strong => colors.success,
    };

    return Semantics(
      label: l10n.passwordStrengthSemantics(label),
      liveRegion: true,
      excludeSemantics: true,
      child: Row(
        children: [
          for (var index = 0; index < _segments; index++) ...[
            if (index > 0) const SizedBox(width: AppSpacing.xxs),
            Expanded(
              child: Container(
                height: AppSpacing.xxs,
                decoration: BoxDecoration(
                  color: index < filled ? color : colors.outlineVariant,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
              ),
            ),
          ],
          const SizedBox(width: AppSpacing.sm),
          AppText(label, role: AppTextRole.labelMedium, color: color),
        ],
      ),
    );
  }
}
