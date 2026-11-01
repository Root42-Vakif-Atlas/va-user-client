import 'package:dio/dio.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/error/failures.dart';

/// Teknik istisnaları Domain `Failure` tiplerine dönüştürür (TRD §9).
///
/// Yalnızca Data katmanında kullanılır.
abstract final class ErrorMapper {
  /// Herhangi bir hatayı [Failure] tipine dönüştürür.
  ///
  /// [DioException] içine `ErrorInterceptor` tarafından yerleştirilmiş
  /// [AppException] varsa o kullanılır.
  static Failure toFailure(Object error) {
    final exception = switch (error) {
      AppException() => error,
      DioException() => exceptionFromDio(error),
      _ => UnexpectedException(error),
    };

    return switch (exception) {
      ServerException(:final statusCode, :final retryAfter) =>
        failureFromStatusCode(statusCode, retryAfter: retryAfter),
      NetworkException(type: NetworkExceptionType.offline) =>
        const NetworkFailure(kind: NetworkFailureKind.offline),
      NetworkException() => const NetworkFailure(),
      CacheException() => const CacheFailure(),
      SecurityException() => const SecurityViolationFailure(),
      RequestCancelledException() => const UnexpectedFailure(),
      UnexpectedException() => const UnexpectedFailure(),
    };
  }

  /// HTTP durum kodunu hata tablosuna göre [Failure] tipine eşler.
  static Failure failureFromStatusCode(int statusCode, {Duration? retryAfter}) {
    return switch (statusCode) {
      400 => const ServerFailure(
        kind: ServerFailureKind.invalidRequest,
        statusCode: 400,
      ),
      401 || 403 => const UnauthorizedFailure(),
      404 => const ServerFailure(
        kind: ServerFailureKind.notFound,
        statusCode: 404,
      ),
      422 => const ModerationRejectedFailure(),
      423 || 429 => TooManyRequestsFailure(retryAfter: retryAfter),
      >= 500 && < 600 => ServerFailure(
        kind: ServerFailureKind.unavailable,
        statusCode: statusCode,
      ),
      _ => ServerFailure(
        kind: ServerFailureKind.unknown,
        statusCode: statusCode,
      ),
    };
  }

  /// [DioException] tipini uygulama içi [AppException] tipine dönüştürür.
  static AppException exceptionFromDio(DioException error) {
    final inner = error.error;
    if (inner is AppException) {
      return inner;
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => const NetworkException(
        NetworkExceptionType.timeout,
      ),
      DioExceptionType.connectionError => const NetworkException(
        NetworkExceptionType.noConnection,
      ),
      DioExceptionType.badCertificate => const SecurityException(
        SecurityExceptionType.sslPinningFailed,
      ),
      DioExceptionType.badResponse => ServerException(
        statusCode: error.response?.statusCode ?? 0,
        errorCode: _errorCodeFrom(error.response?.data),
        retryAfter: _retryAfterFrom(error.response),
      ),
      DioExceptionType.cancel => const RequestCancelledException(),
      DioExceptionType.unknown => UnexpectedException(inner),
    };
  }

  /// `Retry-After` başlığı (saniye) öncelikli, yoksa gövdedeki `retryAfter`.
  static Duration? _retryAfterFrom(Response<dynamic>? response) {
    final header = int.tryParse(
      response?.headers.value('retry-after')?.trim() ?? '',
    );
    final body = response?.data;
    final seconds =
        header ??
        (body is Map<String, dynamic> && body['retryAfter'] is int
            ? body['retryAfter'] as int
            : null);
    return seconds == null || seconds < 0 ? null : Duration(seconds: seconds);
  }

  static String? _errorCodeFrom(Object? body) {
    if (body is Map<String, dynamic>) {
      final code = body['code'];
      if (code is String) {
        return code;
      }
    }
    return null;
  }
}
