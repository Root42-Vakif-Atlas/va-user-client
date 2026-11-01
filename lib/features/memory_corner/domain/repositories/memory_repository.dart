import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';

/// Başarılı bir işlemin ardından açık listelerin kendini güncellemesi için
/// yayınlanan değişiklik.
sealed class MemoryChange {
  const MemoryChange(this.monumentId);

  final String monumentId;
}

final class MemoryCreated extends MemoryChange {
  MemoryCreated(this.memory) : super(memory.monumentId);

  final Memory memory;
}

/// Anı silindi ya da kullanıcı bildirdiği için kendisine gizlendi.
final class MemoryRemoved extends MemoryChange {
  const MemoryRemoved({required String monumentId, required this.memoryId})
    : super(monumentId);

  final String memoryId;
}

/// Eserlerin Anı Köşesi (Memory mikro servisi).
///
/// Okuma herkese açıktır; paylaşma, silme ve bildirme oturum gerektirir
/// (sunucu 401 döner).
abstract interface class MemoryRepository {
  Stream<MemoryChange> get changes;

  /// [range] anı tarihine göre filtreler; [includeYears] yıl sayılarını
  /// (filtreden bağımsız) da ister.
  ResultFuture<MemoryPage> getMemories({
    required String monumentId,
    required int limit,
    String? cursor,
    MemoryDateRange? range,
    bool includeYears = false,
  });

  /// Oturum açık kullanıcının kendi anıları, en son paylaşılan önce.
  /// Bildirimle başkalarına gizlenmiş veya incelemedeki anılar da gelir.
  ResultFuture<MemoryPage> getMyMemories({required int limit, String? cursor});

  /// Fotoğrafları yükler ve anıyı yayınlar. [onProgress] yükleme ilerlemesini
  /// 0–1 arasında bildirir.
  ResultFuture<Memory> createMemory(
    MemoryDraft draft, {
    void Function(double progress)? onProgress,
  });

  ResultFuture<Unit> deleteMemory(Memory memory);

  ResultFuture<Unit> reportMemory(
    Memory memory, {
    required MemoryReportReason reason,
    String? note,
  });
}
