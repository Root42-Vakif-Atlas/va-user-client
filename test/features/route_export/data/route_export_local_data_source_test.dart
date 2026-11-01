import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/storage/local_db_service.dart';
import 'package:vakif_atlas/features/route_export/data/dtos/route_export_dtos.dart';
import 'package:vakif_atlas/features/route_export/data/sources/route_export_file_store_io.dart';
import 'package:vakif_atlas/features/route_export/data/sources/route_export_local_data_source.dart';

void main() {
  late Directory directory;
  late LocalDbService database;
  late RouteExportLocalDataSourceImpl source;

  RouteExportRecordDto record(String id) => RouteExportRecordDto(
    id: id,
    routeId: 'rt_1',
    routeName: 'Trakya',
    fileName: 'vakif-atlas-trakya.pdf',
    createdAt: DateTime.utc(2026, 10, 18),
    byteSize: 3,
    stopCount: 2,
  );

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('vakif_atlas_exports');
    database = LocalDbService.withInitializer(
      () async => Hive.init('${directory.path}/db'),
    );
    source = RouteExportLocalDataSourceImpl.withFileStore(
      database,
      IoRouteExportFileStore(() async => Directory('${directory.path}/files')),
    );
  });

  tearDown(() async {
    await database.close();
    await directory.delete(recursive: true);
  });

  final bytes = Uint8List.fromList([1, 2, 3]);

  test(
    'PDF uygulamaya özel dizinde, kaydı yerel veritabanında saklanır',
    () async {
      await source.save('owner', record('e1'), bytes);

      expect(await source.readIndex('owner'), [record('e1')]);
      expect(await source.readFile('owner', 'e1'), bytes);
      expect(
        File('${directory.path}/files/route_exports/owner/e1.pdf').existsSync(),
        isTrue,
      );
      // Yarım yazma dosyası kalmaz.
      expect(
        File('${directory.path}/files/route_exports/owner/e1.pdf.part')
            .existsSync(),
        isFalse,
      );
    },
  );

  test('sahipler birbirinin kaydını okuyamaz', () async {
    await source.save('a', record('e1'), bytes);

    expect(await source.readIndex('b'), isEmpty);
    expect(await source.readFile('b', 'e1'), isNull);
  });

  test('silme ve sahip silme dosyaları da kaldırır', () async {
    await source.save('a', record('e1'), bytes);
    await source.save('a', record('e2'), bytes);
    await source.save('b', record('e3'), bytes);

    await source.delete('a', 'e1');
    expect((await source.readIndex('a')).map((r) => r.id), ['e2']);

    await source.deleteOwner('a');
    expect(await source.readIndex('a'), isEmpty);
    expect(
      Directory('${directory.path}/files/route_exports/a').existsSync(),
      isFalse,
    );
    expect(await source.readFile('b', 'e3'), bytes);
  });

  test('bozuk kayıt dizinden atılır', () async {
    final box = await database.openBox<Object?>(
      RouteExportLocalDataSourceImpl.boxName,
    );
    await box.put('a/bozuk', {'unexpected': true});
    await source.save('a', record('e1'), bytes);

    expect((await source.readIndex('a')).map((r) => r.id), ['e1']);
    expect(box.containsKey('a/bozuk'), isFalse);
  });

  test('dosya sistemi hatası CacheException olur', () async {
    // Dizin olması gereken yolda bir dosya var: klasör oluşturulamaz.
    File('${directory.path}/engel').writeAsStringSync('x');
    final failing = RouteExportLocalDataSourceImpl.withFileStore(
      database,
      IoRouteExportFileStore(() async => Directory('${directory.path}/engel')),
    );
    await expectLater(
      failing.save('a', record('e1'), bytes),
      throwsA(isA<CacheException>()),
    );
    expect(await source.readIndex('a'), isEmpty);
  });
}
