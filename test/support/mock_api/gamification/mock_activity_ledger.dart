import 'dart:async';

import '../auth/auth_mock_api.dart';
import '../mock_api.dart';

/// XP kazandıran katkı türleri.
enum MockActivityKind { routeCreated, memoryShared, damageReported }

/// Mock sunucunun katkı kaydı (gerçek sistemde servislerin yayınladığı
/// `RouteCreated`, `MemoryPublished`, `DamageReportSubmitted` olayları).
final class MockActivity {
  const MockActivity({
    required this.kind,
    required this.refId,
    required this.monumentIds,
    required this.at,
  });

  factory MockActivity.fromJson(Map<String, dynamic> json) => MockActivity(
    kind: MockActivityKind.values.byName(json['kind'] as String),
    refId: json['refId'] as String,
    monumentIds: [for (final id in json['monumentIds'] as List) id as String],
    at: DateTime.parse(json['at'] as String),
  );

  final MockActivityKind kind;
  final String refId;
  final List<String> monumentIds;
  final DateTime at;

  Map<String, dynamic> toJson() => {
    'kind': kind.name,
    'refId': refId,
    'monumentIds': monumentIds,
    'at': at.toUtc().toIso8601String(),
  };
}

/// Kullanıcının katkıları ve görüldü olarak işaretlenen kazanımlar.
final class MockLedgerEntry {
  const MockLedgerEntry({this.activities = const [], this.seen = const {}});

  final List<MockActivity> activities;
  final Set<String> seen;
}

/// Mock sunucunun oyunlaştırma deposu (kullanıcı başına JSON).
abstract interface class MockActivityStore {
  Future<Map<String, dynamic>?> load(String userId);

  Future<void> save(String userId, Map<String, dynamic> state);

  Future<void> delete(String userId);
}

class InMemoryMockActivityStore implements MockActivityStore {
  final Map<String, Map<String, dynamic>> _state = {};

  @override
  Future<Map<String, dynamic>?> load(String userId) async => _state[userId];

  @override
  Future<void> save(String userId, Map<String, dynamic> state) async =>
      _state[userId] = state;

  @override
  Future<void> delete(String userId) async => _state.remove(userId);
}

/// Katkı defteri: rota, anı ve rapor mock API'leri başarılı oluşturmada
/// buraya yazar; `GamificationMockApi` XP'yi bu kayıtlardan hesaplar.
/// Yalnızca oturum açık istekler kaydedilir; hesap silinince temizlenir.
class MockActivityLedger {
  MockActivityLedger(MockActivityStore store, AuthMockApi auth)
    : this.withClock(store: store, auth: auth, clock: DateTime.now);

  MockActivityLedger.withClock({
    required this._store,
    required this._auth,
    required DateTime Function() clock,
  }) : _now = clock {
    _auth.addAccountDeletionListener(_store.delete);
  }

  final MockActivityStore _store;
  final AuthMockApi _auth;
  final DateTime Function() _now;

  /// İstek oturum açık bir kullanıcıdansa katkıyı kaydeder.
  Future<void> recordFor(
    MockRequest request, {
    required MockActivityKind kind,
    required String refId,
    required List<String> monumentIds,
  }) async {
    final account = await _auth.accountFor(request);
    if (account == null) {
      return;
    }
    await record(
      account.id,
      MockActivity(
        kind: kind,
        refId: refId,
        monumentIds: monumentIds,
        at: _now().toUtc(),
      ),
    );
  }

  Future<void> record(String userId, MockActivity activity) async {
    final entry = await entryFor(userId);
    await _save(
      userId,
      MockLedgerEntry(
        activities: [...entry.activities, activity],
        seen: entry.seen,
      ),
    );
  }

  Future<MockLedgerEntry> entryFor(String userId) async {
    final state = await _store.load(userId);
    if (state == null) {
      return const MockLedgerEntry();
    }
    return MockLedgerEntry(
      activities: [
        for (final item in state['activities'] as List? ?? const [])
          MockActivity.fromJson(item as Map<String, dynamic>),
      ],
      seen: {for (final id in state['seen'] as List? ?? const []) id as String},
    );
  }

  Future<void> markSeen(String userId, Iterable<String> ids) async {
    final entry = await entryFor(userId);
    await _save(
      userId,
      MockLedgerEntry(
        activities: entry.activities,
        seen: {...entry.seen, ...ids},
      ),
    );
  }

  Future<void> _save(String userId, MockLedgerEntry entry) =>
      _store.save(userId, {
        'activities': [
          for (final activity in entry.activities) activity.toJson(),
        ],
        'seen': entry.seen.toList(),
      });
}
