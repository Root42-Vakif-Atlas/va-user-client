import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/domain/entities/verification_challenge.dart';
import 'package:vakif_atlas/features/auth/domain/usecases/auth_usecases.dart';
import 'package:vakif_atlas/features/auth/domain/validation/credentials_validator.dart';
import 'package:vakif_atlas/features/auth/domain/validation/password_policy.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/form_status.dart';
import 'package:vakif_atlas/features/auth/presentation/pending_verification.dart';

part 'verification_bloc.freezed.dart';

/// "Kodu tekrar gönder" işleminin durumu.
enum ResendStatus { idle, sending, sent, failure }

// ── E-posta doğrulama ───────────────────────────────────────────────────────

@freezed
sealed class VerifyEmailEvent with _$VerifyEmailEvent {
  const factory VerifyEmailEvent.codeChanged(String value) =
      VerifyEmailCodeChanged;
  const factory VerifyEmailEvent.submitted() = VerifyEmailSubmitted;
  const factory VerifyEmailEvent.resendRequested() = VerifyEmailResendRequested;
}

@freezed
abstract class VerifyEmailState with _$VerifyEmailState {
  const factory VerifyEmailState({
    required String email,
    @Default('') String code,
    @Default(false) bool showValidationErrors,
    @Default(FormStatus.editing) FormStatus status,
    @Default(0) int invalidSubmissions,
    @Default(ResendStatus.idle) ResendStatus resendStatus,

    /// Her yeniden gönderim denemesinin sonucunda artar (dinleyiciler için).
    @Default(0) int resendAttempts,

    /// Sunucunun bildirdiği yeni bekleme süresi.
    Duration? cooldown,
    Failure? failure,
    UserEntity? user,
  }) = _VerifyEmailState;

  const VerifyEmailState._();

  VerificationCodeError? get codeError =>
      CredentialsValidator.validateVerificationCode(code);

  bool get isSubmitting => status == FormStatus.submitting;

  @override
  String toString() =>
      'VerifyEmailState(status: $status, resend: $resendStatus, '
      'failure: $failure)';
}

/// E-posta doğrulama ekranı. Başarılı doğrulama oturumu açar; yönlendirmeyi
/// `AuthGuard` yapar.
@injectable
class VerifyEmailBloc extends Bloc<VerifyEmailEvent, VerifyEmailState> {
  VerifyEmailBloc(
    this._verify,
    this._resend,
    @factoryParam PendingVerification? pending,
  ) : _password = pending?.password ?? '',
      super(VerifyEmailState(email: pending?.challenge.email ?? '')) {
    on<VerifyEmailCodeChanged>(
      (event, emit) =>
          emit(state.copyWith(code: event.value, status: FormStatus.editing)),
    );
    on<VerifyEmailSubmitted>(_onSubmitted, transformer: droppable());
    on<VerifyEmailResendRequested>(_onResend, transformer: droppable());
  }

  final VerifyEmailUseCase _verify;
  final ResendVerificationCodeUseCase _resend;

  /// Formdaki şifre; durumda (ve dolayısıyla loglarda) tutulmaz.
  final String _password;

