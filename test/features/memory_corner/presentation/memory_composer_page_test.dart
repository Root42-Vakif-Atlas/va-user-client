import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/media/photo_attacher.dart';
import 'package:vakif_atlas/core/media/photo_picker_service.dart';
import 'package:vakif_atlas/features/memory_corner/domain/usecases/memory_usecases.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/bloc/memory_composer_bloc.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/pages/memory_composer_page.dart';

import '../../../helpers/catalog_test_utils.dart';
import '../../../helpers/memory_test_utils.dart';
import '../../../helpers/permission_test_utils.dart';
import '../../../helpers/pump_app.dart';

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}

void main() {
  late List<String> announcements;
  late FakePhotoPickerService picker;
  late FakePermissionService permissions;
  late int closed;
  late int submitted;
  late int openedMine;

  setUp(() {
    announcements = [];
    picker = FakePhotoPickerService(supportsCamera: false);
    permissions = FakePermissionService();
    closed = 0;
    submitted = 0;
    openedMine = 0;
  });

  Future<MemoryTestEnvironment> pumpComposer(
    WidgetTester tester, {
    String monumentId = 'selimiye-camii',
    double textScale = 1,
    bool signedIn = true,
  }) async {
    final env = MemoryTestEnvironment();
    if (signedIn) {
      await tester.runAsync(env.signIn);
    }
    final catalog = catalogUseCases();
    await tester.pumpApp(
      RepositoryProvider<A11yAnnouncer>.value(
        value: A11yAnnouncer.withSender(
          (_, message, _, _) async => announcements.add(message),
        ),
        child: BlocProvider<MemoryComposerBloc>(
          create: (_) => MemoryComposerBloc(
            catalog.detail,
            env.useCases.create,
            PhotoAttacher(picker, const FakePhotoProcessor(), permissions),
          ),
          child: MemoryComposerPage(
            monumentId: monumentId,
            authorName: 'Ayşe Yılmaz',
            onClose: () => closed++,
            onSubmitted: () => submitted++,
            onOpenMyMemories: () => openedMine++,
          ),
        ),
      ),
      textScale: textScale,
    );
    await _settle(tester);
    return env;
  }

  testWidgets('eser bağlamı ve herkese açık ad önizlemesi gösterilir', (
    tester,
  ) async {
    await pumpComposer(tester);

    expect(find.text('Anı paylaş'), findsOneWidget);
    expect(find.text('Selimiye Camii'), findsOneWidget);
    expect(find.text('Merkez, Edirne'), findsOneWidget);
    expect(find.textContaining('“Ayşe Y.”'), findsOneWidget);
  });

  testWidgets('boş metinle paylaşımda alan hatası gösterilir ve duyurulur', (
    tester,
  ) async {
    await pumpComposer(tester);

    await tester.tap(find.byKey(const Key('memory_composer_submit')));
    await _settle(tester);

    expect(find.text('Anınızı yazın.'), findsOneWidget);
    expect(
      announcements,
      contains('Paylaşmadan önce işaretli alanları düzeltin.'),
    );
    expect(submitted, 0);
  });

  testWidgets('metin + betimli fotoğrafla paylaşılır', (tester) async {
    final env = await pumpComposer(tester);
    picker.results.add(PhotosPicked([testJpeg()]));

    await tester.enterText(
      find.byKey(const Key('memory_composer_text')),
      'Avludaki şadırvanın sesi hâlâ kulağımda.',
    );
    await tester.ensureVisible(
      find.byKey(const Key('memory_composer_add_photo')),
    );
    await tester.tap(find.byKey(const Key('memory_composer_add_photo')));
    await _settle(tester);

    expect(picker.requests.single.source, PhotoSource.gallery);
    expect(find.bySemanticsLabel('Fotoğraf 1, açıklama eklenmedi'), findsOne);

    final describe = find.byWidgetPredicate(
      (widget) =>
          widget.key is ValueKey<String> &&
          (widget.key! as ValueKey<String>).value.startsWith(
            'memory_composer_describe_',
          ),
    );
    await tester.ensureVisible(describe);
    await tester.tap(describe);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('photo_description_field')),
      'Şadırvan ve avlu',
    );
    await tester.tap(find.byKey(const Key('photo_description_save')));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Fotoğraf 1: Şadırvan ve avlu'), findsOne);

    await tester.tap(find.byKey(const Key('memory_composer_submit')));
    await _settle(tester);

    expect(submitted, 1);
    expect(find.text('Anınız paylaşıldı'), findsOneWidget);
    expect(announcements, contains('Anınız paylaşıldı'));
    final page = await tester.runAsync(
      () => env.useCases.get(
        const GetMemoriesParams(monumentId: 'selimiye-camii'),
      ),
    );
    final latest = page!.fold((_) => fail('liste'), (p) => p.items.first);
    expect(latest.text, 'Avludaki şadırvanın sesi hâlâ kulağımda.');
    expect(latest.photos.single.description, 'Şadırvan ve avlu');
  });

  // YZ moderasyonu (ADR 58): karar paylaşım yanıtında gelir.
  for (final (text, message, assertive) in [
    (
      'Rehber berbattı, hiçbir şey anlatmadı.',
      'Anınız incelemeye alındı. Onaylanınca Anı Köşesi\'nde yayınlanacak; '
          'durumunu Anılarım\'da görebilirsiniz.',
      false,
    ),
    (
      'Buraya gelen herkes salak.',
      'Anınız topluluk kurallarına uygun bulunmadığı için yayınlanmadı. '
          'Anılarım\'da görebilirsiniz.',
      true,
    ),
  ]) {
    testWidgets('YZ kararı bildirilir ve Anılarım açılabilir: $message', (
      tester,
    ) async {
      await pumpComposer(tester);
      await tester.enterText(
        find.byKey(const Key('memory_composer_text')),
        text,
      );
      await tester.ensureVisible(
        find.byKey(const Key('memory_composer_submit')),
      );
      await tester.tap(find.byKey(const Key('memory_composer_submit')));
      await _settle(tester);

      expect(submitted, 1);
      expect(find.text(message), findsOneWidget);
      expect(find.text('Anınız paylaşıldı'), findsNothing);
      expect(announcements, contains(message));
      expect(assertive, text.contains('salak'));

      // Bildirimin giriş animasyonu bitsin; eylem ancak sonra dokunulabilir.
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.widgetWithText(SnackBarAction, 'Anılarım'));
      await tester.pump();
      expect(openedMine, 1);
    });
  }

  testWidgets('metin alanı dışına dokununca klavye kapanır, metin korunur', (
    tester,
  ) async {
    await pumpComposer(tester);
    final field = find.byKey(const Key('memory_composer_text'));

    await tester.showKeyboard(field);
    await tester.enterText(field, 'Yarım kalan anı');
    await tester.pump();
    expect(tester.testTextInput.isVisible, isTrue);

    await tester.tap(field);
    await tester.pump();
    expect(
      tester.testTextInput.isVisible,
      isTrue,
      reason: 'Alanın içine dokunmak klavyeyi kapatmaz',
    );

    await tester.tap(find.byKey(const Key('memory_composer_monument_name')));
    await tester.pump();

    expect(tester.testTextInput.isVisible, isFalse);
    expect(find.text('Yarım kalan anı'), findsOneWidget);
    expect(submitted, 0);
  });

  testWidgets('kaydedilmemiş içerikle kapatırken onay istenir', (tester) async {
    await pumpComposer(tester);

    await tester.tap(find.byKey(const Key('memory_composer_close')));
    await tester.pumpAndSettle();
    expect(closed, 1, reason: 'Boş taslak onaysız kapanır');

    await tester.enterText(
      find.byKey(const Key('memory_composer_text')),
      'Yarım kalan anı',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('memory_composer_close')));
    await tester.pumpAndSettle();
    expect(find.text('Anı taslağı silinsin mi?'), findsOneWidget);

    await tester.tap(find.byKey(const Key('memory_discard_cancel')));
    await tester.pumpAndSettle();
    expect(closed, 1);
    expect(find.text('Yarım kalan anı'), findsOneWidget);

    await tester.tap(find.byKey(const Key('memory_composer_close')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('memory_discard_confirm')));
    await tester.pumpAndSettle();
    expect(closed, 2);
  });

  testWidgets('izin reddinde ayarlara yönlendiren bildirim', (tester) async {
    await pumpComposer(tester);
    picker.results.add(const PhotoAccessDenied(PhotoSource.gallery));

    await tester.ensureVisible(
      find.byKey(const Key('memory_composer_add_photo')),
    );
    await tester.tap(find.byKey(const Key('memory_composer_add_photo')));
    await _settle(tester);

    expect(
      find.text(
        'Fotoğraflara erişim izni verilmedi. İzni cihaz ayarlarından '
        'verebilirsiniz.',
      ),
      findsOneWidget,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ayarlar'));
    await tester.pump();
    expect(permissions.settingsOpened, 1);
  });

  testWidgets('bilinmeyen eser için bulunamadı durumu', (tester) async {
    await pumpComposer(tester, monumentId: 'yok-boyle-eser');

    expect(find.byKey(const Key('memory_composer_not_found')), findsOneWidget);
    expect(find.byKey(const Key('memory_composer_submit')), findsNothing);
  });

  testWidgets('%200 metin ölçeğinde taşma yok, erişilebilirlik yönergeleri', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpComposer(tester, textScale: 2);
    picker.results.add(PhotosPicked([testJpeg(), testJpeg()]));
    await tester.ensureVisible(
      find.byKey(const Key('memory_composer_add_photo')),
    );
    await tester.tap(find.byKey(const Key('memory_composer_add_photo')));
    await _settle(tester);

    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
