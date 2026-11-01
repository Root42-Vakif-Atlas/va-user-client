/// Mock sunucunun rota deposu: kurulum kimliği → rota kayıtları (JSON).
abstract interface class MockRouteStore {
  Future<List<Map<String, dynamic>>> load(String installationId);

  Future<void> save(String installationId, List<Map<String, dynamic>> routes);
}

/// Testler için bellek içi depo.
class InMemoryMockRouteStore implements MockRouteStore {
  final Map<String, List<Map<String, dynamic>>> _routes = {};

  @override
  Future<List<Map<String, dynamic>>> load(String installationId) async => [
    ...?_routes[installationId],
  ];

  @override
  Future<void> save(
    String installationId,
    List<Map<String, dynamic>> routes,
  ) async {
    _routes[installationId] = [...routes];
  }
}
