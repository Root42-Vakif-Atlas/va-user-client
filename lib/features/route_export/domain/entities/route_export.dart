import 'dart:typed_data';

import 'package:vakif_atlas/core/error/failures.dart';

/// Kullanıcının arşivindeki bir dışa aktarım (meta veri).
final class RouteExport {
  const RouteExport({
    required this.id,
    required this.routeId,
    required this.routeName,
    required this.fileName,
    required this.createdAt,
    required this.byteSize,
    required this.stopCount,
  });

  final String id;
  final String routeId;
  final String routeName;
  final String fileName;
  final DateTime createdAt;
  final int byteSize;
  final int stopCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteExport &&
          other.id == id &&
          other.routeId == routeId &&
          other.routeName == routeName &&
          other.fileName == fileName &&
          other.createdAt == createdAt &&
          other.byteSize == byteSize &&
          other.stopCount == stopCount;

  @override
  int get hashCode => Object.hash(
    id,
    routeId,
    routeName,
    fileName,
    createdAt,
    byteSize,
    stopCount,
  );

  @override
  String toString() => 'RouteExport($id)';
}

/// Üretilen veya arşivden açılan PDF.
final class RouteExportFile {
  const RouteExportFile({
    required this.bytes,
    required this.fileName,
    this.saved,
    this.archiveFailure,
  });

  final Uint8List bytes;
  final String fileName;

  /// Arşive kaydedildiyse kaydın kendisi; misafirde `null`.
  final RouteExport? saved;

  /// PDF üretildi ama arşive kaydedilemedi (ör. depolama dolu); dosya yine
  /// de paylaşılabilir.
  final Failure? archiveFailure;

  @override
  String toString() => 'RouteExportFile($fileName, ${bytes.length} B)';
}

/// Arşivdeki PDF'in paylaşılabilir bağlantısı (nesne deposunun ön imzalı
/// adresi). Bağlantıya sahip herkes PDF'i [expiresAt]'e kadar açabilir;
/// dışa aktarım silinince çalışmaz olur. Adres imza taşıdığından loglara
/// yazılmaz.
final class RouteExportLink {
  const RouteExportLink({required this.url, required this.expiresAt});

  final String url;
  final DateTime expiresAt;

  @override
  bool operator ==(Object other) =>
      other is RouteExportLink &&
      other.url == url &&
      other.expiresAt == expiresAt;

  @override
  int get hashCode => Object.hash(url, expiresAt);

  @override
  String toString() => 'RouteExportLink(***, $expiresAt)';
}

/// Dışa aktarım arşivinin kuralları.
abstract final class RouteExportRules {
  /// Kullanıcı başına saklanan en fazla dışa aktarım; aşılınca en eskisi
  /// silinir.
  static const int maxPerOwner = 50;
}
