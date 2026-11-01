import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/error_mapper.dart';
import 'package:vakif_atlas/core/events/user_activity_events.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/memory_corner/data/dtos/memory_dtos.dart';
import 'package:vakif_atlas/features/memory_corner/data/sources/memory_remote_data_source.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';
import 'package:vakif_atlas/features/memory_corner/domain/repositories/memory_repository.dart';

/// Değişiklik akışı uygulama ömrü boyunca açıktır (singleton).
@LazySingleton(as: MemoryRepository)
class MemoryRepositoryImpl implements MemoryRepository {
  MemoryRepositoryImpl(this._remote, this._activity);

  final MemoryRemoteDataSource _remote;

  /// Başarılı katkı oyunlaştırmaya duyurulur.
  final UserActivityEvents _activity;
  final StreamController<MemoryChange> _changes =
      StreamController<MemoryChange>.broadcast();

  @override
  Stream<MemoryChange> get changes => _changes.stream;

  @override
  ResultFuture<MemoryPage> getMemories({
    required String monumentId,
    required int limit,
    String? cursor,
    MemoryDateRange? range,
    bool includeYears = false,
  }) => _guard(() async {
    final page = await _remote.fetchMemories(
      monumentId: monumentId,
      limit: limit,
      cursor: cursor,
      from: CalendarDateJson.format(range?.from),
      to: CalendarDateJson.format(range?.to),
      includeFacets: includeYears,
    );
    return page.toDomain();
  });

  @override
  ResultFuture<MemoryPage> getMyMemories({
    required int limit,
    String? cursor,
  }) => _guard(() async {
    final page = await _remote.fetchMyMemories(limit: limit, cursor: cursor);
    return page.toDomain();
  });

  /// Fotoğraflar sırayla yüklenir (mobil bağlantıda tek akış daha
  /// güvenilirdir); ilerleme toplam bayta göre hesaplanır. Anı ancak tüm
  /// yüklemeler bitince oluşturulur; yarıda kalan yüklemeleri sunucu süre
  /// dolunca siler.
  @override
  ResultFuture<Memory> createMemory(
    MemoryDraft draft, {
    void Function(double progress)? onProgress,
  }) => _guard(() async {
    final totalBytes = draft.photos.fold(
      0,
      (sum, photo) => sum + photo.bytes.length,
    );
    var uploadedBytes = 0;
    void report(int bytes) {
      if (onProgress != null && totalBytes > 0) {
        onProgress((bytes / totalBytes).clamp(0, 1).toDouble());
      }
    }

    final attachments = <MemoryPhotoAttachmentDto>[];
    for (final photo in draft.photos) {
      final ticket = await _remote.requestPhotoUpload(
        PhotoUploadRequestDto(
          contentType: MemoryEndpoints.photoContentType,
          byteSize: photo.bytes.length,
          width: photo.width,
          height: photo.height,
        ),
      );
      final offset = uploadedBytes;
      await _remote.uploadPhoto(
        ticket,
        photo.bytes,
        onSendProgress: (sent, _) => report(offset + sent),
      );
      uploadedBytes += photo.bytes.length;
      report(uploadedBytes);
      attachments.add(
        MemoryPhotoAttachmentDto(
          uploadId: ticket.id,
          description: photo.description.isEmpty ? null : photo.description,
        ),
      );
    }

    final created = await _remote.createMemory(
      CreateMemoryRequestDto(
        monumentId: draft.monumentId,
        text: draft.text,
        visitedOn: CalendarDateJson.format(draft.visitedOn),
        photos: attachments,
      ),
    );
    final memory = created.toDomain();
    _changes.add(MemoryCreated(memory));
    _activity.notifyContribution();
    return memory;
  });

  @override
  ResultFuture<Unit> deleteMemory(Memory memory) => _guard(() async {
    await _remote.deleteMemory(memory.id);
    _changes.add(
      MemoryRemoved(monumentId: memory.monumentId, memoryId: memory.id),
    );
    return unit;
  });

  @override
  ResultFuture<Unit> reportMemory(
    Memory memory, {
    required MemoryReportReason reason,
    String? note,
  }) => _guard(() async {
    await _remote.reportMemory(
      memory.id,
      MemoryReportRequestDto(reason: reason, note: note),
    );
    _changes.add(
      MemoryRemoved(monumentId: memory.monumentId, memoryId: memory.id),
    );
    return unit;
  });

  static ResultFuture<T> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on Exception catch (error) {
      return Left(ErrorMapper.toFailure(error));
    }
  }
}
