import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/network/interceptors/retry_interceptor.dart';

import '../../helpers/network_test_utils.dart';
import '../../support/mock_api/mock_api.dart';

void main() {
  late List<Duration> waits;
  late int calls;

  setUp(() {
    waits = [];
    calls = 0;
  });

  Dio buildDio(String method, List<int> statuses) {
    final dio = testDio([
      MockRoute(method, 'resource', (_) {
        final status = statuses[calls.clamp(0, statuses.length - 1)];
        calls++;
        return status == 200
            ? const MockResponse.ok({'ok': true})
            : MockResponse.error(status, 'error');
      }),
    ]);
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        maxJitter: Duration.zero,
        wait: (delay) async => waits.add(delay),
      ),
    );
    return dio;
  }

  test('GET 5xx sonrası üstel beklemeyle tekrar dener ve başarır', () async {
    final dio = buildDio('GET', [503, 502, 200]);

    final response = await dio.get<Map<String, dynamic>>('resource');

    expect(response.data, {'ok': true});
    expect(calls, 3);
    expect(waits, const [
      Duration(milliseconds: 500),
      Duration(milliseconds: 1000),
    ]);
  });

  test('en fazla maxRetries kez tekrar dener', () async {
    final dio = buildDio('GET', [500]);

    await expectLater(dio.get<void>('resource'), throwsA(isA<DioException>()));
    expect(calls, 4);
    expect(waits, const [
      Duration(milliseconds: 500),
      Duration(milliseconds: 1000),
      Duration(milliseconds: 2000),
    ]);
  });

  test('POST (idempotent olmayan) istek tekrarlanmaz', () async {
    final dio = buildDio('POST', [503, 200]);

    await expectLater(dio.post<void>('resource'), throwsA(isA<DioException>()));
    expect(calls, 1);
    expect(waits, isEmpty);
  });

  test('4xx hatası tekrarlanmaz', () async {
    final dio = buildDio('GET', [404, 200]);

    await expectLater(dio.get<void>('resource'), throwsA(isA<DioException>()));
    expect(calls, 1);
  });

  test('jitter maxJitter sınırını aşmaz', () {
    final interceptor = RetryInterceptor(dio: Dio(), random: math.Random(42));
    for (var attempt = 0; attempt < 3; attempt++) {
      final base = const Duration(milliseconds: 500) * math.pow(2, attempt);
      final delay = interceptor.delayFor(attempt);
      expect(delay, greaterThanOrEqualTo(base));
      expect(delay, lessThan(base + const Duration(milliseconds: 250)));
    }
  });
}
