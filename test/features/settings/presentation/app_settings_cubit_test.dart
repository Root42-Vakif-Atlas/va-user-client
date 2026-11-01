import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/theme/theme_preference.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/settings/domain/entities/accessibility_preferences.dart';
import 'package:vakif_atlas/features/settings/domain/entities/app_settings.dart';
import 'package:vakif_atlas/features/settings/domain/usecases/get_app_settings_usecase.dart';
import 'package:vakif_atlas/features/settings/domain/usecases/save_app_settings_usecase.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_state.dart';

class _MockGet extends Mock implements GetAppSettingsUseCase {}

class _MockSave extends Mock implements SaveAppSettingsUseCase {}

/// Platform kanalı yerine çağrıları sayan titreşim servisi.
class _CountingHaptics extends HapticFeedbackService {
  _CountingHaptics(this._onPulse) : super.withDelay((_) async {});

  final void Function() _onPulse;

  @override
  Future<void> selection() async {
    if (enabled) {
      _onPulse();
    }
  }
}

void main() {
  late _MockGet getSettings;
  late _MockSave saveSettings;
  late HapticFeedbackService haptics;
  late int hapticPulses;

  setUpAll(() => registerFallbackValue(AppSettings.defaults));

  setUp(() {
    getSettings = _MockGet();
    saveSettings = _MockSave();
    when(getSettings.call).thenReturn(AppSettings.defaults);
    when(() => saveSettings(any())).thenAnswer((_) async => const Right(unit));
    hapticPulses = 0;
    haptics = _CountingHaptics(() => hapticPulses++);
  });

  AppSettingsCubit build() =>
      AppSettingsCubit(getSettings, saveSettings, haptics);

  test('başlangıç durumu kayıtlı ayarlardır', () {
    expect(build().state, AppSettingsState(settings: AppSettings.defaults));
  });

  blocTest<AppSettingsCubit, AppSettingsState>(
    'tema değişikliği anında uygulanır ve kaydedilir',
    build: build,
    act: (cubit) => cubit.setThemePreference(ThemePreference.light),
    expect: () => [
      AppSettingsState(
        settings: AppSettings.defaults.copyWith(
          themePreference: ThemePreference.light,
        ),
      ),
    ],
    verify: (_) => verify(
      () => saveSettings(
        AppSettings.defaults.copyWith(themePreference: ThemePreference.light),
      ),
    ).called(1),
  );

  AppSettings withA11y(Map<AccessibilityFeature, int> levels) => AppSettings
      .defaults
      .copyWith(accessibility: AccessibilityPreferences(levels));

  blocTest<AppSettingsCubit, AppSettingsState>(
    'kutucuk bir sonraki seviyeye geçer ve kaydedilir',
    build: build,
    act: (cubit) async {
      await cubit.cycleAccessibility(AccessibilityFeature.contrast);
      await cubit.cycleAccessibility(AccessibilityFeature.contrast);
    },
    expect: () => [
      AppSettingsState(settings: withA11y({AccessibilityFeature.contrast: 1})),
      AppSettingsState(settings: withA11y({AccessibilityFeature.contrast: 2})),
    ],
    verify: (_) =>
        verify(() => saveSettings(withA11y({AccessibilityFeature.contrast: 2})))
            .called(1),
  );

  blocTest<AppSettingsCubit, AppSettingsState>(
    'seviye doğrudan ayarlanabilir; dil ayrıca güncellenir',
    build: build,
    act: (cubit) async {
      await cubit.setLanguageCode('en');
      await cubit.setAccessibilityLevel(AccessibilityFeature.zoom, 2);
    },
    skip: 1,
    expect: () => [
      AppSettingsState(
        settings: withA11y({AccessibilityFeature.zoom: 2})
            .copyWith(languageCode: 'en'),
      ),
    ],
  );

  blocTest<AppSettingsCubit, AppSettingsState>(
    'varsayılana dönüş tema ve dili korur; geri alınabilir',
    seed: () => AppSettingsState(
      settings: withA11y({AccessibilityFeature.grayscale: 3})
          .copyWith(themePreference: ThemePreference.dark),
    ),
    build: build,
    act: (cubit) async {
      final previous = await cubit.resetAccessibility();
      await cubit.restoreAccessibility(previous);
    },
    expect: () => [
      AppSettingsState(
        settings: AppSettings.defaults.copyWith(
          themePreference: ThemePreference.dark,
        ),
      ),
      AppSettingsState(
        settings: withA11y({AccessibilityFeature.grayscale: 3})
            .copyWith(themePreference: ThemePreference.dark),
      ),
    ],
  );

  test(
    'titreşim tercihi servise yansıtılır; açılınca bir tık hissettirir',
    () async {
      final cubit = build();
      expect(haptics.enabled, isTrue);

      await cubit.cycleAccessibility(AccessibilityFeature.haptics);
      expect(haptics.enabled, isFalse);
      expect(hapticPulses, 0);

      await cubit.cycleAccessibility(AccessibilityFeature.haptics);
      expect(haptics.enabled, isTrue);
      expect(hapticPulses, 1);
      await cubit.close();
    },
  );

  test('kayıtlı titreşim tercihi açılışta servise uygulanır', () async {
    when(getSettings.call)
        .thenReturn(withA11y({AccessibilityFeature.haptics: 0}));
    final cubit = build();
    expect(haptics.enabled, isFalse);
    await cubit.close();
  });

  blocTest<AppSettingsCubit, AppSettingsState>(
    'aynı değer tekrar seçilirse durum yayınlanmaz ve kaydedilmez',
    build: build,
    act: (cubit) => cubit.setThemePreference(ThemePreference.system),
    expect: () => <AppSettingsState>[],
    verify: (_) => verifyNever(() => saveSettings(any())),
  );

  blocTest<AppSettingsCubit, AppSettingsState>(
    'kaydetme başarısızsa değişiklik korunur ve hata bildirilir',
    setUp: () =>
        when(() => saveSettings(any()))
            .thenAnswer((_) async => const Left(CacheFailure())),
    build: build,
    act: (cubit) => cubit.cycleAccessibility(AccessibilityFeature.contrast),
    expect: () => [
      AppSettingsState(settings: withA11y({AccessibilityFeature.contrast: 1})),
      AppSettingsState(
        settings: withA11y({AccessibilityFeature.contrast: 1}),
        saveFailure: const CacheFailure(),
      ),
    ],
  );
}
