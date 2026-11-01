import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/core/theme/launch_colors.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/templates/splash_view.dart';

void main() {
  Future<void> pumpSplash(
    WidgetTester tester, {
    bool disableAnimations = false,
    double textScale = 1,
    Size size = const Size(390, 844),
    ThemeData? theme,
  }) async {
    tester.view.physicalSize = size * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        theme: theme ?? AppTheme.light(),
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            disableAnimations: disableAnimations,
            textScaler: TextScaler.linear(textScale),
          ),
          child: child!,
        ),
        home: const SplashView(),
      ),
    );
  }

  testWidgets('amblem native açılışla aynı boyutta tam ekran ortasındadır', (
    tester,
  ) async {
    await pumpSplash(tester);

    final emblem = tester.getRect(find.byKey(const Key('splash_emblem')));
    expect(emblem.size, const Size.square(AppSizes.splashEmblem));
    expect(emblem.center, const Offset(390 / 2, 844 / 2));
    // Uygulama teması açık olsa da zemin marka rengidir.
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, LaunchColors.background);
    // Yalnızca logo: ad veya slogan yazılmaz.
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('yükleme göstergesi yalnızca açılış uzarsa belirir', (
    tester,
  ) async {
    await pumpSplash(tester);
    expect(find.byKey(const Key('splash_progress')), findsNothing);

    await tester.pump(SplashView.progressDelay);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('hareket azaltmada dönen gösterge yerine sabit ikon', (
    tester,
  ) async {
    await pumpSplash(tester, disableAnimations: true);
    await tester.pump(SplashView.progressDelay);

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byIcon(Icons.hourglass_top), findsOneWidget);
    // Hiç animasyon kalmadığı için ekran durağanlaşır.
    await tester.pumpAndSettle();
  });

  testWidgets('ekran okuyucuya tek bir canlı bölge olarak okunur', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpSplash(tester, disableAnimations: true);

    expect(
      tester.getSemantics(find.bySemanticsLabel('Vakıf Atlas açılıyor')),
      isSemantics(label: 'Vakıf Atlas açılıyor', isLiveRegion: true),
    );
    handle.dispose();
  });

  testWidgets('%200 metin ölçeğinde küçük ekranda taşmaz', (tester) async {
    await pumpSplash(
      tester,
      textScale: 2,
      size: const Size(320, 568),
      disableAnimations: true,
    );
    await tester.pump(SplashView.progressDelay);
    expect(tester.takeException(), isNull);
  });
}
