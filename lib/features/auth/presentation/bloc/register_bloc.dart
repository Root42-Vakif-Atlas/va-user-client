import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/auth/domain/entities/registration_data.dart';
import 'package:vakif_atlas/features/auth/domain/entities/verification_challenge.dart';
import 'package:vakif_atlas/features/auth/domain/usecases/auth_usecases.dart';
import 'package:vakif_atlas/features/auth/domain/validation/credentials_validator.dart';
import 'package:vakif_atlas/features/auth/domain/validation/password_policy.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/form_status.dart';

part 'register_bloc.freezed.dart';

@freezed
sealed class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.displayNameChanged(String value) =
      RegisterDisplayNameChanged;
  const factory RegisterEvent.emailChanged(String value) = RegisterEmailChanged;
  const factory RegisterEvent.passwordChanged(String value) =
      RegisterPasswordChanged;
  const factory RegisterEvent.confirmationChanged(String value) =
      RegisterConfirmationChanged;
  const factory RegisterEvent.termsChanged({required bool accepted}) =
      RegisterTermsChanged;
  const factory RegisterEvent.privacyNoticeChanged({
    required bool acknowledged,
  }) = RegisterPrivacyNoticeChanged;
  const factory RegisterEvent.submitted() = RegisterSubmitted;
}

@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default('') String displayName,
    @Default('') String email,
    @Default('') String password,
    @Default('') String confirmation,
    @Default(false) bool acceptedTerms,
    @Default(false) bool acknowledgedPrivacyNotice,
    @Default(false) bool showValidationErrors,
    @Default(FormStatus.editing) FormStatus status,
    @Default(0) int invalidSubmissions,
    Failure? failure,
    VerificationChallenge? challenge,
  }) = _RegisterState;

  const RegisterState._();

  DisplayNameValidationError? get displayNameError =>
      CredentialsValidator.validateDisplayName(displayName);

  EmailValidationError? get emailError =>
      CredentialsValidator.validateEmail(email);

  PasswordPolicyViolation? get passwordError =>
      PasswordPolicy.validate(password, email: email, displayName: displayName);

  ConfirmPasswordError? get confirmationError =>
      CredentialsValidator.validateConfirmation(password, confirmation);

  PasswordStrength get strength =>
      PasswordPolicy.strength(password, email: email, displayName: displayName);

  bool get isValid =>
      displayNameError == null &&
      emailError == null &&
      passwordError == null &&
      confirmationError == null &&
      acceptedTerms &&
      acknowledgedPrivacyNotice;

  bool get isSubmitting => status == FormStatus.submitting;

  /// Kişisel veriler ve şifre loglara/raporlara yazılmaz.
  @override
  String toString() => 'RegisterState(status: $status, failure: $failure)';
}

/// Kayıt formu. Ekran bazlıdır (factory).
@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this._register) : super(const RegisterState()) {
    on<RegisterDisplayNameChanged>(
      (event, emit) => emit(_edit(state.copyWith(displayName: event.value))),
    );
    on<RegisterEmailChanged>(
      (event, emit) => emit(_edit(state.copyWith(email: event.value))),
    );
    on<RegisterPasswordChanged>(
      (event, emit) => emit(_edit(state.copyWith(password: event.value))),
    );
    on<RegisterConfirmationChanged>(
      (event, emit) => emit(_edit(state.copyWith(confirmation: event.value))),
    );
    on<RegisterTermsChanged>(
      (event, emit) =>
          emit(_edit(state.copyWith(acceptedTerms: event.accepted))),
    );
    on<RegisterPrivacyNoticeChanged>(
      (event, emit) => emit(
        _edit(state.copyWith(acknowledgedPrivacyNotice: event.acknowledged)),
      ),
    );
    on<RegisterSubmitted>(_onSubmitted, transformer: droppable());
  }

  final RegisterUseCase _register;

  static RegisterState _edit(RegisterState state) =>
      state.copyWith(status: FormStatus.editing);

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
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
    final result = await _register(
      RegistrationData(
        displayName: state.displayName,
        email: state.email,
        password: state.password,
        acceptedTerms: state.acceptedTerms,
        acknowledgedPrivacyNotice: state.acknowledgedPrivacyNotice,
      ),
    );
    emit(
      result.fold(
        (failure) =>
            state.copyWith(status: FormStatus.failure, failure: failure),
        (challenge) =>
            state.copyWith(status: FormStatus.success, challenge: challenge),
      ),
    );
  }
}
