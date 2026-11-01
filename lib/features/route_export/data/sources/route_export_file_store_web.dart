import 'dart:typed_data';

import 'package:vakif_atlas/features/route_export/data/sources/route_export_file_store.dart';

/// Web: dosya sistemi yoktur; dışa aktarımlar yalnızca oturum boyunca
/// bellekte tutulur (ADR 2: platforma özel servisler web'de sadeleşir).
RouteExportFileStore createRouteExportFileStore() =>
    MemoryRouteExportFileStore();

class MemoryRouteExportFileStore implements RouteExportFileStore {
  final Map<String, Uint8List> _files = {};

  @override
  Future<void> write(String path, Uint8List bytes) async =>
      _files[path] = bytes;

  @override
  Future<Uint8List?> read(String path) async => _files[path];

  @override
  Future<void> delete(String path) async => _files.remove(path);

  @override
  Future<void> deleteDirectory(String path) async =>
      _files.removeWhere((key, _) => key.startsWith('$path/'));
}
