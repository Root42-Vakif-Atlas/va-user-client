import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_document.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_export.dart';

/// Rota belgelerinin üretimi ve arşivi.
///
/// Arşiv sunucudadır (`docs/api-contracts.md` → Rota dışa aktarımları);
/// cihazda yalnızca önbellek tutulur. Sahibi rotalardaki gibi oturum
/// açıksa hesap ([ownerId] = kullanıcı kimliği), değilse kurulumdur
/// ([ownerId] = `null`); girişte kurulumun misafir kayıtları hesaba
/// taşınır. Bir sahip başkasının dışa aktarımlarını göremez.
abstract interface class RouteExportRepository {
  /// Belgeyi PDF'e dönüştürür ve sahibinin arşivine yükler (sınır aşılırsa
  /// sunucu en eski kaydı siler). Yükleme başarısız olursa dosya yine
  /// döner, `archiveFailure` dolu olur.
  ResultFuture<RouteExportFile> createExport({
    required RouteDocument document,
    String? ownerId,
  });

  /// Sahibin dışa aktarımları, en yenisi önce.
  ResultFuture<List<RouteExport>> getExports(String? ownerId);

  ResultFuture<RouteExportFile> openExport({
    required String? ownerId,
    required String exportId,
  });

  /// Kaydın paylaşılabilir bağlantısı (her çağrıda yenisi üretilir).
  ResultFuture<RouteExportLink> createShareLink({
    required String? ownerId,
    required String exportId,
  });

  ResultFuture<Unit> deleteExport({
    required String? ownerId,
    required String exportId,
  });

  /// Sahibin cihazdaki önbelleğini siler (hesap silinince; oturum
  /// değişince misafir önbelleği).
  ResultFuture<Unit> deleteAllForOwner(String? ownerId);

  /// Arşiv değiştiğinde değişen sahip (misafirde `null`).
  Stream<String?> get changes;
}
