import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/media/photo_attacher.dart';
import 'package:vakif_atlas/core/media/photo_draft.dart';
import 'package:vakif_atlas/core/media/photo_picker_service.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';
import 'package:vakif_atlas/features/memory_corner/domain/usecases/memory_usecases.dart';

part 'memory_composer_bloc.freezed.dart';
part 'memory_composer_event.dart';
part 'memory_composer_state.dart';

/// Anı paylaşma ekranı (ekran bazlı, factory).
///
/// - Fotoğraflar seçilir seçilmez cihazda küçültülür ve meta verisi silinir;
///   taslakta yalnızca paylaşıma hazır baytlar tutulur.
/// - Gönderme `droppable()`: çift dokunuş tek paylaşım üretir.
/// - Yükleme ilerlemesi en az %2 adımlarla yayınlanır (gereksiz yeniden
///   çizim ve ekran okuyucu gürültüsü olmasın).
@injectable
class MemoryComposerBloc
    extends Bloc<MemoryComposerEvent, MemoryComposerState> {
  MemoryComposerBloc(this._getMonument, this._createMemory, this._photos)
    : super(const MemoryComposerState()) {
    on<MemoryComposerStarted>(_onStarted, transformer: restartable());
    on<MemoryTextChanged>(_onTextChanged);
    on<MemoryVisitDateChanged>(_onVisitDateChanged);
    on<MemoryPhotosRequested>(_onPhotosRequested, transformer: droppable());
    on<MemoryPhotoRemoved>(_onPhotoRemoved);
    on<MemoryPhotoDescriptionChanged>(_onDescriptionChanged);
    on<MemorySubmitted>(_onSubmitted, transformer: droppable());
  }

  final GetMonumentDetailUseCase _getMonument;
  final CreateMemoryUseCase _createMemory;
  final PhotoAttacher _photos;

  static const double _progressStep = 0.02;

  bool get supportsCamera => _photos.supportsCamera;

  /// İzin reddedildiğinde uygulama ayarlarını açar.
  bool get canOpenAppSettings => _photos.canOpenAppSettings;

  Future<void> openAppSettings() => _photos.openAppSettings();

  Future<void> _onStarted(
    MemoryComposerStarted event,
    Emitter<MemoryComposerState> emit,
  ) async {
    final editing =
        state.status != MemoryComposerStatus.loadingMonument &&
        state.monumentId == event.monumentId &&
        state.monumentName != null;
    // Dil değişiminde taslak korunur, yalnızca başlık yeniden yüklenir.
    if (!editing) {
      emit(
        state.copyWith(
          monumentId: event.monumentId,
          status: MemoryComposerStatus.loadingMonument,
          monumentFailure: null,
        ),
      );
    }
    final result = await _getMonument(
      GetMonumentDetailParams(
        id: event.monumentId,
        languageCode: event.languageCode,
      ),
    );
    result.fold(
      (failure) {
        if (!editing) {
          emit(
            state.copyWith(
              status: MemoryComposerStatus.monumentFailure,
              monumentFailure: failure,
            ),
          );
        }
      },
      (monument) => emit(
        state.copyWith(
          monumentName: monument.name,
          monumentPlace: '${monument.district}, ${monument.city}',
          status: editing ? state.status : MemoryComposerStatus.editing,
        ),
      ),
    );
  }

  void _onTextChanged(
    MemoryTextChanged event,
    Emitter<MemoryComposerState> emit,
  ) => emit(state.copyWith(text: event.text, submitFailure: null));

  void _onVisitDateChanged(
    MemoryVisitDateChanged event,
    Emitter<MemoryComposerState> emit,
  ) => emit(state.copyWith(visitedOn: event.date, submitFailure: null));

  Future<void> _onPhotosRequested(
    MemoryPhotosRequested event,
    Emitter<MemoryComposerState> emit,
  ) async {
    if (state.isSubmitting) {
      return;
    }
    final notice = await _photos.attach(
      event.source,
      remaining: state.remainingPhotos,
      maxBytes: MemoryRules.maxPhotoBytes,
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
      _photoNotice(emit, notice);
    }
  }

  void _onPhotoRemoved(
    MemoryPhotoRemoved event,
    Emitter<MemoryComposerState> emit,
  ) => emit(
    state.copyWith(
      photos: [
        for (final photo in state.photos)
          if (photo.localId != event.localId) photo,
      ],
    ),
  );

  void _onDescriptionChanged(
    MemoryPhotoDescriptionChanged event,
    Emitter<MemoryComposerState> emit,
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

  Future<void> _onSubmitted(
    MemorySubmitted event,
    Emitter<MemoryComposerState> emit,
  ) async {
    if (state.status != MemoryComposerStatus.editing ||
        state.processingPhotos > 0) {
      return;
    }
    if (state.issue != null) {
      emit(
        state.copyWith(
          showValidation: true,
          submitAttempts: state.submitAttempts + 1,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: MemoryComposerStatus.submitting,
        showValidation: true,
        submitAttempts: state.submitAttempts + 1,
        submitFailure: null,
        uploadProgress: state.photos.isEmpty ? null : 0,
      ),
    );
    var published = 0.0;
    final result = await _createMemory(
      CreateMemoryParams(
        draft: state.draft,
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
          status: MemoryComposerStatus.editing,
          submitFailure: failure,
          uploadProgress: null,
        ),
      ),
      (memory) => emit(
        state.copyWith(
          status: MemoryComposerStatus.submitted,
          created: memory,
          uploadProgress: null,
        ),
      ),
    );
  }

  void _photoNotice(Emitter<MemoryComposerState> emit, PhotoNotice notice) =>
      emit(
        state.copyWith(
          photoNotice: notice,
          photoNoticeCount: state.photoNoticeCount + 1,
        ),
      );
}
