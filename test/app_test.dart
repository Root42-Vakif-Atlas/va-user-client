import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/app.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/core/network/session_events.dart';
import 'package:vakif_atlas/core/security/privacy_screen_guard.dart';
import 'package:vakif_atlas/core/storage/preferences_service.dart';
import 'package:vakif_atlas/core/theme/color_blindness_profile.dart';
import 'package:vakif_atlas/core/theme/extensions/app_color_scheme.dart';
import 'package:vakif_atlas/core/theme/theme_preference.dart';
import 'package:vakif_atlas/features/auth/domain/repositories/auth_repository.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:vakif_atlas/features/settings/domain/entities/accessibility_preferences.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_cubit.dart';

import 'helpers/map_test_utils.dart';
import 'helpers/test_di.dart';
import 'support/mock_api/auth/auth_mock_api.dart';

void main() {
  late TestDependencies dependencies;

  tearDown(resetDependencies);

  Future<void> pumpApp(
    WidgetTester tester, {
    bool onboardingCompleted = true,
  }) async {
    // Test ortamının cihaz dili en-US'dir; Türkçe tercih açıkça verilir.
    dependencies = await TestDependencies.setUp(
      preferences: {'settings.language_code': 'tr'},
      onboardingCompleted: onboardingCompleted,
    );
    getIt<AuthBloc>().add(const AuthEvent.started());
    await tester.pumpWidget(const VakifAtlasApp());
    // Açılış ekranındaki gösterge sürekli döner; oturum çözülene kadar
    // sabit süreli pump kullanılır.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
  }

  /// DI, gerçek dosya G/Ç'si içeren dispose işlemleri (Hive) barındırdığından
  /// testWidgets'ın sahte zaman bölgesi dışında, `tearDown` içinde sıfırlanır.
  Future<void> unmount(WidgetTester tester) =>
      tester.pumpWidget(const SizedBox.shrink());

  BuildContext pageContext(WidgetTester tester, String text) =>
      tester.element(find.text(text).first);

  testWidgets('guest olarak harita keşfiyle ve cihazın temasıyla açılır', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await pumpApp(tester);

    expect(find.text('Yer veya eser ara'), findsOneWidget);
    final theme = Theme.of(pageContext(tester, 'Yer veya eser ara'));
    expect(theme.brightness, Brightness.dark);
    expect(theme.extension<AppColorScheme>(), same(AppColorScheme.dark));

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpAndSettle();
    expect(
      Theme.of(pageContext(tester, 'Yer veya eser ara'))
          .extension<AppColorScheme>(),
      same(AppColorScheme.light),
    );

    await unmount(tester);
  });

  testWidgets('tema, kontrast ve dil tercihleri anında uygulanır', (
    tester,
  ) async {
    await pumpApp(tester);
    final settings = getIt<AppSettingsCubit>();

    await settings.setThemePreference(ThemePreference.light);
    await tester.pumpAndSettle();
    expect(
      Theme.of(pageContext(tester, 'Yer veya eser ara'))
          .extension<AppColorScheme>(),
      same(AppColorScheme.light),
    );

    await settings.cycleAccessibility(AccessibilityFeature.contrast);
    await tester.pumpAndSettle();
    expect(
      Theme.of(pageContext(tester, 'Yer veya eser ara'))
          .extension<AppColorScheme>(),
      same(AppColorScheme.highContrastLight),
    );

    await settings.setLanguageCode('en');
    await tester.pumpAndSettle();
    expect(find.text('Search places or monuments'), findsOneWidget);
    expect(find.text('Yer veya eser ara'), findsNothing);

    await unmount(tester);
  });

  testWidgets('renk körlüğü filtresi ve metin ölçeği kök ağaca uygulanır', (
    tester,
  ) async {
    await pumpApp(tester);
    final settings = getIt<AppSettingsCubit>();
    // Kök filtre tüm rotaları (Navigator) sarar; haritanın kendi koyu
    // altlık filtresi sayılmaz.
    Finder rootFilter() => find.ancestor(
      of: find.byType(Navigator).first,
      matching: find.byType(ColorFiltered),
    );
    expect(rootFilter(), findsNothing);

    await settings.setAccessibilityLevel(
      AccessibilityFeature.colorBlindness,
      ColorBlindnessProfile.protanopia.index,
    );
    await settings.setAccessibilityLevel(AccessibilityFeature.zoom, 4);
    await tester.pumpAndSettle();

    expect(rootFilter(), findsOneWidget);
    // AppBar başlığı Material tarafından ayrıca sınırlandığından ölçek sayfa
    // gövdesindeki metinden okunur.
    final scaler = MediaQuery.textScalerOf(
      pageContext(tester, testMapTileConfig.attribution),
    );
    expect(scaler.scale(10), closeTo(20, 0.001));
    expect(tester.takeException(), isNull);

    await unmount(tester);
  });

  testWidgets('ilk kurulumda tanıtım açılır; tercihler kalıcı kaydedilir', (
    tester,
  ) async {
    await pumpApp(tester, onboardingCompleted: false);
    expect(find.byKey(const Key('onboarding_step_welcome')), findsOneWidget);

    // Erişilebilirlik adımı tek yapılandırma noktasını açar; tercih tüm
    // uygulamaya (tanıtım dahil) anında uygulanır.
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.byKey(const Key('onboarding_next_button')));
      await tester.pumpAndSettle();
    }
    await tester.tap(
      find.byKey(const Key('onboarding_open_accessibility_button')),
    );
    await tester.pumpAndSettle();
    final highContrast = find.byKey(const Key('a11y_tile_contrast'));
    await tester.scrollUntilVisible(highContrast, 200);
    await tester.ensureVisible(highContrast);
    await tester.pumpAndSettle();
    await tester.tap(highContrast);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(
      Theme.of(
        tester.element(find.byKey(const Key('onboarding_step_accessibility'))),
      ).extension<AppColorScheme>()!.isHighContrast,
      isTrue,
    );

    await tester.tap(find.byKey(const Key('onboarding_skip_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_guest_button')));
    await tester.pumpAndSettle();

    expect(find.text('Yer veya eser ara'), findsOneWidget);
    expect(dependencies.announcements, contains(startsWith('Adım 6 / 6')));
    final preferences = getIt<PreferencesService>();
    expect(
      preferences.onboardingVersion,
      OnboardingRepositoryImpl.currentVersion,
    );
    expect(preferences.accessibilityLevels?['contrast'], 1);

    await unmount(tester);
  });

  testWidgets('uygulama içi "hareketi azalt" tüm rotalara uygulanır', (
    tester,
  ) async {
    await pumpApp(tester);
    BuildContext page() => tester.element(find.text('Yer veya eser ara'));
    expect(MediaQuery.disableAnimationsOf(page()), isFalse);

    await getIt<AppSettingsCubit>().cycleAccessibility(
      AccessibilityFeature.stopAnimations,
    );
    await tester.pumpAndSettle();

    expect(MediaQuery.disableAnimationsOf(page()), isTrue);
    await unmount(tester);
  });

  testWidgets('arka plana alındığında içerik gizlenir', (tester) async {
    await pumpApp(tester);

    getIt<PrivacyScreenGuard>().handleLifecycleState(AppLifecycleState.paused);
    await tester.pump();
    expect(find.byKey(const Key('privacy_screen_cover')), findsOneWidget);

    getIt<PrivacyScreenGuard>().handleLifecycleState(AppLifecycleState.resumed);
    await tester.pump();
    expect(find.byKey(const Key('privacy_screen_cover')), findsNothing);

    await unmount(tester);
  });

  testWidgets('oturum sona erince kullanıcı görsel ve sesli bilgilendirilir', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.runAsync(
      () => getIt<AuthRepository>().login(
        email: AuthMockApi.demoEmail,
        password: AuthMockApi.demoPassword,
      ),
    );
    await tester.pumpAndSettle();
    expect(getIt<AuthBloc>().state, isA<AuthAuthenticated>());

    getIt<SessionEvents>().notifySessionExpired();
    await tester.pumpAndSettle();

    const message = 'Oturumunuzun süresi doldu. Lütfen tekrar giriş yapın.';
    expect(find.text(message), findsOneWidget);
    expect(dependencies.announcements, contains(message));

    await unmount(tester);
  });

  testWidgets('güvenlik engelinde yalnızca bilgilendirme ekranı gösterilir', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = [const Locale('tr')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(const SecurityBlockedApp());
    await tester.pumpAndSettle();

    expect(find.text('Güvenli çalışma ortamı doğrulanamadı'), findsOneWidget);
  });

  testWidgets('açılış başarısız olunca hata ekranı gösterilir', (tester) async {
    tester.platformDispatcher.localesTestValue = [const Locale('tr')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(const StartupFailedApp());
    await tester.pumpAndSettle();

    expect(find.text('Uygulama başlatılamadı'), findsOneWidget);
  });
}
