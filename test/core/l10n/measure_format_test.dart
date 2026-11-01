import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/l10n/measure_format.dart';

void main() {
  final tr = lookupAppLocalizations(const Locale('tr'));
  final en = lookupAppLocalizations(const Locale('en'));

  test('mesafe dile göre biçimlenir', () {
    expect(tr.distance(850), '850 m');
    expect(tr.distance(9440), '9,4 km');
    expect(en.distance(9440), '9.4 km');
    expect(tr.distance(1240400), '1.240 km');
    expect(en.distance(1240400), '1,240 km');
  });

  test('kısa süre biçimi', () {
    expect(tr.durationShort(const Duration(minutes: 45)), '45 dk');
    expect(
      tr.durationShort(const Duration(hours: 3, minutes: 15)),
      '3 sa 15 dk',
    );
    expect(tr.durationShort(const Duration(hours: 2)), '2 sa');
    expect(
      tr.durationShort(const Duration(days: 2, hours: 3, minutes: 40)),
      '2 g 3 sa',
    );
    expect(en.durationShort(const Duration(hours: 1, minutes: 5)), '1 h 5 min');
    // 59 dk 40 sn → 1 sa.
    expect(tr.durationShort(const Duration(seconds: 3580)), '1 sa');
  });

  test('ekran okuyucu için uzun süre biçimi çoğullanır', () {
    expect(tr.durationLong(const Duration(days: 1, hours: 1)), '1 gün 1 saat');
    expect(en.durationLong(const Duration(days: 2, hours: 1)), '2 days 1 hour');
    expect(en.durationLong(const Duration(minutes: 1)), '1 minute');
    expect(tr.durationLong(Duration.zero), '0 dakika');
  });
}
