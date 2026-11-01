import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/accessibility/presentation/pages/accessibility_page.dart';
import 'package:vakif_atlas/features/settings/domain/entities/accessibility_preferences.dart';
import 'package:vakif_atlas/features/settings/domain/entities/app_settings.dart';
import 'package:vakif_atlas/features/settings/domain/usecases/get_app_settings_usecase.dart';
import 'package:vakif_atlas/features/settings/domain/usecases/save_app_settings_usecase.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_cubit.dart';

class _MockGet extends Mock implements GetAppSettingsUseCase {}

class _MockSave extends Mock implements SaveAppSettingsUseCase {}

void main() {
  late AppSettingsCubit cubit;
  late _MockSave save;
  late List<String> announcements;

  setUpAll(() => registerFallbackValue(AppSettings.defaults));

  setUp(() {
    final get = _MockGet();
    save = _MockSave();
    when(get.call).thenReturn(AppSettings.defaults);
    when(() => save(any())).thenAnswer((_) async => const Right(unit));
    cubit = AppSettingsCubit(
      get,
      save,
      HapticFeedbackService.withDelay((_) async {}),
    );
    announcements = [];
  });

  tearDown(() => cubit.close());

  AccessibilityPreferences prefs() => cubit.state.settings.accessibility;

  Finder tile(AccessibilityFeature feature) =>
      find.byKey(Key('a11y_tile_${feature.name}'));

  Future<void> pumpPage(
    WidgetTester tester, {
    double textScale = 1,
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<A11yAnnouncer>.value(
            value: A11yAnnouncer.withSender(
              (_, message, _, _) async => announcements.add(message),
            ),
          ),
          RepositoryProvider<HapticFeedbackService>.value(
            value: HapticFeedbackService.withDelay((_) async {}),
          ),
        ],
        child: BlocProvider<AppSettingsCubit>.value(
          value: cubit,
          child: MaterialApp(
            theme: AppTheme.light(),
            locale: const Locale('tr'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(textScale)),
              child: child!,
            ),
            home: const AccessibilityPage(),
          ),
        ),
      ),
    );
  }

  /// Kutucuğu kaydırıp tamamen görünür hale getirir ve dokunur.
  Future<void> tap(WidgetTester tester, AccessibilityFeature feature) async {
    await tester.scrollUntilVisible(tile(feature), 200);
    await tester.ensureVisible(tile(feature));
    await tester.pumpAndSettle();
    await tester.tap(tile(feature));
    await tester.pumpAndSettle();
  }

  testWidgets('tüm özellikler tek panelde; büyük imleç yalnızca fareyle', (
    tester,
  ) async {
    await pumpPage(tester);

    for (final feature in AccessibilityFeature.values) {
      if (feature == AccessibilityFeature.bigCursor) {
        continue;
      }
      await tester.scrollUntilVisible(tile(feature), 200);
      expect(tile(feature), findsOneWidget, reason: feature.name);
    }
    // Dokunmatik cihazda fare imleci yoktur.
    expect(tile(AccessibilityFeature.bigCursor), findsNothing);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(tile(AccessibilityFeature.bigCursor), 200);
    expect(tile(AccessibilityFeature.bigCursor), findsOneWidget);
  });

  testWidgets('her dokunuş bir sonraki seviyeye geçer ve duyurulur', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpPage(tester);

    await tap(tester, AccessibilityFeature.grayscale);
    expect(prefs().level(AccessibilityFeature.grayscale), 1);
    expect(announcements.last, 'Gri Tonlama: %25');
    expect(
      tester.getSemantics(tile(AccessibilityFeature.grayscale)),
      matchesSemantics(
        isButton: true,
        hasTapAction: true,
        hasEnabledState: true,
        isEnabled: true,
        label: 'Gri Tonlama',
        value: '%25, Seviye 1 / 4',
        onTapHint: 'sonraki seviye',
      ),
    );

    for (var i = 0; i < 4; i++) {
      await tap(tester, AccessibilityFeature.grayscale);
    }
    expect(prefs().level(AccessibilityFeature.grayscale), 0);
    expect(announcements.last, 'Gri Tonlama: Kapalı');

    await tap(tester, AccessibilityFeature.contrast);
    expect(announcements.last, 'Kontrast: Yüksek kontrast');
    verify(() => save(any())).called(6);
    handle.dispose();
  });

  testWidgets('açma/kapama kutucuğu durumunu toggled olarak bildirir', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpPage(tester);

    await tap(tester, AccessibilityFeature.hideImages);

    expect(prefs().hideImages, isTrue);
    expect(
      tester.getSemantics(tile(AccessibilityFeature.hideImages)),
      matchesSemantics(
        isButton: true,
        hasTapAction: true,
        hasEnabledState: true,
        isEnabled: true,
        hasToggledState: true,
        isToggled: true,
        label: 'Görseli Gizle',
        value: 'Açık',
        onTapHint: 'sonraki seviye',
      ),
    );
    handle.dispose();
  });

  testWidgets('cihazda hareket azaltma açıksa kutucuk açık ve kilitlidir', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await pumpPage(tester);

    await tester.scrollUntilVisible(
      tile(AccessibilityFeature.stopAnimations),
      200,
    );
    await tester.tap(tile(AccessibilityFeature.stopAnimations));
    await tester.pumpAndSettle();

    expect(prefs().reduceMotion, isFalse);
    verifyNever(() => save(any()));
  });

  testWidgets('varsayılanlara dönülür, duyurulur ve geri alınabilir', (
    tester,
  ) async {
    await pumpPage(tester);
    final reset = find.byKey(const Key('accessibility_reset_button'));
    await tester.scrollUntilVisible(reset, 200);
    await tester.tap(reset);
    await tester.pump();
    // Varsayılandayken kapalıdır.
    verifyNever(() => save(any()));

    await tap(tester, AccessibilityFeature.zoom);
    await tap(tester, AccessibilityFeature.lineHeight);
    await tester.scrollUntilVisible(reset, 200);
    await tester.ensureVisible(reset);
    await tester.pumpAndSettle();
    await tester.tap(reset);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));

    expect(prefs().isDefault, isTrue);
    expect(
      announcements,
      contains('Erişilebilirlik tercihleri varsayılana döndürüldü.'),
    );
    await tester.tap(find.text('Geri al'));
    await tester.pump();
    expect(prefs().level(AccessibilityFeature.zoom), 1);
    expect(prefs().level(AccessibilityFeature.lineHeight), 1);
  });

  testWidgets('kaydetme hatasında bilgilendirme gösterilir', (tester) async {
    when(() => save(any())).thenAnswer((_) async => const Left(CacheFailure()));
    await pumpPage(tester);

    await tap(tester, AccessibilityFeature.easyReading);

    expect(
      find.text(
        'Ayar bu cihaza kaydedilemedi. Uygulama yeniden açıldığında önceki '
        'değer kullanılacak.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('%200 metin ölçeğinde taşma olmadan kaydırılabilir', (
    tester,
  ) async {
    await pumpPage(tester, textScale: 2, size: const Size(320, 640));
    await tester.scrollUntilVisible(
      find.byKey(const Key('accessibility_reset_button')),
      300,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('dokunma hedefi, etiket ve kontrast kılavuzlarını karşılar', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpPage(tester);
    await tap(tester, AccessibilityFeature.contrast);
    await tester.scrollUntilVisible(tile(AccessibilityFeature.readAloud), -200);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
