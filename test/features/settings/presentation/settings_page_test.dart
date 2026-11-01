import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/location/location_service.dart';
import 'package:vakif_atlas/core/permissions/permission_service.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/core/theme/color_blindness_profile.dart';
import 'package:vakif_atlas/core/theme/theme_preference.dart';
import 'package:vakif_atlas/features/settings/domain/entities/app_settings.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_state.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/device_permissions_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/location_permission_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/pages/settings_page.dart';

import '../../../helpers/location_test_utils.dart';
import '../../../helpers/permission_test_utils.dart';

class _MockCubit extends MockCubit<AppSettingsState>
    implements AppSettingsCubit {}

void main() {
  late _MockCubit cubit;
  late FakeLocationService location;
  late FakePermissionService permissions;
  late List<String> opened;

  setUpAll(() {
    registerFallbackValue(ThemePreference.dark);
    registerFallbackValue(ColorBlindnessProfile.none);
  });

  setUp(() {
    cubit = _MockCubit();
    when(() => cubit.state)
        .thenReturn(AppSettingsState(settings: AppSettings.defaults));
    when(() => cubit.setThemePreference(any())).thenAnswer((_) async {});
    when(() => cubit.setLanguageCode(any())).thenAnswer((_) async {});
    when(() => cubit.setShowAccessibilityButton(visible: any(named: 'visible')))
        .thenAnswer((_) async {});
    location = FakeLocationService();
    permissions = FakePermissionService(
      access: {AppPermission.microphone: PermissionAccess.denied},
    );
    opened = [];
  });

  Future<void> pumpPage(
    WidgetTester tester, {
    double textScale = 1,
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AppSettingsCubit>.value(value: cubit),
          BlocProvider<LocationPermissionCubit>(
            create: (_) => LocationPermissionCubit(location),
          ),
          BlocProvider<DevicePermissionsCubit>(
            create: (_) => DevicePermissionsCubit(permissions),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.dark(),
          locale: const Locale('tr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: SettingsPage(
            onReplayOnboarding: () => opened.add('onboarding'),
            onOpenAccessibility: () => opened.add('accessibility'),
            onOpenPrivacyNotice: () => opened.add('privacy'),
            onOpenTermsOfUse: () => opened.add('terms'),
            onOpenFeedback: () => opened.add('feedback'),
            appVersion: '1.0.0 (42)',
          ),
        ),
      ),
    );
  }

  testWidgets('tema seçimi cubit\'e iletilir', (tester) async {
    await pumpPage(tester);

    await tester.tap(
      find.byKey(const Key('settings_theme_ThemePreference.light')),
    );

    verify(() => cubit.setThemePreference(ThemePreference.light)).called(1);
  });

  testWidgets('dil seçimi cubit\'e iletilir', (tester) async {
    await pumpPage(tester);

    final english = find.byKey(
      const Key('settings_language__LanguageOption.english'),
    );
    await tester.scrollUntilVisible(english, 200);
    await tester.tap(english);
    verify(() => cubit.setLanguageCode('en')).called(1);
  });

  testWidgets('erişilebilirlik denetimleri burada değil; satır tek sayfayı '
      'açar', (tester) async {
    await pumpPage(tester);

    for (final key in [
      'a11y_tile_contrast',
      'a11y_tile_zoom',
      'a11y_tile_stopAnimations',
      'a11y_tile_haptics',
    ]) {
      expect(find.byKey(Key(key)), findsNothing, reason: key);
    }
    final tile = find.byKey(const Key('settings_accessibility_tile'));
    await tester.scrollUntilVisible(tile, 200);
    await tester.ensureVisible(tile);
    await tester.pumpAndSettle();
    await tester.tap(tile);
    expect(opened.last, 'accessibility');
  });

  testWidgets('haritadaki Erişilebilirlik butonu buradan gizlenir', (
    tester,
  ) async {
    await pumpPage(tester);

    final toggle = find.byKey(
      const Key('settings_show_accessibility_button_switch'),
    );
    await tester.scrollUntilVisible(toggle, 200);
    await tester.ensureVisible(toggle);
    await tester.pumpAndSettle();
    expect(tester.widget<SwitchListTile>(toggle).value, isTrue);
    await tester.tap(toggle);

    verify(() => cubit.setShowAccessibilityButton(visible: false)).called(1);
  });

  testWidgets('konum izni kartı izni ister ve yeni durumu gösterir', (
    tester,
  ) async {
    await pumpPage(tester);
    final request = find.byKey(const Key('location_permission_request_button'));
    await tester.scrollUntilVisible(request, 200);
    await tester.ensureVisible(request);
    await tester.pump();
    expect(_status('location', 'İzin verilmedi'), findsOneWidget);

    await tester.tap(request);
    await tester.pump();

    expect(location.requestAccessCalls, 1);
    expect(_status('location', 'İzin verildi'), findsOneWidget);
    expect(request, findsNothing);
  });

  testWidgets('kamera ve mikrofon kartları; izin yalnızca butonla', (
    tester,
  ) async {
    permissions.access[AppPermission.camera] = PermissionAccess.deniedForever;
    permissions.requestResults[AppPermission.microphone] =
        PermissionAccess.granted;
    await pumpPage(tester);
    final mic = find.byKey(const Key('microphone_permission_request_button'));
    await tester.scrollUntilVisible(mic, 200);
    await tester.ensureVisible(mic);
    await tester.pump();

    // Açılışta hiçbir izin kendiliğinden istenmez.
    expect(permissions.requested, isEmpty);
    // Fotoğraf seçimi izin gerektirmediğinden kartı yoktur.
    expect(find.byKey(const Key('photos_permission_card')), findsNothing);
    expect(
      _status('camera', 'Kapalı. Sistem ayarlarından izin verebilirsiniz.'),
      findsOneWidget,
    );

    await tester.tap(mic);
    await tester.pump();
    expect(permissions.requested, [AppPermission.microphone]);
    expect(_status('microphone', 'İzin verildi'), findsOneWidget);
    expect(mic, findsNothing);

    final cameraSettings = find.byKey(
      const Key('camera_permission_settings_button'),
    );
    await tester.ensureVisible(cameraSettings);
    await tester.pump();
    await tester.tap(cameraSettings);
    await tester.pump();
    expect(permissions.settingsOpened, 1);
    expect(permissions.requested, [AppPermission.microphone]);
  });

  testWidgets('kalıcı ret durumunda uygulama ayarları açılır', (tester) async {
    location.access = LocationAccess.deniedForever;
    await pumpPage(tester);
    final open = find.byKey(const Key('location_permission_settings_button'));
    await tester.scrollUntilVisible(open, 200);
    await tester.ensureVisible(open);
    await tester.pump();

    await tester.tap(open);
    await tester.pump();

    expect(location.openedSettings, [LocationIssue.permissionDeniedForever]);
    expect(location.requestAccessCalls, 0);
  });

  testWidgets('tanıtım ve yasal metin bağlantıları geri çağrıları tetikler', (
    tester,
  ) async {
    await pumpPage(tester);
    for (final (key, expected) in [
      ('settings_feedback_tile', 'feedback'),
      ('settings_replay_onboarding_tile', 'onboarding'),
      ('settings_privacy_notice_tile', 'privacy'),
      ('settings_terms_tile', 'terms'),
    ]) {
      final tile = find.byKey(Key(key));
      await tester.scrollUntilVisible(tile, 200);
      await tester.ensureVisible(tile);
      await tester.pumpAndSettle();
      await tester.tap(tile);
      expect(opened.last, expected);
    }
  });

  testWidgets('Hakkında: simge, sürüm, kurumsal mesaj ve geliştirici tek '
      'parça okunur', (tester) async {
    await pumpPage(tester);
    final card = find.byKey(const Key('settings_about_card'));
    await tester.scrollUntilVisible(card, 200);
    await tester.pumpAndSettle();

    expect(find.text('Sürüm 1.0.0 (42)'), findsOneWidget);
    expect(find.textContaining('Root42'), findsOneWidget);
    expect(
      tester.getSemantics(find.text('Sürüm 1.0.0 (42)')).label,
      allOf(contains('Vakıf Atlas'), contains('Sürüm 1.0.0 (42)')),
    );
  });

  testWidgets('kaydetme hatasında bilgilendirme gösterilir', (tester) async {
    whenListen(
      cubit,
      Stream.value(
        AppSettingsState(
          settings: AppSettings.defaults,
          saveFailure: const CacheFailure(),
        ),
      ),
      initialState: AppSettingsState(settings: AppSettings.defaults),
    );
    await pumpPage(tester);
    await tester.pump();

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
      find.byKey(const Key('settings_licenses_tile')),
      300,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('dokunma hedefi ve etiket kılavuzlarını karşılar', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpPage(tester);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    handle.dispose();
  });
}

/// [permission] kartındaki durum metni.
Finder _status(String permission, String text) => find.descendant(
  of: find.byKey(Key('${permission}_permission_status')),
  matching: find.text(text),
);
