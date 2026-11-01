import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/entities/saved_monument.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/usecases/saved_monuments_usecases.dart';

import '../../../helpers/saved_monuments_test_utils.dart';

SavedMonument _saved(String id, int minute) => SavedMonument(
  monumentId: id,
  savedAt: DateTime.utc(2026, 10, 19, 12, minute),
);

void main() {
  test(
    'liste en yeni önce döner; değişiklik akışı güncel listeyi verir',
    () async {
      final env = SavedMonumentsTestEnvironment(
        initial: [_saved('a', 1), _saved('b', 3)],
      );
      final changes = <List<String>>[];
      final subscription = env.repository.changes.listen(
        (items) => changes.add([for (final item in items) item.monumentId]),
      );

      final saved = await GetSavedMonumentsUseCase(env.repository)(
        const NoParams(),
      );
      expect(
        [for (final item in saved.getOrNull()!) item.monumentId],
        ['b', 'a'],
      );

      await SaveMonumentUseCase(env.repository)(_saved('c', 2));
      await RemoveSavedMonumentUseCase(env.repository)('b');
      await Future<void>.delayed(Duration.zero);

      expect(changes, [
        ['b', 'c', 'a'],
        ['c', 'a'],
      ]);
      await subscription.cancel();
    },
  );

  test('kayıtlı eser yeniden kaydedilmez; zamanı değişmez', () async {
    final env = SavedMonumentsTestEnvironment(initial: [_saved('a', 1)]);

    final result = await SaveMonumentUseCase(env.repository)(_saved('a', 9));

    expect(
      result,
      const Right<Failure, SaveMonumentOutcome>(
        SaveMonumentOutcome.alreadySaved,
      ),
    );
    final saved = await env.local.readAll();
    expect(saved.single.savedAt.minute, 1);
  });

  test('sınır doluysa eklenmez', () async {
    final env = SavedMonumentsTestEnvironment(
      initial: [
        for (var i = 0; i < SavedMonumentRules.maxSaved; i++)
          SavedMonument(
            monumentId: 'm$i',
            savedAt: DateTime.utc(2026).add(Duration(minutes: i)),
          ),
      ],
    );

    final result = await SaveMonumentUseCase(env.repository)(_saved('yeni', 0));

    expect(result.getOrNull(), SaveMonumentOutcome.limitReached);
    expect(await env.local.readAll(), hasLength(SavedMonumentRules.maxSaved));
  });

  test('yazma hatası CacheFailure olur', () async {
    final env = SavedMonumentsTestEnvironment()..local.failWrites = true;

    final result = await SaveMonumentUseCase(env.repository)(_saved('a', 1));

    expect(result, const Left<Failure, SaveMonumentOutcome>(CacheFailure()));
  });

  test('kayıt yalnızca kimlik içerir; toString kişisel veri taşımaz', () {
    expect(
      _saved('selimiye-camii', 1).toString(),
      'SavedMonument(selimiye-camii)',
    );
  });
}
