import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:vakif_atlas/core/error/error_mapper.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/network/interceptors/correlation_interceptor.dart';
import 'package:vakif_atlas/core/network/interceptors/error_interceptor.dart';
import 'package:vakif_atlas/core/network/network_constants.dart';
import 'package:vakif_atlas/core/network/network_status.dart';
import 'package:vakif_atlas/core/observability/telemetry_service.dart';

import '../../helpers/network_test_utils.dart';
import '../../support/mock_api/mock_api.dart';

class _MockTelemetry extends Mock implements TelemetryService {}

/// Sunucuya bağlanamayan adaptör ([reason] → `DioException.error`).
class _FailingAdapter implements HttpClientAdapter {
  _FailingAdapter(this.reason);

  final String reason;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    throw DioException.connectionError(
      requestOptions: options,
      reason: reason,
      error: reason,
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('ErrorInterceptor', () {
    late _MockTelemetry telemetry;

    setUp(() {
      telemetry = _MockTelemetry();
      when(
        () => telemetry.recordError(
          any<Object>(),
          any(),
          fatal: any(named: 'fatal'),
          reason: any(named: 'reason'),
        ),
      ).thenAnswer((_) async {});
    });

    Dio buildDio(int status) {
      return testDio([
        MockRoute('GET', 'resource', (_) => MockResponse.error(status, 'code')),
      ])..interceptors.add(ErrorInterceptor(telemetry, FakeNetworkStatus()));
    }

    test('422 → ServerException → ModerationRejectedFailure', () async {
      try {
        await buildDio(422).get<void>('resource');
        fail('DioException bekleniyordu');
      } on DioException catch (error) {
        expect(error.error, isA<ServerException>());
        expect(ErrorMapper.toFailure(error), const ModerationRejectedFailure());
      }
    });

    test('5xx telemetriye raporlanır', () async {
      await expectLater(
        buildDio(503).get<void>('resource'),
        throwsA(isA<DioException>()),
      );
      verify(
        () => telemetry.recordError(
          any<Object>(),
          any(),
          reason: any(named: 'reason'),
        ),
      ).called(1);
    });

    test('4xx telemetriye raporlanmaz', () async {
      await expectLater(
        buildDio(400).get<void>('resource'),
        throwsA(isA<DioException>()),
      );
      verifyNever(
        () => telemetry.recordError(
          any<Object>(),
          any(),
          reason: any(named: 'reason'),
        ),
      );
    });

    Dio unreachableDio(NetworkStatus network, {String reason = 'refused'}) {
      return testDio([])
        ..httpClientAdapter = _FailingAdapter(reason)
        ..interceptors.add(ErrorInterceptor(telemetry, network));
    }

    Future<Failure> failureOf(Dio dio) async {
      try {
        await dio.get<void>('resource');
      } on DioException catch (error) {
        return ErrorMapper.toFailure(error);
      }
      throw StateError('DioException bekleniyordu');
    }

    test(
      'cihaz çevrimiçiyken bağlantı hatası → sunucuya ulaşılamıyor',
      () async {
        expect(
          await failureOf(unreachableDio(FakeNetworkStatus())),
          const NetworkFailure(),
        );
      },
    );

    test('cihaz çevrimdışıyken bağlantı hatası → internet yok', () async {
      expect(
        await failureOf(unreachableDio(FakeNetworkStatus(online: false))),
        const NetworkFailure(kind: NetworkFailureKind.offline),
      );
    });

    test('ad çözümlenemiyorsa arayüz açık olsa da internet yok', () async {
      expect(
        await failureOf(
          unreachableDio(
            FakeNetworkStatus(),
            reason: "Failed host lookup: 'api.vakifatlas.gov.tr'",
          ),
        ),
        const NetworkFailure(kind: NetworkFailureKind.offline),
      );
    });
  });

  group('CorrelationInterceptor', () {
    late Map<String, String> received;

    Dio buildDio({String? integrity}) {
      final dio = testDio([
        MockRoute('GET', 'resource', (request) {
          received = request.headers;
          return const MockResponse.noContent();
        }),
      ]);
      dio.interceptors.add(
        CorrelationInterceptor(
          uuid: const Uuid(),
          packageInfo: PackageInfo(
            appName: 'Vakıf Atlas',
            packageName: 'tr.gov.vgm.vakif_atlas',
            version: '1.2.3',
            buildNumber: '45',
          ),
          languageCode: () => 'en',
          deviceIntegrity: () => integrity,
        ),
      );
      return dio;
    }

    test('izlenebilirlik başlıklarını ekler', () async {
      await buildDio().get<void>('resource');

      expect(
        received[NetworkConstants.correlationIdHeader.toLowerCase()],
        matches(RegExp(r'^[0-9a-f-]{36}$')),
      );
      expect(received['accept-language'], 'en');
      expect(
        received[NetworkConstants.appVersionHeader.toLowerCase()],
        '1.2.3+45',
      );
      expect(
        received[NetworkConstants.platformHeader.toLowerCase()],
        isNotEmpty,
      );
      expect(
        received.containsKey(
          NetworkConstants.deviceIntegrityHeader.toLowerCase(),
        ),
        isFalse,
      );
    });

    test('var olan correlation id korunur (tekrar denemeler)', () async {
      await buildDio().get<void>(
        'resource',
        options: Options(
          headers: {NetworkConstants.correlationIdHeader: 'existing-id'},
        ),
      );
      expect(
        received[NetworkConstants.correlationIdHeader.toLowerCase()],
        'existing-id',
      );
    });

    test('isteğin açıkça belirttiği içerik dili korunur', () async {
      await buildDio().get<void>(
        'resource',
        options: Options(
          headers: {NetworkConstants.acceptLanguageHeader: 'tr'},
        ),
      );
      expect(received['accept-language'], 'tr');
    });

    test('cihaz bütünlüğü durumu biliniyorsa başlığa eklenir', () async {
      await buildDio(integrity: 'compromised').get<void>('resource');
      expect(
        received[NetworkConstants.deviceIntegrityHeader.toLowerCase()],
        'compromised',
      );
    });
  });
}
