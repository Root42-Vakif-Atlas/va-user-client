part of 'damage_report_wizard_bloc.dart';

@freezed
sealed class DamageReportWizardEvent with _$DamageReportWizardEvent {
  /// [monumentId] verilirse (eser detayından gelindi) eser seçili başlar ve
  /// form ikinci adımdan açılır.
  const factory DamageReportWizardEvent.started({
    required String languageCode,
    String? monumentId,
  }) = DamageReportWizardStarted;

  const factory DamageReportWizardEvent.monumentSelected(MonumentPin monument) =
      ReportMonumentSelected;

  const factory DamageReportWizardEvent.categorySelected(
    DamageCategory category,
  ) = ReportCategorySelected;

  const factory DamageReportWizardEvent.urgencySelected(ReportUrgency urgency) =
      ReportUrgencySelected;

  const factory DamageReportWizardEvent.descriptionChanged(String text) =
      ReportDescriptionChanged;

  const factory DamageReportWizardEvent.photosRequested(PhotoSource source) =
      ReportPhotosRequested;

  const factory DamageReportWizardEvent.photoRemoved(String localId) =
      ReportPhotoRemoved;

  const factory DamageReportWizardEvent.photoDescriptionChanged({
    required String localId,
    required String description,
  }) = ReportPhotoDescriptionChanged;

  /// "Konumumu ekle" açıldığında konum bir kez okunur.
  const factory DamageReportWizardEvent.locationSharingChanged({
    required bool enabled,
  }) = ReportLocationSharingChanged;

  const factory DamageReportWizardEvent.nextRequested() = ReportNextRequested;

  const factory DamageReportWizardEvent.backRequested() = ReportBackRequested;

  /// Gözden geçirme adımındaki "Düzenle".
  const factory DamageReportWizardEvent.stepSelected(ReportStep step) =
      ReportStepSelected;

  const factory DamageReportWizardEvent.submitted() = ReportSubmitted;
}
