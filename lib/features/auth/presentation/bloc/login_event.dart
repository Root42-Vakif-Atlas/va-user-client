part of 'login_bloc.dart';

@freezed
sealed class LoginEvent with _$LoginEvent {
  const factory LoginEvent.emailChanged(String email) = LoginEmailChanged;

  const factory LoginEvent.passwordChanged(String password) =
      LoginPasswordChanged;

  const factory LoginEvent.submitted() = LoginSubmitted;
}
