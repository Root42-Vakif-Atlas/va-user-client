import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/sharing/document_share_service.dart';
import 'package:vakif_atlas/features/route_export/data/dtos/route_export_dtos.dart';
import 'package:vakif_atlas/features/route_export/data/render/route_pdf_renderer.dart';
import 'package:vakif_atlas/features/route_export/data/repositories/route_export_repository_impl.dart';
import 'package:vakif_atlas/features/route_export/data/sources/route_export_local_data_source.dart';
import 'package:vakif_atlas/features/route_export/data/sources/route_export_remote_data_source.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_document.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_export.dart';

/// PDF yerine belge başlığını içeren küçük bir gövde üretir; üretilen
/// belgeleri kaydeder.
class FakeRoutePdfRenderer implements RoutePdfRenderer {
  final List<RouteDocument> rendered = [];

  /// `true` → üretim hatası.
  bool fail = false;

  @override
  Future<Uint8List> render(RouteDocument document) async {
    if (fail) {
      throw const UnexpectedException('render');
    }
    rendered.add(document);
    return Uint8List.fromList(utf8.encode('%PDF-1.5 ${document.title}'));
  }
}

/// Bellek içi arşiv (Hive ve dosya G/Ç'si widget testlerinin sahte zaman
/// bölgesinde tamamlanmaz).
class InMemoryRouteExportLocalDataSource implements RouteExportLocalDataSource {
  final Map<String, Map<String, RouteExportRecordDto>> records = {};
  final Map<String, Uint8List> files = {};

  /// `true` → yazma hatası (ör. depolama dolu).
  bool failWrites = false;

  @override
  Future<List<RouteExportRecordDto>> readIndex(String ownerKey) async => [
    ...?records[ownerKey]?.values,
  ];

  @override
  Future<void> save(
    String ownerKey,
    RouteExportRecordDto record,
    Uint8List bytes,
  ) async {
    if (failWrites) {
      throw const CacheException('route_exports.write');
    }
    (records[ownerKey] ??= {})[record.id] = record;
    files['$ownerKey/${record.id}'] = bytes;
  }

  @override
  Future<Uint8List?> readFile(String ownerKey, String id) async =>
      records[ownerKey]?.containsKey(id) ?? false
      ? files['$ownerKey/$id']
      : null;

  @override
  Future<void> delete(String ownerKey, String id) async {
    records[ownerKey]?.remove(id);
    files.remove('$ownerKey/$id');
  }

  @override
  Future<void> deleteOwner(String ownerKey) async {
    records.remove(ownerKey);
    files.removeWhere((key, _) => key.startsWith('$ownerKey/'));
  }
}

/// Sunucudaki arşiv (bellekte): istekler [session] hesabının Bearer'ıyla
/// (misafirde yalnızca [installation] kimliğiyle) gitmiş sayılır; oturum
/// açık istekte kurulumun misafir kayıtları hesaba taşınır (media servisi
/// `ExportOwner`). Kimlikler sıralı, saat dakika dakika ilerler.
class FakeRouteExportRemoteDataSource implements RouteExportRemoteDataSource {
  FakeRouteExportRemoteDataSource({DateTime? start})
    : _now = start ?? DateTime.utc(2026, 10, 18, 9);

  /// Oturumdaki hesap; `null` → misafir.
  String? session = 'u';

  /// İsteklerin `X-Installation-Id` değeri.
  String installation = 'inst_1';

  /// `true` → her istek ağ hatası.
  bool offline = false;

  final Map<String, List<RouteExportRecordDto>> records = {};
  final Map<String, Uint8List> objects = {};
  final List<RouteExportUploadRequestDto> uploads = [];
  int downloads = 0;
  int _counter = 0;
  DateTime _now;

  static String guestKey(String installation) => 'i:$installation';

  List<RouteExportRecordDto> get _own =>
      records[session ?? guestKey(installation)] ??= [];

