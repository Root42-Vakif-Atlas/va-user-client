part of 'damage_report_wizard_bloc.dart';

/// Formun adımları (sırasıyla).
enum ReportStep { monument, category, urgency, details, location, review }

enum ReportLocationStatus { off, locating, found, failed }

enum ReportSubmitStatus { idle, submitting, submitted }

@freezed
abstract class DamageReportWizardState with _$DamageReportWizardState {
  const factory DamageReportWizardState({
    @Default('tr') String languageCode,
    @Default(ReportStep.monument) ReportStep step,
    MonumentPin? monument,

    /// Eser detayından gelinen eser çözülüyor.
    @Default(false) bool monumentLoading,
    Failure? monumentFailure,
    DamageCategory? category,
    ReportUrgency? urgency,
    @Default('') String description,
    @Default(<PhotoDraft>[]) List<PhotoDraft> photos,
    @Default(0) int processingPhotos,
    @Default(ReportLocationStatus.off) ReportLocationStatus locationStatus,
    ReportLocation? location,
    LocationIssue? locationIssue,

    /// Mevcut adım geçilmeye çalışıldı; alan hatası gösterilir.
    @Default(false) bool showStepError,

    /// Geçersiz her "İleri"de artar (duyuru + odak).
    @Default(0) int stepErrorCount,
    @Default(ReportSubmitStatus.idle) ReportSubmitStatus submitStatus,
    double? uploadProgress,
    Failure? submitFailure,
    DamageReport? submitted,
    PhotoNotice? photoNotice,
    @Default(0) int photoNoticeCount,
  }) = _DamageReportWizardState;

  const DamageReportWizardState._();

  DamageReportDraft get draft => DamageReportDraft(
    monumentId: monument?.id,
    category: category,
    urgency: urgency,
    description: description,
    photos: photos,
    location: locationStatus == ReportLocationStatus.found ? location : null,
  );

  /// Mevcut adımı geçmeyi engelleyen kural ihlali.
  DamageReportIssue? get stepIssue => switch (step) {
    ReportStep.monument =>
      monument == null ? DamageReportIssue.monumentMissing : null,
    ReportStep.category =>
      category == null ? DamageReportIssue.categoryMissing : null,
    ReportStep.urgency =>
      urgency == null ? DamageReportIssue.urgencyMissing : null,
    ReportStep.details => DamageReportRules.validateDetails(draft),
    ReportStep.location || ReportStep.review => null,
  };

  int get stepNumber => step.index + 1;

  int get stepCount => ReportStep.values.length;

  bool get isSubmitting => submitStatus == ReportSubmitStatus.submitting;

  bool get shareLocation => locationStatus != ReportLocationStatus.off;

  int get remainingPhotos =>
      DamageReportRules.maxPhotos - photos.length - processingPhotos;

  /// Paylaşılan konumun esere tahmini uzaklığı (sunucu kesin hesaplar).
  double? get estimatedDistanceMeters {
    final here = location;
    final target = monument?.location;
    if (here == null || target == null || !target.isValid) {
      return null;
    }
    return DamageReportRules.distanceMeters(
      here.latitude,
      here.longitude,
      target.latitude,
      target.longitude,
    );
  }

  /// Kapatırken onay gerektiren içerik.
  bool get isDirty =>
      submitStatus != ReportSubmitStatus.submitted &&
      (category != null ||
          urgency != null ||
          description.trim().isNotEmpty ||
          photos.isNotEmpty ||
          processingPhotos > 0);
}
