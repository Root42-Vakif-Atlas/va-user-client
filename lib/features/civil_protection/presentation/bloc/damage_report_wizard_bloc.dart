import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/location/location_service.dart';
import 'package:vakif_atlas/core/media/photo_attacher.dart';
import 'package:vakif_atlas/core/media/photo_draft.dart';
import 'package:vakif_atlas/core/media/photo_picker_service.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report_draft.dart';
import 'package:vakif_atlas/features/civil_protection/domain/usecases/damage_report_usecases.dart';

part 'damage_report_wizard_bloc.freezed.dart';
part 'damage_report_wizard_event.dart';
part 'damage_report_wizard_state.dart';

/// Adım adım Sivil Koruma bildirimi (ekran bazlı, factory):
/// eser → hasar türü → aciliyet → açıklama ve fotoğraf → konum → gözden
/// geçir.
///
/// - Adım, kuralları sağlanmadan geçilmez; hata alan altında gösterilir ve
///   duyurulur (WCAG 3.3.1).
/// - Konum yalnızca kullanıcı "Konumumu ekle"yi açınca, bir kez okunur
///   (bağlamsal izin); kapatılırsa rapordan çıkarılır.
/// - Gönderim `droppable()`: çift dokunuş tek rapor üretir.
@injectable
class DamageReportWizardBloc
    extends Bloc<DamageReportWizardEvent, DamageReportWizardState> {
  DamageReportWizardBloc(
    this._getMonuments,
    this._submit,
    this._photos,
    this._location,
  ) : super(const DamageReportWizardState()) {
    on<DamageReportWizardStarted>(_onStarted, transformer: restartable());
    on<ReportMonumentSelected>(_onMonumentSelected);
    on<ReportCategorySelected>(
      (event, emit) =>
          emit(state.copyWith(category: event.category, showStepError: false)),
    );
    on<ReportUrgencySelected>(
      (event, emit) =>
          emit(state.copyWith(urgency: event.urgency, showStepError: false)),
    );
    on<ReportDescriptionChanged>(
      (event, emit) => emit(state.copyWith(description: event.text)),
    );
    on<ReportPhotosRequested>(_onPhotosRequested, transformer: droppable());
    on<ReportPhotoRemoved>(_onPhotoRemoved);
    on<ReportPhotoDescriptionChanged>(_onPhotoDescriptionChanged);
    on<ReportLocationSharingChanged>(
      _onLocationSharingChanged,
      transformer: restartable(),
    );
    on<ReportNextRequested>(_onNext);
    on<ReportBackRequested>(_onBack);
    on<ReportStepSelected>(
      (event, emit) =>
          emit(state.copyWith(step: event.step, showStepError: false)),
    );
    on<ReportSubmitted>(_onSubmitted, transformer: droppable());
  }

  final GetMonumentPinsUseCase _getMonuments;
  final SubmitDamageReportUseCase _submit;
  final PhotoAttacher _photos;
  final LocationService _location;

  static const double _progressStep = 0.02;

  bool get supportsCamera => _photos.supportsCamera;

  bool get supportsLocation => _location.isSupported;

  bool get canOpenPhotoSettings => _photos.canOpenAppSettings;

  Future<void> openPhotoSettings() => _photos.openAppSettings();

  bool canOpenLocationSettings(LocationIssue issue) =>
      _location.canOpenSettings(issue);

  Future<void> openLocationSettings(LocationIssue issue) =>
      _location.openSettings(issue);

  Future<void> _onStarted(
    DamageReportWizardStarted event,
    Emitter<DamageReportWizardState> emit,
  ) async {
    final monumentId = event.monumentId ?? state.monument?.id;
    emit(state.copyWith(languageCode: event.languageCode));
    if (monumentId == null) {
      return;
    }
    final first = state.monument == null;
    emit(state.copyWith(monumentLoading: true, monumentFailure: null));
    final result = await _getMonuments(
      GetMonumentPinsParams(
        ids: [monumentId],
        languageCode: event.languageCode,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(monumentLoading: false, monumentFailure: failure),
      ),
      (pins) {
        final pin = pins.where((p) => p.id == monumentId).firstOrNull;
        emit(
          state.copyWith(
            monumentLoading: false,
            monument: pin ?? state.monument,
            monumentFailure: pin == null
                ? const ServerFailure(
                    kind: ServerFailureKind.notFound,
                    statusCode: 404,
                  )
                : null,
            // Eser detayından gelindiyse doğrudan hasar türüne geçilir.
            step: first && pin != null && state.step == ReportStep.monument
                ? ReportStep.category
                : state.step,
          ),
        );
      },
    );
  }

  void _onMonumentSelected(
    ReportMonumentSelected event,
    Emitter<DamageReportWizardState> emit,
  ) => emit(
    state.copyWith(
      monument: event.monument,
      monumentFailure: null,
      showStepError: false,
    ),
  );

  Future<void> _onPhotosRequested(
    ReportPhotosRequested event,
    Emitter<DamageReportWizardState> emit,
  ) async {
    if (state.isSubmitting) {
      return;
    }
    final notice = await _photos.attach(
      event.source,
      remaining: state.remainingPhotos,
      maxBytes: DamageReportRules.maxPhotoBytes,
      onProcessing: (count) => emit(
        state.copyWith(processingPhotos: state.processingPhotos + count),
      ),
      onProcessed: (photo) => emit(
        state.copyWith(
          processingPhotos: state.processingPhotos - 1,
          photos: [...state.photos, ?photo],
        ),
      ),
    );
    if (notice != null) {
      emit(
        state.copyWith(
          photoNotice: notice,
          photoNoticeCount: state.photoNoticeCount + 1,
        ),
      );
    }
  }

  void _onPhotoRemoved(
    ReportPhotoRemoved event,
    Emitter<DamageReportWizardState> emit,
  ) => emit(
    state.copyWith(
      photos: [
        for (final photo in state.photos)
          if (photo.localId != event.localId) photo,
      ],
    ),
  );

  void _onPhotoDescriptionChanged(
    ReportPhotoDescriptionChanged event,
    Emitter<DamageReportWizardState> emit,
  ) => emit(
    state.copyWith(
      photos: [
        for (final photo in state.photos)
          photo.localId == event.localId
              ? photo.withDescription(event.description)
              : photo,
      ],
    ),
  );

  Future<void> _onLocationSharingChanged(
    ReportLocationSharingChanged event,
    Emitter<DamageReportWizardState> emit,
  ) async {
    if (!event.enabled) {
      emit(
        state.copyWith(
          locationStatus: ReportLocationStatus.off,
          location: null,
          locationIssue: null,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        locationStatus: ReportLocationStatus.locating,
        locationIssue: null,
      ),
    );
    final result = await _location.currentPosition();
    switch (result) {
      case LocationFound(:final position):
        emit(
          state.copyWith(
            locationStatus: ReportLocationStatus.found,
            location: ReportLocation(
              latitude: position.latitude,
              longitude: position.longitude,
              accuracyMeters: position.accuracyMeters,
            ),
          ),
        );
      case LocationFailed(:final issue):
        emit(
          state.copyWith(
            locationStatus: ReportLocationStatus.failed,
            location: null,
            locationIssue: issue,
          ),
        );
    }
  }

  void _onNext(
    ReportNextRequested event,
    Emitter<DamageReportWizardState> emit,
  ) {
    if (state.step == ReportStep.review) {
      return;
    }
    if (state.stepIssue != null || state.processingPhotos > 0) {
      emit(
        state.copyWith(
          showStepError: true,
          stepErrorCount: state.stepErrorCount + 1,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        step: ReportStep.values[state.step.index + 1],
        showStepError: false,
      ),
    );
  }

  void _onBack(
    ReportBackRequested event,
    Emitter<DamageReportWizardState> emit,
  ) {
    if (state.step == ReportStep.monument || state.isSubmitting) {
      return;
    }
    emit(
      state.copyWith(
        step: ReportStep.values[state.step.index - 1],
        showStepError: false,
      ),
    );
  }

  Future<void> _onSubmitted(
    ReportSubmitted event,
    Emitter<DamageReportWizardState> emit,
  ) async {
    if (state.step != ReportStep.review ||
        state.submitStatus != ReportSubmitStatus.idle) {
      return;
    }
    final draft = state.draft;
    final issue = DamageReportRules.validate(draft);
    if (issue != null) {
      // Eksik adıma dönülür.
      emit(
        state.copyWith(
          step: _stepOf(issue),
          showStepError: true,
          stepErrorCount: state.stepErrorCount + 1,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        submitStatus: ReportSubmitStatus.submitting,
        submitFailure: null,
        uploadProgress: state.photos.isEmpty ? null : 0,
      ),
    );
    var published = 0.0;
    final result = await _submit(
      SubmitDamageReportParams(
        draft: draft,
        languageCode: state.languageCode,
        onProgress: (progress) {
          if (isClosed ||
              (progress - published < _progressStep && progress < 1)) {
            return;
          }
          published = progress;
          emit(state.copyWith(uploadProgress: progress));
        },
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          submitStatus: ReportSubmitStatus.idle,
          submitFailure: failure,
          uploadProgress: null,
        ),
      ),
      (report) => emit(
        state.copyWith(
          submitStatus: ReportSubmitStatus.submitted,
          submitted: report,
          uploadProgress: null,
        ),
      ),
    );
  }

  static ReportStep _stepOf(DamageReportIssue issue) => switch (issue) {
    DamageReportIssue.monumentMissing => ReportStep.monument,
    DamageReportIssue.categoryMissing => ReportStep.category,
    DamageReportIssue.urgencyMissing => ReportStep.urgency,
    DamageReportIssue.descriptionTooShort ||
    DamageReportIssue.descriptionTooLong ||
    DamageReportIssue.tooManyPhotos ||
    DamageReportIssue.photoTooLarge ||
    DamageReportIssue.photoDescriptionTooLong => ReportStep.details,
  };
}
