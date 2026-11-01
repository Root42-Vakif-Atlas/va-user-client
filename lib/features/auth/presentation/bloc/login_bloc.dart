import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/domain/usecases/auth_usecases.dart';
import 'package:vakif_atlas/features/auth/domain/validation/credentials_validator.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

/// Giriş formu durumu. Ekran bazlıdır (factory).
@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._login) : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted, transformer: droppable());
  }

  final LoginUseCase _login;

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email, status: LoginStatus.editing));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(password: event.password, status: LoginStatus.editing));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.isValid) {
      emit(
        state.copyWith(
          showValidationErrors: true,
          status: LoginStatus.invalid,
          invalidSubmissions: state.invalidSubmissions + 1,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        showValidationErrors: true,
        status: LoginStatus.submitting,
        failure: null,
      ),
    );
    final result = await _login(
      LoginParams(email: state.email, password: state.password),
    );
    emit(
      result.fold(
        (failure) => state.copyWith(
          status:
              failure is AuthFailure &&
                  failure.reason == AuthFailureReason.emailNotVerified
              ? LoginStatus.verificationRequired
              : LoginStatus.failure,
          failure: failure,
        ),
        // Başarıda şifre durumdan temizlenir.
        (user) => state.copyWith(
          status: LoginStatus.success,
          user: user,
          password: '',
        ),
      ),
    );
  }
}
