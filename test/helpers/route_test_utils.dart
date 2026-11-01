import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/events/user_activity_events.dart';
import 'package:vakif_atlas/core/network/session_events.dart';
import 'package:vakif_atlas/core/storage/installation_id_service.dart';
import 'package:vakif_atlas/features/route_planner/data/repositories/route_repository_impl.dart';
import 'package:vakif_atlas/features/route_planner/data/sources/route_remote_data_source.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';

import '../support/mock_api/route_planner/mock_route_store.dart';
import '../support/mock_api/route_planner/route_mock_api.dart';
import 'network_test_utils.dart';

class _FakeInstallation extends Mock implements InstallationIdService {}

/// Mock rota API'si (OSRM fikstürlü karayolu bacakları) ile hesaplanmış
/// gerçek bir rota.
Future<TravelRoute> createTestRoute(
  String name,
  List<String> monumentIds, {
  String languageCode = 'tr',
}) async {
  final installation = _FakeInstallation();
  when(installation.resolve)
      .thenAnswer((_) async => '0b6f6a0e-1f6c-4d3a-9b1e-3c2d1e0f9a8b');
  final repository = RouteRepositoryImpl(
    RouteRemoteDataSourceImpl(
      testDio(RouteMockApi(InMemoryMockRouteStore()).routes),
      installation,
    ),
    UserActivityEvents(),
    SessionEvents(),
  );
  final result = await repository.createRoute(
    plan: RoutePlan(
      name: name,
      stops: [
        RouteStopPlan(
          monumentId: monumentIds.first,
          breaks: [RouteBreak.ofKind(RouteBreakKind.meal)],
        ),
        for (final id in monumentIds.skip(1)) RouteStopPlan(monumentId: id),
      ],
    ),
    languageCode: languageCode,
  );
  return result.fold((failure) => throw StateError('$failure'), (r) => r);
}
