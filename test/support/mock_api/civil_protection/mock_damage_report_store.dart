/// Mock sunucunun rapor deposu: rapor kayıtları + kayıt numarası sayacı
/// (JSON). `null` → henüz kayıt yok (başlangıç verisi yüklenir).
abstract interface class MockDamageReportStore {
  Future<Map<String, dynamic>?> load();

  Future<void> save(Map<String, dynamic> state);
}

/// Testler için bellek içi depo.
class InMemoryMockDamageReportStore implements MockDamageReportStore {
  InMemoryMockDamageReportStore([this._state]);

  Map<String, dynamic>? _state;

  @override
  Future<Map<String, dynamic>?> load() async => _state;

  @override
  Future<void> save(Map<String, dynamic> state) async => _state = state;
}
