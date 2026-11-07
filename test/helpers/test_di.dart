import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/a11y/speech_input_service.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/core/location/location_service.dart';
import 'package:vakif_atlas/core/map/map_tile_source.dart';
import 'package:vakif_atlas/core/media/photo_picker_service.dart';
import 'package:vakif_atlas/core/media/photo_processor.dart';
import 'package:vakif_atlas/core/network/http_transport.dart';
import 'package:vakif_atlas/core/network/network_status.dart';
import 'package:vakif_atlas/core/notifications/local_notification_service.dart';
import 'package:vakif_atlas/core/permissions/permission_service.dart';
import 'package:vakif_atlas/features/catalog/data/sources/catalog_local_data_source.dart';
import 'package:vakif_atlas/features/onboarding/data/repositories/onboarding_repository_impl.dart';

import '../support/mock_api/ai_assistant/assistant_mock_api.dart';
import '../support/mock_api/auth/auth_mock_api.dart';
import '../support/mock_api/auth/legal_mock_api.dart';
import '../support/mock_api/auth/mock_user_store.dart';
import '../support/mock_api/catalog/catalog_mock_api.dart';
import '../support/mock_api/civil_protection/civil_protection_mock_api.dart';
import '../support/mock_api/civil_protection/mock_damage_report_store.dart';
import '../support/mock_api/feedback/feedback_mock_api.dart';
import '../support/mock_api/gamification/gamification_mock_api.dart';
import '../support/mock_api/gamification/mock_activity_ledger.dart';
import '../support/mock_api/memory_corner/memory_mock_api.dart';
import '../support/mock_api/memory_corner/mock_memory_store.dart';
import '../support/mock_api/mock_api.dart';
import '../support/mock_api/mock_mailbox.dart';
import '../support/mock_api/route_planner/mock_route_store.dart';
import '../support/mock_api/route_planner/route_mock_api.dart';
import '../support/mock_api/saved_monuments/saved_monuments_mock_api.dart';
import 'catalog_test_utils.dart';
import 'location_test_utils.dart';
import 'map_test_utils.dart';
import 'network_test_utils.dart';
import 'notification_test_utils.dart';
import 'memory_test_utils.dart';
import 'permission_test_utils.dart';
import 'speech_test_utils.dart';
import 'test_config.dart';

/// Bellek içi `FlutterSecureStorage` (platform kanalı gerektirmez).
class InMemorySecureStorage extends Mock implements FlutterSecureStorage {
  InMemorySecureStorage() {
    when(() => read(key: any(named: 'key'))).thenAnswer(
      (invocation) async => values[invocation.namedArguments[#key] as String],
    );
    when(
      () => write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((invocation) async {
      values[invocation.namedArguments[#key] as String] =
          invocation.namedArguments[#value] as String;
    });
    when(() => delete(key: any(named: 'key'))).thenAnswer(
      (invocation) async =>
          values.remove(invocation.namedArguments[#key] as String),
    );
    when(deleteAll).thenAnswer((_) async => values.clear());
  }

  final Map<String, String> values = {};
}

/// Testlerde tam DI grafiği: ağ istekleri bellek içi sahte backend'e
/// (`MockApiAdapter`) gider, platform eklentileri
/// bellek içi, ekran okuyucu duyuruları [announcements] listesine yazılır.
final class TestDependencies {
  TestDependencies._(this.secureStorage, this.announcements);

  final InMemorySecureStorage secureStorage;
  final List<String> announcements;

  /// [onboardingCompleted] `true` iken ilk açılış tanıtımı tamamlanmış
  /// sayılır (tanıtım dışındaki akış testleri doğrudan uygulamaya açılır).
  static Future<TestDependencies> setUp({
    Map<String, Object> preferences = const {},
    bool onboardingCompleted = true,
    DateTime Function()? authClock,
  }) async {
    setUpPlatformPluginMocks(
      preferences: {
        if (onboardingCompleted)
          'onboarding.completed_version':
              OnboardingRepositoryImpl.currentVersion,
        ...preferences,
      },
    );
    await configureDependencies(testAppConfig());

    final storage = InMemorySecureStorage();
    final announcements = <String>[];
    final mailbox = MockMailbox();
    final authMockApi = AuthMockApi.withClock(
      store: InMemoryMockUserStore(),
      mailbox: mailbox,
      clock: authClock ?? DateTime.now,
    );
    final feedbackMockApi = FeedbackMockApi(authMockApi);
    getIt
      ..allowReassignment = true
      ..registerSingleton<FlutterSecureStorage>(storage)
      ..registerSingleton<NetworkStatus>(
        FakeNetworkStatus(),
        dispose: (status) => status.dispose(),
      )
      ..registerSingleton<MockMailbox>(mailbox, dispose: (m) => m.dispose())
      ..registerSingleton<AuthMockApi>(authMockApi)
      ..registerSingleton<FeedbackMockApi>(feedbackMockApi)
      ..registerSingleton<HttpTransport>(
        MockHttpTransport(
          MockApiAdapter(
            apis: [
              const HealthMockApi(),
              authMockApi,
              LegalMockApi(),
              CatalogMockApi(),
              RouteMockApi(InMemoryMockRouteStore(), auth: authMockApi),
              MemoryMockApi(InMemoryMockMemoryStore(), authMockApi),
              CivilProtectionMockApi(
                InMemoryMockDamageReportStore(),
                authMockApi,
              ),
              AssistantMockApi(),
              SavedMonumentsMockApi(auth: authMockApi),
              GamificationMockApi(
                MockActivityLedger(InMemoryMockActivityStore(), authMockApi),
                authMockApi,
              ),
              feedbackMockApi,
            ],
          ),
        ),
      )
      ..registerSingleton<A11yAnnouncer>(
        A11yAnnouncer.withSender(
          (_, message, _, _) async => announcements.add(message),
        ),
      )
      ..registerSingleton<HapticFeedbackService>(
        HapticFeedbackService.withDelay((_) async {}),
      )
      ..registerSingleton<MapTileSource>(testMapTileSource())
      ..registerSingleton<LocationService>(FakeLocationService())
      ..registerSingleton<LocalNotificationService>(
        FakeLocalNotificationService(),
      )
      ..registerSingleton<PhotoPickerService>(FakePhotoPickerService())
      ..registerSingleton<PermissionService>(FakePermissionService())
      ..registerSingleton<SpeechInputService>(FakeSpeechInputService())
      ..registerSingleton<PhotoProcessor>(const FakePhotoProcessor())
      ..registerSingleton<CatalogLocalDataSource>(
        InMemoryCatalogLocalDataSource(),
      );
    return TestDependencies._(storage, announcements);
  }
}
