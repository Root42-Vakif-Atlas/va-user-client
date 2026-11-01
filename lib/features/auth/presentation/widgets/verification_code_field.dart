import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/features/auth/domain/validation/credentials_validator.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/validation_messages.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_text_field.dart';

/// Tek kullanımlık kod alanı.
///
/// Ekran okuyucu ve klavye kullanıcıları için altı ayrı kutu yerine tek bir
/// alan kullanılır; `oneTimeCode` ipucu ile işletim sistemi kodu
/// e-posta/SMS'ten otomatik önerebilir.
class VerificationCodeField extends StatelessWidget {
  const VerificationCodeField({
    required this.onChanged,
    required this.enabled,
    this.error,
    this.focusNode,
    this.onSubmitted,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final bool enabled;
  final VerificationCodeError? error;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppTextField(
      key: const Key('verification_code_field'),
      focusNode: focusNode,
      label: l10n.verificationCodeLabel,
      hint: l10n.verificationCodeHint,
      errorText: l10n.verificationCodeError(error),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.oneTimeCode],
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(
          CredentialsValidator.verificationCodeLength,
        ),
      ],
      enabled: enabled,
      onChanged: onChanged,
      onSubmitted: (_) => onSubmitted?.call(),
    );
  }
}
