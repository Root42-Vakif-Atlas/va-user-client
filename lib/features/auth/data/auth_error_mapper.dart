import 'package:dio/dio.dart';
import 'package:vakif_atlas/core/error/error_mapper.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/error/failures.dart';

/// Kimlik doğrulama uç noktalarının makine okunur hata kodlarını
/// [AuthFailure] nedenlerine eşler; diğer hatalar çekirdek eşleyiciye düşer.
abstract final class AuthErrorMapper {
  static const Map<String, AuthFailureReason> _reasons = {
    'invalid_credentials': AuthFailureReason.invalidCredentials,
    'email_not_verified': AuthFailureReason.emailNotVerified,
    'invalid_code': AuthFailureReason.invalidVerificationCode,
    'code_expired': AuthFailureReason.verificationCodeExpired,
    'weak_password': AuthFailureReason.weakPassword,
    'invalid_current_password': AuthFailureReason.invalidCurrentPassword,
  };

  static Failure toFailure(Object error) {
    final exception = error is DioException
        ? ErrorMapper.exceptionFromDio(error)
        : error;
    if (exception is ServerException) {
      final reason = _reasons[exception.errorCode];
      if (reason != null) {
        return AuthFailure(reason, retryAfter: exception.retryAfter);
      }
    }
    return ErrorMapper.toFailure(error);
  }
}
