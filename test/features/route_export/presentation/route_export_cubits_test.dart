import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/network/session_events.dart';
import 'package:vakif_atlas/features/route_export/data/repositories/route_export_repository_impl.dart';
import 'package:vakif_atlas/features/route_export/data/route_export_account_cleanup.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_document.dart';
import 'package:vakif_atlas/features/route_export/domain/usecases/route_export_usecases.dart';
import 'package:vakif_atlas/features/route_export/presentation/cubit/route_export_cubit.dart';
import 'package:vakif_atlas/features/route_export/presentation/cubit/route_exports_cubit.dart';

import '../../../helpers/route_export_test_utils.dart';

final _document = RouteDocument(
  routeId: 'rt_1',
  title: 'Trakya',
  subtitle: 's',
  languageCode: 'tr',
  fileName: 'vakif-atlas-trakya.pdf',
  facts: const [],
  stops: const [],
  path: const [],
  labels: const RouteDocumentLabels(
    brand: 'b',
    summaryHeading: 's',
    sketchHeading: 'k',
    sketchCaption: 'c',
    stopsHeading: 'd',
    mapLink: 'm',
    disclaimer: 'x',
    attribution: 'a',
    generatedOn: 'g',
    pageOf: 'p',
  ),
);

void main() {
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

  /// [owner] oturumuyla dışa aktarır (sunucu kaydı Bearer'a göre ayırır).
  Future<void> exportAs(String owner) async {
    final previous = remote.session;
    remote.session = owner;
    await repository.createExport(document: _document, ownerId: owner);
    remote.session = previous;
  }

  group('RouteExportCubit', () {
    test('üretim sırasında ikinci istek yok sayılır', () async {
      final cubit = RouteExportCubit(
        CreateRouteExportUseCase(repository),
        CreateRouteExportShareLinkUseCase(repository),
      );
      final first = cubit.export(_document, ownerId: 'u');
      final second = cubit.export(_document, ownerId: 'u');
      expect(cubit.state.isExporting, isTrue);
      await Future.wait([first, second]);

      expect(cubit.state.status, RouteExportStatus.ready);
      expect(cubit.state.file?.saved, isNotNull);
      expect(renderer.rendered, hasLength(1));
      await cubit.close();
    });

    test('hata durumu taşınır; sonraki deneme başarılı olabilir', () async {
      final cubit = RouteExportCubit(
        CreateRouteExportUseCase(repository),
        CreateRouteExportShareLinkUseCase(repository),
      );
      renderer.fail = true;
      await cubit.export(_document);
      expect(cubit.state.status, RouteExportStatus.failure);

      renderer.fail = false;
      await cubit.export(_document);
      expect(cubit.state.status, RouteExportStatus.ready);
      expect(cubit.state.failure, isNull);
      await cubit.close();
    });
  });

  group('RouteExportsCubit', () {
    RouteExportsCubit build() => RouteExportsCubit(
      GetRouteExportsUseCase(repository),
      OpenRouteExportUseCase(repository),
      CreateRouteExportShareLinkUseCase(repository),
      DeleteRouteExportUseCase(repository),
      WatchRouteExportChangesUseCase(repository),
    );

    test(
      'yalnızca sahibin kayıtları listelenir ve değişince yenilenir',
      () async {
        await exportAs('u');
        await exportAs('other');
        final cubit = build();

        await cubit.start('u');
        expect(cubit.state.status, RouteExportsStatus.ready);
        expect(cubit.state.items, hasLength(1));

        await repository.createExport(document: _document, ownerId: 'u');
        await Future<void>.delayed(Duration.zero);
        expect(cubit.state.items, hasLength(2));
        await cubit.close();
      },
    );

    test('açma ve silme', () async {
      final created = await repository.createExport(
        document: _document,
        ownerId: 'u',
      );
      final id = created.getOrNull()!.saved!.id;
      final cubit = build();
      await cubit.start('u');

      expect((await cubit.open(id))?.fileName, 'vakif-atlas-trakya.pdf');
      expect(await cubit.open('yok'), isNull);
      expect(cubit.state.actionFailure, isNotNull);

      await cubit.delete(id);
      expect(cubit.state.items, isEmpty);
      expect(cubit.state.deletions, 1);
      await cubit.close();
    });
  });

  group('RouteExportAccountCleanup', () {
    test('hesap silinince yalnızca o hesabın arşivi silinir', () async {
      await exportAs('u');
      await exportAs('other');
      final events = SessionEvents();
      final cleanup = RouteExportAccountCleanup(events, repository)..start();

      events
        ..notifyAccountChanged(null)
        ..notifyAccountDeleted('u');
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      // Sunucudaki arşivi media servisi siler; cihazdaki önbellek temizlenir.
      expect(local.records[RouteExportRepositoryImpl.ownerKey('u')], isNull);
      expect(
        local.records[RouteExportRepositoryImpl.ownerKey('other')],
        hasLength(1),
      );
      await cleanup.dispose();
      await events.dispose();
    });
  });
}
