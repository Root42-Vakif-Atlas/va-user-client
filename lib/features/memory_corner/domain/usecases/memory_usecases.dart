import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';
import 'package:vakif_atlas/features/memory_corner/domain/repositories/memory_repository.dart';

final class GetMemoriesParams {
  const GetMemoriesParams({
    required this.monumentId,
    this.limit = MemoryRules.pageSize,
    this.cursor,
    this.range,
    this.includeYears = false,
  });

  final String monumentId;
  final int limit;
  final String? cursor;
  final MemoryDateRange? range;
  final bool includeYears;

  @override
  bool operator ==(Object other) =>
      other is GetMemoriesParams &&
      other.monumentId == monumentId &&
      other.limit == limit &&
      other.cursor == cursor &&
      other.range == range &&
      other.includeYears == includeYears;

  @override
  int get hashCode => Object.hash(
    GetMemoriesParams,
    monumentId,
    limit,
    cursor,
    range,
    includeYears,
  );
}

/// Eserin anıları, anı tarihine göre en yeni önce.
class GetMemoriesUseCase implements UseCase<MemoryPage, GetMemoriesParams> {
  const GetMemoriesUseCase(this._repository);

  final MemoryRepository _repository;

  @override
  ResultFuture<MemoryPage> call(GetMemoriesParams params) =>
      _repository.getMemories(
        monumentId: params.monumentId,
        limit: params.limit,
        cursor: params.cursor,
        range: params.range,
        includeYears: params.includeYears,
      );
}

final class GetMyMemoriesParams {
  const GetMyMemoriesParams({this.limit = MemoryRules.pageSize, this.cursor});

  final int limit;
  final String? cursor;

  @override
  bool operator ==(Object other) =>
      other is GetMyMemoriesParams &&
      other.limit == limit &&
      other.cursor == cursor;

  @override
  int get hashCode => Object.hash(GetMyMemoriesParams, limit, cursor);
}

/// Profildeki "Anılarım": kullanıcının kendi anıları, en son paylaşılan önce
/// (oturum gerekir).
class GetMyMemoriesUseCase implements UseCase<MemoryPage, GetMyMemoriesParams> {
  const GetMyMemoriesUseCase(this._repository);

  final MemoryRepository _repository;

  @override
  ResultFuture<MemoryPage> call(GetMyMemoriesParams params) =>
      _repository.getMyMemories(limit: params.limit, cursor: params.cursor);
}

final class CreateMemoryParams {
  const CreateMemoryParams({required this.draft, this.onProgress});

  final MemoryDraft draft;
  final void Function(double progress)? onProgress;
}

/// Anıyı paylaşır. Kurallara uymayan taslak sunucuya gönderilmez.
class CreateMemoryUseCase implements UseCase<Memory, CreateMemoryParams> {
  const CreateMemoryUseCase(this._repository, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final MemoryRepository _repository;
  final DateTime Function() _clock;

  @override
  ResultFuture<Memory> call(CreateMemoryParams params) async {
    if (MemoryRules.validate(params.draft, today: _clock()) != null) {
      return const Left(
        ServerFailure(kind: ServerFailureKind.invalidRequest, statusCode: 400),
      );
    }
    final draft = params.draft;
    return _repository.createMemory(
      MemoryDraft(
        monumentId: draft.monumentId,
        text: draft.text.trim(),
        visitedOn: draft.visitedOn,
        photos: [
          for (final photo in draft.photos)
            photo.withDescription(photo.description.trim()),
        ],
      ),
      onProgress: params.onProgress,
    );
  }
}

/// Kullanıcının kendi anısını siler.
class DeleteMemoryUseCase implements UseCase<Unit, Memory> {
  const DeleteMemoryUseCase(this._repository);

  final MemoryRepository _repository;

  @override
  ResultFuture<Unit> call(Memory memory) => _repository.deleteMemory(memory);
}

final class ReportMemoryParams {
  const ReportMemoryParams({
    required this.memory,
    required this.reason,
    this.note = '',
  });

  final Memory memory;
  final MemoryReportReason reason;
  final String note;
}

/// Anıyı inceleme için bildirir; anı bildiren kullanıcıya gizlenir.
class ReportMemoryUseCase implements UseCase<Unit, ReportMemoryParams> {
  const ReportMemoryUseCase(this._repository);

  final MemoryRepository _repository;

  @override
  ResultFuture<Unit> call(ReportMemoryParams params) async {
    final note = params.note.trim();
    if (note.runes.length > MemoryRules.maxReportNoteLength) {
      return const Left(
        ServerFailure(kind: ServerFailureKind.invalidRequest, statusCode: 400),
      );
    }
    return _repository.reportMemory(
      params.memory,
      reason: params.reason,
      note: note.isEmpty ? null : note,
    );
  }
}

class WatchMemoryChangesUseCase
    implements StreamUseCase<MemoryChange, NoParams> {
  const WatchMemoryChangesUseCase(this._repository);

  final MemoryRepository _repository;

  @override
  Stream<MemoryChange> call(NoParams params) => _repository.changes;
}
