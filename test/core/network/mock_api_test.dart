import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/network_test_utils.dart';
import '../../support/mock_api/mock_api.dart';

void main() {
  group('MockRoute', () {
    test('yol parametrelerini çözer', () {
      final route = MockRoute(
        'GET',
        'monuments/:id/memories',
        (_) => const MockResponse.noContent(),
      );
      expect(route.match('get', 'monuments/m%2042/memories'), {'id': 'm 42'});
      expect(route.match('POST', 'monuments/1/memories'), isNull);
      expect(route.match('GET', 'monuments/1'), isNull);
    });
  });

  group('MockApiAdapter', () {
    test('kök yol önekini atar, JSON gövdeyi ve başlıkları iletir', () async {
      late MockRequest captured;
      final dio = testDio([
        MockRoute('POST', 'items/:id', (request) {
          captured = request;
          return const MockResponse.ok({'ok': true});
        }),
      ]);

      final response = await dio.post<Map<String, dynamic>>(
        'items/7',
        data: {'name': 'Kervansaray'},
        queryParameters: {'lang': 'tr'},
        options: Options(headers: {'Authorization': 'Bearer abc'}),
      );

      expect(response.data, {'ok': true});
      expect(captured.path, 'items/7');
      expect(captured.pathParameters, {'id': '7'});
      expect(captured.queryParameters, {'lang': 'tr'});
      expect(captured.field('name'), 'Kervansaray');
      expect(captured.bearerToken, 'abc');
    });

    test('tanımsız uç nokta 404 not_found döner', () async {
      final dio = testDio([]);
      await expectLater(
        dio.get<void>('missing'),
        throwsA(
          isA<DioException>()
              .having((e) => e.response?.statusCode, 'status', 404)
              .having((e) => e.response?.data, 'body', {'code': 'not_found'}),
        ),
      );
    });

    test('HealthMockApi bağlantı denetimine yanıt verir', () async {
      final dio = Dio(BaseOptions(baseUrl: testBaseUrl))
        ..httpClientAdapter = MockApiAdapter(apis: [const HealthMockApi()]);
      final response = await dio.head<void>('health');
      expect(response.statusCode, 204);
    });
  });
}
