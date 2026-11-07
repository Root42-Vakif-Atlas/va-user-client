import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/notifications/local_notification_service.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/entities/nearby_alert.dart';
import 'package:vakif_atlas/features/nearby_alerts/presentation/nearby_alert_notification.dart';

import '../nearby_alerts_test_data.dart';

void main() {
  final tr = lookupAppLocalizations(const Locale('tr'));
  final en = lookupAppLocalizations(const Locale('en'));

  test('Türkçe içerik: başlık, mesafe · tür, kısa tanıtım ve görsel', () {
    final notification = NearbyAlertNotification.build(
      NearbyAlert(monument: testMonument(), distanceMeters: 118.4),
      tr,
      includeImage: true,
    );

    expect(notification.title, 'Bursa Ulu Camii yakınındasınız');
    expect(notification.subtitle, '120 m uzakta · Cami');
    expect(notification.body, startsWith('Yıldırım Bayezid'));
    expect(notification.expandedBody, endsWith('Ayrıntılar için dokunun.'));
    expect(notification.imageUrl, 'https://cdn.example/ulucami.jpg');
    expect(notification.payload, '/monument/bursa-ulu-camii');
    expect(notification.channel, AppNotificationChannel.nearbyMonuments);
    expect(notification.timeout, isNotNull);
  });

  test('İngilizce içerik', () {
    final notification = NearbyAlertNotification.build(
      NearbyAlert(monument: testMonument(), distanceMeters: 42),
      en,
      includeImage: true,
    );
    expect(notification.title, "You're near Bursa Ulu Camii");
    expect(notification.subtitle, '40 m away · Mosque');
  });

  test('konum kesin değilse mesafe yerine "Yakınınızda" yazılır', () {
    final notification = NearbyAlertNotification.build(
      NearbyAlert(
        monument: testMonument(),
        distanceMeters: 40,
        accuracyMeters: 200,
      ),
      tr,
      includeImage: true,
    );
    expect(notification.subtitle, 'Yakınınızda · Cami');
  });

  test('"görselleri gizle" tercihinde görsel eklenmez', () {
    final notification = NearbyAlertNotification.build(
      NearbyAlert(monument: testMonument(), distanceMeters: 50),
      tr,
      includeImage: false,
    );
    expect(notification.imageUrl, isNull);
  });

  test('tanıtım yoksa konum, uzunsa kelime sınırında kısaltılmış metin', () {
    final empty = NearbyAlertNotification.build(
      NearbyAlert(
        monument: testMonument(shortDescription: '  '),
        distanceMeters: 50,
      ),
      tr,
      includeImage: true,
    );
    expect(empty.body, tr.monumentLocation('Osmangazi', 'Bursa'));

    final long = NearbyAlertNotification.build(
      NearbyAlert(
        monument: testMonument(shortDescription: 'kubbe ' * 100),
        distanceMeters: 50,
      ),
      tr,
      includeImage: true,
    );
    expect(
      long.body.length,
      lessThanOrEqualTo(NearbyAlertNotification.maxDescriptionLength + 1),
    );
    expect(long.body, endsWith('kubbe…'));
  });

  test('mesafe 10 m\'ye yuvarlanır, en az 10 m gösterilir', () {
    expect(NearbyAlertNotification.displayDistance(3), 10);
    expect(NearbyAlertNotification.displayDistance(144), 140);
    expect(NearbyAlertNotification.displayDistance(146), 150);
  });

  test('bildirim kimliği eser başına sabit ve pozitiftir', () {
    final id = NearbyAlertNotification.notificationId('bursa-ulu-camii');
    expect(id, NearbyAlertNotification.notificationId('bursa-ulu-camii'));
    expect(id, isNot(NearbyAlertNotification.notificationId('yesil-camii')));
    expect(id, greaterThanOrEqualTo(0));
  });

  test('bildirim yükünden yalnızca eser detayı rotası açılır', () {
    expect(
      NearbyAlertNotification.routeOf('/monument/bursa-ulu-camii'),
      '/monument/bursa-ulu-camii',
    );
    for (final payload in [
      '',
      '/profile',
      '/monument/',
      '/monument/a/memory-corner',
      'https://evil.example/monument/x',
      '//evil.example/monument/x',
      '/monument/x?from=/profile',
    ]) {
      expect(NearbyAlertNotification.routeOf(payload), isNull, reason: payload);
    }
  });
}
