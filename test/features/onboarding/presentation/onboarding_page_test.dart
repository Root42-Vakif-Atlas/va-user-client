import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/location/location_service.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/core/theme/theme_preference.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:vakif_atlas/features/settings/domain/entities/app_settings.dart';
import 'package:vakif_atlas/features/settings/domain/usecases/get_app_settings_usecase.dart';
import 'package:vakif_atlas/features/settings/domain/usecases/save_app_settings_usecase.dart';
import 'package:vakif_atlas/features/settings/presentation/app_settings_presentation.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_state.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/device_permissions_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/location_permission_cubit.dart';

import '../../../helpers/location_test_utils.dart';
import '../../../helpers/permission_test_utils.dart';

class _MockGet extends Mock implements GetAppSettingsUseCase {}

class _MockSave extends Mock implements SaveAppSettingsUseCase {}

void main() {
  late List<String> announcements;
  late List<OnboardingExit> exits;
  late int privacyOpened;
  late int accessibilityOpened;
  late FakeLocationService location;
  late FakePermissionService permissions;

  setUpAll(() => registerFallbackValue(AppSettings.defaults));

  setUp(() {
    announcements = [];
    exits = [];
    privacyOpened = 0;
    accessibilityOpened = 0;
    location = FakeLocationService();
    permissions = FakePermissionService();
  });

  /// Tercihler gerçek `AppSettingsCubit` ile uygulanır; tema ve dil
  /// değişikliklerinin canlı yansıması da doğrulanır.
  Future<void> pumpPage(
    WidgetTester tester, {
    String? signedInDisplayName,
    double textScale = 1,
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    final getSettings = _MockGet();
    final saveSettings = _MockSave();
    when(getSettings.call)
        .thenReturn(AppSettings.defaults.copyWith(languageCode: 'tr'));
    when(() => saveSettings(any())).thenAnswer((_) async => const Right(unit));

    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: A11yAnnouncer.withSender(
              (_, message, _, _) async => announcements.add(message),
            ),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AppSettingsCubit>(
              create: (_) => AppSettingsCubit(
                getSettings,
                saveSettings,
                HapticFeedbackService.withDelay((_) async {}),
              ),
            ),
            BlocProvider<LocationPermissionCubit>(
              create: (_) => LocationPermissionCubit(location),
            ),
            BlocProvider<DevicePermissionsCubit>(
              create: (_) => DevicePermissionsCubit(permissions),
            ),
          ],
          child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
            builder: (context, state) => MaterialApp(
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: state.settings.themeMode,
              locale: state.settings.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(textScale)),
                child: child!,
              ),
              home: OnboardingPage(
                signedInDisplayName: signedInDisplayName,
                onFinished: exits.add,
                onOpenPrivacyNotice: () => privacyOpened++,
                onOpenAccessibility: () => accessibilityOpened++,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> next(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();
  }

  Finder step(String name) => find.byKey(Key('onboarding_step_$name'));

  AppSettings settingsOf(WidgetTester tester) => tester
      .element(find.byType(OnboardingPage))
      .read<AppSettingsCubit>()
      .state
      .settings;

  testWidgets('altı adım sırayla gezilir ve her adım duyurulur', (
    tester,
  ) async {
    await pumpPage(tester);
    expect(step('welcome'), findsOneWidget);
    expect(find.text('Adım 1 / 6'), findsOneWidget);
    expect(find.byKey(const Key('onboarding_back_button')), findsNothing);

    for (final (name, title) in [
      ('display', 'Görünüm'),
      ('accessibility', 'Erişilebilirlik'),
      ('tour', "Vakıf Atlas'ı tanıyın"),
      ('permissions', 'İzinler'),
      ('account', 'Nasıl devam etmek istersiniz?'),
    ]) {
      await next(tester);
      expect(step(name), findsOneWidget);
      expect(announcements.last, endsWith(': $title'));
    }
    expect(announcements.last, 'Adım 6 / 6: Nasıl devam etmek istersiniz?');
    // Son adımda "Devam" ve "Atla" yoktur; hesap seçimi yapılır.
    expect(find.byKey(const Key('onboarding_next_button')), findsNothing);
    expect(find.byKey(const Key('onboarding_skip_button')), findsNothing);
  });

  testWidgets('geri butonu ve sistem geri hareketi önceki adıma döner', (
    tester,
  ) async {
    await pumpPage(tester);
    await next(tester);
    await next(tester);
    expect(step('accessibility'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding_back_button')));
    await tester.pumpAndSettle();
    expect(step('display'), findsOneWidget);

    final handled = await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(handled, isTrue);
    expect(step('welcome'), findsOneWidget);
  });

  testWidgets('dil seçimi tanıtımı anında çevirir', (tester) async {
    await pumpPage(tester);

    final english = find.byKey(
      const Key('settings_language__LanguageOption.english'),
    );
    await tester.scrollUntilVisible(english, 200);
    await tester.tap(english);
    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Step 1 of 6'), findsOneWidget);
    expect(settingsOf(tester).languageCode, 'en');
  });

  testWidgets('tema kaydedilir; erişilebilirlik adımı tek sayfayı açar', (
    tester,
  ) async {
    await pumpPage(tester);
    await next(tester);

    await tester.tap(
      find.byKey(const Key('settings_theme_ThemePreference.dark')),
    );
    await tester.pumpAndSettle();
    expect(settingsOf(tester).themePreference, ThemePreference.dark);
    expect(
      Theme.of(tester.element(step('display'))).brightness,
      Brightness.dark,
    );

    await next(tester);
    expect(step('accessibility'), findsOneWidget);
    // Erişilebilirlik denetimleri tanıtımda değil, Erişilebilirlik
    // sayfasındadır (tek yapılandırma noktası).
    for (final key in [
      'a11y_tile_contrast',
      'a11y_tile_zoom',
      'a11y_tile_stopAnimations',
      'a11y_tile_haptics',
    ]) {
      expect(find.byKey(Key(key)), findsNothing, reason: key);
    }
    await tester.tap(
      find.byKey(const Key('onboarding_open_accessibility_button')),
    );
    expect(accessibilityOpened, 1);
  });

  testWidgets('izin adımında konum izni yalnızca butonla istenir', (
    tester,
  ) async {
    await pumpPage(tester);
    for (var i = 0; i < 4; i++) {
      await next(tester);
    }
    expect(step('permissions'), findsOneWidget);
    expect(location.requestAccessCalls, 0);
    expect(location.currentPositionCalls, 0);
    // Kamera ve mikrofon kartları da gösterilir; hiçbiri kendiliğinden
    // istenmez.
    for (final name in ['camera', 'microphone']) {
      expect(find.byKey(Key('${name}_permission_card')), findsOneWidget);
    }
    expect(permissions.requested, isEmpty);

    await tester.tap(
      find.byKey(const Key('location_permission_request_button')),
    );
    await tester.pumpAndSettle();
    expect(location.requestAccessCalls, 1);
    expect(
      find.descendant(
        of: find.byKey(const Key('location_permission_status')),
        matching: find.text('İzin verildi'),
      ),
      findsOneWidget,
    );
    // Konum okunmaz; yalnızca izin durumu değişir.
    expect(location.currentPositionCalls, 0);

    final privacy = find.byKey(const Key('onboarding_privacy_notice_button'));
    await tester.scrollUntilVisible(privacy, 200);
    await tester.tap(privacy);
    expect(privacyOpened, 1);
  });

  testWidgets('desteklenmeyen platformda izin butonu gösterilmez', (
    tester,
  ) async {
    location.access = LocationAccess.unsupported;
    await pumpPage(tester);
    for (var i = 0; i < 4; i++) {
      await next(tester);
    }
    expect(find.text('Bu cihazda kullanılamıyor.'), findsOneWidget);
    expect(
      find.byKey(const Key('location_permission_request_button')),
      findsNothing,
    );
  });

  testWidgets('"Atla" hesap adımına geçer; seçimler geri çağrıya iletilir', (
    tester,
  ) async {
    await pumpPage(tester);
    await tester.tap(find.byKey(const Key('onboarding_skip_button')));
    await tester.pumpAndSettle();
    expect(step('account'), findsOneWidget);
    expect(location.requestAccessCalls, 0);

    for (final (key, exit) in [
      ('onboarding_sign_in_button', OnboardingExit.signIn),
      ('onboarding_create_account_button', OnboardingExit.createAccount),
      ('onboarding_guest_button', OnboardingExit.guest),
    ]) {
      await tester.tap(find.byKey(Key(key)));
      expect(exits.last, exit);
    }
  });

  testWidgets('oturum açıksa yalnızca devam seçeneği sunulur', (tester) async {
    await pumpPage(tester, signedInDisplayName: 'Ayşe Yılmaz');
    await tester.tap(find.byKey(const Key('onboarding_skip_button')));
    await tester.pumpAndSettle();

    expect(find.text('Hoş geldiniz, Ayşe Yılmaz'), findsOneWidget);
    expect(find.byKey(const Key('onboarding_guest_button')), findsNothing);
    await tester.tap(find.byKey(const Key('onboarding_continue_button')));
    expect(exits, [OnboardingExit.continueSignedIn]);
  });

  testWidgets('%200 metin ölçeğinde hiçbir adım taşmaz', (tester) async {
    await pumpPage(tester, textScale: 2, size: const Size(320, 640));
    for (var i = 0; i < 6; i++) {
      expect(tester.takeException(), isNull);
      final scrollable = find.byType(Scrollable).last;
      await tester.drag(scrollable, const Offset(0, -3000));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      if (i < 5) {
        await next(tester);
      }
    }
  });

  testWidgets('her adım dokunma hedefi ve etiket kılavuzlarını karşılar', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpPage(tester);
    for (var i = 0; i < 6; i++) {
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      if (i < 5) {
        await next(tester);
      }
    }
    handle.dispose();
  });
}
