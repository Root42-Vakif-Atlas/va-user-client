import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/auth/domain/entities/auth_session_event.dart';
import 'package:vakif_atlas/features/auth/domain/entities/auth_tokens.dart';
import 'package:vakif_atlas/features/auth/domain/entities/registration_data.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/domain/entities/verification_challenge.dart';

abstract interface class AuthRepository {
  /// Giriş, çıkış, oturum sona erme ve hesap silme olayları.
  Stream<AuthSessionEvent> get sessionEvents;

  /// Cihazda kayıtlı oturumu geri yükler; oturum yoksa `null`.
  ///
  /// Ağ gerektirmez; anahtarın geçerliliği ilk korumalı istekte doğrulanır.
  ResultFuture<UserEntity?> restoreSession();

  ResultFuture<UserEntity> login({
    required String email,
    required String password,
  });

  ResultFuture<Unit> logout();

  ResultFuture<AuthTokens> refreshToken();

  /// Hesap oluşturur ve e-posta doğrulama kodu gönderilmesini ister.
  ///
  /// Hesap numaralandırmayı (enumeration) önlemek için e-posta zaten kayıtlı
  /// olsa da aynı sonuç döner.
  ResultFuture<VerificationChallenge> register(RegistrationData data);

  /// E-postayı doğrular ve kullanıcının oturumunu açar.
  /// Kodu doğrular; [password] hesabın şifresi olur ve oturum açılır.
  ResultFuture<UserEntity> verifyEmail({
    required String email,
    required String code,
    required String password,
  });

  ResultFuture<VerificationChallenge> resendVerificationCode(String email);

  /// Şifre sıfırlama kodu ister. Hesap var olmasa da aynı sonuç döner.
  ResultFuture<VerificationChallenge> requestPasswordReset(String email);

  /// Kodu doğrular ve şifreyi değiştirir; tüm oturumlar sonlandırılır.
  ResultFuture<Unit> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  /// Oturum açık kullanıcının şifresini değiştirir; diğer cihazlardaki
  /// oturumlar sonlandırılır, bu cihazda oturum devam eder.
  ResultFuture<Unit> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Hesabı ve bağlı kişisel verileri kalıcı olarak siler.
  ResultFuture<Unit> deleteAccount({required String password});
}
