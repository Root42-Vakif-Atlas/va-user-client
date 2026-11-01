import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/error_mapper.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/route_export/data/dtos/route_export_dtos.dart';
import 'package:vakif_atlas/features/route_export/data/render/route_pdf_renderer.dart';
import 'package:vakif_atlas/features/route_export/data/sources/route_export_local_data_source.dart';
import 'package:vakif_atlas/features/route_export/data/sources/route_export_remote_data_source.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_document.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_export.dart';
import 'package:vakif_atlas/features/route_export/domain/repositories/route_export_repository.dart';

/// PDF cihazda üretilir; arşiv sunucudadır (media servisi, `route-exports`;
/// oturum açıksa hesabın, değilse kurulumun). Cihazdaki uygulamaya özel depo, açılan/kaydedilen
/// dosyaların önbelleğidir: liste sunucudan gelir ve önbellek ona göre
/// budanır, bağlantı yokken önbellekteki kayıtlar gösterilir.
///
/// Sahip kimliği yerel depoda doğrudan kullanılmaz: SHA-256 özeti klasör
/// ve anahtar olarak kullanılır (dosya yolları ve olası loglar kişisel
/// veri içermez). Sunucu istekleri oturumun Bearer anahtarıyla, misafirde
/// kurulum kimliğiyle gider.
@LazySingleton(as: RouteExportRepository)
class RouteExportRepositoryImpl implements RouteExportRepository {
  RouteExportRepositoryImpl(this._renderer, this._remote, this._local);

  final RoutePdfRenderer _renderer;
  final RouteExportRemoteDataSource _remote;
  final RouteExportLocalDataSource _local;

  /// Uygulama ömrü boyunca yaşar (lazySingleton); kapatılmaz.
  final StreamController<String?> _changes = StreamController.broadcast();

  /// Misafir önbelleğinin sahibi; sunucu kullanıcı kimlikleriyle çakışmaz.
  static const String _guestOwner = ':guest';

  static String ownerKey(String? ownerId) =>
      sha256.convert(utf8.encode(ownerId ?? _guestOwner)).toString();

  @override
  Stream<String?> get changes => _changes.stream;

  @override
  ResultFuture<RouteExportFile> createExport({
    required RouteDocument document,
    String? ownerId,
  }) async {
    final Uint8List bytes;
    try {
      bytes = await _renderer.render(document);
    } on Exception {
      return const Left(UnexpectedFailure());
    }
    final RouteExportRecordDto record;
    try {
      record = await _remote.upload(
        RouteExportUploadRequestDto(
          routeId: document.routeId,
          routeName: document.title,
          fileName: document.fileName,
          byteSize: bytes.length,
          stopCount: document.stops.length,
          sha256: sha256.convert(bytes).toString(),
        ),
        bytes,
      );
    } on Exception catch (error) {
      return Right(
        RouteExportFile(
          bytes: bytes,
          fileName: document.fileName,
          archiveFailure: ErrorMapper.toFailure(error),
        ),
      );
    }
    await _cache(ownerKey(ownerId), record, bytes);
    _changes.add(ownerId);
    return Right(
      RouteExportFile(
        bytes: bytes,
        fileName: document.fileName,
        saved: record.toDomain(),
      ),
    );
  }

  @override
  ResultFuture<List<RouteExport>> getExports(String? ownerId) async {
    final key = ownerKey(ownerId);
    try {
      // Sunucu sahip başına en çok [RouteExportRules.maxPerOwner] kayıt
      // tutar; tek sayfa yeterlidir.
      final page = await _remote.fetchExports(
        limit: RouteExportRules.maxPerOwner,
      );
      await _prune(key, {for (final record in page.items) record.id});
      return Right([
        for (final record in _newestFirst(page.items)) record.toDomain(),
      ]);
    } on Exception catch (error) {
      final failure = ErrorMapper.toFailure(error);
      if (failure is! NetworkFailure) {
        return Left(failure);
      }
      // Çevrimdışı: bu cihazda önbellekteki kayıtlar.
      try {
        return Right([
          for (final record in _newestFirst(await _local.readIndex(key)))
            record.toDomain(),
        ]);
      } on CacheException {
        return const Left(NetworkFailure());
      }
    }
  }

