import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/auth/domain/entities/legal_document.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/domain/entities/verification_challenge.dart';
import 'package:vakif_atlas/features/auth/domain/usecases/auth_usecases.dart';
import 'package:vakif_atlas/features/auth/domain/validation/credentials_validator.dart';
import 'package:vakif_atlas/features/auth/domain/validation/password_policy.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/form_status.dart';

part 'account_blocs.freezed.dart';

// ── Şifremi unuttum ─────────────────────────────────────────────────────────

@freezed
sealed class ForgotPasswordEvent with _$ForgotPasswordEvent {
  const factory ForgotPasswordEvent.emailChanged(String value) =
      ForgotPasswordEmailChanged;
  const factory ForgotPasswordEvent.submitted() = ForgotPasswordSubmitted;
}

@freezed
abstract class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default('') String email,
    @Default(false) bool showValidationErrors,
    @Default(FormStatus.editing) FormStatus status,
    @Default(0) int invalidSubmissions,
    Failure? failure,
    VerificationChallenge? challenge,
  }) = _ForgotPasswordState;

  const ForgotPasswordState._();

  EmailValidationError? get emailError =>
      CredentialsValidator.validateEmail(email);

  bool get isSubmitting => status == FormStatus.submitting;

  @override
  String toString() => 'ForgotPasswordState(status: $status)';
}

@injectable
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc(this._requestReset) : super(const ForgotPasswordState()) {
    on<ForgotPasswordEmailChanged>(
      (event, emit) =>
          emit(state.copyWith(email: event.value, status: FormStatus.editing)),
    );
    on<ForgotPasswordSubmitted>(_onSubmitted, transformer: droppable());
  }

  final RequestPasswordResetUseCase _requestReset;

  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (state.emailError != null) {
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
    final result = await _requestReset(state.email);
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

// ── Şifre değiştirme ────────────────────────────────────────────────────────

@freezed
sealed class ChangePasswordEvent with _$ChangePasswordEvent {
  const factory ChangePasswordEvent.currentPasswordChanged(String value) =
      ChangePasswordCurrentChanged;
  const factory ChangePasswordEvent.newPasswordChanged(String value) =
      ChangePasswordNewChanged;
  const factory ChangePasswordEvent.confirmationChanged(String value) =
      ChangePasswordConfirmationChanged;
  const factory ChangePasswordEvent.submitted() = ChangePasswordSubmitted;
}

@freezed
abstract class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    /// Kişisel bilgi içeren şifreleri reddetmek için.
    @Default('') String email,
    @Default('') String displayName,
    @Default('') String currentPassword,
    @Default('') String newPassword,
    @Default('') String confirmation,
    @Default(false) bool showValidationErrors,
    @Default(FormStatus.editing) FormStatus status,
    @Default(0) int invalidSubmissions,
    Failure? failure,
  }) = _ChangePasswordState;

  const ChangePasswordState._();

  PasswordValidationError? get currentPasswordError =>
      CredentialsValidator.validateLoginPassword(currentPassword);

  PasswordPolicyViolation? get newPasswordError => PasswordPolicy.validate(
    newPassword,
    email: email,
    displayName: displayName,
  );

  /// Yeni şifre mevcut şifreyle aynı olamaz.
  bool get isSameAsCurrent =>
      newPassword.isNotEmpty && newPassword == currentPassword;

  ConfirmPasswordError? get confirmationError =>
      CredentialsValidator.validateConfirmation(newPassword, confirmation);

  PasswordStrength get strength => PasswordPolicy.strength(
    newPassword,
    email: email,
    displayName: displayName,
  );

  bool get isValid =>
      currentPasswordError == null &&
      newPasswordError == null &&
      !isSameAsCurrent &&
      confirmationError == null;

  bool get isSubmitting => status == FormStatus.submitting;

  @override
  String toString() =>
      'ChangePasswordState(status: $status, failure: $failure)';
}

