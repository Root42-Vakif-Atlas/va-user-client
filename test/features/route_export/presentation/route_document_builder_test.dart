import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/features/route_export/presentation/route_document_builder.dart';

import '../../../helpers/route_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('tr');
    await initializeDateFormatting('en');
  });

  final now = DateTime(2026, 10, 18, 20, 15);

  test(
    'kayıtlı rotanın özeti, durakları ve yolculukları belgeye aktarılır',
    () async {
      final route = await createTestRoute('Trakya', [
        'selimiye-camii',
        'suleymaniye-camii',
        'bursa-ulu-camii',
      ]);
      final document = buildRouteDocument(
        route,
        lookupAppLocalizations(const Locale('tr')),
        now: now,
      );

      expect(document.title, 'Trakya');
      expect(document.subtitle, 'Edirne → İstanbul → Bursa · 3 durak');
      expect(document.facts.map((f) => f.label), [
        'Toplam süre',
        'Karayolu mesafesi',
        'Yolculuk',
        'Ziyaret',
        'Mola',
      ]);
      expect(document.stops.first.place, 'Merkez, Edirne · Cami');
      expect(document.stops.first.details, [
        'Ziyaret · 1 saat',
        'Yemek molası · 45 dakika',
      ]);
      expect(document.stops.first.nextLeg, startsWith('237 km · araçla ≈ '));
      expect(document.stops.last.nextLeg, isNull);
      expect(document.stops.first.mapUrl, contains('openstreetmap.org'));
      expect(document.path.length, greaterThan(document.stops.length));
      expect(document.labels.generatedOn, 'Hazırlanma: 18 Ekim 2026 20:15');
      expect(document.labels.page(1, 2), 'Sayfa 1 / 2');
    },
  );

  test('belge arayüz dilinde üretilir', () async {
    final route = await createTestRoute('Thrace', [
      'selimiye-camii',
      'bursa-ulu-camii',
    ], languageCode: 'en');
    final document = buildRouteDocument(
      route,
      lookupAppLocalizations(const Locale('en')),
      now: now,
    );

    expect(document.languageCode, 'en');
    expect(document.facts.first.label, 'Total time');
    expect(document.labels.page(2, 3), 'Page 2 of 3');
  });

  test('dosya adı Türkçe harflerden arındırılır, kısaltılır ve tarihlenir', () {
    expect(
      routeExportFileName('Şişli – Üsküdar Gezisi!', now),
      'vakif-atlas-sisli-uskudar-gezisi-2026-10-18.pdf',
    );
    expect(
      routeExportFileName('  ***  ', now),
      'vakif-atlas-rota-2026-10-18.pdf',
    );
    final long = routeExportFileName('a' * 200, now);
    expect(
      long.length,
      lessThanOrEqualTo('vakif-atlas--2026-10-18.pdf'.length + 60),
    );
  });

  test('dosya boyutu dile göre biçimlenir', () {
    final tr = lookupAppLocalizations(const Locale('tr'));
    expect(tr.fileSize(20 * 1024), '20 KB');
    expect(tr.fileSize(1536 * 1024), '1,5 MB');
  });
}