  @override
  ResultFuture<RouteExportFile> openExport({
    required String? ownerId,
    required String exportId,
  }) async {
    final key = ownerKey(ownerId);
    try {
      final cached = await _cachedFile(key, exportId);
      if (cached != null) {
        return Right(cached);
      }
      final page = await _remote.fetchExports(
        limit: RouteExportRules.maxPerOwner,
      );
      final record = page.items.where((r) => r.id == exportId).firstOrNull;
      if (record == null) {
        return await _notFound(ownerId, key, exportId);
      }
      final bytes = await _remote.download(exportId);
      await _cache(key, record, bytes);
      return Right(
        RouteExportFile(
          bytes: bytes,
          fileName: record.fileName,
          saved: record.toDomain(),
        ),
      );
    } on Exception catch (error) {
      final failure = ErrorMapper.toFailure(error);
      if (failure case ServerFailure(kind: ServerFailureKind.notFound)) {
        return _notFound(ownerId, key, exportId);
      }
      return Left(failure);
    }
  }

  @override
  ResultFuture<RouteExportLink> createShareLink({
    required String? ownerId,
    required String exportId,
  }) async {
    try {
      return Right((await _remote.createShareLink(exportId)).toLink());
    } on Exception catch (error) {
      final failure = ErrorMapper.toFailure(error);
      if (failure case ServerFailure(kind: ServerFailureKind.notFound)) {
        await _notFound(ownerId, ownerKey(ownerId), exportId);
      }
      return Left(failure);
    }
  }

  @override
  ResultFuture<Unit> deleteExport({
    required String? ownerId,
    required String exportId,
  }) async {
    try {
      await _remote.delete(exportId);
    } on Exception catch (error) {
      final failure = ErrorMapper.toFailure(error);
      // Sunucuda zaten yoksa yerel önbellek de temizlenir.
      if (failure is! ServerFailure ||
          failure.kind != ServerFailureKind.notFound) {
        return Left(failure);
      }
    }
    try {
      await _local.delete(ownerKey(ownerId), exportId);
    } on CacheException {
      // Önbellek temizliği başarısız olsa da kayıt sunucudan silindi.
    }
    _changes.add(ownerId);
    return const Right(unit);
  }

  /// Hesap silindiğinde sunucudaki arşivi media servisi siler
  /// (`AccountDeleted`); burada cihazdaki önbellek temizlenir.
  @override
  ResultFuture<Unit> deleteAllForOwner(String? ownerId) async {
    try {
      await _local.deleteOwner(ownerKey(ownerId));
    } on CacheException {
      return const Left(CacheFailure());
    }
    _changes.add(ownerId);
    return const Right(unit);
  }

  Future<RouteExportFile?> _cachedFile(String key, String exportId) async {
    try {
      final record = (await _local.readIndex(key))
          .where((r) => r.id == exportId)
          .firstOrNull;
      final bytes = record == null
          ? null
          : await _local.readFile(key, exportId);
      if (record == null || bytes == null) {
        return null;
      }
      return RouteExportFile(
        bytes: bytes,
        fileName: record.fileName,
        saved: record.toDomain(),
      );
    } on Exception {
      return null;
    }
  }

  /// Önbellek en iyi çabadır (depolama dolu, dosya sistemi hatası…):
  /// yazılamazsa dosya gerektiğinde sunucudan yeniden indirilir.
  Future<void> _cache(
    String key,
    RouteExportRecordDto record,
    Uint8List bytes,
  ) async {
    try {
      await _local.save(key, record, bytes);
      final records = _newestFirst(await _local.readIndex(key));
      for (final stale in records.skip(RouteExportRules.maxPerOwner)) {
        await _local.delete(key, stale.id);
      }
    } on Exception {
      return;
    }
  }

  /// Sunucuda artık olmayan (başka cihazdan silinmiş, kotadan düşmüş)
  /// kayıtlar önbellekten kaldırılır.
  Future<void> _prune(String key, Set<String> remoteIds) async {
    try {
      for (final record in await _local.readIndex(key)) {
        if (!remoteIds.contains(record.id)) {
          await _local.delete(key, record.id);
        }
      }
    } on Exception {
      return;
    }
  }

  Future<Either<Failure, RouteExportFile>> _notFound(
    String? ownerId,
    String key,
    String exportId,
  ) async {
    try {
      await _local.delete(key, exportId);
    } on Exception {
      // Kayıt zaten yok sayılır.
    }
    _changes.add(ownerId);
    return const Left(
      ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
    );
  }

  static List<RouteExportRecordDto> _newestFirst(
    List<RouteExportRecordDto> records,
  ) => [...records]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}
