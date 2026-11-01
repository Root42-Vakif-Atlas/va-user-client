import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/features/auth/domain/repositories/auth_repository.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/features/route_planner/domain/repositories/route_repository.dart';
import 'package:vakif_atlas/features/saved_monuments/data/repositories/saved_monuments_repository_impl.dart';
import 'package:vakif_atlas/features/saved_monuments/data/sources/saved_monuments_local_data_source.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/entities/saved_monument.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/repositories/saved_monuments_repository.dart';

import '../../../helpers/saved_monuments_test_utils.dart';
import '../../../helpers/test_di.dart';
import '../../../support/mock_api/auth/auth_mock_api.dart';

/// Rotalar ve kaydedilenler oturum açıkken hesaba aittir: uygulamanın
/// gerçek DI grafiği + sahte backend ile uçtan uca.
void main() {
  tearDown(resetDependencies);

  RoutePlan plan(String name) => RoutePlan(
    name: name,
    stops: [
      RouteStopPlan(monumentId: 'selimiye-camii'),
      RouteStopPlan(monumentId: 'suleymaniye-camii'),
    ],
  );

  Future<List<String>> routeNames() async => [
    for (final route in (await getIt<RouteRepository>().getRoutes(
      languageCode: 'tr',
    )).getOrNull()!)
      route.name,
  ];

  Future<void> signIn() async {
    final result = await getIt<AuthRepository>().login(
      email: AuthMockApi.demoEmail,
      password: AuthMockApi.demoPassword,
    );
    expect(result.isRight, isTrue);
  }

  test('misafir rotası girişte hesaba taşınır; çıkışta görünmez, '
      'yeniden girişte geri gelir', () async {
    await TestDependencies.setUp();
    final routes = getIt<RouteRepository>();
    final changes = <RouteChangeType>[];
    final subscription = routes.changes.listen(
      (change) => changes.add(change.type),
    );

    await routes.createRoute(plan: plan('Misafir'), languageCode: 'tr');
    await signIn();
    await routes.createRoute(plan: plan('Hesap'), languageCode: 'tr');
    expect(await routeNames(), unorderedEquals(['Misafir', 'Hesap']));

    await getIt<AuthRepository>().logout();
    expect(await routeNames(), isEmpty);

    await signIn();
    expect(await routeNames(), unorderedEquals(['Misafir', 'Hesap']));
    // Liste ve detay ekranları oturum değişiminde kendini yeniler.
    expect(
      changes.where((type) => type == RouteChangeType.scopeChanged),
      hasLength(3),
    );
    await subscription.cancel();
  });

  test('kaydedilenler girişte hesaba eşitlenir; çıkışta cihazdan '
      'kaldırılır, yeniden girişte geri gelir', () async {
    await TestDependencies.setUp();
    getIt.registerSingleton<SavedMonumentsLocalDataSource>(
      InMemorySavedMonumentsLocalDataSource(),
    );
    final repository =
        getIt<SavedMonumentsRepository>() as SavedMonumentsRepositoryImpl;
    Future<List<String>> ids() async {
      await repository.synchronize();
      return [
        for (final item in (await repository.getSaved()).getOrNull()!)
          item.monumentId,
      ];
    }

    await repository.save(
      SavedMonument(
        monumentId: 'selimiye-camii',
        savedAt: DateTime.utc(2026, 10, 21, 9),
      ),
    );
    await signIn();
    await Future<void>.delayed(Duration.zero);
    expect(await ids(), ['selimiye-camii']);

    await getIt<AuthRepository>().logout();
    await Future<void>.delayed(Duration.zero);
    expect(await ids(), isEmpty);

    await signIn();
    await Future<void>.delayed(Duration.zero);
    expect(await ids(), ['selimiye-camii']);
  });
}
