import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/a11y/voice_io_service.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/map/map_tile_source.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/cubit/monument_detail_cubit.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/pages/monument_detail_page.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/cubit/saved_monuments_cubit.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/widgets/saved_monument_feedback.dart';
import 'package:vakif_atlas/shared/widgets/molecules/monument_save_button.dart';

import '../../../helpers/catalog_test_utils.dart';
import '../../../helpers/map_test_utils.dart';
import '../../../helpers/saved_monuments_test_utils.dart';

class _MockGetMonumentDetail extends Mock implements GetMonumentDetailUseCase {}

class _MockGetComplexMembers extends Mock implements GetComplexMembersUseCase {}

class _MockFlutterTts extends Mock implements FlutterTts {}

void main() {
  late _MockGetMonumentDetail getDetail;
  late _MockFlutterTts tts;
  late VoidCallback ttsStarted;
  late int showOnMapCalls;
  late int backToMapCalls;

  setUpAll(() {
    registerFallbackValue(
      const GetMonumentDetailParams(id: 'id', languageCode: 'tr'),
    );
    registerFallbackValue(() {});
    registerFallbackValue((dynamic _) {});
  });

  setUp(() {
    showOnMapCalls = 0;
    backToMapCalls = 0;
    getDetail = _MockGetMonumentDetail();
    when(() => getDetail(any())).thenAnswer((invocation) async {
      final params =
          invocation.positionalArguments.single as GetMonumentDetailParams;
      return Right(fixtureDetail(params.id, languageCode: params.languageCode));
    });
    tts = _MockFlutterTts();
    ttsStarted = () {};
    when(() => tts.setLanguage(any())).thenAnswer((_) async => 1);
    when(() => tts.speak(any())).thenAnswer((_) async => 1);
    when(tts.stop).thenAnswer((_) async => 1);
    when(() => tts.setStartHandler(any())).thenAnswer((invocation) {
      ttsStarted = invocation.positionalArguments.single as VoidCallback;
    });
  });

  Future<void> pumpDetail(
    WidgetTester tester, {
    String id = 'selimiye-camii',
    double textScale = 1,
    ThemeData? theme,
    MonumentSectionBuilder? memoriesBuilder,
    VoidCallback? onReportDamage,
    MonumentSectionBuilder? saveButtonBuilder,
  }) async {
    tester.view.physicalSize =
        const Size(390, 844) * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    final voice = VoiceIoService(tts);
    addTearDown(voice.dispose);
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: A11yAnnouncer.withSender((_, _, _, _) async {}),
          ),
          RepositoryProvider.value(
            value: HapticFeedbackService.withDelay((_) async {}),
          ),
          RepositoryProvider.value(value: voice),
          RepositoryProvider<MapTileSource>.value(value: testMapTileSource()),
        ],
        child: BlocProvider(
          create: (_) =>
              MonumentDetailCubit(getDetail, _MockGetComplexMembers()),
          child: MaterialApp(
            theme: theme ?? AppTheme.dark(),
            locale: const Locale('tr'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(textScale)),
              child: child!,
            ),
            home: MonumentDetailPage(
              monumentId: id,
              onShowOnMap: () => showOnMapCalls++,
              onBackToMap: () => backToMapCalls++,
              memoriesBuilder: memoriesBuilder,
              onReportDamage: onReportDamage,
              saveButtonBuilder: saveButtonBuilder,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('monument_detail_scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('eser bilgileri bölümler halinde gösterilir', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpDetail(tester);

    expect(find.byKey(const Key('monument_detail_name')), findsOneWidget);
    expect(find.bySemanticsLabel('Yapı türü: Cami'), findsOneWidget);
    expect(find.bySemanticsLabel('Dönem: Osmanlı'), findsOneWidget);
    expect(find.bySemanticsLabel('Yapım tarihi: 1568–1575'), findsOneWidget);
    expect(
      find.byKey(const Key('monument_detail_unesco_badge')),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Fotoğraf galerisi, 5 fotoğraf'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(RegExp(r'^Fotoğraf 1 / 5: Mavi gökyüzü')),
      findsOneWidget,
    );

    for (final heading in [
      'Hakkında',
      'Tarihçe',
      'Eser künyesi',
      'Konum',
      'Fotoğraf künyesi',
    ]) {
      await scrollTo(tester, find.text(heading));
      expect(find.text(heading), findsOneWidget, reason: heading);
    }
    expect(find.text('Sultan II. Selim'), findsOneWidget);
    expect(find.text('Mimar Sinan'), findsOneWidget);
    expect(find.textContaining('Meydan Mahallesi'), findsOneWidget);
    expect(
      find.text('Aziz Akbiyik · CC BY-SA 3.0 · Wikimedia Commons'),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets('künye başlığın hemen altında, kompakt kartta; bilgi '
      'tekrarlanmaz', (tester) async {
    await pumpDetail(tester);

    final card = find.byKey(const Key('monument_facts_card'));
    final name = tester.getRect(find.byKey(const Key('monument_detail_name')));
    final about = find.text('Hakkında');
    expect(tester.getRect(card).top, greaterThan(name.bottom));
    expect(tester.getRect(card).bottom, lessThan(tester.getRect(about).top));
    // Tür, dönem ve yapım tarihi yalnızca künyede bir kez gösterilir.
    expect(find.text('Cami'), findsOneWidget);
    expect(find.text('1568–1575'), findsOneWidget);

    // İki sütun: "Yapı türü" ile "Dönem" aynı satırda.
    final category = tester.getRect(find.text('Yapı türü'));
    final period = tester.getRect(find.text('Dönem'));
    expect(category.top, moreOrLessEquals(period.top, epsilon: 1));
    expect(period.left, greaterThan(category.right));
  });

  testWidgets('künye %200 metin ölçeğinde tek sütuna geçer', (tester) async {
    await pumpDetail(tester, textScale: 2);

    final category = tester.getRect(find.text('Yapı türü'));
    final period = tester.getRect(find.text('Dönem'));
    expect(period.top, greaterThan(category.bottom));
    expect(tester.takeException(), isNull);
  });

  testWidgets('galeri butonlar ve küçük resimlerle gezilir', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpDetail(tester);

    final previous = find.byKey(const Key('photo_gallery_previous_button'));
    final next = find.byKey(const Key('photo_gallery_next_button'));
    expect(previous, findsNothing, reason: 'ilk fotoğrafta önceki yok');

    await tester.tap(next);
    await tester.pumpAndSettle();
    expect(find.text('2 / 5'), findsOneWidget);
    expect(
      tester.getSemantics(find.byKey(const Key('photo_gallery_thumbnail_1'))),
      isSemantics(isSelected: true, isButton: true),
    );

    await tester.tap(find.byKey(const Key('photo_gallery_thumbnail_4')));
    await tester.pumpAndSettle();
    expect(find.text('5 / 5'), findsOneWidget);
    expect(next, findsNothing, reason: 'son fotoğrafta sonraki yok');
    expect(previous, findsOneWidget);
    semantics.dispose();
  });

  testWidgets('tam ekran görüntüleyici altyazı ve künye gösterir', (
    tester,
  ) async {
    await pumpDetail(tester);
    final detail = fixtureDetail('selimiye-camii');

    await tester.tap(find.byKey(const Key('photo_gallery_pages')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('photo_viewer_caption')), findsOneWidget);
    expect(find.text(detail.images.first.altText), findsWidgets);
    expect(find.text('1 / 5'), findsWidgets);

    await tester.tap(find.byKey(const Key('photo_viewer_next_button')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(const Key('photo_viewer_caption'))).data,
      detail.images[1].altText,
    );

    await tester.tap(find.byKey(const Key('photo_viewer_close_button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('photo_viewer_caption')), findsNothing);
    expect(find.text('2 / 5'), findsOneWidget, reason: 'galeri senkron');
  });

  testWidgets('sesli dinle metni okur ve durdurulabilir', (tester) async {
    await pumpDetail(tester);

    await scrollTo(tester, find.byKey(const Key('monument_listen_button')));
    await tester.tap(find.byKey(const Key('monument_listen_button')));
    await tester.pump();
    final spoken =
        verify(() => tts.speak(captureAny())).captured.single as String;
    expect(spoken, startsWith('Selimiye Camii. Cami, Merkez, Edirne.'));
    verify(() => tts.setLanguage('tr-TR')).called(1);

    ttsStarted();
    await tester.pump();
    expect(find.text('Seslendirmeyi durdur'), findsOneWidget);

    await tester.tap(find.byKey(const Key('monument_listen_button')));
    await tester.pump();
    verify(tts.stop).called(1);
  });

  testWidgets('Anı Köşesi yuvası konum bölümünden sonra eser kaydıyla '
      'kurulur', (tester) async {
    String? builtFor;
    await pumpDetail(
      tester,
      memoriesBuilder: (context, monument) {
        builtFor = monument.id;
        return const SizedBox(key: Key('memories_slot'), height: 120);
      },
    );
    final slot = find.byKey(const Key('memories_slot'));
    await scrollTo(tester, slot);

    expect(builtFor, 'selimiye-camii');
    expect(
      tester.getTopLeft(slot).dy,
      greaterThan(
        tester
            .getBottomLeft(
              find.byKey(const Key('monument_detail_show_on_map_button')),
            )
            .dy,
      ),
    );
  });

  testWidgets('"Bir sorun mu gördünüz?" bölümü Sivil Koruma bildirimine '
      'geçer; geri çağrı yoksa gösterilmez', (tester) async {
    var reports = 0;
    await pumpDetail(tester, onReportDamage: () => reports++);
    final button = find.byKey(const Key('monument_report_damage_button'));
    await scrollTo(tester, button);

    expect(find.text('Bir sorun mu gördünüz?'), findsOneWidget);
    await tester.tap(button);
    expect(reports, 1);

    await pumpDetail(tester);
    expect(
      find.byKey(const Key('monument_report_damage_section')),
      findsNothing,
    );
  });

  testWidgets('haritada göster geri çağrısını tetikler', (tester) async {
    await pumpDetail(tester);
    final button = find.byKey(const Key('monument_detail_show_on_map_button'));

    await scrollTo(tester, button);
    await tester.tap(button);

    expect(showOnMapCalls, 1);
    expect(find.byKey(const Key('monument_detail_map')), findsOneWidget);
  });

  testWidgets('bulunamayan eser için haritaya dönüş sunulur', (tester) async {
    when(() => getDetail(any())).thenAnswer(
      (_) async => const Left(
        ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
      ),
    );
    await pumpDetail(tester, id: 'yok');

    expect(find.byKey(const Key('monument_detail_not_found')), findsOneWidget);
    expect(find.text('Eser bulunamadı'), findsOneWidget);

    await tester.tap(find.text('Haritaya dön'));
    expect(backToMapCalls, 1);
  });

  testWidgets('ağ hatasında tekrar dene yeniden yükler', (tester) async {
    when(() => getDetail(any()))
        .thenAnswer((_) async => const Left(NetworkFailure()));
    await pumpDetail(tester);
    expect(find.byKey(const Key('monument_detail_error')), findsOneWidget);

    when(() => getDetail(any()))
        .thenAnswer((_) async => Right(fixtureDetail('selimiye-camii')));
    await tester.tap(find.text('Tekrar dene'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('monument_detail_name')), findsOneWidget);
  });

  testWidgets('dokunma hedefleri erişilebilirlik kılavuzlarına uyar', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpDetail(tester);

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });

  for (final (name, theme) in [
    ('koyu', AppTheme.dark()),
    ('açık', AppTheme.light()),
    ('koyu yüksek kontrast', AppTheme.highContrastDark()),
  ]) {
    testWidgets('%200 metin ölçeğinde taşma olmaz ($name)', (tester) async {
      await pumpDetail(
        tester,
        id: 'divrigi-ulu-camii-ve-darussifasi',
        textScale: 2,
        theme: theme,
      );

      await scrollTo(tester, find.text('Fotoğraf künyesi'));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('üst çubuktaki kaydet butonu eseri kaydeder ve geri alınır', (
    tester,
  ) async {
    final env = SavedMonumentsTestEnvironment();
    final saved = env.cubit();
    addTearDown(() => unawaited(saved.close()));
    await pumpDetail(
      tester,
      saveButtonBuilder: (context, monument) =>
          BlocSelector<SavedMonumentsCubit, SavedMonumentsState, bool>(
            bloc: saved,
            selector: (state) => state.contains(monument.id),
            builder: (context, isSaved) => MonumentSaveButton(
              isSaved: isSaved,
              monumentName: monument.name,
              onPressed: () => toggleSavedMonument(
                context,
                cubit: saved,
                monumentId: monument.id,
                monumentName: monument.name,
              ),
            ),
          ),
    );

    final save = find.descendant(
      of: find.byType(SliverAppBar),
      matching: find.byKey(const Key('monument_save_button')),
    );
    expect(save, findsOneWidget);
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(saved.state.contains('selimiye-camii'), isTrue);
    expect(find.text('Kaydedildi: Selimiye Camii'), findsOneWidget);

    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(saved.state.contains('selimiye-camii'), isFalse);
    await tester.tap(find.text('Geri al'));
    await tester.pumpAndSettle();
    expect(saved.state.contains('selimiye-camii'), isTrue);
  });
}
