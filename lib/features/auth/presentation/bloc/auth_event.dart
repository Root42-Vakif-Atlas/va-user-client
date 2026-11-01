part of 'auth_bloc.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  /// Uygulama açılışında kayıtlı oturumu geri yükler.
  const factory AuthEvent.started() = AuthStarted;

  const factory AuthEvent.logoutRequested() = AuthLogoutRequested;

  /// Repository'den gelen giriş / çıkış / oturum sona erme olayı.
  const factory AuthEvent.sessionChanged(AuthSessionEvent event) =
      AuthSessionChanged;
}
