import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/location/location_service.dart';
import 'package:vakif_atlas/core/permissions/permission_service.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/nearby_alerts/presentation/cubit/nearby_alerts_cubit.dart';

import '../../../helpers/location_test_utils.dart';
import '../../../helpers/notification_test_utils.dart';
import '../nearby_alerts_test_data.dart';

DevicePosition _at(GeoPoint point, {double accuracy = 15}) => DevicePosition(
  latitude: point.latitude,
  longitude: point.longitude,
  accuracyMeters: accuracy,
);

void main() {
  late FakeLocationService location;
  late FakeLocalNotificationService notifications;
  late FakeNearbyMonumentsRepository monuments;
  late InMemoryNearbyAlertLogRepository log;
  late NearbyAlertsCubit cubit;

  setUp(() {
    location = FakeLocationService(access: LocationAccess.granted);
    notifications = FakeLocalNotificationService(
      access: PermissionAccess.granted,
    );
    monuments = FakeNearbyMonumentsRepository([testMonument()]);
    log = InMemoryNearbyAlertLogRepository();
    cubit = testNearbyAlertsCubit(
      location: location,
      notifications: notifications,
      monuments: monuments,
      log: log,
    );
  });

  tearDown(() async {
    await cubit.close();
    await location.dispose();
  });

  Future<void> start([String languageCode = 'tr']) =>
      cubit.start(languageCode: languageCode, includeImages: true);

  /// Konum akışındaki asenkron değerlendirmenin bitmesini bekler.
  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('izinler varsa arka plan takibiyle konum izlenir', () async {
    await start();

    expect(cubit.state, NearbyAlertsStatus.active);
    expect(location.hasListeners, isTrue);
    expect(location.lastBackground?.title, 'Yakındaki eser bildirimleri açık');
  });

  test('başlatma izin sormaz; eksik izin durumu bildirilir', () async {
    notifications.access = PermissionAccess.denied;
    await start();
    expect(cubit.state, NearbyAlertsStatus.notificationsBlocked);
    expect(notifications.requestCalls, 0);
    expect(location.hasListeners, isFalse);

    notifications.access = PermissionAccess.granted;
    location.access = LocationAccess.deniedForever;
    await start();
    expect(cubit.state, NearbyAlertsStatus.locationBlocked);
    expect(location.requestAccessCalls, 0);
  });

  test('yakındaki eser bir kez bildirilir ve kaydedilir', () async {
    await start();

    location.updates.add(_at(northOf(ulucami, 60)));
    await settle();
    location.updates.add(_at(northOf(ulucami, 30)));
    await settle();

    expect(notifications.shown, hasLength(1));
    expect(notifications.shown.single.title, 'Bursa Ulu Camii yakınındasınız');
    expect(notifications.shown.single.payload, '/monument/bursa-ulu-camii');
    expect(log.log.entries, isNotEmpty);
  });

  test('uzaktaki eser veya düşük doğruluklu konum bildirilmez', () async {
    await start();

    location.updates.add(_at(northOf(ulucami, 600)));
    await settle();
    location.updates.add(_at(ulucami, accuracy: 500));
    await settle();

    expect(notifications.shown, isEmpty);
    // Düşük doğrulukta ağ isteği de yapılmaz.
    expect(monuments.queries, hasLength(1));
  });

  test('dil değişince takip metinleri o dilde yeniden başlar', () async {
    await start();
    await start('en');

    expect(location.lastBackground?.title, 'Nearby monument alerts are on');
    location.updates.add(_at(ulucami));
    await settle();
    expect(notifications.shown.single.title, "You're near Bursa Ulu Camii");
  });

  test('durdurulunca konum izlenmez', () async {
    await start();
    await cubit.stop();

    expect(cubit.state, NearbyAlertsStatus.off);
    expect(location.hasListeners, isFalse);
  });

  test('konum akışı kapanırsa (izin geri alındı) durum bildirilir', () async {
    await start();
    await location.updates.close();
    await settle();

    expect(cubit.state, NearbyAlertsStatus.locationBlocked);
  });

  test('ayar açılırken önce bildirim, sonra konum izni istenir', () async {
    notifications.access = PermissionAccess.denied;
    location.access = LocationAccess.denied;

    expect(await cubit.requestActivation(), NearbyAlertsActivation.granted);
    expect(notifications.requestCalls, 1);
    expect(location.requestAccessCalls, 1);
  });

  test('geçmiş silinebilir', () async {
    await start();
    location.updates.add(_at(ulucami));
    await settle();
    await cubit.clearHistory();

    expect(log.clears, 1);
    expect(log.log.entries, isEmpty);
  });

  test('desteklenmeyen platformda hiçbir şey başlatılmaz', () async {
    final unsupported = testNearbyAlertsCubit(
      location: location,
      notifications: FakeLocalNotificationService(isSupported: false),
    );
    addTearDown(unsupported.close);

    await unsupported.start(languageCode: 'tr', includeImages: true);
    expect(unsupported.state, NearbyAlertsStatus.unsupported);
    expect(location.hasListeners, isFalse);
  });
}
