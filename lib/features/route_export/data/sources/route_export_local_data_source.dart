import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/storage/local_db_service.dart';
import 'package:vakif_atlas/features/route_export/data/dtos/route_export_dtos.dart';
import 'package:vakif_atlas/features/route_export/data/sources/route_export_file_store.dart';

/// Dışa aktarım arşivi: dizin yerel veritabanında, PDF'ler uygulamaya özel
/// dizinde. [ownerKey] sahibin kimliğinden türetilen, kişisel veri içermeyen
/// anahtardır. Hatalar `CacheException` olarak fırlatılır.
abstract interface class RouteExportLocalDataSource {
  Future<List<RouteExportRecordDto>> readIndex(String ownerKey);

  Future<void> save(
    String ownerKey,
    RouteExportRecordDto record,
    Uint8List bytes,
  );

  /// Dosya veya kayıt yoksa `null`.
  Future<Uint8List?> readFile(String ownerKey, String id);

  Future<void> delete(String ownerKey, String id);

  Future<void> deleteOwner(String ownerKey);
}

@LazySingleton(as: RouteExportLocalDataSource)
class RouteExportLocalDataSourceImpl implements RouteExportLocalDataSource {
  RouteExportLocalDataSourceImpl(this._db)
    : _files = createRouteExportFileStore();

  /// Testlerde dosya deposunu değiştirmek için.
  RouteExportLocalDataSourceImpl.withFileStore(this._db, this._files);

  static const String boxName = 'route_exports.v1';

  final LocalDbService _db;
  final RouteExportFileStore _files;

  static String _key(String ownerKey, String id) => '$ownerKey/$id';

  static String _path(String ownerKey, String id) => '$ownerKey/$id.pdf';

  @override
  Future<List<RouteExportRecordDto>> readIndex(String ownerKey) async {
    final box = await _db.openBox<Object?>(boxName);
    final records = <RouteExportRecordDto>[];
    for (final key in box.keys.whereType<String>()) {
      if (!key.startsWith('$ownerKey/')) {
        continue;
      }
      final value = box.get(key);
      try {
        if (value is Map) {
          records.add(
            RouteExportRecordDto.fromJson(Map<String, dynamic>.from(value)),
          );
          continue;
        }
      } on CheckedFromJsonException {
        // Bozuk kayıt aşağıda silinir.
      }
      await box.delete(key);
    }
    return records;
  }

  @override
  Future<void> save(
    String ownerKey,
    RouteExportRecordDto record,
    Uint8List bytes,
  ) async {
    // Önce dosya: dizinde olup dosyası olmayan kayıt oluşmaz.
    await _files.write(_path(ownerKey, record.id), bytes);
    final box = await _db.openBox<Object?>(boxName);
    try {
      await box.put(_key(ownerKey, record.id), record.toJson());
    } on Exception {
      await _files.delete(_path(ownerKey, record.id));
      throw const CacheException('route_exports.index');
    }
  }

  @override
  Future<Uint8List?> readFile(String ownerKey, String id) async {
    final box = await _db.openBox<Object?>(boxName);
    if (!box.containsKey(_key(ownerKey, id))) {
      return null;
    }
    return _files.read(_path(ownerKey, id));
  }

  @override
  Future<void> delete(String ownerKey, String id) async {
    final box = await _db.openBox<Object?>(boxName);
    await box.delete(_key(ownerKey, id));
    await _files.delete(_path(ownerKey, id));
  }

  @override
  Future<void> deleteOwner(String ownerKey) async {
    final box = await _db.openBox<Object?>(boxName);
    await box.deleteAll(
      box.keys.whereType<String>().where((k) => k.startsWith('$ownerKey/')),
    );
    await _files.deleteDirectory(ownerKey);
  }
}
