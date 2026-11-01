part of 'memory_composer_bloc.dart';

@freezed
sealed class MemoryComposerEvent with _$MemoryComposerEvent {
  /// Eser bilgisi (başlıktaki ad / il) arayüz dilinde yüklenir.
  const factory MemoryComposerEvent.started({
    required String monumentId,
    required String languageCode,
  }) = MemoryComposerStarted;

  const factory MemoryComposerEvent.textChanged(String text) =
      MemoryTextChanged;

  const factory MemoryComposerEvent.visitDateChanged(DateTime? date) =
      MemoryVisitDateChanged;

  const factory MemoryComposerEvent.photosRequested(PhotoSource source) =
      MemoryPhotosRequested;

  const factory MemoryComposerEvent.photoRemoved(String localId) =
      MemoryPhotoRemoved;

  const factory MemoryComposerEvent.photoDescriptionChanged({
    required String localId,
    required String description,
  }) = MemoryPhotoDescriptionChanged;

  const factory MemoryComposerEvent.submitted() = MemorySubmitted;
}
