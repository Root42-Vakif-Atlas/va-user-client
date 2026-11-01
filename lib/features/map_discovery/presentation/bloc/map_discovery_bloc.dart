import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';

part 'map_discovery_bloc.freezed.dart';
part 'map_discovery_event.dart';
part 'map_discovery_state.dart';

/// Harita Keşfi ekranının durumu. Ekran bazlıdır (factory).
///
/// - Pinler ve kümeler sunucudan karo karo gelir (`MonumentTilesCubit`);
///   bu BLoC uygulanan sorgunun kapsamını (`GET catalog/map/extent`: toplam,
///   sınır, katalog sürümü) ve seçimi yönetir.
/// - Seçilen eserin önizlemesi detaydan gelir (`GET catalog/monuments/{id}`,
///   önbellekli). Eser bulunamazsa seçim kaldırılır ve hata yayınlanır.
/// - Yükleme, seçim ve daraltma `restartable()`: dil değişince ya da yeni
///   seçimde eski istek sonucu uygulanmaz.
@injectable
class MapDiscoveryBloc extends Bloc<MapDiscoveryEvent, MapDiscoveryState> {
  MapDiscoveryBloc(this._getExtent, this._getDetail, this._search)
    : super(const MapDiscoveryState()) {
    on<MapDiscoveryLoadRequested>(_onLoadRequested, transformer: restartable());
    on<MapDiscoveryMonumentSelected>(
      _onMonumentSelected,
      transformer: restartable(),
    );
    on<MapDiscoverySelectionCleared>(_onSelectionCleared);
    on<MapDiscoverySelectionRetryRequested>(
      _onSelectionRetryRequested,
      transformer: restartable(),
    );
    on<MapDiscoveryRefinementApplied>(
      _onRefinementApplied,
      transformer: restartable(),
    );
    on<MapDiscoveryRefinementsCleared>(
      (event, emit) => _onRefinementApplied(
        const MapDiscoveryRefinementApplied(MonumentSearchQuery.empty),
        emit,
      ),
      transformer: restartable(),
    );
    on<MapDiscoveryClusterOpened>(_onClusterOpened, transformer: restartable());
  }

  final GetMapExtentUseCase _getExtent;
  final GetMonumentDetailUseCase _getDetail;
  final SearchMonumentsUseCase _search;

  /// İçerik dili (il adları ve önizleme bu dilde).
  String _languageCode = 'tr';

  /// Aynı konum listesinin en çok kaydı (aynı yapıdaki eserler bunu aşmaz).
  static const int clusterListLimit = SearchMonumentsParams.maxPageSize;

  Future<void> _onLoadRequested(
    MapDiscoveryLoadRequested event,
    Emitter<MapDiscoveryState> emit,
  ) async {
    final languageChanged = event.languageCode != _languageCode;
    _languageCode = event.languageCode;
    emit(state.copyWith(status: MapDiscoveryStatus.loading, failure: null));
    final result = await _getExtent(
      GetMapExtentParams(query: state.query, languageCode: _languageCode),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: MapDiscoveryStatus.failure, failure: failure),
      ),
      (extent) => emit(
        state.copyWith(status: MapDiscoveryStatus.success, extent: extent),
      ),
    );
    final selectedId = state.selectedId;
    if (languageChanged && selectedId != null && state.selection != null) {
      // Önizleme yeni dilde yeniden istenir (eski dildeki kayıt atılır).
      emit(state.copyWith(selection: null));
      add(MapDiscoveryEvent.monumentSelected(selectedId));
    }
  }

  Future<void> _onMonumentSelected(
    MapDiscoveryMonumentSelected event,
    Emitter<MapDiscoveryState> emit,
  ) async {
    final id = event.id;
    final reuse = state.selection?.id == id;
    emit(
      state.copyWith(
        selectedId: id,
        selectedPin:
            event.pin ?? (state.selectedId == id ? state.selectedPin : null),
        selection: reuse ? state.selection : null,
        selectionStatus: reuse
            ? SelectionStatus.success
            : SelectionStatus.loading,
        selectionFailure: null,
      ),
    );
    if (!reuse) {
      await _loadSelection(id, emit);
    }
  }

  Future<void> _onSelectionRetryRequested(
    MapDiscoverySelectionRetryRequested event,
    Emitter<MapDiscoveryState> emit,
  ) async {
    final id = state.selectedId;
    if (id == null) {
      return;
    }
    emit(
      state.copyWith(
        selectionStatus: SelectionStatus.loading,
        selectionFailure: null,
      ),
    );
    await _loadSelection(id, emit);
  }

  Future<void> _loadSelection(
    String id,
    Emitter<MapDiscoveryState> emit,
  ) async {
    final result = await _getDetail(
      GetMonumentDetailParams(id: id, languageCode: _languageCode),
    );
    if (state.selectedId != id) {
      return;
    }
    result.fold(
      (failure) {
        final notFound =
            failure is ServerFailure &&
            failure.kind == ServerFailureKind.notFound;
        emit(
          notFound
              ? _withoutSelection(state).copyWith(selectionFailure: failure)
              : state.copyWith(
                  selectionStatus: SelectionStatus.failure,
                  selectionFailure: failure,
                ),
        );
      },
      (detail) => emit(
        state.copyWith(
          selection: detail,
          selectionStatus: SelectionStatus.success,
        ),
      ),
    );
  }

  void _onSelectionCleared(
    MapDiscoverySelectionCleared event,
    Emitter<MapDiscoveryState> emit,
  ) {
    emit(_withoutSelection(state));
  }

  Future<void> _onRefinementApplied(
    MapDiscoveryRefinementApplied event,
    Emitter<MapDiscoveryState> emit,
  ) async {
    final query = event.query;
    emit(state.copyWith(isRefining: true, refinementFailure: null));
    final result = await _getExtent(
      GetMapExtentParams(query: query, languageCode: _languageCode),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(isRefining: false, refinementFailure: failure)),
      (extent) => emit(
        state.copyWith(
          query: query,
          extent: extent,
          isRefining: false,
          status: MapDiscoveryStatus.success,
        ),
      ),
    );
  }

  Future<void> _onClusterOpened(
    MapDiscoveryClusterOpened event,
    Emitter<MapDiscoveryState> emit,
  ) async {
    emit(
      state.copyWith(
        clusterStatus: SelectionStatus.loading,
        clusterMonuments: const [],
      ),
    );
    final result = await _search(
      SearchMonumentsParams(
        query: state.query,
        languageCode: _languageCode,
        limit: clusterListLimit,
        bounds: event.bounds,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(clusterStatus: SelectionStatus.failure)),
      (page) => emit(
        state.copyWith(
          clusterStatus: SelectionStatus.success,
          clusterMonuments: [
            for (final monument in page.items)
              MonumentPin.fromSummary(monument),
          ],
        ),
      ),
    );
  }

  static MapDiscoveryState _withoutSelection(MapDiscoveryState state) =>
      state.copyWith(
        selectedId: null,
        selectedPin: null,
        selection: null,
        selectionStatus: SelectionStatus.none,
        selectionFailure: null,
      );
}
