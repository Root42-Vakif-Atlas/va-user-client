part of 'auth_bloc.dart';

@freezed
sealed class AuthState with _$AuthState {
  /// Kayıtlı oturum henüz okunmadı (açılış).
  const factory AuthState.unknown() = AuthUnknown;

  /// `guest` rolü: salt okunur alanlara erişebilir.
  ///
  /// [sessionExpired] oturumun kullanıcı isteği dışında sona erdiğini belirtir.
  const factory AuthState.guest({@Default(false) bool sessionExpired}) =
      AuthGuest;

  /// `citizen` rolü: tüm özelliklere erişebilir.
  const factory AuthState.authenticated(UserEntity user) = AuthAuthenticated;
}
