part of 'memory_composer_bloc.dart';

enum MemoryComposerStatus {
  loadingMonument,
  monumentFailure,
  editing,
  submitting,
  submitted,
}

@freezed
abstract class MemoryComposerState with _$MemoryComposerState {
  const factory MemoryComposerState({
    @Default('') String monumentId,
    String? monumentName,

    /// "İlçe, İl".
    String? monumentPlace,
    @Default(MemoryComposerStatus.loadingMonument) MemoryComposerStatus status,
    Failure? monumentFailure,
    @Default('') String text,
    DateTime? visitedOn,
    @Default(<PhotoDraft>[]) List<PhotoDraft> photos,

    /// Hazırlanmakta olan (küçültülen) fotoğraf sayısı.
    @Default(0) int processingPhotos,

    /// İlk gönderme denemesinden sonra alan hataları gösterilir.
    @Default(false) bool showValidation,

    /// Her gönderme denemesinde artar (geçersizse ilk hatalı alana odaklanılır).
    @Default(0) int submitAttempts,

    /// 0–1; yalnızca fotoğraf yüklenirken.
    double? uploadProgress,
    Failure? submitFailure,
    Memory? created,
    PhotoNotice? photoNotice,
    @Default(0) int photoNoticeCount,
  }) = _MemoryComposerState;

  const MemoryComposerState._();

  MemoryDraft get draft => MemoryDraft(
    monumentId: monumentId,
    text: text,
    visitedOn: visitedOn,
    photos: photos,
  );

  /// Ekranda gösterilen ilk kural ihlali (gönderme denemesinden sonra).
  MemoryDraftIssue? get issue => MemoryRules.validate(draft);

  int get remainingPhotos =>
      MemoryRules.maxPhotos - photos.length - processingPhotos;

  bool get isSubmitting => status == MemoryComposerStatus.submitting;

  /// Kapatırken onay gerektiren kaydedilmemiş içerik.
  bool get isDirty =>
      status != MemoryComposerStatus.submitted &&
      (text.trim().isNotEmpty ||
          photos.isNotEmpty ||
          processingPhotos > 0 ||
          visitedOn != null);
}
