import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/app.dart';
import 'package:vakif_atlas/core/a11y/accessibility_scope.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/a11y/voice_io_service.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/core/router/app_router.dart';
import 'package:vakif_atlas/core/router/routes.dart';
import 'package:vakif_atlas/core/storage/preferences_service.dart';
import 'package:vakif_atlas/core/theme/color_blindness_filter.dart';
import 'package:vakif_atlas/core/theme/color_blindness_profile.dart';
import 'package:vakif_atlas/core/theme/extensions/app_color_scheme.dart';
import 'package:vakif_atlas/core/theme/tokens/app_colors.dart';
import 'package:vakif_atlas/core/theme/tokens/app_typography.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas/features/settings/domain/entities/accessibility_preferences.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_cubit.dart';

import '../../helpers/test_di.dart';

class _MockVoice extends Mock implements VoiceIoService {}

/// Erişilebilirlik panelinin her kutucuğu, gerçek uygulamada (kök
/// sağlayıcılar, tema, filtreler, katmanlar) gerçek dokunuşla her seviyede
/// denenir; etkinin tüm uygulamaya uygulandığı kök ağaçtan ölçülür.
void main() {
  late _MockVoice voice;

  const intro =
      'Bir kutucuğa her dokunuşta bir sonraki seviyeye geçilir; son '
      'seviyeden sonra kapanır. Tercihler tüm uygulamaya hemen uygulanır ve '
      'bu cihazda saklanır.';

  setUp(() {
    voice = _MockVoice();
    when(() => voice.speak(any(), languageCode: any(named: 'languageCode')))
        .thenAnswer((_) async {});
    when(() => voice.stop()).thenAnswer((_) async {});
  });

  tearDown(resetDependencies);

  Future<void> openPanel(WidgetTester tester) async {
    await TestDependencies.setUp(preferences: {'settings.language_code': 'tr'});
    getIt.registerSingleton<VoiceIoService>(voice);
    getIt<AuthBloc>().add(const AuthEvent.started());
    await tester.pumpWidget(const VakifAtlasApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    // `push` sayfa kapanınca tamamlanır; beklenmez.
    unawaited(getIt<AppRouter>().router.push(AppRoutes.accessibility));
    await tester.pumpAndSettle();
  }

  Future<void> unmount(WidgetTester tester) =>
      tester.pumpWidget(const SizedBox.shrink());

  Finder tileOf(AccessibilityFeature feature) =>
      find.byKey(Key('a11y_tile_${feature.name}'));

  /// Kutucuğa kullanıcı gibi dokunur.
  Future<void> tap(WidgetTester tester, AccessibilityFeature feature) async {
    final tile = tileOf(feature);
    await tester.scrollUntilVisible(
      tile,
      120,
      scrollable: find.descendant(
        of: find.byKey(const Key('accessibility_list')),
        matching: find.byType(Scrollable),
      ),
    );
    // Kenardan görünmesi yetmez: dokunulacak merkez ekranda olmalı.
    await tester.ensureVisible(tile);
    await tester.pumpAndSettle();
    final before = getIt<AppSettingsCubit>().state.settings.accessibility.level(
      feature,
    );
    await tester.tap(tile);
    await tester.pumpAndSettle();
    // Dokunuş kutucuğa ulaştı ve bir sonraki seviyeye geçti.
    expect(
      getIt<AppSettingsCubit>().state.settings.accessibility.level(feature),
      (before + 1) % (feature.levels + 1),
      reason: '${feature.name} dokunuşu uygulanmadı',
    );
  }

  /// Listeyi başa kaydırır (açıklama metni yeniden çizilir).
  Future<void> scrollToTop(WidgetTester tester) async {
    tester
        .state<ScrollableState>(
          find.descendant(
            of: find.byKey(const Key('accessibility_list')),
            matching: find.byType(Scrollable),
          ),
        )
        .position
        .jumpTo(0);
    await tester.pumpAndSettle();
  }

  BuildContext page(WidgetTester tester) =>
      tester.element(find.byKey(const Key('accessibility_list')));

  /// Tüm rotaları saran kök renk filtresi; yoksa `null`.
  ColorFilter? rootFilter(WidgetTester tester) {
    final filters = find.ancestor(
      of: find.byType(Navigator).first,
      matching: find.byType(ColorFiltered),
    );
    return filters.evaluate().isEmpty
        ? null
        : tester.widget<ColorFiltered>(filters.first).colorFilter;
  }

  /// Sayfanın açıklama metninin ekranda çizilen stili.
  Future<TextStyle> introStyle(WidgetTester tester) async {
    await scrollToTop(tester);
    return tester
        .widget<RichText>(
          find.descendant(
            of: find.text(intro),
            matching: find.byType(RichText),
          ),
        )
        .text
        .style!;
  }

  /// Ortalanmış bir kutucuk etiketinin çizilen hizası.
  TextAlign tileLabelAlign(WidgetTester tester) => tester
      .widget<RichText>(
        find.descendant(
          of: find.text('Yakınlaştırma'),
          matching: find.byType(RichText),
        ),
      )
      .textAlign;

  AppColorScheme scheme(WidgetTester tester) =>
      Theme.of(page(tester)).extension<AppColorScheme>()!;

  int level(AccessibilityFeature feature) =>
      getIt<PreferencesService>().accessibilityLevels?[feature.name] ?? -1;

  testWidgets('Sesli Okuma: dokunulan metin seslendirilir; kapatınca durur', (
    tester,
  ) async {
    await openPanel(tester);

    await tap(tester, AccessibilityFeature.readAloud);
    await scrollToTop(tester);
    await tester.tap(find.text(intro));
    await tester.pump();
    verify(() => voice.speak(intro, languageCode: 'tr')).called(1);

    await tap(tester, AccessibilityFeature.readAloud);
    verify(() => voice.stop()).called(greaterThanOrEqualTo(1));
    await scrollToTop(tester);
    await tester.tap(find.text(intro));
    await tester.pump();
    verifyNever(() => voice.speak(intro, languageCode: 'tr'));
    await unmount(tester);
  });

  testWidgets('Odağı Oku: klavye odağındaki öğe seslendirilir', (tester) async {
    await openPanel(tester);

    await tap(tester, AccessibilityFeature.readOnFocus);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    verify(() => voice.speak(any(), languageCode: 'tr'))
        .called(greaterThanOrEqualTo(1));
    await unmount(tester);
  });

  testWidgets('Gri Tonlama: %25 – %100, sonra kapalı', (tester) async {
    await openPanel(tester);
    for (var step = 1; step <= 4; step++) {
      await tap(tester, AccessibilityFeature.grayscale);
      expect(
        rootFilter(tester),
        ColorFilter.matrix(ColorMatrices.grayscale(step / 4)),
        reason: 'seviye $step',
      );
    }
    await tap(tester, AccessibilityFeature.grayscale);
    expect(rootFilter(tester), isNull);
    await unmount(tester);
  });

  testWidgets('Kontrast: otomatik · koyu · açık · ters renk, sonra kapalı', (
    tester,
  ) async {
    await openPanel(tester);
    expect(scheme(tester), same(AppColorScheme.light));

    await tap(tester, AccessibilityFeature.contrast);
    expect(scheme(tester), same(AppColorScheme.highContrastLight));

    await tap(tester, AccessibilityFeature.contrast);
    expect(scheme(tester), same(AppColorScheme.highContrastDark));

    await tap(tester, AccessibilityFeature.contrast);
    expect(scheme(tester), same(AppColorScheme.highContrastLight));

    await tap(tester, AccessibilityFeature.contrast);
    expect(rootFilter(tester), const ColorFilter.matrix(ColorMatrices.invert));
    expect(scheme(tester).isHighContrast, isFalse);

    await tap(tester, AccessibilityFeature.contrast);
    expect(rootFilter(tester), isNull);
    expect(scheme(tester), same(AppColorScheme.light));
    await unmount(tester);
  });

  testWidgets('Yakınlaştırma: %125 – %200, sonra %100', (tester) async {
    await openPanel(tester);
    for (var step = 1; step <= 4; step++) {
      await tap(tester, AccessibilityFeature.zoom);
      expect(
        MediaQuery.textScalerOf(page(tester)).scale(10),
        closeTo(10 * (1 + step * 0.25), 0.001),
        reason: 'seviye $step',
      );
      expect(tester.takeException(), isNull);
    }
    await tap(tester, AccessibilityFeature.zoom);
    expect(MediaQuery.textScalerOf(page(tester)).scale(10), closeTo(10, 0.001));
    await unmount(tester);
  });

  testWidgets('Görseli Gizle tüm uygulamaya yansır', (tester) async {
    await openPanel(tester);
    await tap(tester, AccessibilityFeature.hideImages);
    expect(AccessibilityScope.of(page(tester)).hideImages, isTrue);
    await tap(tester, AccessibilityFeature.hideImages);
    expect(AccessibilityScope.of(page(tester)).hideImages, isFalse);
    await unmount(tester);
  });

  testWidgets('Bağlantıları Vurgula: butonlar alt çizgili ve çerçeveli', (
    tester,
  ) async {
    await openPanel(tester);
    TextDecoration? decoration() =>
        Theme.of(page(tester)).textButtonTheme.style!.textStyle!
            .resolve({})!
            .decoration;

    expect(decoration(), isNot(TextDecoration.underline));
    await tap(tester, AccessibilityFeature.highlightLinks);
    expect(decoration(), TextDecoration.underline);
    expect(
      Theme.of(page(tester)).textButtonTheme.style!.side!.resolve({}),
      isNotNull,
    );
    await tap(tester, AccessibilityFeature.highlightLinks);
    expect(decoration(), isNot(TextDecoration.underline));
    await unmount(tester);
  });

  testWidgets('Renk Körlüğü: protanopi · döteranopi · tritanopi', (
    tester,
  ) async {
    await openPanel(tester);
    for (final profile in [
      ColorBlindnessProfile.protanopia,
      ColorBlindnessProfile.deuteranopia,
      ColorBlindnessProfile.tritanopia,
    ]) {
      await tap(tester, AccessibilityFeature.colorBlindness);
      expect(
        rootFilter(tester),
        ColorFilter.matrix(DaltonizationMatrix.forProfile(profile)),
        reason: profile.name,
      );
    }
    await tap(tester, AccessibilityFeature.colorBlindness);
    expect(rootFilter(tester), isNull);
    await unmount(tester);
  });

  testWidgets('Kolay Okuma: ekrandaki metne WCAG 1.4.12 aralığı uygulanır', (
    tester,
  ) async {
    await openPanel(tester);
    final size = (await introStyle(tester)).fontSize!;

    await tap(tester, AccessibilityFeature.easyReading);
    final style = (await introStyle(tester));
    expect(style.letterSpacing, closeTo(size * 0.12, 0.001));
    expect(style.wordSpacing, closeTo(size * 0.16, 0.001));
    expect(style.height, greaterThanOrEqualTo(1.5));

    await tap(tester, AccessibilityFeature.easyReading);
    expect(
      (await introStyle(tester)).letterSpacing,
      isNot(closeTo(size * 0.12, 0.001)),
    );
    await unmount(tester);
  });

  testWidgets('Mavi Işık Filtresi: hafif · güçlü', (tester) async {
    await openPanel(tester);
    for (var step = 1; step <= 2; step++) {
      await tap(tester, AccessibilityFeature.blueLightFilter);
      expect(
        rootFilter(tester),
        ColorFilter.matrix(ColorMatrices.blueLight(step / 2)),
      );
    }
    await tap(tester, AccessibilityFeature.blueLightFilter);
    expect(rootFilter(tester), isNull);
    await unmount(tester);
  });

  testWidgets('Animasyonları Durdur tüm rotalara uygulanır', (tester) async {
    await openPanel(tester);
    await tap(tester, AccessibilityFeature.stopAnimations);
    expect(MediaQuery.disableAnimationsOf(page(tester)), isTrue);
    await tap(tester, AccessibilityFeature.stopAnimations);
    expect(MediaQuery.disableAnimationsOf(page(tester)), isFalse);
    await unmount(tester);
  });

  testWidgets('Disleksi Dostu: font · + aralık · + krem zemin', (tester) async {
    await openPanel(tester);
    final size = (await introStyle(tester)).fontSize!;

    await tap(tester, AccessibilityFeature.dyslexiaFriendly);
    expect(
      (await introStyle(tester)).fontFamily,
      AppFonts.atkinsonHyperlegible,
    );
    expect(
      (await introStyle(tester)).letterSpacing,
      isNot(closeTo(size * 0.12, 1e-3)),
    );

    await tap(tester, AccessibilityFeature.dyslexiaFriendly);
    expect(
      (await introStyle(tester)).letterSpacing,
      closeTo(size * 0.12, 0.001),
    );
    expect(scheme(tester).surface, isNot(AppColors.warmIvory));

    await tap(tester, AccessibilityFeature.dyslexiaFriendly);
    expect(scheme(tester).surface, AppColors.warmIvory);

    await tap(tester, AccessibilityFeature.dyslexiaFriendly);
    expect(
      (await introStyle(tester)).fontFamily,
      isNot(AppFonts.atkinsonHyperlegible),
    );
    expect(scheme(tester).surface, isNot(AppColors.warmIvory));
    await unmount(tester);
  });

  testWidgets('Okuma Kılavuzu: ince · kalın · maske', (tester) async {
    await openPanel(tester);
    for (var step = 1; step <= 3; step++) {
      await tap(tester, AccessibilityFeature.readingGuide);
      final guide = tester.widget<CustomPaint>(
        find.byKey(const Key('reading_guide')),
      );
      expect((guide.painter! as dynamic).level, step);
    }
    await tap(tester, AccessibilityFeature.readingGuide);
    expect(find.byKey(const Key('reading_guide')), findsNothing);
    await unmount(tester);
  });

  testWidgets('Odak Vurgusu: klavye odağı her seviyede çerçevelenir', (
    tester,
  ) async {
    await openPanel(tester);
    Finder ring() => find.byWidgetPredicate(
      (widget) =>
          widget is CustomPaint &&
          widget.painter.runtimeType.toString() == '_FocusRingPainter',
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(ring(), findsNothing);
    for (var step = 1; step <= 3; step++) {
      await tap(tester, AccessibilityFeature.focusHighlight);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(ring(), findsOneWidget, reason: 'seviye $step');
      expect(
        (tester.widget<CustomPaint>(ring()).painter! as dynamic).level,
        step,
      );
    }
    await tap(tester, AccessibilityFeature.focusHighlight);
    await tester.pumpAndSettle();
    expect(ring(), findsNothing);
    await unmount(tester);
  });

  testWidgets('Büyük İmleç: fareyle görünür; sistem imleci gizlenir', (
    tester,
  ) async {
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: const Offset(1, 1));
    addTearDown(mouse.removePointer);
    await openPanel(tester);
    MouseCursor? activeCursor() =>
        RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1);

    for (final size in [40.0, 56.0]) {
      await tap(tester, AccessibilityFeature.bigCursor);
      // Fare bir butonun (tıklama imleci) üzerindeyken bile.
      await mouse.moveTo(
        tester.getCenter(find.byKey(const Key('accessibility_reset_button'))),
      );
      await tester.pumpAndSettle();
      final cursor = tester.widget<CustomPaint>(
        find.byKey(const Key('big_cursor')),
      );
      expect((cursor.painter! as dynamic).size, size);
      expect((cursor.painter! as dynamic).position, isNotNull);
      expect(activeCursor(), SystemMouseCursors.none, reason: 'boyut $size');
    }

    await tap(tester, AccessibilityFeature.bigCursor);
    await mouse.moveTo(
      tester.getCenter(find.byKey(const Key('accessibility_reset_button'))),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('big_cursor')), findsNothing);
    expect(activeCursor(), isNot(SystemMouseCursors.none));
    await unmount(tester);
  });

  testWidgets('Satır Yüksekliği: 1,5 · 1,75 · 2 · 2,25', (tester) async {
    await openPanel(tester);
    final designHeight = AppTypography.bodyLarge.height ?? 0;
    for (var step = 1; step <= 4; step++) {
      await tap(tester, AccessibilityFeature.lineHeight);
      final chosen = 1.25 + step * 0.25;
      expect(
        (await introStyle(tester)).height,
        chosen > designHeight ? chosen : designHeight,
        reason: 'seviye $step',
      );
      expect(tester.takeException(), isNull);
    }
    await tap(tester, AccessibilityFeature.lineHeight);
    expect((await introStyle(tester)).height, AppTypography.bodyLarge.height);
    await unmount(tester);
  });

  testWidgets('Sola Hizala: ortalanmış metin başa hizalanır', (tester) async {
    await openPanel(tester);
    expect(tileLabelAlign(tester), TextAlign.center);
    await tap(tester, AccessibilityFeature.alignLeft);
    expect(tileLabelAlign(tester), TextAlign.start);
    await tap(tester, AccessibilityFeature.alignLeft);
    expect(tileLabelAlign(tester), TextAlign.center);
    await unmount(tester);
  });

  testWidgets('Titreşim: varsayılan açık; kapatınca titreşim verilmez', (
    tester,
  ) async {
    await openPanel(tester);
    final haptics = getIt<HapticFeedbackService>();
    expect(haptics.enabled, isTrue);
    await tap(tester, AccessibilityFeature.haptics);
    expect(haptics.enabled, isFalse);
    await tap(tester, AccessibilityFeature.haptics);
    expect(haptics.enabled, isTrue);
    await unmount(tester);
  });

  testWidgets('her seçim kalıcı kaydedilir; varsayılana dönüş tüm etkileri '
      'kaldırır ve geri alınabilir', (tester) async {
    await openPanel(tester);
    await tap(tester, AccessibilityFeature.grayscale);
    await tap(tester, AccessibilityFeature.zoom);
    await tap(tester, AccessibilityFeature.alignLeft);
    expect(level(AccessibilityFeature.grayscale), 1);
    expect(level(AccessibilityFeature.zoom), 1);

    final reset = find.byKey(const Key('accessibility_reset_button'));
    await tester.scrollUntilVisible(
      reset,
      200,
      scrollable: find.descendant(
        of: find.byKey(const Key('accessibility_list')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(reset);
    await tester.pumpAndSettle();
    expect(rootFilter(tester), isNull);
    expect(MediaQuery.textScalerOf(page(tester)).scale(10), closeTo(10, 1e-3));
    expect(level(AccessibilityFeature.grayscale), 0);

    await tester.tap(find.text('Geri al'));
    await tester.pumpAndSettle();
    expect(rootFilter(tester), isNotNull);
    expect(level(AccessibilityFeature.zoom), 1);
    expect(tileLabelAlign(tester), TextAlign.start);
    await unmount(tester);
  });
}
