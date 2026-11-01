import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/entities/saved_monument.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/cubit/saved_monuments_cubit.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/cubit/saved_monuments_list_cubit.dart';

import '../../../helpers/saved_monuments_test_utils.dart';

Future<void> _flush() => Future<void>.delayed(Duration.zero);

/// Akışla tetiklenen katalog çözümü (HTTP katmanı) tamamlanana kadar bekler.
Future<void> _until(bool Function() condition) async {
  for (var i = 0; i < 100 && !condition(); i++) {
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
  expect(condition(), isTrue);
}

void main() {
  group('SavedMonumentsCubit', () {
    test('açılışta kayıtları yükler', () async {
      final env = SavedMonumentsTestEnvironment(
        initial: [
          SavedMonument(
            monumentId: 'selimiye-camii',
            savedAt: DateTime.utc(2026, 10, 1),
          ),
        ],
      );
      final cubit = env.cubit();
      await _flush();

      expect(cubit.state.isLoaded, isTrue);
      expect(cubit.state.contains('selimiye-camii'), isTrue);
      await cubit.close();
    });

    test('kaydet → kaldır → geri al; sıra ve zaman korunur', () async {
      final env = SavedMonumentsTestEnvironment();
      final cubit = env.cubit();
      await _flush();

      expect(await cubit.toggle('selimiye-camii'), SavedToggleOutcome.saved);
      env.now = env.now.add(const Duration(hours: 1));
      expect(await cubit.toggle('bursa-ulu-camii'), SavedToggleOutcome.saved);
      expect(
        [for (final item in cubit.state.items) item.monumentId],
        ['bursa-ulu-camii', 'selimiye-camii'],
      );

      final previous = cubit.state.find('selimiye-camii')!;
      expect(await cubit.toggle('selimiye-camii'), SavedToggleOutcome.removed);
      expect(cubit.state.contains('selimiye-camii'), isFalse);

      expect(await cubit.restore(previous), SavedToggleOutcome.saved);
      expect(cubit.state.find('selimiye-camii'), previous);
      expect(cubit.state.items.last, previous);
      await cubit.close();
    });

    test('yazılamazsa durum değişmez', () async {
      final env = SavedMonumentsTestEnvironment();
      final cubit = env.cubit();
      await _flush();
      env.local.failWrites = true;

      expect(await cubit.toggle('selimiye-camii'), SavedToggleOutcome.failed);
      expect(cubit.state.count, 0);
      await cubit.close();
    });
  });

  group('SavedMonumentsListCubit', () {
    test(
      'kayıtlar katalogdan çözülür; katalogda olmayan işaretlenir',
      () async {
        final env = SavedMonumentsTestEnvironment(
          initial: [
            SavedMonument(
              monumentId: 'selimiye-camii',
              savedAt: DateTime.utc(2026, 10, 2),
            ),
            SavedMonument(
              monumentId: 'kaldirilmis-eser',
              savedAt: DateTime.utc(2026, 10, 1),
            ),
          ],
        );
        final list = env.listCubit();

        await list.load(languageCode: 'tr');

        expect(list.state.status, SavedMonumentsListStatus.ready);
        expect(list.state.entries.first.pin?.name, 'Selimiye Camii');
        expect(list.state.entries.last.saved.monumentId, 'kaldirilmis-eser');
        expect(list.state.entries.last.pin, isNull);
        await list.close();
      },
    );

    test('kaydetme/kaldırma ile kendini yeniler; dil değişince yeniden '
        'çözer', () async {
      final env = SavedMonumentsTestEnvironment();
      final saved = env.cubit();
      final list = env.listCubit();
      await list.load(languageCode: 'tr');
      expect(list.state.entries, isEmpty);

      await saved.toggle('suleymaniye-camii');
      await _until(() => list.state.entries.isNotEmpty);
      expect(list.state.entries.single.pin?.name, 'Süleymaniye Camii');

      await list.load(languageCode: 'en');
      expect(list.state.entries.single.pin?.name, 'Süleymaniye Mosque');

      await saved.toggle('suleymaniye-camii');
      await _until(() => list.state.entries.isEmpty);
      await list.close();
      await saved.close();
    });
  });
}
