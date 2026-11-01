import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/error_mapper.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/error/failures.dart';

void main() {
  final requestOptions = RequestOptions(path: '/test');

  DioException dioError(DioExceptionType type, {int? statusCode}) {
    return DioException(
      requestOptions: requestOptions,
      type: type,
      response: statusCode == null
          ? null
          : Response<Object?>(
              requestOptions: requestOptions,
              statusCode: statusCode,
              data: const {'code': 'sample_code'},
            ),
    );
  }

  group('ErrorMapper.failureFromStatusCode (TRD §9)', () {
    final cases = <int, Failure>{
      400: const ServerFailure(
        kind: ServerFailureKind.invalidRequest,
        statusCode: 400,
      ),
      401: const UnauthorizedFailure(),
      403: const UnauthorizedFailure(),
      404: const ServerFailure(
        kind: ServerFailureKind.notFound,
        statusCode: 404,
      ),
      422: const ModerationRejectedFailure(),
      500: const ServerFailure(
        kind: ServerFailureKind.unavailable,
        statusCode: 500,
      ),
      502: const ServerFailure(
        kind: ServerFailureKind.unavailable,
        statusCode: 502,
      ),
      503: const ServerFailure(
        kind: ServerFailureKind.unavailable,
        statusCode: 503,
      ),
      504: const ServerFailure(
        kind: ServerFailureKind.unavailable,
        statusCode: 504,
      ),
      409: const ServerFailure(
        kind: ServerFailureKind.unknown,
        statusCode: 409,
      ),
      423: const TooManyRequestsFailure(),
      429: const TooManyRequestsFailure(),
    };

    cases.forEach((statusCode, expected) {
      test('$statusCode → $expected', () {
        expect(ErrorMapper.failureFromStatusCode(statusCode), expected);
      });
    });
  });

  group('ErrorMapper.toFailure', () {
    test('AppException tiplerini eşler', () {
      expect(
        ErrorMapper.toFailure(
          const NetworkException(NetworkExceptionType.timeout),
        ),
        const NetworkFailure(),
      );
      expect(
        ErrorMapper.toFailure(const CacheException('read')),
        const CacheFailure(),
      );
      expect(
        ErrorMapper.toFailure(
          const SecurityException(SecurityExceptionType.sslPinningFailed),
        ),
        const SecurityViolationFailure(),
      );
      expect(
        ErrorMapper.toFailure(const ServerException(statusCode: 422)),
        const ModerationRejectedFailure(),
      );
    });

    test('Dio zaman aşımı ve bağlantı hatası NetworkFailure olur', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.connectionError,
      ]) {
        expect(ErrorMapper.toFailure(dioError(type)), const NetworkFailure());
      }
    });

    test('Dio sertifika hatası SecurityViolationFailure olur', () {
      expect(
        ErrorMapper.toFailure(dioError(DioExceptionType.badCertificate)),
        const SecurityViolationFailure(),
      );
    });

    test('Dio badResponse durum koduna göre eşlenir', () {
      expect(
        ErrorMapper.toFailure(
          dioError(DioExceptionType.badResponse, statusCode: 401),
        ),
        const UnauthorizedFailure(),
      );
    });

    test('DioException içindeki AppException önceliklidir', () {
      final error = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.unknown,
        error: const CacheException('write'),
      );
      expect(ErrorMapper.toFailure(error), const CacheFailure());
    });

    test('sınıflandırılamayan hata UnexpectedFailure olur', () {
      expect(
        ErrorMapper.toFailure(const FormatException()),
        const UnexpectedFailure(),
      );
    });
  });

  group('ErrorMapper.exceptionFromDio', () {
    test('429 yanıtında Retry-After başlığını taşır', () {
      final options = RequestOptions(path: '/auth/login');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<Object?>(
          requestOptions: options,
          statusCode: 429,
          headers: Headers.fromMap({
            'retry-after': ['90'],
          }),
        ),
      );
      expect(
        ErrorMapper.toFailure(error),
        const TooManyRequestsFailure(retryAfter: Duration(seconds: 90)),
      );
    });

    test('Retry-After yoksa gövdedeki retryAfter kullanılır', () {
      final options = RequestOptions(path: '/auth/login');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<Object?>(
          requestOptions: options,
          statusCode: 423,
          data: const {'code': 'account_locked', 'retryAfter': 900},
        ),
      );
      expect(
        ErrorMapper.toFailure(error),
        const TooManyRequestsFailure(retryAfter: Duration(minutes: 15)),
      );
    });

    test('yanıt gövdesindeki hata kodunu taşır', () {
      final exception = ErrorMapper.exceptionFromDio(
        dioError(DioExceptionType.badResponse, statusCode: 400),
      );
      expect(exception, isA<ServerException>());
      expect((exception as ServerException).errorCode, 'sample_code');
    });

    test('iptal edilen istek RequestCancelledException olur', () {
      expect(
        ErrorMapper.exceptionFromDio(dioError(DioExceptionType.cancel)),
        isA<RequestCancelledException>(),
      );
    });
  });
}
