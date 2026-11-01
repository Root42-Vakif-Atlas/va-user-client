import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/core/location/location_service.dart';
import 'package:vakif_atlas/core/media/photo_picker_service.dart';
import 'package:vakif_atlas/features/catalog/presentation/bloc/monument_search_bloc.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/bloc/damage_report_wizard_bloc.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/cubit/damage_report_detail_cubit.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/cubit/damage_report_list_cubit.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/pages/civil_protection_page.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/pages/damage_report_detail_page.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/pages/damage_report_wizard_page.dart';

import '../../../helpers/catalog_test_utils.dart';
import '../../../helpers/civil_protection_test_utils.dart';
import '../../../helpers/location_test_utils.dart';
import '../../../helpers/memory_test_utils.dart';
import '../../../helpers/pump_app.dart';

Future<void> _settleRequests(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}

void main() {
  late List<String> announcements;

  setUp(() => announcements = []);

  Widget withAnnouncer(Widget child) => RepositoryProvider<A11yAnnouncer>.value(
    value: A11yAnnouncer.withSender(
      (_, message, _, _) async => announcements.add(message),
    ),
    child: child,
  );

  Future<void> expectAccessible(WidgetTester tester) async {
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  }

  group('Sivil Koruma sekmesi', () {
    late int signIns;
    late int creates;
    late List<String> opened;

    setUp(() {
      signIns = 0;
      creates = 0;
      opened = [];
    });

    Future<void> pumpTab(
      WidgetTester tester,
      CivilProtectionTestEnvironment env, {
      String? viewerId,
      double textScale = 1,
    }) async {
      await tester.pumpApp(
        withAnnouncer(
          BlocProvider<DamageReportListCubit>(
            create: (_) => env.listCubit(),
            child: CivilProtectionPage(
              viewerId: viewerId,
              onSignIn: () => signIns++,
              onCreateReport: () => creates++,
              onOpenReport: opened.add,
            ),
          ),
        ),
        textScale: textScale,
        surfaceSize: const Size(400, 1400),
      );
      await _settleRequests(tester);
    }

    testWidgets('misafir tanıtımı ve giriş butonunu görür; sekmede kalıcı '
        '112 uyarısı yok', (tester) async {
      await pumpTab(tester, CivilProtectionTestEnvironment());

      expect(find.text('Kültürel mirası birlikte koruyalım'), findsOneWidget);
      expect(find.textContaining('112'), findsNothing);
      expect(find.byKey(const Key('cp_new_report_fab')), findsNothing);
      await tester.tap(find.byKey(const Key('cp_sign_in_button')));
      expect(signIns, 1);
    });

    testWidgets('oturum açık kullanıcı bildirimlerini durumlarıyla görür', (
      tester,
    ) async {
      final env = CivilProtectionTestEnvironment();
      await tester.runAsync(env.signIn);
      await pumpTab(tester, env, viewerId: 'usr_demo_001');

      expect(find.text('Bildirimlerim'), findsOneWidget);
      expect(find.text('Kızlarağası Hanı'), findsOneWidget);
      expect(find.text('Sonuçlandı'), findsOneWidget);
      expect(find.text('İnceleniyor'), findsOneWidget);
      expect(
        find.bySemanticsLabel(
          RegExp(
            'Bursa Ulu Camii, Yapısal hasar. Kayıt SK-2026-000102. Durum: İnceleniyor',
          ),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('damage_report_rpt_seed_0002')));
      expect(opened, ['rpt_seed_0002']);
      await tester.tap(find.byKey(const Key('cp_new_report_fab')));
      expect(creates, 1);
    });

    testWidgets('%200 metin ölçeği ve erişilebilirlik (misafir ve liste)', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpTab(tester, CivilProtectionTestEnvironment(), textScale: 2);
      await expectAccessible(tester);

      final env = CivilProtectionTestEnvironment();
      await tester.runAsync(env.signIn);
      await pumpTab(tester, env, viewerId: 'usr_demo_001', textScale: 2);
      // %200 metinde FAB içeriğin üstündedir; liste sonundaki boşluk
      // (FAB payı) kaydırınca içeriği açığa çıkarır. Kontrast FAB'ın kendi
      // zemininde ölçülsün.
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -2000));
      await tester.pumpAndSettle();
      await expectAccessible(tester);
      handle.dispose();
    });
  });

  group('Adım adım bildirim', () {
    late int closed;
    late List<DamageReport> submitted;

    setUp(() {
      closed = 0;
      submitted = [];
    });

    Future<CivilProtectionTestEnvironment> pumpWizard(
      WidgetTester tester, {
      String? monumentId = 'selimiye-camii',
      FakeLocationService? location,
      FakePhotoPickerService? picker,
      double textScale = 1,
    }) async {
      final env = CivilProtectionTestEnvironment();
      await tester.runAsync(env.signIn);
      await tester.pumpApp(
        withAnnouncer(
          MultiBlocProvider(
            providers: [
              BlocProvider<DamageReportWizardBloc>(
                create: (_) => env.wizardBloc(
                  location: location,
                  picker:
                      picker ?? FakePhotoPickerService(supportsCamera: false),
                ),
              ),
              BlocProvider<MonumentSearchBloc>(
                create: (_) => MonumentSearchBloc(catalogUseCases().search),
              ),
            ],
            child: DamageReportWizardPage(
              initialMonumentId: monumentId,
              onClose: () => closed++,
              onSubmitted: submitted.add,
            ),
          ),
        ),
        textScale: textScale,
        surfaceSize: const Size(400, 1000),
      );
      await _settleRequests(tester);
      return env;
    }

    Future<void> next(WidgetTester tester) async {
      await tester.tap(find.byKey(const Key('cp_next')));
      await tester.pumpAndSettle();
    }

    Future<void> tapVisible(WidgetTester tester, Finder finder) async {
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    testWidgets('eser seçili açılır, adımlar tamamlanıp bildirim gönderilir', (
      tester,
    ) async {
      await pumpWizard(
        tester,
        location: FakeLocationService(
          result: const LocationFound(
            DevicePosition(
              latitude: 41.6790,
              longitude: 26.5600,
              accuracyMeters: 12,
            ),
          ),
        ),
        picker: FakePhotoPickerService(supportsCamera: false)
          ..results.add(PhotosPicked([testJpeg()])),
      );

      // Eser detayından gelindi: 2. adım.
      expect(find.text('Adım 2/6: Hasar türü'), findsOneWidget);
      await next(tester);
      expect(find.text('Bir hasar türü seçin.'), findsWidgets);
      expect(announcements, contains('Bir hasar türü seçin.'));

      await tapVisible(
        tester,
        find.byKey(const Key('cp_category_DamageCategory.vandalism')),
      );
      await next(tester);
      expect(announcements, contains('Adım 3/6: Aciliyet'));
      expect(find.textContaining('112'), findsOneWidget);
      await tapVisible(
        tester,
        find.byKey(const Key('cp_urgency_ReportUrgency.high')),
      );
      await next(tester);

      await tester.enterText(
        find.byKey(const Key('cp_description')),
        'Avlu duvarında sprey boyayla yapılmış yazılar var.',
      );
      await tapVisible(tester, find.byKey(const Key('report_add_photo')));
      await _settleRequests(tester);
      expect(
        find.bySemanticsLabel('Fotoğraf 1, açıklama eklenmedi'),
        findsOneWidget,
      );
      await next(tester);

      await tester.tap(find.byKey(const Key('cp_location_toggle')));
      await _settleRequests(tester);
      expect(find.byKey(const Key('cp_location_found')), findsOneWidget);
      expect(find.textContaining('yerinde yapılmış'), findsOneWidget);
      await next(tester);

      expect(find.text('Bildiriminizi kontrol edin'), findsOneWidget);
      expect(find.text('Konum eklendi'), findsOneWidget);
      expect(find.text('1 fotoğraf'), findsOneWidget);
      await tester.tap(find.byKey(const Key('cp_submit')));
      await _settleRequests(tester);

      expect(submitted.single.referenceCode, 'SK-2026-000103');
      expect(
        submitted.single.locationCheck.verification,
        LocationVerification.onSite,
      );
      expect(announcements, contains('Bildiriminiz alındı · SK-2026-000103'));
    });

    testWidgets('gözden geçirmede "Düzenle" ilgili adıma döner; geri tuşu '
        'önceki adıma gider', (tester) async {
      await pumpWizard(tester);
      await tapVisible(
        tester,
        find.byKey(const Key('cp_category_DamageCategory.theft')),
      );
      await next(tester);
      await tapVisible(
        tester,
        find.byKey(const Key('cp_urgency_ReportUrgency.low')),
      );
      await next(tester);
      await tester.enterText(
        find.byKey(const Key('cp_description')),
        'Mihrap çevresindeki çinilerden biri eksik görünüyor.',
      );
      await next(tester);
      await next(tester);

      await tester.tap(find.byKey(const Key('cp_review_edit_category')));
      await tester.pumpAndSettle();
      expect(find.text('Adım 2/6: Hasar türü'), findsOneWidget);

      final popped = await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(popped, isTrue);
      expect(find.text('Adım 1/6: Eser'), findsOneWidget);
      expect(closed, 0);
    });

    testWidgets('eser seçiciden eser seçilir', (tester) async {
      final env = CivilProtectionTestEnvironment();
      await tester.runAsync(env.signIn);
      tester.view.physicalSize =
          const Size(400, 1000) * tester.view.devicePixelRatio;
      addTearDown(tester.view.resetPhysicalSize);
      // Seçici yeni bir rotada açılır; uygulamadaki gibi duyurucu köktedir.
      await tester.pumpWidget(
        withAnnouncer(
          MaterialApp(
            locale: const Locale('tr'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.light(),
            home: MultiBlocProvider(
              providers: [
                BlocProvider<DamageReportWizardBloc>(
                  create: (_) => env.wizardBloc(),
                ),
                BlocProvider<MonumentSearchBloc>(
                  create: (_) => MonumentSearchBloc(catalogUseCases().search),
                ),
              ],
              child: DamageReportWizardPage(
                onClose: () => closed++,
                onSubmitted: submitted.add,
              ),
            ),
          ),
        ),
      );
      await _settleRequests(tester);

      expect(find.text('Adım 1/6: Eser'), findsOneWidget);
      await tester.tap(find.byKey(const Key('cp_choose_monument')));
      await tester.pump(const Duration(milliseconds: 500));
      await _settleRequests(tester);
      final first = find.byWidgetPredicate(
        (widget) =>
            widget.key is ValueKey<String> &&
            (widget.key! as ValueKey<String>).value.startsWith('report_pick_'),
      );
      await tester.tap(first.first);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('cp_selected_monument')), findsOneWidget);
      await tester.tap(find.byKey(const Key('cp_next')));
      await tester.pumpAndSettle();
      expect(find.text('Adım 2/6: Hasar türü'), findsOneWidget);
    });

    testWidgets('içerikle kapatırken onay istenir', (tester) async {
      await pumpWizard(tester);
      await tapVisible(
        tester,
        find.byKey(const Key('cp_category_DamageCategory.other')),
      );

      await tester.tap(find.byKey(const Key('cp_wizard_close')));
      await tester.pumpAndSettle();
      expect(find.text('Bildirim taslağı silinsin mi?'), findsOneWidget);
      await tester.tap(find.byKey(const Key('cp_discard_confirm')));
      await tester.pumpAndSettle();
      expect(closed, 1);
    });

    testWidgets('%200 metin ölçeği ve erişilebilirlik (tüm adımlar)', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpWizard(tester, textScale: 2);
      await expectAccessible(tester);
      await tapVisible(
        tester,
        find.byKey(const Key('cp_category_DamageCategory.vandalism')),
      );
      await next(tester);
      await expectAccessible(tester);
      await tapVisible(
        tester,
        find.byKey(const Key('cp_urgency_ReportUrgency.critical')),
      );
      await next(tester);
      await tester.enterText(
        find.byKey(const Key('cp_description')),
        'Kubbede çökme tehlikesi yaratan büyük bir yarık oluştu.',
      );
      await next(tester);
      await expectAccessible(tester);
      await next(tester);
      await expectAccessible(tester);
      handle.dispose();
    });
  });

  group('Bildirim ayrıntısı', () {
    Future<void> pumpDetail(
      WidgetTester tester,
      String id, {
      double textScale = 1,
    }) async {
      final env = CivilProtectionTestEnvironment();
      await tester.runAsync(env.signIn);
      await tester.pumpApp(
        withAnnouncer(
          BlocProvider<DamageReportDetailCubit>(
            create: (_) => env.detailCubit(),
            child: DamageReportDetailPage(reportId: id, onBackToList: () {}),
          ),
        ),
        textScale: textScale,
        surfaceSize: const Size(400, 1800),
      );
      await _settleRequests(tester);
    }

    testWidgets('kayıt numarası, süreç ve VGM notu gösterilir', (tester) async {
      await pumpDetail(tester, 'rpt_seed_0001');

      expect(find.text('SK-2026-000101'), findsOneWidget);
      for (final status in ['received', 'inReview', 'forwarded', 'resolved']) {
        expect(find.byKey(Key('cp_status_$status')), findsOneWidget);
      }
      expect(find.text('VGM notu'), findsOneWidget);
      expect(find.text('Yerinde doğrulandı (esere 18 m)'), findsOneWidget);
      expect(
        tester.getSemantics(find.byKey(const Key('cp_status_resolved'))).label,
        startsWith('Sonuçlandı, şu anki adım'),
      );
    });

    testWidgets('süren bildirimde sonraki adımlar "bekleniyor"', (
      tester,
    ) async {
      await pumpDetail(tester, 'rpt_seed_0002');

      expect(
        tester.getSemantics(find.byKey(const Key('cp_status_forwarded'))).label,
        'Yetkili birime iletildi, Bekleniyor',
      );
      expect(find.text('Konum paylaşılmadı'), findsOneWidget);
    });

    testWidgets('kayıt numarası kopyalanır ve duyurulur', (tester) async {
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await pumpDetail(tester, 'rpt_seed_0001');

      await tester.tap(find.byKey(const Key('cp_copy_reference')));
      await tester.pump();
      expect(copied, 'SK-2026-000101');
      expect(announcements, contains('Kayıt numarası kopyalandı'));
    });

    testWidgets('başkasının veya bilinmeyen bildirim bulunamadı', (
      tester,
    ) async {
      await pumpDetail(tester, 'rpt_yok');
      expect(find.byKey(const Key('cp_detail_not_found')), findsOneWidget);
    });

    testWidgets('%200 metin ölçeği ve erişilebilirlik', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpDetail(tester, 'rpt_seed_0001', textScale: 2);
      await expectAccessible(tester);
      handle.dispose();
    });
  });
}
