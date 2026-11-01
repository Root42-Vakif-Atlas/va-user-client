import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/storage/cache_store.dart';
import 'package:vakif_atlas/core/storage/local_db_service.dart';

void main() {
  late Directory directory;
  late LocalDbService database;
  late DateTime now;
  late CacheStore cache;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('vakif_atlas_cache');
    database = LocalDbService.withInitializer(
      () async => Hive.init(directory.path),
    );
    now = DateTime(2026, 10, 17, 12);
    cache = CacheStore.withClock(database, () => now);
  });

  tearDown(() async {
    await database.close();
    await directory.delete(recursive: true);
  });

  test('TTL süresi içinde değer okunur', () async {
    await cache.put('pins', {
      'items': [1, 2],
    }, ttl: const Duration(minutes: 5));

    now = now.add(const Duration(minutes: 4));

    expect(await cache.get('pins'), {
      'items': [1, 2],
    });
  });

  test('TTL dolunca null döner ve kayıt silinir', () async {
    await cache.put('pins', 'value', ttl: const Duration(minutes: 5));

    now = now.add(const Duration(minutes: 5));

    expect(await cache.get('pins'), isNull);
    final box = await database.openBox<String>(CacheStore.boxName);
    expect(box.containsKey('pins'), isFalse);
  });

  test('olmayan anahtar null döner', () async {
    expect(await cache.get('missing'), isNull);
  });

  test('bozuk kayıt CacheException fırlatır ve silinir', () async {
    final box = await database.openBox<String>(CacheStore.boxName);
    await box.put('broken', 'not-json');

    await expectLater(cache.get('broken'), throwsA(isA<CacheException>()));
    expect(box.containsKey('broken'), isFalse);
  });

  test('remove ve clear kayıtları siler', () async {
    await cache.put('a', 1, ttl: const Duration(hours: 1));
    await cache.put('b', 2, ttl: const Duration(hours: 1));

    await cache.remove('a');
    expect(await cache.get('a'), isNull);
    expect(await cache.get('b'), 2);

    await cache.clear();
    expect(await cache.get('b'), isNull);
  });

  test('başlatma hatası CacheException olarak fırlatılır', () async {
    final failing = LocalDbService.withInitializer(
      () async => throw const FileSystemException('denied'),
    );

    await expectLater(
      failing.openBox<String>('any'),
      throwsA(isA<CacheException>()),
    );
  });
}
