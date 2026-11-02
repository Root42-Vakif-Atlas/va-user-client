import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/a11y/accessibility_layers.dart';
import 'package:vakif_atlas/core/a11y/accessibility_scope.dart';
import 'package:vakif_atlas/core/a11y/voice_io_service.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/core/theme/app_theme_options.dart';
import 'package:vakif_atlas/core/theme/color_blindness_filter.dart';
import 'package:vakif_atlas/core/theme/color_blindness_profile.dart';
import 'package:vakif_atlas/core/theme/extensions/app_color_scheme.dart';
import 'package:vakif_atlas/core/theme/extensions/app_text_theme.dart';
import 'package:vakif_atlas/core/theme/tokens/app_colors.dart';
import 'package:vakif_atlas/core/theme/tokens/app_typography.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_network_image.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

class _MockVoice extends Mock implements VoiceIoService {}

void main() {
  late _MockVoice voice;

  setUp(() {
    voice = _MockVoice();
    when(() => voice.speak(any(), languageCode: any(named: 'languageCode')))
        .thenAnswer((_) async {});
    when(() => voice.stop()).thenAnswer((_) async {});
  });

  Future<void> pumpLayers(
    WidgetTester tester, {
    required Widget child,
    bool readAloud = false,
    int focusHighlight = 0,
    int readingGuide = 0,
    int bigCursor = 0,
  }) {
    return tester.pumpWidget(
      RepositoryProvider<VoiceIoService>.value(
        value: voice,
        child: MaterialApp(
          locale: const Locale('tr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, app) => AccessibilityLayers(
            readAloud: readAloud,
            focusHighlight: focusHighlight,
            readingGuide: readingGuide,
            bigCursor: bigCursor,
            child: app!,
          ),
          home: Scaffold(body: Center(child: child)),
        ),
      ),
    );
  }

  group('AccessibilityLayers', () {
    testWidgets('sesli okuma dokunulan öğenin etiketini seslendirir', (
      tester,
    ) async {
      await pumpLayers(
        tester,
        readAloud: true,
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Rota oluştur'),
        ),
      );

      await tester.tap(find.text('Rota oluştur'));
      await tester.pump();

      verify(() => voice.speak('Rota oluştur', languageCode: 'tr')).called(1);
    });

    testWidgets('kaydırma (sürükleme) seslendirme tetiklemez', (tester) async {
      await pumpLayers(tester, readAloud: true, child: const Text('Selimiye'));

      await tester.dragFrom(
        tester.getCenter(find.text('Selimiye')),
        const Offset(0, 120),
      );
      await tester.pump();

      verifyNever(
        () => voice.speak(any(), languageCode: any(named: 'languageCode')),
      );
    });

    testWidgets('kapalıyken seslendirmez; kapatılınca konuşma durur', (
      tester,
    ) async {
      await pumpLayers(tester, readAloud: true, child: const Text('Selimiye'));
      await pumpLayers(tester, child: const Text('Selimiye'));
      verify(() => voice.stop()).called(1);

      await tester.tap(find.text('Selimiye'));
      await tester.pump();
      verifyNever(
        () => voice.speak(any(), languageCode: any(named: 'languageCode')),
      );
    });

    testWidgets('odak çerçevesi odaktaki öğeyi sarar; kapalıyken çizilmez', (
      tester,
    ) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      Widget field() => SizedBox(
        width: 200,
        child: TextField(key: const Key('field'), focusNode: focus),
      );
      await pumpLayers(tester, focusHighlight: 2, child: field());
      focus.requestFocus();
      await tester.pump();
      await tester.pump();

      final ring = find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint &&
            widget.painter.runtimeType.toString() == '_FocusRingPainter',
      );
      expect(ring, findsOneWidget);

      await pumpLayers(tester, child: field());
      await tester.pump();
      expect(ring, findsNothing);
    });

    testWidgets('okuma çizgisi dokunuşu ve fareyi izler', (tester) async {
      await pumpLayers(tester, readingGuide: 1, child: const SizedBox());
      expect(find.byKey(const Key('reading_guide')), findsOneWidget);

      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: const Offset(10, 300));
      addTearDown(mouse.removePointer);
      await mouse.moveTo(const Offset(20, 420));
      await tester.pump();

      final paint = tester.widget<CustomPaint>(
        find.byKey(const Key('reading_guide')),
      );
      expect((paint.painter! as dynamic).y as double?, 420);
    });

    testWidgets('açıp kapatmak sayfa durumunu sıfırlamaz', (tester) async {
      final controller = TextEditingController(text: 'korunur');
      addTearDown(controller.dispose);
      final field = TextField(key: const Key('field'), controller: controller);
      await pumpLayers(tester, child: field);
      final state = tester.state(find.byKey(const Key('field')));

      await pumpLayers(
        tester,
        readAloud: true,
        focusHighlight: 3,
        readingGuide: 3,
        bigCursor: 2,
        child: field,
      );
      await pumpLayers(tester, child: field);

      expect(tester.state(find.byKey(const Key('field'))), same(state));
    });
  });

  group('ColorMatrices', () {
    test('kapalıyken matris üretilmez', () {
      expect(
        ColorMatrices.combined(
          profile: ColorBlindnessProfile.none,
          grayscale: 0,
          invert: false,
          blueLightFilter: 0,
        ),
        isNull,
      );
    });

    List<double> apply(List<double> m, List<double> rgb) => [
      for (var row = 0; row < 3; row++)
        m[row * 5] * rgb[0] +
            m[row * 5 + 1] * rgb[1] +
            m[row * 5 + 2] * rgb[2] +
            m[row * 5 + 4],
    ];

    test('tam gri tonlamada kanallar eşitlenir', () {
      final m = ColorMatrices.combined(
        profile: ColorBlindnessProfile.none,
        grayscale: 1,
        invert: false,
        blueLightFilter: 0,
      )!;
      final out = apply(m, [200, 40, 10]);
      expect(out[0], closeTo(out[1], 1e-9));
      expect(out[1], closeTo(out[2], 1e-9));
    });

    test('ters renk ve mavi ışık sırayla birleştirilir', () {
      final m = ColorMatrices.combined(
        profile: ColorBlindnessProfile.none,
        grayscale: 0,
        invert: true,
        blueLightFilter: 1,
      )!;
      // Siyah → beyaz, ardından mavi kanal %45 azalır.
      final out = apply(m, [0, 0, 0]);
      expect(out[0], closeTo(255, 1e-9));
      expect(out[1], closeTo(255 * 0.9, 1e-9));
      expect(out[2], closeTo(255 * 0.55, 1e-9));
    });
  });

  group('Tema seçenekleri', () {
    test('okunaklı font, WCAG 1.4.12 aralığı ve satır yüksekliği', () {
      final text = AppTextTheme.fromColors(
        AppColorScheme.light,
        options: const AppThemeOptions(
          legibleFont: true,
          wideTextSpacing: true,
          lineHeight: 2,
        ),
      );
      final body = text.bodyLarge;
      expect(body.fontFamily, AppFonts.atkinsonHyperlegible);
      expect(body.letterSpacing, closeTo(body.fontSize! * 0.12, 1e-9));
      expect(body.wordSpacing, closeTo(body.fontSize! * 0.16, 1e-9));
      expect(body.height, 2);
    });

    test(
      'AppBar başlığı da Kolay Okuma aralığını ve satır yüksekliğini alır',
      () {
        final title = AppTheme.fromColors(
          AppColorScheme.light,
          options: const AppThemeOptions(wideTextSpacing: true, lineHeight: 2),
        ).appBarTheme.titleTextStyle!;
        expect(title.letterSpacing, closeTo(title.fontSize! * 0.12, 1e-9));
        expect(title.wordSpacing, closeTo(title.fontSize! * 0.16, 1e-9));
        expect(title.height, 2);

        final standard = AppTheme.fromColors(AppColorScheme.light)
            .appBarTheme
            .titleTextStyle!;
        expect(standard.letterSpacing, -0.2);
        expect(standard.height, lessThan(2));
      },
    );

    test(
      'Animasyonları durdur sayfa geçişlerini süresiz ve geçişsiz yapar',
      () {
        final theme = AppTheme.fromColors(
          AppColorScheme.light,
          options: const AppThemeOptions(reduceMotion: true),
        );
        for (final platform in TargetPlatform.values) {
          final builder = theme.pageTransitionsTheme.builders[platform]!;
          expect(builder.transitionDuration, Duration.zero);
          expect(builder.reverseTransitionDuration, Duration.zero);
        }
        final normal = AppTheme.fromColors(AppColorScheme.light);
        expect(
          normal
              .pageTransitionsTheme
              .builders[TargetPlatform.android]!
              .transitionDuration,
          isNot(Duration.zero),
        );
      },
    );

    test(
      'Kolay Okuma satır yüksekliğini WCAG 1.4.12 alt sınırına (1.5) çeker',
      () {
        final text = AppTextTheme.fromColors(
          AppColorScheme.light,
          options: const AppThemeOptions(wideTextSpacing: true),
        );
        for (final style in [
          text.bodyLarge,
          text.bodyMedium,
          text.bodySmall,
          text.labelMedium,
        ]) {
          expect(style.height, greaterThanOrEqualTo(1.5));
        }
        // Kullanıcı daha büyük bir satır yüksekliği seçtiyse o korunur.
        expect(
          const AppThemeOptions(
            wideTextSpacing: true,
            lineHeight: 2,
          ).effectiveLineHeight,
          2,
        );
        expect(const AppThemeOptions().effectiveLineHeight, isNull);
      },
    );

    test('bağlantı vurgusu liste satırı başlıklarını da alt çizgili yapar', () {
      final theme = AppTheme.fromColors(
        AppColorScheme.light,
        options: const AppThemeOptions(highlightLinks: true),
      );
      expect(
        theme.listTileTheme.titleTextStyle!.decoration,
        TextDecoration.underline,
      );
      expect(
        AppTheme.fromColors(AppColorScheme.light)
            .listTileTheme
            .titleTextStyle!
            .decoration,
        isNot(TextDecoration.underline),
      );
    });

    test('krem zemin yalnızca açık, standart kontrastlı temada', () {
      const options = AppThemeOptions(creamBackground: true);
      expect(
        AppTheme.fromColors(
          AppColorScheme.light,
          options: options,
        ).scaffoldBackgroundColor,
        AppColors.warmIvory,
      );
      expect(
        AppTheme.fromColors(
          AppColorScheme.highContrastLight,
          options: options,
        ).scaffoldBackgroundColor,
        isNot(AppColors.warmIvory),
      );
    });

    test('bağlantı vurgusu metin butonlarını alt çizgili yapar', () {
      final theme = AppTheme.fromColors(
        AppColorScheme.light,
        options: const AppThemeOptions(highlightLinks: true),
      );
      final style = theme.textButtonTheme.style!.textStyle!.resolve({});
      expect(style!.decoration, TextDecoration.underline);
      expect(theme.textButtonTheme.style!.side!.resolve({}), isNotNull);
    });
  });

  group('AccessibilityScope', () {
    Widget host(
      Widget child, {
      bool hideImages = false,
      bool alignLeft = false,
    }) => MaterialApp(
      theme: AppTheme.light(),
      locale: const Locale('tr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: AccessibilityScope(
        hideImages: hideImages,
        alignLeft: alignLeft,
        child: Scaffold(body: child),
      ),
    );

    testWidgets('sola hizala ortalanmış metni başa hizalar', (tester) async {
      const text = AppText('Selimiye', textAlign: TextAlign.center);
      await tester.pumpWidget(host(text));
      expect(
        tester.widget<Text>(find.text('Selimiye')).textAlign,
        TextAlign.center,
      );

      await tester.pumpWidget(host(text, alignLeft: true));
      expect(
        tester.widget<Text>(find.text('Selimiye')).textAlign,
        TextAlign.start,
      );
    });

    testWidgets('görseli gizle fotoğraf yerine betimini gösterir', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const SizedBox.square(
            dimension: 200,
            child: AppNetworkImage(
              url: 'https://example.invalid/a.jpg',
              semanticsLabel: 'Selimiye Camii avlusu',
            ),
          ),
          hideImages: true,
        ),
      );

      expect(find.byKey(const Key('hidden_image')), findsOneWidget);
      expect(find.text('Selimiye Camii avlusu'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });
  });
}
