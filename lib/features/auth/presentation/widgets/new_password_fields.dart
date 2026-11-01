import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/auth/domain/validation/credentials_validator.dart';
import 'package:vakif_atlas/features/auth/domain/validation/password_policy.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/password_strength_indicator.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/validation_messages.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_text_field.dart';

/// Yeni şifre + tekrarı + güç göstergesi (kayıt, sıfırlama, değiştirme).
///
/// `newPassword` otomatik doldurma ipucu sayesinde iOS/Android şifre
/// yöneticileri güçlü şifre önerebilir.
class NewPasswordFields extends StatelessWidget {
  const NewPasswordFields({
    required this.password,
    required this.strength,
    required this.passwordLabel,
    required this.confirmLabel,
    required this.onPasswordChanged,
    required this.onConfirmationChanged,
    required this.enabled,
    this.passwordError,
    this.confirmationError,
    this.passwordFocus,
    this.confirmationFocus,
    this.onSubmitted,
    this.keyPrefix = 'new_password',
    super.key,
  });

  final String password;
  final PasswordStrength strength;
  final String passwordLabel;
  final String confirmLabel;
  final PasswordPolicyViolation? passwordError;
  final ConfirmPasswordError? confirmationError;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmationChanged;
  final bool enabled;
  final FocusNode? passwordFocus;
  final FocusNode? confirmationFocus;
  final VoidCallback? onSubmitted;
  final String keyPrefix;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          key: Key('${keyPrefix}_field'),
          focusNode: passwordFocus,
          label: passwordLabel,
          helperText: l10n.passwordRequirementsHint(PasswordPolicy.minLength),
          errorText: l10n.newPasswordError(passwordError),
          isPassword: true,
          enabled: enabled,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          onChanged: onPasswordChanged,
          onSubmitted: (_) => confirmationFocus?.requestFocus(),
        ),
        if (password.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          PasswordStrengthIndicator(strength: strength),
        ],
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          key: Key('${keyPrefix}_confirm_field'),
          focusNode: confirmationFocus,
          label: confirmLabel,
          errorText: l10n.confirmPasswordError(confirmationError),
          isPassword: true,
          enabled: enabled,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
          onChanged: onConfirmationChanged,
          onSubmitted: (_) => onSubmitted?.call(),
        ),
      ],
    );
  }
}
