import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';

/// Oturum durumundaki değişiklikler.
sealed class AuthSessionEvent {
  const AuthSessionEvent();
}

final class SignedIn extends AuthSessionEvent {
  const SignedIn(this.user);

  final UserEntity user;

  @override
  bool operator ==(Object other) => other is SignedIn && other.user == user;

  @override
  int get hashCode => Object.hash(SignedIn, user);
}

/// Kullanıcı isteğiyle oturum kapatıldı.
final class SignedOut extends AuthSessionEvent {
  const SignedOut();

  @override
  bool operator ==(Object other) => other is SignedOut;

  @override
  int get hashCode => (SignedOut).hashCode;
}

/// Anahtar yenilenemediği için oturum sona erdi.
final class SessionExpired extends AuthSessionEvent {
  const SessionExpired();

  @override
  bool operator ==(Object other) => other is SessionExpired;

  @override
  int get hashCode => (SessionExpired).hashCode;
}

/// Kullanıcı hesabını kalıcı olarak sildi. Kullanıcıya ait yerel veriler
/// (ör. rota dışa aktarımları) [userId] ile temizlenir.
final class AccountDeleted extends AuthSessionEvent {
  const AccountDeleted({this.userId});

  /// Oturum önbelleğinde kullanıcı yoksa `null`.
  final String? userId;

  @override
  bool operator ==(Object other) =>
      other is AccountDeleted && other.userId == userId;

  @override
  int get hashCode => Object.hash(AccountDeleted, userId);
}