  @override
  Future<RouteExportRecordDto> upload(
    RouteExportUploadRequestDto request,
    Uint8List bytes,
  ) async {
    _check();
    if (sha256.convert(bytes).toString() != request.sha256 ||
        bytes.length != request.byteSize) {
      throw const ServerException(statusCode: 400, errorCode: 'invalid_upload');
    }
    uploads.add(request);
    _now = _now.add(const Duration(minutes: 1));
    final record = RouteExportRecordDto(
      id: 'exp_${++_counter}',
      routeId: request.routeId,
      routeName: request.routeName,
      fileName: request.fileName,
      createdAt: _now,
      byteSize: request.byteSize,
      stopCount: request.stopCount,
    );
    _own.insert(0, record);
    objects[record.id] = bytes;
    while (_own.length > RouteExportRules.maxPerOwner) {
      objects.remove(_own.removeLast().id);
    }
    return record;
  }

  @override
  Future<RouteExportPageDto> fetchExports({
    required int limit,
    String? cursor,
  }) async {
    _check();
    return RouteExportPageDto(items: _own.take(limit).toList());
  }

  @override
  Future<Uint8List> download(String id) async {
    _check();
    final bytes = _own.any((r) => r.id == id) ? objects[id] : null;
    if (bytes == null) {
      throw const ServerException(statusCode: 404, errorCode: 'not_found');
    }
    downloads++;
    return bytes;
  }

  final List<String> shareLinks = [];

  @override
  Future<RouteExportDownloadDto> createShareLink(String id) async {
    _check();
    if (!_own.any((r) => r.id == id)) {
      throw const ServerException(statusCode: 404, errorCode: 'not_found');
    }
    shareLinks.add(id);
    return RouteExportDownloadDto(
      url: 'https://storage.example/route-exports/$id.pdf?X-Amz-Signature=s',
      expiresAt: _now.add(const Duration(days: 7)),
    );
  }

  @override
  Future<void> delete(String id) async {
    _check();
    final before = _own.length;
    _own.removeWhere((r) => r.id == id);
    if (_own.length == before) {
      throw const ServerException(statusCode: 404, errorCode: 'not_found');
    }
    objects.remove(id);
  }

  void _check() {
    if (offline) {
      throw const NetworkException(NetworkExceptionType.noConnection);
    }
    final guest = records.remove(guestKey(installation));
    if (session == null) {
      if (guest != null) {
        records[guestKey(installation)] = guest;
      }
      return;
    }
    if (guest == null || guest.isEmpty) {
      return;
    }
    final merged = [..._own, ...guest]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    for (final dropped in merged.skip(RouteExportRules.maxPerOwner)) {
      objects.remove(dropped.id);
    }
    records[session!] = merged.take(RouteExportRules.maxPerOwner).toList();
  }
}

RouteExportRepositoryImpl testRouteExportRepository({
  required RoutePdfRenderer renderer,
  required RouteExportLocalDataSource local,
  RouteExportRemoteDataSource? remote,
}) => RouteExportRepositoryImpl(
  renderer,
  remote ?? FakeRouteExportRemoteDataSource(),
  local,
);

class FakeDocumentShareService implements DocumentShareService {
  final List<String> shared = [];
  final List<String> printed = [];

  /// Paylaş/yazdır penceresinin açılıp açılmadığı.
  bool result = true;

  @override
  Future<bool> sharePdf({
    required Uint8List bytes,
    required String fileName,
  }) async {
    shared.add(fileName);
    return result;
  }

  @override
  Future<bool> printPdf({
    required Uint8List bytes,
    required String name,
  }) async {
    printed.add(name);
    return result;
  }
}

/// Panoya yazılan metinler (`Clipboard.setData` platform çağrısı).
List<String> captureClipboard(WidgetTester tester) {
  final copied = <String>[];
  final messenger = tester.binding.defaultBinaryMessenger
    ..setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        copied.add((call.arguments as Map)['text'] as String);
      }
      return null;
    });
  addTearDown(
    () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
  );
  return copied;
}

/// PDF rasterleştirmesi (platform eklentisi) yerine testlerde çizilir.
Widget fakePdfPreview(BuildContext context, Uint8List bytes, String name) =>
    SizedBox.expand(key: Key('fake_pdf_preview_$name'));
