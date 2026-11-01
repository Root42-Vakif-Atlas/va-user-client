import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';

/// [Failure] tiplerini kullanıcıya gösterilecek yerelleştirilmiş mesaja
/// dönüştürür (TRD §9). BLoC'lar `Failure` taşır, dönüşüm UI'da yapılır.
extension FailureMessage on Failure {
  String toUserMessage(AppLocalizations l10n) {
    return switch (this) {
      ServerFailure(kind: ServerFailureKind.invalidRequest) =>
        l10n.errorInvalidRequest,
      ServerFailure(kind: ServerFailureKind.notFound) => l10n.errorNotFound,
      ServerFailure(kind: ServerFailureKind.unavailable) =>
        l10n.errorServerUnavailable,
      ServerFailure(kind: ServerFailureKind.unknown) => l10n.errorUnexpected,
      UnauthorizedFailure() => l10n.errorUnauthorized,
      AuthFailure(:final reason) => _authMessage(l10n, reason),
      TooManyRequestsFailure(:final retryAfter) => _rateLimitMessage(
        l10n,
        retryAfter,
      ),
      ModerationRejectedFailure() => l10n.errorModerationRejected,
      NetworkFailure(kind: NetworkFailureKind.offline) => l10n.errorOffline,
      NetworkFailure(kind: NetworkFailureKind.serverUnreachable) =>
        l10n.errorServerUnreachable,
      CacheFailure() => l10n.errorCacheRead,
      SecurityViolationFailure() => l10n.errorSecurityViolation,
      UnexpectedFailure() => l10n.errorUnexpected,
    };
  }

  static String _authMessage(AppLocalizations l10n, AuthFailureReason reason) {
    return switch (reason) {
      AuthFailureReason.invalidCredentials => l10n.errorInvalidCredentials,
      AuthFailureReason.emailNotVerified => l10n.errorEmailNotVerified,
      AuthFailureReason.invalidVerificationCode =>
        l10n.errorInvalidVerificationCode,
      AuthFailureReason.verificationCodeExpired =>
        l10n.errorVerificationCodeExpired,
      AuthFailureReason.weakPassword => l10n.errorWeakPassword,
      AuthFailureReason.invalidCurrentPassword =>
        l10n.errorInvalidCurrentPassword,
    };
  }

  /// Bekleme süresi bilinmiyorsa genel mesaj; biliniyorsa yukarı yuvarlanmış
  /// dakika sayısı gösterilir.
  static String _rateLimitMessage(AppLocalizations l10n, Duration? retryAfter) {
    if (retryAfter == null || retryAfter <= Duration.zero) {
      return l10n.errorTooManyRequests;
    }
    final minutes = (retryAfter.inSeconds / 60).ceil();
    return l10n.errorTooManyRequestsRetry(minutes);
  }
}
