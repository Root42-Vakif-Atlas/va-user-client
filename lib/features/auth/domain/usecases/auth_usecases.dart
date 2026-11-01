import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/auth/domain/entities/auth_session_event.dart';
import 'package:vakif_atlas/features/auth/domain/entities/auth_tokens.dart';
import 'package:vakif_atlas/features/auth/domain/entities/legal_document.dart';
import 'package:vakif_atlas/features/auth/domain/entities/registration_data.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/domain/entities/verification_challenge.dart';
import 'package:vakif_atlas/features/auth/domain/repositories/auth_repository.dart';
import 'package:vakif_atlas/features/auth/domain/repositories/legal_document_repository.dart';
import 'package:vakif_atlas/features/auth/domain/validation/credentials_validator.dart';

// ── Parametreler ────────────────────────────────────────────────────────────
// Şifre ve kodlar `toString` ile asla yazdırılmaz.

final class LoginParams {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  bool operator ==(Object other) =>
      other is LoginParams &&
      other.email == email &&
      other.password == password;

  @override
  int get hashCode => Object.hash(email, password);

  @override
  String toString() => 'LoginParams(***)';
}

final class VerifyEmailParams {
  const VerifyEmailParams({
    required this.email,
    required this.code,
    required this.password,
  });

  final String email;
  final String code;

  /// Doğrulamada hesabın şifresi olur (kayıt/giriş formunda girilen).
  final String password;

  @override
  bool operator ==(Object other) =>
      other is VerifyEmailParams &&
      other.email == email &&
      other.code == code &&
      other.password == password;

  @override
  int get hashCode => Object.hash(email, code, password);

  @override
  String toString() => 'VerifyEmailParams(***)';
}

final class ResetPasswordParams {
  const ResetPasswordParams({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  final String email;
  final String code;
  final String newPassword;

  @override
  bool operator ==(Object other) =>
      other is ResetPasswordParams &&
      other.email == email &&
      other.code == code &&
      other.newPassword == newPassword;

  @override
  int get hashCode => Object.hash(email, code, newPassword);

  @override
  String toString() => 'ResetPasswordParams(***)';
}

final class ChangePasswordParams {
  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });

  final String currentPassword;
  final String newPassword;

  @override
  bool operator ==(Object other) =>
      other is ChangePasswordParams &&
      other.currentPassword == currentPassword &&
      other.newPassword == newPassword;

  @override
  int get hashCode => Object.hash(currentPassword, newPassword);

  @override
  String toString() => 'ChangePasswordParams(***)';
}

final class LegalDocumentParams {
  const LegalDocumentParams({required this.type, required this.languageCode});

  final LegalDocumentType type;
  final String languageCode;

  @override
  bool operator ==(Object other) =>
      other is LegalDocumentParams &&
      other.type == type &&
      other.languageCode == languageCode;

  @override
  int get hashCode => Object.hash(type, languageCode);
}

// ── Oturum ──────────────────────────────────────────────────────────────────

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<UserEntity> call(LoginParams params) => _repository.login(
    email: CredentialsValidator.normalizeEmail(params.email),
    password: params.password,
  );
}

class LogoutUseCase implements UseCase<Unit, NoParams> {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<Unit> call(NoParams params) => _repository.logout();
}

class RefreshTokenUseCase implements UseCase<AuthTokens, NoParams> {
  const RefreshTokenUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<AuthTokens> call(NoParams params) => _repository.refreshToken();
}

class RestoreSessionUseCase implements UseCase<UserEntity?, NoParams> {
  const RestoreSessionUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<UserEntity?> call(NoParams params) =>
      _repository.restoreSession();
}

class WatchAuthSessionUseCase
    implements StreamUseCase<AuthSessionEvent, NoParams> {
  const WatchAuthSessionUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Stream<AuthSessionEvent> call(NoParams params) => _repository.sessionEvents;
}

// ── Kayıt ve doğrulama ──────────────────────────────────────────────────────

class RegisterUseCase
    implements UseCase<VerificationChallenge, RegistrationData> {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<VerificationChallenge> call(RegistrationData params) =>
      _repository.register(
        params.copyWith(
          displayName: CredentialsValidator.normalizeDisplayName(
            params.displayName,
          ),
          email: CredentialsValidator.normalizeEmail(params.email),
        ),
      );
}

class VerifyEmailUseCase implements UseCase<UserEntity, VerifyEmailParams> {
  const VerifyEmailUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<UserEntity> call(VerifyEmailParams params) =>
      _repository.verifyEmail(
        email: CredentialsValidator.normalizeEmail(params.email),
        code: CredentialsValidator.normalizeVerificationCode(params.code),
        password: params.password,
      );
}

class ResendVerificationCodeUseCase
    implements UseCase<VerificationChallenge, String> {
  const ResendVerificationCodeUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<VerificationChallenge> call(String email) => _repository
      .resendVerificationCode(CredentialsValidator.normalizeEmail(email));
}

// ── Şifre ───────────────────────────────────────────────────────────────────

class RequestPasswordResetUseCase
    implements UseCase<VerificationChallenge, String> {
  const RequestPasswordResetUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<VerificationChallenge> call(String email) => _repository
      .requestPasswordReset(CredentialsValidator.normalizeEmail(email));
}

class ResetPasswordUseCase implements UseCase<Unit, ResetPasswordParams> {
  const ResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<Unit> call(ResetPasswordParams params) =>
      _repository.resetPassword(
        email: CredentialsValidator.normalizeEmail(params.email),
        code: CredentialsValidator.normalizeVerificationCode(params.code),
        newPassword: params.newPassword,
      );
}

class ChangePasswordUseCase implements UseCase<Unit, ChangePasswordParams> {
  const ChangePasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<Unit> call(ChangePasswordParams params) =>
      _repository.changePassword(
        currentPassword: params.currentPassword,
        newPassword: params.newPassword,
      );
}

// ── Hesap ve yasal metinler ─────────────────────────────────────────────────

class DeleteAccountUseCase implements UseCase<Unit, String> {
  const DeleteAccountUseCase(this._repository);

  final AuthRepository _repository;

  /// [password] kimlik yeniden doğrulaması (re-authentication) içindir.
  @override
  ResultFuture<Unit> call(String password) =>
      _repository.deleteAccount(password: password);
}

class GetLegalDocumentUseCase
    implements UseCase<LegalDocument, LegalDocumentParams> {
  const GetLegalDocumentUseCase(this._repository);

  final LegalDocumentRepository _repository;

  @override
  ResultFuture<LegalDocument> call(LegalDocumentParams params) =>
      _repository.getDocument(params.type, languageCode: params.languageCode);
}
