import 'package:vakif_atlas/core/media/photo_draft.dart';
import 'package:vakif_atlas/core/utils/list_equality.dart';
import 'package:vakif_atlas/core/utils/turkish_text.dart';

/// Yeni anı (`POST memories`).
final class MemoryDraft {
  const MemoryDraft({
    required this.monumentId,
    required this.text,
    this.visitedOn,
    this.photos = const [],
  });

  final String monumentId;
  final String text;
  final DateTime? visitedOn;
  final List<PhotoDraft> photos;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryDraft &&
          other.monumentId == monumentId &&
          other.text == text &&
          other.visitedOn == visitedOn &&
          elementsEqual(other.photos, photos);

  @override
  int get hashCode =>
      Object.hash(monumentId, text, visitedOn, Object.hashAll(photos));

  @override
  String toString() =>
      'MemoryDraft(monumentId: $monumentId, photos: ${photos.length})';
}

/// Taslağın kurallara uymama nedeni.
enum MemoryDraftIssue {
  textEmpty,
  textTooLong,
  tooManyPhotos,
  photoTooLarge,
  descriptionTooLong,
  visitDateInFuture,
  visitDateTooEarly,
}

/// Anı kuralları. Sunucu da aynı kuralları uygular
/// (`docs/api-contracts.md` → Anı Köşesi).
abstract final class MemoryRules {
  static const int maxTextLength = 1000;
  static const int maxPhotos = 4;
  static const int maxPhotoDescriptionLength = 250;
  static const int maxReportNoteLength = 500;

  /// Yükleme başına üst sınır; cihazda küçültülmüş fotoğraf bunun çok
  /// altındadır.
  static const int maxPhotoBytes = 5 * 1024 * 1024;

  /// Fotoğrafın uzun kenarı cihazda bu boyuta indirilir (px).
  static const int photoMaxDimension = 1600;

  static const int earliestVisitYear = 1900;

  /// Önizleme (eser detayı) ve tam liste sayfa boyutları.
  static const int previewSize = 3;
  static const int pageSize = 20;

  /// Anılarda görünen ad: "Ayşe Nur Yılmaz" → "Ayşe Y." (soyadının yalnızca
  /// baş harfi; KVKK veri minimizasyonu). Sunucu üretir; istemci paylaşım
  /// öncesi önizlemede gösterir.
  static String publicDisplayName(String fullName) {
    final words = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.length < 2) {
      return words.isEmpty ? '' : words.single;
    }
    final initial = TurkishText.toUpperCase(
      String.fromCharCode(words.last.runes.first),
    );
    return '${words.first} $initial.';
  }

  /// İlk ihlal; taslak geçerliyse `null`. [today] yerel takvim günüdür.
  static MemoryDraftIssue? validate(MemoryDraft draft, {DateTime? today}) {
    final text = draft.text.trim();
    if (text.isEmpty) {
      return MemoryDraftIssue.textEmpty;
    }
    if (text.runes.length > maxTextLength) {
      return MemoryDraftIssue.textTooLong;
    }
    if (draft.photos.length > maxPhotos) {
      return MemoryDraftIssue.tooManyPhotos;
    }
    for (final photo in draft.photos) {
      if (photo.bytes.length > maxPhotoBytes) {
        return MemoryDraftIssue.photoTooLarge;
      }
      if (photo.description.trim().runes.length > maxPhotoDescriptionLength) {
        return MemoryDraftIssue.descriptionTooLong;
      }
    }
    final visitedOn = draft.visitedOn;
    if (visitedOn != null) {
      final now = today ?? DateTime.now();
      final lastDay = DateTime(now.year, now.month, now.day);
      final visit = DateTime(visitedOn.year, visitedOn.month, visitedOn.day);
      if (visit.isAfter(lastDay)) {
        return MemoryDraftIssue.visitDateInFuture;
      }
      if (visit.year < earliestVisitYear) {
        return MemoryDraftIssue.visitDateTooEarly;
      }
    }
    return null;
  }
}

/// Bildirme nedeni (`POST memories/{id}/reports`).
enum MemoryReportReason {
  /// Nefret söylemi, taciz veya hakaret.
  offensive,

  /// Müstehcen, şiddet içeren veya rahatsız edici içerik.
  inappropriate,

  /// Reklam veya tekrarlanan içerik.
  spam,

  /// Başkalarının kişisel bilgilerini içeriyor.
  personalInfo,

  /// Bu eserle ilgisi yok.
  unrelated,

  other,
}
