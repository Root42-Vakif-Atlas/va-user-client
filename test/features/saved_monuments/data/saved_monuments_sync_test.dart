import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/features/saved_monuments/data/sources/saved_monuments_local_data_source.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/entities/saved_monument.dart';

import '../../../helpers/saved_monuments_test_utils.dart';

SavedMonument _saved(String id, int minute) => SavedMonument(
  monumentId: id,
  savedAt: DateTime.utc(2026, 10, 19, 12, minute),
);

List<String> _ids(Iterable<SavedMonument> items) => [
  for (final item in items) item.monumentId,
];

/// Sunucudaki küme, en yeni önce.
List<String> _serverIds(FakeSavedMonumentsRemoteDataSource remote) => _ids(
  remote.items.map((e) => e.toDomain()).toList()
    ..sort((a, b) => b.savedAt.compareTo(a.savedAt)),
);

void main() {
  test(
    'ilk eşitlemede cihazdaki ve sunucudaki kayıtlar birleştirilir',
    () async {
      final env = SavedMonumentsTestEnvironment(
        initial: [_saved('a', 1), _saved('b', 3)],
        server: [_saved('b', 2), _saved('c', 4)],
      );

      await env.repository.synchronize();

      expect(env.local.syncState, SavedMonumentsSyncState.synced);
      expect(_serverIds(env.remote), ['c', 'b', 'a']);
      final local = (await env.repository.getSaved()).getOrNull()!;
      expect(_ids(local), ['c', 'b', 'a']);
      // Aynı eserde erken kaydetme zamanı korunur.
      expect(local[1].savedAt, DateTime.utc(2026, 10, 19, 12, 2));
    },
  );

  test('eşitlenmişken sunucudaki değişiklik alınır ve yayınlanır', () async {
    final env = SavedMonumentsTestEnvironment(initial: [_saved('a', 1)]);
    final changes = <List<String>>[];
    final subscription = env.repository.changes.listen(
      (items) => changes.add(_ids(items)),
    );
    env.remote.items = [
      ...env.remote.items,
      ...[_saved('x', 5)]
          .map((e) => (FakeSavedMonumentsRemoteDataSource([e]).items.single)),
    ];

    await env.repository.synchronize();
    await Future<void>.delayed(Duration.zero);

    expect(changes, [
      ['x', 'a'],
    ]);
    await subscription.cancel();
  });

  test('çevrimdışı değişiklik saklanır; bağlantı gelince gönderilir', () async {
    final env = SavedMonumentsTestEnvironment(initial: [_saved('a', 1)]);
    env.remote.offline = true;

    expect((await env.repository.save(_saved('b', 2))).isRight, isTrue);
    await env.repository.synchronize();
    expect(env.local.syncState, SavedMonumentsSyncState.pending);
    expect(env.remote.replaces, 0);

    env.remote.offline = false;
    await env.repository.synchronize();

    expect(env.local.syncState, SavedMonumentsSyncState.synced);
    expect(_serverIds(env.remote), ['b', 'a']);
  });

  test(
    'eşitleme sürerken yapılan değişiklik sunucu yanıtıyla ezilmez',
    () async {
      final env = SavedMonumentsTestEnvironment(initial: [_saved('a', 1)]);
      env.remote.gate = Completer<void>();

      final sync = env.repository.synchronize();
      await Future<void>.delayed(Duration.zero);
      await env.repository.save(_saved('b', 2));
      env.remote.gate!.complete();
      await sync;

      final local = (await env.repository.getSaved()).getOrNull()!;
      expect(_ids(local), ['b', 'a']);
      await env.repository.synchronize();
      expect(_serverIds(env.remote), ['b', 'a']);
      expect(env.local.syncState, SavedMonumentsSyncState.synced);
    },
  );

  test('eşzamanlı iki kaydetme sınırı aşamaz', () async {
    final env = SavedMonumentsTestEnvironment(
      initial: [
        for (var i = 0; i < SavedMonumentRules.maxSaved - 1; i++)
          _saved('m$i', i % 60),
      ],
    );

    final outcomes = await Future.wait([
      env.repository.save(_saved('yeni-1', 1)),
      env.repository.save(_saved('yeni-2', 2)),
    ]);

    expect(outcomes.map((r) => r.getOrNull()), [
      SaveMonumentOutcome.saved,
      SaveMonumentOutcome.limitReached,
    ]);
    expect(await env.local.readAll(), hasLength(SavedMonumentRules.maxSaved));
  });

  test('kayıtlı eser yeniden kaydedilince dokunulmaz', () async {
    final env = SavedMonumentsTestEnvironment(initial: [_saved('a', 1)]);

    final outcome = await env.repository.save(_saved('a', 9));

    expect(outcome.getOrNull(), SaveMonumentOutcome.alreadySaved);
    expect((await env.local.readAll()).single.savedAt, _saved('a', 1).savedAt);
  });
}