@injectable
class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc(this._changePassword, @factoryParam UserEntity? user)
    : super(
        ChangePasswordState(
          email: user?.email ?? '',
          displayName: user?.displayName ?? '',
        ),
      ) {
    on<ChangePasswordCurrentChanged>(
      (event, emit) => emit(
        state.copyWith(
          currentPassword: event.value,
          status: FormStatus.editing,
        ),
      ),
    );
    on<ChangePasswordNewChanged>(
      (event, emit) => emit(
        state.copyWith(newPassword: event.value, status: FormStatus.editing),
      ),
    );
    on<ChangePasswordConfirmationChanged>(
      (event, emit) => emit(
        state.copyWith(confirmation: event.value, status: FormStatus.editing),
      ),
    );
    on<ChangePasswordSubmitted>(_onSubmitted, transformer: droppable());
  }

  final ChangePasswordUseCase _changePassword;

  Future<void> _onSubmitted(
    ChangePasswordSubmitted event,
    Emitter<ChangePasswordState> emit,
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
    final result = await _changePassword(
      ChangePasswordParams(
        currentPassword: state.currentPassword,
        newPassword: state.newPassword,
      ),
    );
    emit(
      result.fold(
        (failure) =>
            state.copyWith(status: FormStatus.failure, failure: failure),
        // Başarıda şifreler durumdan temizlenir.
        (_) => state.copyWith(
          status: FormStatus.success,
          currentPassword: '',
          newPassword: '',
          confirmation: '',
        ),
      ),
    );
  }
}

// ── Hesap silme ─────────────────────────────────────────────────────────────

@freezed
sealed class DeleteAccountEvent with _$DeleteAccountEvent {
  const factory DeleteAccountEvent.passwordChanged(String value) =
      DeleteAccountPasswordChanged;
  const factory DeleteAccountEvent.confirmationChanged({
    required bool confirmed,
  }) = DeleteAccountConfirmationChanged;
  const factory DeleteAccountEvent.submitted() = DeleteAccountSubmitted;
}

@freezed
abstract class DeleteAccountState with _$DeleteAccountState {
  const factory DeleteAccountState({
    @Default('') String password,
    @Default(false) bool confirmed,
    @Default(false) bool showValidationErrors,
    @Default(FormStatus.editing) FormStatus status,
    @Default(0) int invalidSubmissions,
    Failure? failure,
  }) = _DeleteAccountState;

  const DeleteAccountState._();

  PasswordValidationError? get passwordError =>
      CredentialsValidator.validateLoginPassword(password);

  bool get isValid => passwordError == null && confirmed;

  bool get isSubmitting => status == FormStatus.submitting;

  @override
  String toString() => 'DeleteAccountState(status: $status, failure: $failure)';
}

@injectable
class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  DeleteAccountBloc(this._deleteAccount) : super(const DeleteAccountState()) {
    on<DeleteAccountPasswordChanged>(
      (event, emit) => emit(
        state.copyWith(password: event.value, status: FormStatus.editing),
      ),
    );
    on<DeleteAccountConfirmationChanged>(
      (event, emit) => emit(
        state.copyWith(confirmed: event.confirmed, status: FormStatus.editing),
      ),
    );
    on<DeleteAccountSubmitted>(_onSubmitted, transformer: droppable());
  }

  final DeleteAccountUseCase _deleteAccount;

  Future<void> _onSubmitted(
    DeleteAccountSubmitted event,
    Emitter<DeleteAccountState> emit,
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
    final result = await _deleteAccount(state.password);
    emit(
      result.fold(
        (failure) =>
            state.copyWith(status: FormStatus.failure, failure: failure),
        (_) => state.copyWith(status: FormStatus.success, password: ''),
      ),
    );
  }
}

// ── Yasal metin ─────────────────────────────────────────────────────────────

@freezed
sealed class LegalDocumentState with _$LegalDocumentState {
  const factory LegalDocumentState.loading() = LegalDocumentLoading;
  const factory LegalDocumentState.loaded(LegalDocument document) =
      LegalDocumentLoaded;
  const factory LegalDocumentState.failure(Failure failure) =
      LegalDocumentFailure;
}

@injectable
class LegalDocumentCubit extends Cubit<LegalDocumentState> {
  LegalDocumentCubit(this._getDocument)
    : super(const LegalDocumentState.loading());

  final GetLegalDocumentUseCase _getDocument;

  Future<void> load(
    LegalDocumentType type, {
    required String languageCode,
  }) async {
    emit(const LegalDocumentState.loading());
    final result = await _getDocument(
      LegalDocumentParams(type: type, languageCode: languageCode),
    );
    if (isClosed) {
      return;
    }
    emit(result.fold(LegalDocumentState.failure, LegalDocumentState.loaded));
  }
}
