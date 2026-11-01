import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/features/route_export/data/sources/route_export_file_store.dart';

/// Mobil/masaüstü: uygulamaya özel destek dizini
/// (`getApplicationSupportDirectory`, iOS'ta `Library/Application Support`,
/// Android'de dahili `files`). Kullanıcının "Dosyalar" uygulamasında veya
/// paylaşılan depolamada görünmez, başka uygulamalar erişemez.
RouteExportFileStore createRouteExportFileStore() =>
    IoRouteExportFileStore(getApplicationSupportDirectory);

class IoRouteExportFileStore implements RouteExportFileStore {
  IoRouteExportFileStore(this._baseDirectory);

  static const String folder = 'route_exports';

  final Future<Directory> Function() _baseDirectory;
  Future<Directory>? _root;

  Future<Directory> _resolveRoot() async =>
      Directory('${(await _baseDirectory()).path}/$folder');

  Future<File> _file(String path) async =>
      File('${(await (_root ??= _resolveRoot())).path}/$path');

  @override
  Future<void> write(String path, Uint8List bytes) => _guard('write', () async {
    final file = await _file(path);
    await file.parent.create(recursive: true);
    // Önce geçici dosyaya yazılır: yarım kalan yazma bozuk PDF bırakmaz.
    final temporary = File('${file.path}.part');
    await temporary.writeAsBytes(bytes, flush: true);
    await temporary.rename(file.path);
  });

  @override
  Future<Uint8List?> read(String path) => _guard('read', () async {
    final file = await _file(path);
    return await file.exists() ? file.readAsBytes() : null;
  });

  @override
  Future<void> delete(String path) => _guard('delete', () async {
    final file = await _file(path);
    if (await file.exists()) {
      await file.delete();
    }
  });

  @override
  Future<void> deleteDirectory(String path) => _guard('delete', () async {
    final directory = Directory(
      '${(await (_root ??= _resolveRoot())).path}/$path',
    );
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  });

  Future<T> _guard<T>(String operation, Future<T> Function() run) async {
    try {
      return await run();
    } on FileSystemException {
      throw CacheException('route_exports.$operation');
    } on MissingPlatformDirectoryException {
      // Başarısız dizin çözümü önbellekte kalmasın; sonraki çağrı yeniden
      // dener.
      _root = null;
      throw CacheException('route_exports.$operation');
    }
  }
}
