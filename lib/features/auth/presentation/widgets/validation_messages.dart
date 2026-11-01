import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/features/auth/domain/validation/credentials_validator.dart';
import 'package:vakif_atlas/features/auth/domain/validation/password_policy.dart';

/// Alan doğrulama hatalarının, nasıl düzeltileceğini de söyleyen
/// yerelleştirilmiş mesajları (WCAG 3.3.3).
extension ValidationMessages on AppLocalizations {
  String? emailError(EmailValidationError? error) => switch (error) {
    EmailValidationError.empty => validationEmailEmpty,
    EmailValidationError.invalid => validationEmailInvalid,
    null => null,
  };

  String? loginPasswordError(PasswordValidationError? error) => switch (error) {
    PasswordValidationError.empty => validationPasswordEmpty,
    null => null,
  };

  String? newPasswordError(PasswordPolicyViolation? violation) =>
      switch (violation) {
        PasswordPolicyViolation.empty => validationPasswordEmpty,
        PasswordPolicyViolation.tooShort => validationPasswordTooShort(
          PasswordPolicy.minLength,
        ),
        PasswordPolicyViolation.tooLong => validationPasswordTooLong(
          PasswordPolicy.maxLength,
        ),
        PasswordPolicyViolation.common => validationPasswordCommon,
        PasswordPolicyViolation.personalInfo => validationPasswordPersonalInfo,
        PasswordPolicyViolation.repetitive => validationPasswordRepetitive,
        null => null,
      };

  String? confirmPasswordError(ConfirmPasswordError? error) => switch (error) {
    ConfirmPasswordError.empty => validationConfirmPasswordEmpty,
    ConfirmPasswordError.mismatch => validationPasswordMismatch,
    null => null,
  };

  String? displayNameError(DisplayNameValidationError? error) =>
      switch (error) {
        DisplayNameValidationError.empty => validationNameEmpty,
        DisplayNameValidationError.tooShort => validationNameTooShort(
          CredentialsValidator.minDisplayNameLength,
        ),
        DisplayNameValidationError.tooLong => validationNameTooLong(
          CredentialsValidator.maxDisplayNameLength,
        ),
        DisplayNameValidationError.invalid => validationNameInvalid,
        null => null,
      };

  String? verificationCodeError(VerificationCodeError? error) =>
      switch (error) {
        VerificationCodeError.empty => validationCodeEmpty,
        VerificationCodeError.invalid => validationCodeInvalid(
          CredentialsValidator.verificationCodeLength,
        ),
        null => null,
      };

  String passwordStrengthLabel(PasswordStrength strength) => switch (strength) {
    PasswordStrength.weak => passwordStrengthWeak,
    PasswordStrength.fair => passwordStrengthFair,
    PasswordStrength.good => passwordStrengthGood,
    PasswordStrength.strong => passwordStrengthStrong,
  };
}
