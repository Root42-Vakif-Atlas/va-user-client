import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report_draft.dart';

/// Vatandaşın Sivil Koruma bildirimleri (Civil Protection mikro servisi).
///
/// Tüm işlemler oturum gerektirir; kullanıcı yalnızca kendi raporlarını
/// görür.
abstract interface class DamageReportRepository {
  /// Gönderilen raporlar (listelerin kendini güncellemesi için).
  Stream<DamageReport> get submitted;

  ResultFuture<DamageReportPage> getReports({
    required int limit,
    required String languageCode,
    String? cursor,
  });

  ResultFuture<DamageReport> getReport({
    required String id,
    required String languageCode,
  });

  /// Fotoğrafları yükler ve raporu gönderir. [onProgress] yükleme
  /// ilerlemesini 0–1 arasında bildirir.
  ResultFuture<DamageReport> submitReport(
    DamageReportDraft draft, {
    required String languageCode,
    void Function(double progress)? onProgress,
  });
}
