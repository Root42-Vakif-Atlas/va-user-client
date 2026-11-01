import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/network/http_transport.dart';
import 'package:vakif_atlas/core/network/network_constants.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:vakif_atlas/features/auth/domain/entities/auth_session_event.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/domain/repositories/auth_repository.dart';

import '../../../helpers/test_config.dart';
import '../../../support/mock_api/auth/auth_mock_api.dart';
import '../../../support/mock_api/auth/mock_user_store.dart';
import '../../../support/mock_api/mock_api.dart';
import '../../../support/mock_api/mock_mailbox.dart';

class _InMemorySecureStorage extends Mock implements FlutterSecureStorage {
  final Map<String, String> values = {};
}

/// Gerçek DI grafiği + Mock API ile uçtan uca oturum akışı:
/// giriş → korumalı istek → anahtar süresi dolar → otomatik yenileme →
/// yenileme anahtarı iptal → oturum sona erer.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DateTime now;
  late _InMemorySecureStorage storage;

  setUp(() async {
    setUpPlatformPluginMocks();
    now = DateTime(2026, 10, 17, 12);
    storage = _InMemorySecureStorage();
    when(() => storage.read(key: any(named: 'key'))).thenAnswer(
      (invocation) async =>
          storage.values[invocation.namedArguments[#key] as String],
    );
    when(
      () => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((invocation) async {
      storage.values[invocation.namedArguments[#key] as String] =
          invocation.namedArguments[#value] as String;
    });
    when(() => storage.delete(key: any(named: 'key'))).thenAnswer(
      (invocation) async =>
          storage.values.remove(invocation.namedArguments[#key] as String),
    );

    await configureDependencies(testAppConfig());
    final authMockApi = AuthMockApi.withClock(
      store: InMemoryMockUserStore(),
      mailbox: MockMailbox(),
      clock: () => now,
    );
    getIt
      ..allowReassignment = true
      ..registerSingleton<FlutterSecureStorage>(storage)
      ..registerSingleton<AuthMockApi>(authMockApi)
      ..registerSingleton<HttpTransport>(
        MockHttpTransport(
          MockApiAdapter(apis: [const HealthMockApi(), authMockApi]),
        ),
      );
  });

  tearDown(resetDependencies);

  test('hatalı kimlik bilgisi InvalidCredentialsFailure döner', () async {
    final result = await getIt<AuthRepository>().login(
      email: AuthMockApi.demoEmail,
      password: 'yanlis-sifre',
    );
    expect(
      result,
      const Left<Failure, UserEntity>(
        AuthFailure(AuthFailureReason.invalidCredentials),
      ),
    );
  });

  test('anahtar süresi dolunca otomatik yenilenir, iptal edilince oturum '
      'sona erer', () async {
    final repository = getIt<AuthRepository>();
    final remote = getIt<AuthRemoteDataSource>();
    final events = <AuthSessionEvent>[];
    final subscription = repository.sessionEvents.listen(events.add);

    final login = await repository.login(
      email: AuthMockApi.demoEmail,
      password: AuthMockApi.demoPassword,
    );
    expect(login.isRight, isTrue);
    expect((await remote.fetchCurrentUser()).email, AuthMockApi.demoEmail);

    // Erişim anahtarının süresi dolar → 401 → refresh → istek tekrarlanır.
    final firstAccessToken = storage.values['auth.access_token'];
    now = now.add(AuthMockApi.accessTokenLifetime);
    expect((await remote.fetchCurrentUser()).email, AuthMockApi.demoEmail);
    expect(storage.values['auth.access_token'], isNot(firstAccessToken));

    // Yenileme anahtarı da geçersiz → oturum sona erer.
    storage.values['auth.refresh_token'] = 'revoked';
    now = now.add(AuthMockApi.accessTokenLifetime);
    await expectLater(
      remote.fetchCurrentUser(),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          401,
        ),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(events.last, const SessionExpired());
    expect(storage.values.containsKey('auth.access_token'), isFalse);
    await subscription.cancel();
  });

  test('API istemcisi izlenebilirlik başlıklarını gönderir', () async {
    late MockRequest received;
    getIt.registerSingleton<HttpTransport>(
      MockHttpTransport(
        MockApiAdapter(apis: [_CapturingApi((request) => received = request)]),
      ),
    );

    await getIt<Dio>(instanceName: DioNames.api).get<void>('capture');

    expect(received.headers, contains('x-correlation-id'));
    expect(received.headers['accept-language'], isIn(['tr', 'en']));
    expect(received.headers['x-app-version'], '1.0.0+1');
  });
}

final class _CapturingApi implements MockApi {
  _CapturingApi(this.onRequest);

  final void Function(MockRequest request) onRequest;

  @override
  List<MockRoute> get routes => [
    MockRoute('GET', 'capture', (request) {
      onRequest(request);
      return const MockResponse.noContent();
    }),
  ];
}
