import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/media/photo_attacher.dart';
import 'package:vakif_atlas/core/media/photo_picker_service.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';
import 'package:vakif_atlas/features/memory_corner/domain/usecases/memory_usecases.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/bloc/memory_composer_bloc.dart';

import '../../../helpers/catalog_test_utils.dart';
import '../../../helpers/memory_test_utils.dart';
import '../../../helpers/permission_test_utils.dart';

void main() {
  late MemoryTestEnvironment env;
  late FakePhotoPickerService picker;

  MemoryComposerBloc composer() => MemoryComposerBloc(
    catalogUseCases().detail,
    env.useCases.create,
    PhotoAttacher(picker, const FakePhotoProcessor(), FakePermissionService()),
  );

  Future<MemoryComposerState> settle(
    MemoryComposerBloc bloc,
    bool Function(MemoryComposerState state) test,
  ) async {
    if (test(bloc.state)) {
      return bloc.state;
    }
    return bloc.stream.firstWhere(test);
  }

  Future<MemoryComposerBloc> started({String id = 'selimiye-camii'}) async {
    final bloc = composer()
      ..add(MemoryComposerEvent.started(monumentId: id, languageCode: 'tr'));
    await settle(
      bloc,
      (s) =>
          s.status == MemoryComposerStatus.editing ||
          s.status == MemoryComposerStatus.monumentFailure,
    );
    return bloc;
  }

  setUp(() {
    env = MemoryTestEnvironment();
    picker = FakePhotoPickerService();
  });

  test(
    'eser adı ve yeri arayüz dilinde yüklenir; bilinmeyen eser 404',
    () async {
      final bloc = await started();
      expect(bloc.state.monumentName, 'Selimiye Camii');
      expect(bloc.state.monumentPlace, 'Merkez, Edirne');
      await bloc.close();

      final missing = await started(id: 'yok');
      expect(missing.state.status, MemoryComposerStatus.monumentFailure);
      expect(
        missing.state.monumentFailure,
        const ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
      );
      await missing.close();
    },
  );

  test(
    'boş metinle gönderim alan hatasını gösterir, sunucuya gitmez',
    () async {
      final bloc = await started();
      bloc.add(const MemoryComposerEvent.submitted());
      final state = await settle(bloc, (s) => s.submitAttempts == 1);

      expect(state.showValidation, isTrue);
      expect(state.issue, MemoryDraftIssue.textEmpty);
      expect(state.status, MemoryComposerStatus.editing);
      await bloc.close();
    },
  );

  test(
    'seçim sınırı kalan hakka göre; fazlası eklenmez ve bildirilir',
    () async {
      final bloc = await started();
      final photo = testJpeg();
      picker.results.add(PhotosPicked([photo, photo, photo]));
      bloc.add(const MemoryComposerEvent.photosRequested(PhotoSource.gallery));
      await settle(bloc, (s) => s.photos.length == 3);
      expect(picker.requests.single.limit, MemoryRules.maxPhotos);

      picker.results.add(PhotosPicked([photo, photo]));
      bloc.add(const MemoryComposerEvent.photosRequested(PhotoSource.gallery));
      final state = await settle(bloc, (s) => s.photoNoticeCount == 1);

      expect(picker.requests.last.limit, 1);
      expect(state.photos, hasLength(MemoryRules.maxPhotos));
      expect(state.photoNotice?.kind, PhotoNoticeKind.limitReached);
      expect(state.remainingPhotos, 0);
      await bloc.close();
    },
  );

  test('izin reddi ve çözümlenemeyen fotoğraf bildirilir', () async {
    final bloc = await started();
    picker.results
      ..add(const PhotoAccessDenied(PhotoSource.camera))
      ..add(PhotosPicked([Uint8List(0), testJpeg()]));

    bloc.add(const MemoryComposerEvent.photosRequested(PhotoSource.camera));
    var state = await settle(bloc, (s) => s.photoNoticeCount == 1);
    expect(state.photoNotice?.kind, PhotoNoticeKind.cameraDenied);

    bloc.add(const MemoryComposerEvent.photosRequested(PhotoSource.gallery));
    state = await settle(bloc, (s) => s.photoNoticeCount == 2);
    expect(state.photoNotice?.kind, PhotoNoticeKind.unsupported);
    expect(state.photoNotice?.count, 1);
    expect(state.photos, hasLength(1));
    expect(state.processingPhotos, 0);
    await bloc.close();
  });

  test('betim düzenlenir, fotoğraf kaldırılır', () async {
    final bloc = await started();
    picker.results.add(PhotosPicked([testJpeg(), testJpeg()]));
    bloc.add(const MemoryComposerEvent.photosRequested(PhotoSource.gallery));
    var state = await settle(bloc, (s) => s.photos.length == 2);
    final first = state.photos.first;

    bloc
      ..add(
        MemoryComposerEvent.photoDescriptionChanged(
          localId: first.localId,
          description: 'Avlu',
        ),
      )
      ..add(MemoryComposerEvent.photoRemoved(state.photos.last.localId));
    state = await settle(bloc, (s) => s.photos.length == 1);
    expect(state.photos.single.description, 'Avlu');
    await bloc.close();
  });

  test('çift gönderim tek anı oluşturur; ilerleme yayınlanır', () async {
    await env.signIn();
    final bloc = await started();
    picker.results.add(PhotosPicked([testJpeg()]));
    bloc
      ..add(const MemoryComposerEvent.textChanged('Avluda oturduk.'))
      ..add(MemoryComposerEvent.visitDateChanged(DateTime(2026, 10, 1)))
      ..add(const MemoryComposerEvent.photosRequested(PhotoSource.gallery));
    await settle(bloc, (s) => s.photos.length == 1);

    final progress = <double>[];
    final subscription = bloc.stream.listen((s) {
      final value = s.uploadProgress;
      if (value != null) {
        progress.add(value);
      }
    });
    bloc
      ..add(const MemoryComposerEvent.submitted())
      ..add(const MemoryComposerEvent.submitted());
    final state = await settle(
      bloc,
      (s) => s.status == MemoryComposerStatus.submitted,
    );

    expect(state.created?.text, 'Avluda oturduk.');
    expect(state.created?.photos, hasLength(1));
    expect(state.isDirty, isFalse);
    expect(progress, isNotEmpty);
    expect(progress.last, 1);
    final page = await env.useCases.get(
      const GetMemoriesParams(monumentId: 'selimiye-camii'),
    );
    expect(page.fold((_) => 0, (p) => p.total), 5, reason: 'tek paylaşım');
    await subscription.cancel();
    await bloc.close();
  });

  test('sunucu hatasında düzenlemeye dönülür, taslak korunur', () async {
    final bloc = await started();
    bloc
      ..add(const MemoryComposerEvent.textChanged('Oturum yok'))
      ..add(const MemoryComposerEvent.submitted());
    final state = await settle(bloc, (s) => s.submitFailure != null);

    expect(state.submitFailure, const UnauthorizedFailure());
    expect(state.status, MemoryComposerStatus.editing);
    expect(state.text, 'Oturum yok');
    expect(state.isDirty, isTrue);
    await bloc.close();
  });
}
