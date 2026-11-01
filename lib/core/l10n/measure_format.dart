import 'package:intl/intl.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';

/// Yerelleştirilmiş mesafe ve süre biçimleri.
///
/// Kısa biçim (ör. `2 g 3 sa`) görsel arayüz, uzun biçim (ör. `2 gün
/// 3 saat`) ekran okuyucu etiketleri ve duyurular içindir.
extension MeasureFormat on AppLocalizations {
  /// `850 m`, `9,4 km`, `1.240 km` (dile göre basamak ayırıcıları).
  String distance(num meters) {
    if (meters < 1000) {
      return distanceMeters(
        NumberFormat.decimalPattern(localeName).format(meters.round()),
      );
    }
    final kilometers = meters / 1000;
    final format = kilometers < 10
        ? NumberFormat.decimalPatternDigits(
            locale: localeName,
            decimalDigits: 1,
          )
        : NumberFormat.decimalPattern(localeName);
    return distanceKilometers(
      format.format(kilometers < 10 ? kilometers : kilometers.round()),
    );
  }

  /// `45 dk`, `3 sa 15 dk`, `2 g 3 sa` — bir günü aşan sürede dakika
  /// gösterilmez.
  String durationShort(Duration duration) => _parts(
    duration,
    days: durationDaysShort,
    hours: durationHoursShort,
    minutes: durationMinutesShort,
  );

  /// `45 dakika`, `3 saat 15 dakika`, `2 gün 3 saat`.
  String durationLong(Duration duration) => _parts(
    duration,
    days: durationDays,
    hours: durationHours,
    minutes: durationMinutes,
  );

  static String _parts(
    Duration duration, {
    required String Function(int) days,
    required String Function(int) hours,
    required String Function(int) minutes,
  }) {
    // Saniyeler en yakın dakikaya yuvarlanır.
    final totalMinutes = (duration.inSeconds / 60).round();
    final dayCount = totalMinutes ~/ (24 * 60);
    final hourCount = (totalMinutes ~/ 60) % 24;
    final minuteCount = totalMinutes % 60;
    if (dayCount > 0) {
      return [days(dayCount), if (hourCount > 0) hours(hourCount)].join(' ');
    }
    if (hourCount > 0) {
      return [
        hours(hourCount),
        if (minuteCount > 0) minutes(minuteCount),
      ].join(' ');
    }
    return minutes(minuteCount);
  }
}
