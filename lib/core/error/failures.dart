/// Domain katmanına taşınan, kullanıcıya anlamlı hata tipleri.
///
/// Data katmanındaki teknik istisnalar `ErrorMapper` ile bu tiplere
/// dönüştürülür; Presentation katmanı yalnızca [Failure] görür.
/// Kullanıcı mesajı eşlemesi: `failure_l10n.dart`.
sealed class Failure {
  const Failure();
}

/// Sunucu kaynaklı hatanın sınıfı (TRD §9 hata tablosu).
enum ServerFailureKind {
  /// 400 — Gönderilen istek geçersiz.
  invalidRequest,

  /// 404 — İstenen kaynak bulunamadı.
  notFound,

  /// 5xx — Sunucu geçici olarak hizmet veremiyor.
  unavailable,

  /// Tabloda karşılığı olmayan diğer HTTP durum kodları.
  unknown,
}

/// HTTP 400 / 404 / 5xx ve diğer sunucu hataları.
final class ServerFailure extends Failure {
  const ServerFailure({required this.kind, this.statusCode});

  final ServerFailureKind kind;
  final int? statusCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerFailure &&
          other.kind == kind &&
          other.statusCode == statusCode;

  @override
  int get hashCode => Object.hash(ServerFailure, kind, statusCode);

  @override
  String toString() => 'ServerFailure(kind: $kind, statusCode: $statusCode)';
}

/// HTTP 401 / 403 — oturum süresi doldu veya yetki yok.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();

  @override
  bool operator ==(Object other) => other is UnauthorizedFailure;

  @override
  int get hashCode => (UnauthorizedFailure).hashCode;

  @override
  String toString() => 'UnauthorizedFailure()';
}

/// Kimlik doğrulama akışlarına özgü hata nedeni.
///
/// Sunucunun makine okunur hata kodlarından (`{"code": "..."}`) eşlenir.
enum AuthFailureReason {
  /// Giriş: e-posta veya şifre hatalı (hangisinin hatalı olduğu söylenmez).
  invalidCredentials,

  /// Giriş: hesap var ancak e-posta adresi doğrulanmamış.
  emailNotVerified,

  /// Doğrulama / sıfırlama kodu hatalı.
  invalidVerificationCode,

  /// Kodun süresi doldu veya deneme hakkı bitti; yeni kod istenmeli.
  verificationCodeExpired,

  /// Sunucu şifreyi güvenlik politikasına uygun bulmadı.
  weakPassword,

  /// Şifre değiştirme / hesap silme: mevcut şifre hatalı.
  invalidCurrentPassword,
}

/// Kimlik doğrulama akışı hatası.
final class AuthFailure extends Failure {
  const AuthFailure(this.reason, {this.retryAfter});

  final AuthFailureReason reason;

  /// [AuthFailureReason.emailNotVerified]: giriş yeni kod gönderdiyse
  /// "Kodu tekrar gönder" için sunucudaki bekleme süresi.
  final Duration? retryAfter;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthFailure &&
          other.reason == reason &&
          other.retryAfter == retryAfter;

  @override
  int get hashCode => Object.hash(AuthFailure, reason, retryAfter);

  @override
  String toString() => 'AuthFailure($reason, retryAfter: $retryAfter)';
}

/// HTTP 429 / 423 — hız sınırı aşıldı veya hesap geçici olarak kilitlendi.
final class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure({this.retryAfter});

  /// Sunucunun bildirdiği bekleme süresi (bilinmiyorsa `null`).
  final Duration? retryAfter;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TooManyRequestsFailure && other.retryAfter == retryAfter;

  @override
  int get hashCode => Object.hash(TooManyRequestsFailure, retryAfter);

  @override
  String toString() => 'TooManyRequestsFailure(retryAfter: $retryAfter)';
}

/// HTTP 422 — içerik topluluk kurallarına uygun bulunmadı (AI moderasyon).
final class ModerationRejectedFailure extends Failure {
  const ModerationRejectedFailure();

  @override
  bool operator ==(Object other) => other is ModerationRejectedFailure;

  @override
  int get hashCode => (ModerationRejectedFailure).hashCode;

  @override
  String toString() => 'ModerationRejectedFailure()';
}

/// İsteğin neden sunucuya ulaşamadığı.
enum NetworkFailureKind {
  /// Cihazın internet bağlantısı yok.
  offline,

  /// Cihaz çevrimiçi ama sunucu yanıt vermiyor / bağlantıyı reddediyor.
  serverUnreachable,
}

/// İstek sunucuya ulaşamadı: çevrimdışı veya sunucuya erişilemiyor.
final class NetworkFailure extends Failure {
  const NetworkFailure({this.kind = NetworkFailureKind.serverUnreachable});

  final NetworkFailureKind kind;

  bool get isOffline => kind == NetworkFailureKind.offline;

  @override
  bool operator ==(Object other) =>
      other is NetworkFailure && other.kind == kind;

  @override
  int get hashCode => Object.hash(NetworkFailure, kind);

  @override
  String toString() => 'NetworkFailure($kind)';
}

/// Yerel veri okunamadı veya yazılamadı.
final class CacheFailure extends Failure {
  const CacheFailure();

  @override
  bool operator ==(Object other) => other is CacheFailure;

  @override
  int get hashCode => (CacheFailure).hashCode;

  @override
  String toString() => 'CacheFailure()';
}

/// SSL pinning veya cihaz bütünlüğü doğrulanamadı.
final class SecurityViolationFailure extends Failure {
  const SecurityViolationFailure();

  @override
  bool operator ==(Object other) => other is SecurityViolationFailure;

  @override
  int get hashCode => (SecurityViolationFailure).hashCode;

  @override
  String toString() => 'SecurityViolationFailure()';
}

/// Sınıflandırılamayan beklenmeyen hata (ör. bozuk yanıt gövdesi).
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure();

  @override
  bool operator ==(Object other) => other is UnexpectedFailure;

  @override
  int get hashCode => (UnexpectedFailure).hashCode;

  @override
  String toString() => 'UnexpectedFailure()';
}
