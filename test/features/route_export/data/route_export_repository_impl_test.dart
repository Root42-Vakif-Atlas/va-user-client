import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/route_export/data/repositories/route_export_repository_impl.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_document.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_export.dart';

import '../../../helpers/route_export_test_utils.dart';

RouteDocument _document(String name, {String routeId = 'rt_1'}) =>
    RouteDocument(
      routeId: routeId,
      title: name,
      subtitle: 'Edirne → Bursa · 2 durak',
      languageCode: 'tr',
      fileName: 'vakif-atlas-$name.pdf',
      facts: const [],
      stops: const [],
      path: const [],
      labels: const RouteDocumentLabels(
        brand: 'Vakıf Atlas',
        summaryHeading: 's',
        sketchHeading: 'k',
        sketchCaption: 'c',
        stopsHeading: 'd',
        mapLink: 'm',
        disclaimer: 'x',
        attribution: 'a',
        generatedOn: 'g',
        pageOf: '{page}/{total}',
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeRoutePdfRenderer renderer;
  late InMemoryRouteExportLocalDataSource local;
  late FakeRouteExportRemoteDataSource remote;
  late RouteExportRepositoryImpl repository;

  setUp(() {
    renderer = FakeRoutePdfRenderer();
    local = InMemoryRouteExportLocalDataSource();
    remote = FakeRouteExportRemoteDataSource();
    repository = testRouteExportRepository(
      renderer: renderer,
      local: local,
      remote: remote,
    );
  });

  Future<List<RouteExport>> list(String? owner) async =>
      (await repository.getExports(owner)).getOrNull()!;

  String cacheKey(String? owner) => RouteExportRepositoryImpl.ownerKey(owner);

  test('misafirin PDF\'i kurulumun arşivine yüklenir; girişte hesaba '
      'taşınır, misafir önbelleği temizlenir', () async {
    remote.session = null;
    final changes = <String?>[];
    final subscription = repository.changes.listen(changes.add);

    final result = await repository.createExport(document: _document('a'));

    final file = result.getOrNull()!;
    expect(file.saved, isNotNull);
    expect(file.fileName, 'vakif-atlas-a.pdf');
    expect((await list(null)).map((e) => e.routeName), ['a']);
    expect(local.records[cacheKey(null)], hasLength(1));

    // Giriş: sunucu kurulumun kayıtlarını hesaba taşır.
    remote.session = 'usr_1';
    expect((await list('usr_1')).map((e) => e.routeName), ['a']);
    await repository.deleteAllForOwner(null);
    expect(local.records[cacheKey(null)], isNull);

    // Çıkış: misafir görünümü boştur (kayıt hesabın).
    remote.session = null;
    expect(await list(null), isEmpty);
    await Future<void>.delayed(Duration.zero);
    expect(changes, [null, null]);
    await subscription.cancel();
  });

  test(
    'sahibin sunucudaki arşivine yüklenir; en yenisi önce listelenir',
    () async {
      remote.session = 'usr_1';
      final changes = <String?>[];
      final subscription = repository.changes.listen(changes.add);

      await repository.createExport(document: _document('a'), ownerId: 'usr_1');
      await repository.createExport(document: _document('b'), ownerId: 'usr_1');
      await Future<void>.delayed(Duration.zero);

      expect((await list('usr_1')).map((e) => e.routeName), ['b', 'a']);
      expect(changes, ['usr_1', 'usr_1']);
      // Sunucu boyutu ve SHA-256 özetini doğrular.
      expect(remote.uploads.first.routeName, 'a');
      expect(remote.uploads.first.sha256, hasLength(64));
      await subscription.cancel();
    },
  );

  test(
    'bir hesabın dışa aktarımları başka hesaptan görülemez ve açılamaz',
    () async {
      remote.session = 'usr_1';
      final created = await repository.createExport(
        document: _document('özel'),
        ownerId: 'usr_1',
      );
      final id = created.getOrNull()!.saved!.id;

      remote.session = 'usr_2';
      expect(await list('usr_2'), isEmpty);
      expect(
        await repository.openExport(ownerId: 'usr_2', exportId: id),
        isA<Left<Failure, RouteExportFile>>(),
      );
      // Önbellek anahtarı kimliğin özetidir; kimlik açık yazılmaz.
      expect(local.records.keys.single, cacheKey('usr_1'));
      expect(local.records.keys.single, isNot(contains('usr_1')));
    },
  );

  test('sınır aşılınca en eski dışa aktarım silinir', () async {
    for (var i = 0; i <= RouteExportRules.maxPerOwner; i++) {
      await repository.createExport(document: _document('r$i'), ownerId: 'u');
    }

    final exports = await list('u');
    expect(exports, hasLength(RouteExportRules.maxPerOwner));
    expect(exports.map((e) => e.routeName), isNot(contains('r0')));
    expect(local.files, hasLength(RouteExportRules.maxPerOwner));
  });

  test('açılan dışa aktarım aynı içeriği döndürür (önbellekten)', () async {
    final created = await repository.createExport(
      document: _document('a'),
      ownerId: 'u',
    );
    final saved = created.getOrNull()!;

    final opened = await repository.openExport(
      ownerId: 'u',
      exportId: saved.saved!.id,
    );

    expect(opened.getOrNull()!.bytes, saved.bytes);
    expect(opened.getOrNull()!.fileName, 'vakif-atlas-a.pdf');
    expect(remote.downloads, 0);
  });

  test(
    'önbellekte olmayan dosya sunucudan indirilip önbelleğe alınır',
    () async {
      final created = await repository.createExport(
        document: _document('a'),
        ownerId: 'u',
      );
      final saved = created.getOrNull()!;
      // Ör. başka cihazda oluşturulmuş ya da önbellek temizlenmiş.
      local.records.clear();
      local.files.clear();

      final opened = await repository.openExport(
        ownerId: 'u',
        exportId: saved.saved!.id,
      );

      expect(opened.getOrNull()!.bytes, saved.bytes);
      expect(remote.downloads, 1);
      await repository.openExport(ownerId: 'u', exportId: saved.saved!.id);
      expect(remote.downloads, 1);
    },
  );

  test(
    'sunucuda silinmiş kayıt bulunamadı döner; liste önbelleği budar',
    () async {
      final created = await repository.createExport(
        document: _document('a'),
        ownerId: 'u',
      );
      final id = created.getOrNull()!.saved!.id;
      await repository.createExport(document: _document('b'), ownerId: 'u');
      // Başka cihazdan silindi; bu cihazda dosyası da yok.
      await remote.delete(id);
      local.files.remove('${cacheKey('u')}/$id');

      expect(
        await repository.openExport(ownerId: 'u', exportId: id),
        const Left<Failure, RouteExportFile>(
          ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
        ),
      );
      expect((await list('u')).map((e) => e.routeName), ['b']);
      expect(local.records[cacheKey('u')]!.keys, isNot(contains(id)));
    },
  );

  test(
    'çevrimdışıyken önbellekteki dışa aktarımlar listelenir ve açılır',
    () async {
      final created = await repository.createExport(
        document: _document('a'),
        ownerId: 'u',
      );
      remote.offline = true;

      expect((await list('u')).map((e) => e.routeName), ['a']);
      final opened = await repository.openExport(
        ownerId: 'u',
        exportId: created.getOrNull()!.saved!.id,
      );
      expect(opened.getOrNull()!.bytes, created.getOrNull()!.bytes);
    },
  );

  test('sunucuya yüklenemezse PDF yine de paylaşılabilir', () async {
    remote.offline = true;

    final result = await repository.createExport(
      document: _document('a'),
      ownerId: 'u',
    );

    final file = result.getOrNull()!;
    expect(file.saved, isNull);
    expect(file.archiveFailure, const NetworkFailure());
    expect(file.bytes, isNotEmpty);
    expect(local.records, isEmpty);
  });

  test(
    'cihaz önbelleğine yazılamasa da sunucudaki arşive kaydedilir',
    () async {
      local.failWrites = true;

      final result = await repository.createExport(
        document: _document('a'),
        ownerId: 'u',
      );

      expect(result.getOrNull()!.saved, isNotNull);
      expect(result.getOrNull()!.archiveFailure, isNull);
      expect(await list('u'), hasLength(1));
    },
  );

  test('üretim hatası UnexpectedFailure döner', () async {
    renderer.fail = true;

    expect(
      await repository.createExport(document: _document('a'), ownerId: 'u'),
      const Left<Failure, RouteExportFile>(UnexpectedFailure()),
    );
  });

  test(
    'silme sunucudan ve önbellekten kaldırır; hesap silme önbelleği temizler',
    () async {
      final first = await repository.createExport(
        document: _document('a'),
        ownerId: 'u',
      );
      await repository.createExport(document: _document('b'), ownerId: 'u');
      remote.session = 'diğer';
      await repository.createExport(document: _document('c'), ownerId: 'diğer');
      remote.session = 'u';

      await repository.deleteExport(
        ownerId: 'u',
        exportId: first.getOrNull()!.saved!.id,
      );
      expect((await list('u')).map((e) => e.routeName), ['b']);
      expect(remote.records['u']!.map((e) => e.routeName), ['b']);

      // Sunucudaki kayıtları media servisi `AccountDeleted` ile siler.
      await repository.deleteAllForOwner('u');
      expect(local.records[cacheKey('u')], isNull);
      expect(local.records[cacheKey('diğer')], hasLength(1));
    },
  );

  test('ağ hatasında silinmeyen kayıt yerinde kalır', () async {
    final created = await repository.createExport(
      document: _document('a'),
      ownerId: 'u',
    );
    remote.offline = true;

    final result = await repository.deleteExport(
      ownerId: 'u',
      exportId: created.getOrNull()!.saved!.id,
    );

    expect(result, const Left<Failure, Unit>(NetworkFailure()));
    remote.offline = false;
    expect(await list('u'), hasLength(1));
  });

  test(
    'paylaşım bağlantısı üretilir; silinmiş kayıtta önbellek temizlenir',
    () async {
      remote.session = 'usr_1';
      final file = (await repository.createExport(
        document: _document('a'),
        ownerId: 'usr_1',
      )).getOrNull()!;
      final id = file.saved!.id;

      final link = (await repository.createShareLink(
        ownerId: 'usr_1',
        exportId: id,
      )).getOrNull()!;
      expect(link.url, contains(id));
      expect(link.toString(), isNot(contains('Signature')));

      // Başka cihazdan silindi: 404 → önbellekten de kalkar.
      remote.records['usr_1']!.clear();
      final result = await repository.createShareLink(
        ownerId: 'usr_1',
        exportId: id,
      );
      expect(
        result.fold((failure) => failure, (_) => null),
        isA<ServerFailure>(),
      );
      expect(local.records[cacheKey('usr_1')], isEmpty);
    },
  );
}
