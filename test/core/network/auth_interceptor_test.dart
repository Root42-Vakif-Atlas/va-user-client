import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/network/interceptors/auth_interceptor.dart';
import 'package:vakif_atlas/core/network/network_constants.dart';
import 'package:vakif_atlas/core/network/session_events.dart';
import 'package:vakif_atlas/core/storage/secure_storage_service.dart';

import '../../helpers/network_test_utils.dart';
import '../../support/mock_api/mock_api.dart';

class _MockSecureStorage extends Mock implements SecureStorageService {}

class _FakeRefresher implements AuthTokenRefresher {
  _FakeRefresher(this.onRefresh);

  final Future<String?> Function() onRefresh;
  int calls = 0;

  @override
  Future<String?> refreshAccessToken() {
    calls++;
    return onRefresh();
  }
}

void main() {
  late _MockSecureStorage storage;
  late SessionEvents sessionEvents;
  late String? currentToken;
  late int protectedCalls;

  setUp(() {
    storage = _MockSecureStorage();
    sessionEvents = SessionEvents();
    currentToken = 'expired-token';
    protectedCalls = 0;
    when(storage.getAccessToken).thenAnswer((_) async => currentToken);
  });

  tearDown(() => sessionEvents.dispose());

  MockRoute protectedRoute() => MockRoute('GET', 'protected', (request) {
    protectedCalls++;
    return request.bearerToken == 'fresh-token'
        ? const MockResponse.ok({'data': 'gizli'})
        : MockResponse.error(401, 'unauthorized');
  });

  Dio buildDio(AuthTokenRefresher refresher, {List<MockRoute>? routes}) {
    final dio = testDio(routes ?? [protectedRoute()]);
    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        storage: storage,
        refresher: refresher,
        sessionEvents: sessionEvents,
      ),
    );
    return dio;
  }

  test('erişim anahtarını Bearer başlığı olarak ekler', () async {
    currentToken = 'fresh-token';
    final dio = buildDio(_FakeRefresher(() async => null));

    final response = await dio.get<Map<String, dynamic>>('protected');

    expect(response.data, {'data': 'gizli'});
  });

  test('anahtar okunamazsa istek engellenmez; anahtarsız gönderilir', () async {
    when(storage.getAccessToken)
        .thenThrow(const CacheException('secure_storage.read'));
    String? sentAuthorization = 'unset';
    final dio = buildDio(
      _FakeRefresher(() async => null),
      routes: [
        MockRoute('GET', 'public', (request) {
          sentAuthorization = request.bearerToken;
          return const MockResponse.ok({'data': 'açık'});
        }),
      ],
    );

    final response = await dio.get<Map<String, dynamic>>('public');

    expect(response.data, {'data': 'açık'});
    expect(sentAuthorization, isNull);
  });

  test('401 → anahtar yenilenir → istek otomatik tekrarlanır', () async {
    final refresher = _FakeRefresher(() async {
      currentToken = 'fresh-token';
      return currentToken;
    });
    final dio = buildDio(refresher);

    final response = await dio.get<Map<String, dynamic>>('protected');

    expect(response.data, {'data': 'gizli'});
    expect(refresher.calls, 1);
    expect(protectedCalls, 2);
  });

  test(
    'eşzamanlı 401 yanıtlarında anahtar yalnızca bir kez yenilenir',
    () async {
      final refresher = _FakeRefresher(() async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        currentToken = 'fresh-token';
        return currentToken;
      });
      final dio = buildDio(refresher);

      final responses = await Future.wait([
        dio.get<Map<String, dynamic>>('protected'),
        dio.get<Map<String, dynamic>>('protected'),
        dio.get<Map<String, dynamic>>('protected'),
      ]);

      expect(responses.map((r) => r.statusCode), everyElement(200));
      expect(refresher.calls, 1);
    },
  );

  test('yenileme başarısızsa oturum sona erer ve 401 iletilir', () async {
    final dio = buildDio(_FakeRefresher(() async => null));
    final expired = expectLater(sessionEvents.onSessionExpired, emits(null));

    await expectLater(
      dio.get<void>('protected'),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          401,
        ),
      ),
    );
    await expired;
  });

  test(
    'skipAuth isteğinde başlık eklenmez ve 401 yenileme tetiklemez',
    () async {
      String? receivedToken = 'not-called';
      final refresher = _FakeRefresher(() async => 'fresh-token');
      final dio = buildDio(
        refresher,
        routes: [
          MockRoute('POST', 'auth/login', (request) {
            receivedToken = request.bearerToken;
            return MockResponse.error(401, 'invalid_credentials');
          }),
        ],
      );

      await expectLater(
        dio.post<void>(
          'auth/login',
          options: Options(extra: {RequestExtras.skipAuth: true}),
        ),
        throwsA(isA<DioException>()),
      );
      expect(receivedToken, isNull);
      expect(refresher.calls, 0);
    },
  );

  test('yenilenmiş anahtarla da 401 alınırsa döngüye girmez', () async {
    final refresher = _FakeRefresher(() async {
      currentToken = 'still-invalid';
      return currentToken;
    });
    final dio = buildDio(refresher);

    await expectLater(dio.get<void>('protected'), throwsA(isA<DioException>()));
    expect(refresher.calls, 1);
    expect(protectedCalls, 2);
  });

  test('anahtarsız (misafir) isteğin 401\'i yenileme ve oturum sonu '
      'tetiklemez', () async {
    currentToken = null;
    var expired = false;
    final subscription = sessionEvents.onSessionExpired.listen(
      (_) => expired = true,
    );
    final refresher = _FakeRefresher(() async => 'fresh-token');
    final dio = buildDio(refresher);

    await expectLater(dio.get<void>('protected'), throwsA(isA<DioException>()));
    await subscription.cancel();

    expect(refresher.calls, 0);
    expect(expired, isFalse);
  });

  test('yenileme ağ hatasıyla biterse oturum korunur ve ağ hatası '
      'iletilir', () async {
    var expired = false;
    final subscription = sessionEvents.onSessionExpired.listen(
      (_) => expired = true,
    );
    final dio = buildDio(
      _FakeRefresher(
        () => Future<String?>.error(
          DioException.connectionError(
            requestOptions: RequestOptions(path: 'auth/refresh'),
            reason: 'offline',
          ),
        ),
      ),
    );

    await expectLater(
      dio.get<void>('protected'),
      throwsA(
        isA<DioException>().having(
          (e) => e.type,
          'type',
          DioExceptionType.connectionError,
        ),
      ),
    );
    await subscription.cancel();

    expect(expired, isFalse);
  });

  test(
    'eşzamanlı başarısız yenilemede oturum sonu bir kez bildirilir',
    () async {
      var expiredCount = 0;
      final subscription = sessionEvents.onSessionExpired.listen(
        (_) => expiredCount++,
      );
      final dio = buildDio(
        _FakeRefresher(() async {
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return null;
        }),
      );

      await Future.wait([
        for (var i = 0; i < 3; i++)
          dio.get<void>('protected').then<void>((_) {}, onError: (_) {}),
      ]);
      await subscription.cancel();

      expect(expiredCount, 1);
    },
  );
}
