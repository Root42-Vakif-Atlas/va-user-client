part of 'login_bloc.dart';

enum LoginStatus {
  editing,
  invalid,
  submitting,
  success,
  failure,

  /// Şifre doğru ancak e-posta doğrulanmamış; doğrulama ekranına geçilir.
  verificationRequired,
}

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default('') String email,
    @Default('') String password,

    /// İlk gönderim denemesinden sonra alan hataları gösterilir.
    @Default(false) bool showValidationErrors,
    @Default(LoginStatus.editing) LoginStatus status,

    /// Geçersiz her gönderimde artar; aynı hatanın tekrar duyurulmasını sağlar.
    @Default(0) int invalidSubmissions,
    Failure? failure,
    UserEntity? user,
  }) = _LoginState;

  const LoginState._();

  EmailValidationError? get emailError =>
      CredentialsValidator.validateEmail(email);

  PasswordValidationError? get passwordError =>
      CredentialsValidator.validateLoginPassword(password);

  bool get isValid => emailError == null && passwordError == null;

  bool get isSubmitting => status == LoginStatus.submitting;

  /// E-posta ve şifre loglara/raporlara yazılmaz.
  @override
  String toString() => 'LoginState(status: $status, failure: $failure)';
}
