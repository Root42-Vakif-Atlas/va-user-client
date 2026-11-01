import 'dart:typed_data';

export 'package:vakif_atlas/features/route_export/data/sources/route_export_file_store_web.dart'
    if (dart.library.io) 'package:vakif_atlas/features/route_export/data/sources/route_export_file_store_io.dart';

/// Dışa aktarılan PDF'lerin ham dosya deposu. Yollar depo köküne
/// göredir (`<sahip>/<kimlik>.pdf`). Hatalar `CacheException` olarak
/// fırlatılır.
abstract interface class RouteExportFileStore {
  Future<void> write(String path, Uint8List bytes);

  /// Dosya yoksa `null`.
  Future<Uint8List?> read(String path);

  Future<void> delete(String path);

  /// Bir sahibin klasörünü tümüyle siler.
  Future<void> deleteDirectory(String path);
}
