import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/features/auth/domain/repositories/auth_repository.dart';
import 'package:vakif_atlas/features/auth/domain/repositories/legal_document_repository.dart';
import 'package:vakif_atlas/features/auth/domain/usecases/auth_usecases.dart';

/// Domain sınıfları DI anotasyonu taşımadığından kayıtları burada yapılır.
@module
abstract class AuthModule {
  @lazySingleton
  LoginUseCase loginUseCase(AuthRepository repository) =>
      LoginUseCase(repository);

  @lazySingleton
  LogoutUseCase logoutUseCase(AuthRepository repository) =>
      LogoutUseCase(repository);

  @lazySingleton
  RefreshTokenUseCase refreshTokenUseCase(AuthRepository repository) =>
      RefreshTokenUseCase(repository);

  @lazySingleton
  RestoreSessionUseCase restoreSessionUseCase(AuthRepository repository) =>
      RestoreSessionUseCase(repository);

  @lazySingleton
  WatchAuthSessionUseCase watchAuthSessionUseCase(AuthRepository repository) =>
      WatchAuthSessionUseCase(repository);

  @lazySingleton
  RegisterUseCase registerUseCase(AuthRepository repository) =>
      RegisterUseCase(repository);

  @lazySingleton
  VerifyEmailUseCase verifyEmailUseCase(AuthRepository repository) =>
      VerifyEmailUseCase(repository);

  @lazySingleton
  ResendVerificationCodeUseCase resendVerificationCodeUseCase(
    AuthRepository repository,
  ) => ResendVerificationCodeUseCase(repository);

  @lazySingleton
  RequestPasswordResetUseCase requestPasswordResetUseCase(
    AuthRepository repository,
  ) => RequestPasswordResetUseCase(repository);

  @lazySingleton
  ResetPasswordUseCase resetPasswordUseCase(AuthRepository repository) =>
      ResetPasswordUseCase(repository);

  @lazySingleton
  ChangePasswordUseCase changePasswordUseCase(AuthRepository repository) =>
      ChangePasswordUseCase(repository);

  @lazySingleton
  DeleteAccountUseCase deleteAccountUseCase(AuthRepository repository) =>
      DeleteAccountUseCase(repository);

  @lazySingleton
  GetLegalDocumentUseCase getLegalDocumentUseCase(
    LegalDocumentRepository repository,
  ) => GetLegalDocumentUseCase(repository);
}