  Future<void> _onSubmitted(
    VerifyEmailSubmitted event,
    Emitter<VerifyEmailState> emit,
  ) async {
    if (state.codeError != null) {
      emit(
        state.copyWith(
          showValidationErrors: true,
          status: FormStatus.invalid,
          invalidSubmissions: state.invalidSubmissions + 1,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        showValidationErrors: true,
        status: FormStatus.submitting,
        failure: null,
      ),
    );
    final result = await _verify(
      VerifyEmailParams(
        email: state.email,
        code: state.code,
        password: _password,
      ),
    );
    emit(
      result.fold(
        (failure) =>
            state.copyWith(status: FormStatus.failure, failure: failure),
        (user) => state.copyWith(status: FormStatus.success, user: user),
      ),
    );
  }

  Future<void> _onResend(
    VerifyEmailResendRequested event,
    Emitter<VerifyEmailState> emit,
  ) async {
    emit(state.copyWith(resendStatus: ResendStatus.sending));
    emit(_resendOutcome(state, await _resend(state.email)));
  }

  static VerifyEmailState _resendOutcome(
    VerifyEmailState state,
    Result<VerificationChallenge> result,
  ) {
    return result.fold(
      (failure) => state.copyWith(
        resendStatus: ResendStatus.failure,
        resendAttempts: state.resendAttempts + 1,
        cooldown: _retryAfter(failure),
        failure: failure,
      ),
      (challenge) => state.copyWith(
        resendStatus: ResendStatus.sent,
        resendAttempts: state.resendAttempts + 1,
        cooldown: challenge.resendAfter,
      ),
    );
  }
}

// ── Şifre sıfırlama ─────────────────────────────────────────────────────────

@freezed
sealed class ResetPasswordEvent with _$ResetPasswordEvent {
  const factory ResetPasswordEvent.codeChanged(String value) =
      ResetPasswordCodeChanged;
  const factory ResetPasswordEvent.passwordChanged(String value) =
      ResetPasswordPasswordChanged;
  const factory ResetPasswordEvent.confirmationChanged(String value) =
      ResetPasswordConfirmationChanged;
  const factory ResetPasswordEvent.submitted() = ResetPasswordSubmitted;
  const factory ResetPasswordEvent.resendRequested() =
      ResetPasswordResendRequested;
}

@freezed
abstract class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState({
    required String email,
    @Default('') String code,
    @Default('') String password,
    @Default('') String confirmation,
    @Default(false) bool showValidationErrors,
    @Default(FormStatus.editing) FormStatus status,
    @Default(0) int invalidSubmissions,
    @Default(ResendStatus.idle) ResendStatus resendStatus,
    @Default(0) int resendAttempts,
    Duration? cooldown,
    Failure? failure,
  }) = _ResetPasswordState;

  const ResetPasswordState._();

  VerificationCodeError? get codeError =>
      CredentialsValidator.validateVerificationCode(code);

  PasswordPolicyViolation? get passwordError =>
      PasswordPolicy.validate(password, email: email);

  ConfirmPasswordError? get confirmationError =>
      CredentialsValidator.validateConfirmation(password, confirmation);

  PasswordStrength get strength =>
      PasswordPolicy.strength(password, email: email);

  bool get isValid =>
      codeError == null && passwordError == null && confirmationError == null;

  bool get isSubmitting => status == FormStatus.submitting;

  @override
  String toString() =>
      'ResetPasswordState(status: $status, resend: $resendStatus, '
      'failure: $failure)';
}

@injectable
class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc(
    this._reset,
    this._requestReset,
    @factoryParam VerificationChallenge? challenge,
  ) : super(ResetPasswordState(email: challenge?.email ?? '')) {
    on<ResetPasswordCodeChanged>(
      (event, emit) =>
          emit(state.copyWith(code: event.value, status: FormStatus.editing)),
    );
    on<ResetPasswordPasswordChanged>(
      (event, emit) => emit(
        state.copyWith(password: event.value, status: FormStatus.editing),
      ),
    );
    on<ResetPasswordConfirmationChanged>(
      (event, emit) => emit(
        state.copyWith(confirmation: event.value, status: FormStatus.editing),
      ),
    );
    on<ResetPasswordSubmitted>(_onSubmitted, transformer: droppable());
    on<ResetPasswordResendRequested>(_onResend, transformer: droppable());
  }

  final ResetPasswordUseCase _reset;
  final RequestPasswordResetUseCase _requestReset;

  Future<void> _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    if (!state.isValid) {
      emit(
        state.copyWith(
          showValidationErrors: true,
          status: FormStatus.invalid,
          invalidSubmissions: state.invalidSubmissions + 1,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        showValidationErrors: true,
        status: FormStatus.submitting,
        failure: null,
      ),
    );
    final result = await _reset(
      ResetPasswordParams(
        email: state.email,
        code: state.code,
        newPassword: state.password,
      ),
    );
    emit(
      result.fold(
        (failure) =>
            state.copyWith(status: FormStatus.failure, failure: failure),
        (_) => state.copyWith(status: FormStatus.success),
      ),
    );
  }

  Future<void> _onResend(
    ResetPasswordResendRequested event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(resendStatus: ResendStatus.sending));
    final result = await _requestReset(state.email);
    emit(
      result.fold(
        (failure) => state.copyWith(
          resendStatus: ResendStatus.failure,
          resendAttempts: state.resendAttempts + 1,
          cooldown: _retryAfter(failure),
          failure: failure,
        ),
        (challenge) => state.copyWith(
          resendStatus: ResendStatus.sent,
          resendAttempts: state.resendAttempts + 1,
          cooldown: challenge.resendAfter,
        ),
      ),
    );
  }
}

Duration? _retryAfter(Failure failure) =>
    failure is TooManyRequestsFailure ? failure.retryAfter : null;
