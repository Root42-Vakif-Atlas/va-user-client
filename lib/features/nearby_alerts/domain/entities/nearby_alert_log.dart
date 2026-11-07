import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';

/// Gönderilen yakınlık bildirimlerinin cihazdaki kaydı: aynı eser (ve aynı
/// külliyenin diğer yapıları) için tekrar bildirim gönderilmesini ve
/// bildirim yağmurunu önler.
///
/// Anahtarlar `monument:<id>` ve `complex:<id>` biçimindedir.
final class NearbyAlertLog {
  NearbyAlertLog(Map<String, DateTime> entries)
    : entries = Map.unmodifiable(entries);

  static final NearbyAlertLog empty = NearbyAlertLog(const {});

  final Map<String, DateTime> entries;

  static String monumentKey(String id) => 'monument:$id';

  static String complexKey(String id) => 'complex:$id';

  /// Son bildirimin zamanı; hiç yoksa `null`.
  DateTime? get lastAlertAt {
    DateTime? latest;
    for (final at in entries.values) {
      if (latest == null || at.isAfter(latest)) {
        latest = at;
      }
    }
    return latest;
  }

  /// [since]'ten sonra bildirilen eser sayısı (külliye kayıtları hariç).
  int alertsSince(DateTime since) => entries.entries
      .where(
        (entry) =>
            entry.key.startsWith('monument:') && entry.value.isAfter(since),
      )
      .length;

  /// [monument] veya üyesi olduğu külliye [since]'ten sonra bildirildi mi?
  bool covers(MonumentSummary monument, DateTime since) {
    bool after(String key) => entries[key]?.isAfter(since) ?? false;
    final complex = monument.complex;
    return after(monumentKey(monument.id)) ||
        (complex != null && after(complexKey(complex.id)));
  }

  NearbyAlertLog record(MonumentSummary monument, DateTime at) {
    final complex = monument.complex;
    return NearbyAlertLog({
      ...entries,
      monumentKey(monument.id): at,
      if (complex != null) complexKey(complex.id): at,
    });
  }

  /// [before]'dan eski kayıtları atar (kayıt büyümez).
  NearbyAlertLog prune(DateTime before) => NearbyAlertLog({
    for (final MapEntry(:key, :value) in entries.entries)
      if (!value.isBefore(before)) key: value,
  });

  @override
  String toString() => 'NearbyAlertLog(${entries.length})';
}
