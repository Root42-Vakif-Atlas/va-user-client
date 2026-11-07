import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/complex.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/entities/nearby_alert.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/entities/nearby_alert_log.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/entities/nearby_alert_policy.dart';

import '../nearby_alerts_test_data.dart';

void main() {
  const policy = NearbyAlertPolicy();
  final now = DateTime(2026, 11, 7, 14);

  NearbyAlert? select(
    List<MonumentSummary> candidates, {
    GeoPoint position = ulucami,
    double accuracy = 15,
    NearbyAlertLog? log,
  }) => policy.select(
    position: position,
    accuracyMeters: accuracy,
    candidates: candidates,
    log: log ?? NearbyAlertLog.empty,
    now: now,
  );

  test('yarıçap içindeki eser bildirilir; dışındaki bildirilmez', () {
    final inside = select([testMonument()], position: northOf(ulucami, 220));
    expect(inside?.monument.id, 'bursa-ulu-camii');
    expect(inside!.distanceMeters, closeTo(220, 1));

    expect(select([testMonument()], position: northOf(ulucami, 300)), isNull);
  });

  test('birden çok aday varsa en yakını seçilir', () {
    final alert = select([
      testMonument(id: 'far', location: northOf(ulucami, 140)),
      testMonument(id: 'near', location: northOf(ulucami, 40)),
    ]);
    expect(alert?.monument.id, 'near');
  });

  test('konumu olmayan, geçersiz konumlu eserler ve külliye kayıtları '
      'atlanır', () {
    expect(
      select([
        testMonument(id: 'no-location', location: null),
        testMonument(
          id: 'invalid',
          location: const GeoPoint(latitude: 200, longitude: 0),
        ),
        testMonument(id: 'complex', memberCount: 4),
      ]),
      isNull,
    );
  });

  test('masaüstü Wi-Fi konumunda (~200 m doğruluk) yakındaki eser '
      'bildirilir', () {
    // macOS'ta Şekerhan önünde: pin ~40 m, doğruluk dairesi ~200 m.
    final alert = select(
      [testMonument()],
      position: northOf(ulucami, 40),
      accuracy: 200,
    );
    expect(alert?.monument.id, 'bursa-ulu-camii');
    expect(alert!.accuracyMeters, 200);
  });

  test('doğruluğu çok düşük konumda bildirim gönderilmez', () {
    expect(select([testMonument()], accuracy: 400), isNull);
    expect(select([testMonument()], accuracy: double.nan), isNull);
  });

  test('aynı eser bekleme süresi içinde yeniden bildirilmez', () {
    final log = NearbyAlertLog.empty.record(
      testMonument(),
      now.subtract(const Duration(hours: 3)),
    );
    expect(select([testMonument()], log: log), isNull);

    final expired = NearbyAlertLog.empty.record(
      testMonument(),
      now.subtract(const Duration(hours: 25)),
    );
    expect(select([testMonument()], log: expired), isNotNull);
  });

  test('külliyenin bir yapısı bildirildiyse diğer yapıları bildirilmez', () {
    const complex = ComplexRef(id: 'yildirim', name: 'Yıldırım Külliyesi');
    final log = NearbyAlertLog.empty.record(
      testMonument(id: 'mosque', complex: complex),
      now.subtract(const Duration(hours: 1)),
    );
    expect(
      select([testMonument(id: 'madrasa', complex: complex)], log: log),
      isNull,
    );
  });

  test('iki bildirim arasında en az beş dakika olur', () {
    final log = NearbyAlertLog.empty.record(
      testMonument(id: 'other'),
      now.subtract(const Duration(minutes: 2)),
    );
    expect(select([testMonument()], log: log), isNull);
    expect(policy.mayAlert(accuracyMeters: 10, log: log, now: now), isFalse);
    expect(
      policy.mayAlert(
        accuracyMeters: 10,
        log: log,
        now: now.add(const Duration(minutes: 4)),
      ),
      isTrue,
    );
  });

  test('günlük üst sınır aşılmaz', () {
    var log = NearbyAlertLog.empty;
    for (var i = 0; i < policy.maxAlertsPerDay; i++) {
      log = log.record(
        testMonument(id: 'm$i'),
        now.subtract(Duration(hours: 1, minutes: i * 10)),
      );
    }
    expect(select([testMonument()], log: log), isNull);
  });

  test('kayıt temizlenince eski girdiler atılır', () {
    final log = NearbyAlertLog.empty
        .record(testMonument(id: 'old'), now.subtract(const Duration(days: 3)))
        .record(testMonument(id: 'new'), now)
        .prune(now.subtract(policy.retention));
    expect(log.entries.keys, [NearbyAlertLog.monumentKey('new')]);
  });
}
