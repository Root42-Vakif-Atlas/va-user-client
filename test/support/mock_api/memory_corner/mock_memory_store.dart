/// Mock sunucunun anı deposu: anı kayıtları + anı başına bildiren
/// kullanıcılar (JSON). `null` → henüz kayıt yok (başlangıç verisi
/// yüklenir).
abstract interface class MockMemoryStore {
  Future<Map<String, dynamic>?> load();

  Future<void> save(Map<String, dynamic> state);
}

/// Testler için bellek içi depo.
class InMemoryMockMemoryStore implements MockMemoryStore {
  InMemoryMockMemoryStore([this._state]);

  Map<String, dynamic>? _state;

  @override
  Future<Map<String, dynamic>?> load() async => _state;

  @override
  Future<void> save(Map<String, dynamic> state) async => _state = state;
}
