import 'package:dio/dio.dart';
import 'package:vakif_atlas/core/events/user_activity_events.dart';
import 'package:vakif_atlas/core/network/network_constants.dart';
import 'package:vakif_atlas/features/gamification/data/repositories/gamification_repository_impl.dart';
import 'package:vakif_atlas/features/gamification/data/sources/gamification_remote_data_source.dart';
import 'package:vakif_atlas/features/gamification/domain/usecases/gamification_usecases.dart';
import 'package:vakif_atlas/features/gamification/presentation/cubit/gamification_cubit.dart';

import '../support/mock_api/auth/auth_mock_api.dart';
import '../support/mock_api/auth/mock_user_store.dart';
import '../support/mock_api/gamification/gamification_mock_api.dart';
import '../support/mock_api/gamification/mock_activity_ledger.dart';
import '../support/mock_api/mock_mailbox.dart';
import '../support/mock_api/route_planner/mock_route_store.dart';
import '../support/mock_api/route_planner/route_mock_api.dart';
import 'network_test_utils.dart';

/// Demo hesabının kimliği (`AuthMockApi`).
const String gamificationDemoUserId = 'usr_demo_001';

/// Mock Gamification API'ye süreç içinde bağlı ortam. Rota mock API'si
/// deftere bağlıdır: oturum açıkken oluşturulan rota XP kazandırır.
final class GamificationTestEnvironment {
  factory GamificationTestEnvironment({DateTime Function()? clock}) {
    final now = clock ?? () => DateTime.utc(2026, 10, 19, 9);
    final auth = AuthMockApi.withClock(
      store: InMemoryMockUserStore(),
      mailbox: MockMailbox(),
      clock: now,
    );
    final ledger = MockActivityLedger.withClock(
      store: InMemoryMockActivityStore(),
      auth: auth,
      clock: now,
    );
    final routes = RouteMockApi.withClock(
      store: InMemoryMockRouteStore(),
      clock: now,
      ledger: ledger,
    );
    final dio = testDio([
      ...auth.routes,
      ...routes.routes,
      ...GamificationMockApi(ledger, auth).routes,
    ]);
    final environment = GamificationTestEnvironment._(dio, ledger);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = environment._token;
          if (token != null && !options.path.startsWith('auth/')) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
    return environment;
  }

  GamificationTestEnvironment._(this.dio, this.ledger)
    : repository = GamificationRepositoryImpl(
        GamificationRemoteDataSourceImpl(dio),
      );

  final Dio dio;
  final MockActivityLedger ledger;
  final GamificationRepositoryImpl repository;
  final UserActivityEvents events = UserActivityEvents();
  String? _token;

  GetGamificationProfileUseCase get getProfile =>
      GetGamificationProfileUseCase(repository);

  AcknowledgeUnlocksUseCase get acknowledge =>
      AcknowledgeUnlocksUseCase(repository);

  GamificationCubit cubit() =>
      GamificationCubit(getProfile, acknowledge, events);

  /// Demo hesabıyla giriş yapar.
  Future<void> signIn() async {
    final response = await dio.post<Map<String, dynamic>>(
      'auth/login',
      data: {
        'email': AuthMockApi.demoEmail,
        'password': AuthMockApi.demoPassword,
      },
    );
    _token = response.data!['accessToken'] as String;
  }

  void signOut() => _token = null;

  /// Rota mock API'si üzerinden rota oluşturur (oturum açıksa deftere yazılır).
  Future<void> createRoute(List<String> monumentIds) async {
    await dio.post<void>(
      'routes',
      data: {
        'name': 'Test rotası',
        'stops': [
          for (final id in monumentIds) {'monumentId': id, 'visitMinutes': 30},
        ],
      },
      options: Options(
        headers: {
          NetworkConstants.installationIdHeader:
              '0b6f6a0e-1f6c-4d3a-9b1e-3c2d1e0f9a8b',
        },
      ),
    );
  }

  Future<void> record(
    MockActivityKind kind,
    List<String> monumentIds, {
    required DateTime at,
  }) => ledger.record(
    gamificationDemoUserId,
    MockActivity(
      kind: kind,
      refId: '${kind.name}_${at.microsecondsSinceEpoch}',
      monumentIds: monumentIds,
      at: at,
    ),
  );
}
