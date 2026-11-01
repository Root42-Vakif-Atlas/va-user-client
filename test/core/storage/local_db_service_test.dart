import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:vakif_atlas/core/storage/local_db_service.dart';

void main() {
  late Directory directory;
  late LocalDbService database;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('vakif_atlas_db');
    database = LocalDbService.withInitializer(
      () async => Hive.init(directory.path),
    );
  });

  tearDown(() async {
    await database.close();
    await directory.delete(recursive: true);
  });

  test(
    'eski sürümlerin cihazdaki mock kutuları silinir, diğerleri kalır',
    () async {
      final legacy = await database.openBox<String>('mock_auth_users');
      await legacy.put('users', '{}');
      await legacy.close();
      final saved = await database.openBox<String>('saved_monuments.v1');
      await saved.put('selimiye-camii', '2026-10-19T12:00:00.000Z');

      await database.deleteLegacyBoxes();

      expect(await Hive.boxExists('mock_auth_users'), isFalse);
      expect((await database.openBox<String>('saved_monuments.v1')).length, 1);
      // Kutu yokken de sorunsuz çalışır.
      await database.deleteLegacyBoxes();
    },
  );
}
