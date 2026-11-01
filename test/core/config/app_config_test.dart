import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/config/app_config.dart';
import 'package:vakif_atlas/core/config/app_environment.dart';
import 'package:vakif_atlas/core/config/map_tile_config.dart';

void main() {
  const validPin = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=';
  const backupPin = 'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=';
  const signing = 'AB:CD';

  group('AppConfig.resolve', () {
    test('dev yerel http backend kullanır ve SSL pinning kapalıdır', () {
      final config = AppConfig.resolve(
        AppEnvironment.dev,
        overrides: const AppConfigOverrides(
          apiBaseUrl: 'http://localhost:8080/v1',
        ),
      );

      expect(config.environment, AppEnvironment.dev);
      expect(config.enableSslPinning, isFalse);
      expect(config.apiBaseUrl.toString(), 'http://localhost:8080/v1/');
    });

    test('her ortamda API_BASE_URL zorunludur (mock yok)', () {
      expect(
        () => AppConfig.resolve(
          AppEnvironment.dev,
          overrides: const AppConfigOverrides(),
        ),
        throwsA(isA<InvalidAppConfigError>()),
      );
    });

    test('staging gerçek backend ve pin ile çözülür', () {
      final config = AppConfig.resolve(
        AppEnvironment.staging,
        overrides: const AppConfigOverrides(
          apiBaseUrl: 'https://api.staging.example.org/',
          sslPinSha256Hashes: [validPin, backupPin],
        ),
      );

      expect(config.enableSslPinning, isTrue);
      expect(config.sslPinSha256Hashes, [validPin, backupPin]);
    });

    test('gerçek backend için API_BASE_URL zorunludur', () {
      expect(
        () => AppConfig.resolve(
          AppEnvironment.staging,
          overrides: const AppConfigOverrides(sslPinSha256Hashes: [validPin]),
        ),
        throwsA(isA<InvalidAppConfigError>()),
      );
    });

    test('staging/prod ortamında http adres reddedilir', () {
      expect(
        () => AppConfig.resolve(
          AppEnvironment.prod,
          overrides: const AppConfigOverrides(
            apiBaseUrl: 'http://api.example.org',
            sslPinSha256Hashes: [validPin],
          ),
        ),
        throwsA(isA<InvalidAppConfigError>()),
      );
    });

    test('pinning zorunlu ortamda pin yoksa reddedilir', () {
      expect(
        () => AppConfig.resolve(
          AppEnvironment.prod,
          overrides: const AppConfigOverrides(
            apiBaseUrl: 'https://api.example.org',
          ),
        ),
        throwsA(isA<InvalidAppConfigError>()),
      );
    });

    test('prod: yedek pin ve imza özeti zorunludur', () {
      for (final overrides in [
        const AppConfigOverrides(
          apiBaseUrl: 'https://api.example.org/',
          sslPinSha256Hashes: [validPin],
          androidSigningSha256: signing,
          mapTileUrlLight: 'https://tiles.example.org/{z}/{x}/{y}.png',
          mapTileAttribution: '© OSM',
        ),
        const AppConfigOverrides(
          apiBaseUrl: 'https://api.example.org/',
          sslPinSha256Hashes: [validPin, backupPin],
          mapTileUrlLight: 'https://tiles.example.org/{z}/{x}/{y}.png',
          mapTileAttribution: '© OSM',
        ),
        const AppConfigOverrides(
          apiBaseUrl: 'https://api.example.org/',
          sslPinSha256Hashes: [validPin, backupPin],
          storageSslPinSha256Hashes: [validPin],
          androidSigningSha256: signing,
          mapTileUrlLight: 'https://tiles.example.org/{z}/{x}/{y}.png',
          mapTileAttribution: '© OSM',
        ),
      ]) {
        expect(
          () => AppConfig.resolve(AppEnvironment.prod, overrides: overrides),
          throwsA(isA<InvalidAppConfigError>()),
        );
      }
    });

    test('depo pin\'leri ayrı tutulur; verilmezse boştur', () {
      final withoutStorage = AppConfig.resolve(
        AppEnvironment.staging,
        overrides: const AppConfigOverrides(
          apiBaseUrl: 'https://api.staging.example.org/',
          sslPinSha256Hashes: [validPin, backupPin],
        ),
      );
      final withStorage = AppConfig.resolve(
        AppEnvironment.staging,
        overrides: const AppConfigOverrides(
          apiBaseUrl: 'https://api.staging.example.org/',
          sslPinSha256Hashes: [validPin, backupPin],
          storageSslPinSha256Hashes: [backupPin, validPin],
        ),
      );

      expect(withoutStorage.storageSslPinSha256Hashes, isEmpty);
      expect(withStorage.storageSslPinSha256Hashes, [backupPin, validPin]);
    });

    test('geçersiz adres reddedilir', () {
      expect(
        () => AppConfig.resolve(
          AppEnvironment.dev,
          overrides: const AppConfigOverrides(apiBaseUrl: 'not a url'),
        ),
        throwsA(isA<InvalidAppConfigError>()),
      );
    });
  });

  group('Harita altlığı (MAP_TILE_*)', () {
    const prodBase = AppConfigOverrides(
      apiBaseUrl: 'https://api.example.org/',
      sslPinSha256Hashes: [validPin, backupPin],
      androidSigningSha256: signing,
    );

    test(
      'dev ve staging varsayılan olarak OpenStreetMap altlığını kullanır',
      () {
        for (final environment in [
          AppEnvironment.dev,
          AppEnvironment.staging,
        ]) {
          final config = AppConfig.resolve(
            environment,
            overrides: const AppConfigOverrides(
              apiBaseUrl: 'https://api.example.org/',
              sslPinSha256Hashes: [validPin],
            ),
          );
          expect(config.mapTiles, MapTileConfig.openStreetMap);
        }
      },
    );

    test('prod ortamında kurum tile sunucusu zorunludur', () {
      expect(
        () => AppConfig.resolve(AppEnvironment.prod, overrides: prodBase),
        throwsA(isA<InvalidAppConfigError>()),
      );
    });

    test('prod ortamında verilen tile sunucusu kullanılır', () {
      final config = AppConfig.resolve(
        AppEnvironment.prod,
        overrides: const AppConfigOverrides(
          apiBaseUrl: 'https://api.example.org/',
          sslPinSha256Hashes: [validPin, backupPin],
          androidSigningSha256: signing,
          mapTileUrlLight: 'https://tiles.example.org/light/{z}/{x}/{y}{r}.png',
          mapTileUrlDark: 'https://tiles.example.org/dark/{z}/{x}/{y}{r}.png',
          mapTileAttribution: '© OpenStreetMap katkıda bulunanlar',
        ),
      );

      expect(
        config.mapTiles.darkUrlTemplate,
        'https://tiles.example.org/dark/{z}/{x}/{y}{r}.png',
      );
    });

    test('prod ortamında koyu stil isteğe bağlıdır', () {
      final config = AppConfig.resolve(
        AppEnvironment.prod,
        overrides: const AppConfigOverrides(
          apiBaseUrl: 'https://api.example.org/',
          sslPinSha256Hashes: [validPin, backupPin],
          androidSigningSha256: signing,
          mapTileUrlLight: 'https://tiles.example.org/{z}/{x}/{y}.png',
          mapTileAttribution: '© OpenStreetMap katkıda bulunanlar',
        ),
      );

      expect(config.mapTiles.darkUrlTemplate, isNull);
    });

    test('https olmayan veya yer tutucusu eksik şablon reddedilir', () {
      for (final template in [
        'http://tiles.example.org/{z}/{x}/{y}.png',
        'https://tiles.example.org/{z}/{x}.png',
      ]) {
        expect(
          () => AppConfig.resolve(
            AppEnvironment.dev,
            overrides: AppConfigOverrides(mapTileUrlDark: template),
          ),
          throwsA(isA<InvalidAppConfigError>()),
          reason: 'koyu: $template',
        );
        expect(
          () => AppConfig.resolve(
            AppEnvironment.dev,
            overrides: AppConfigOverrides(mapTileUrlLight: template),
          ),
          throwsA(isA<InvalidAppConfigError>()),
          reason: template,
        );
      }
    });
  });

  group('AppConfigOverrides.parseSslPins', () {
    test('virgülle ayrılmış pinleri boşlukları temizleyerek ayrıştırır', () {
      expect(AppConfigOverrides.parseSslPins(' $validPin , $backupPin ,'), [
        validPin,
        backupPin,
      ]);
    });

    test('SHA-256 Base64 biçiminde olmayan pini reddeder', () {
      expect(
        () => AppConfigOverrides.parseSslPins('kisa-pin'),
        throwsA(isA<InvalidAppConfigError>()),
      );
    });
  });
}
