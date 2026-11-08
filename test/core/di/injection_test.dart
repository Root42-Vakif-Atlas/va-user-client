import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vakif_atlas/core/config/app_config.dart';
import 'package:vakif_atlas/core/config/app_environment.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/core/observability/app_logger.dart';
import 'package:vakif_atlas/core/observability/telemetry_service.dart';
import 'package:vakif_atlas/features/ai_assistant/data/repositories/catalog_aware_digital_guide_repository.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/repositories/digital_guide_repository.dart';

import '../../helpers/test_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(setUpPlatformPluginMocks);
  tearDown(resetDependencies);

  for (final environment in AppEnvironment.values) {
    test('${environment.name} ortamında DI grafiği çözülür', () async {
      final config = testAppConfig(environment: environment);

      await configureDependencies(config);

      expect(getIt<AppConfig>(), same(config));
      expect(getIt<SharedPreferences>(), isNotNull);
      expect(getIt<PackageInfo>().version, '1.0.0');
      expect(getIt<AppLogger>(), isNotNull);
      expect(getIt<TelemetryService>(), isNotNull);
      // Rehber eser sorularını katalogdan, diğerlerini Asistan servisinden
      // yanıtlar.
      expect(
        getIt<DigitalGuideRepository>(),
        isA<CatalogAwareDigitalGuideRepository>(),
      );
    });
  }

  test('lazySingleton kayıtlar aynı örneği döndürür', () async {
    await configureDependencies(testAppConfig());
    expect(getIt<AppLogger>(), same(getIt<AppLogger>()));
  });
}
