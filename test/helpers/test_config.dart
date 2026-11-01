import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vakif_atlas/core/config/app_config.dart';
import 'package:vakif_atlas/core/config/app_environment.dart';

/// Testlerdeki sahte backend'in (`MockApiAdapter`) kök adresi; `.invalid`
/// alan adı (RFC 2606) çözümlenemez, istekler ağa çıkmaz.
const String testApiBaseUrl = 'https://mock.vakifatlas.invalid/';

/// Testlerde kullanılan konfigürasyon; istekler `TestDependencies`'in
/// kurduğu bellek içi sahte backend'e gider.
AppConfig testAppConfig({AppEnvironment environment = AppEnvironment.dev}) {
  return AppConfig.resolve(
    environment,
    overrides: AppConfigOverrides(
      apiBaseUrl: environment == AppEnvironment.prod
          ? 'https://api.example.org/'
          : testApiBaseUrl,
      sslPinSha256Hashes: const [
        'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
        'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=',
      ],
      androidSigningSha256: environment == AppEnvironment.prod
          ? 'AA:BB:CC'
          : null,
      mapTileUrlLight: environment == AppEnvironment.prod
          ? 'https://tiles.example.org/light/{z}/{x}/{y}.png'
          : null,
      mapTileUrlDark: environment == AppEnvironment.prod
          ? 'https://tiles.example.org/dark/{z}/{x}/{y}.png'
          : null,
      mapTileAttribution: environment == AppEnvironment.prod
          ? '© OpenStreetMap contributors'
          : null,
    ),
  );
}

/// Platform kanalı gerektiren eklentiler için bellek içi değerler kurar.
void setUpPlatformPluginMocks({Map<String, Object> preferences = const {}}) {
  SharedPreferences.setMockInitialValues(preferences);
  PackageInfo.setMockInitialValues(
    appName: 'Vakıf Atlas',
    packageName: 'tr.gov.vgm.vakif_atlas',
    version: '1.0.0',
    buildNumber: '1',
    buildSignature: '',
  );
}
