import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';

part 'monument_search_bloc.freezed.dart';
part 'monument_search_event.dart';
part 'monument_search_state.dart';

/// Tam ekran arama: metin + filtre sunucuya gönderilir, sonuçlar imleçle
/// sayfalanır (ekran bazlı, factory).
///
/// - Sorgu veya dil değişince ilk sayfa istenir (`restartable()`); geç gelen
///   eski yanıtlar nesil sayacıyla yok sayılır, böylece sonraki sayfa
///   istekleri de eski sorguya karışmaz.
/// - Sonraki sayfa `droppable()`: kaydırma sırasında art arda gelen istekler
///   tek istek olarak işlenir.
/// - Metin girişinin seyreltilmesi (debounce) sayfadadır.
@injectable
class MonumentSearchBloc
    extends Bloc<MonumentSearchEvent, MonumentSearchState> {
  MonumentSearchBloc(this._search) : super(const MonumentSearchState()) {
    on<MonumentSearchStarted>(_onStarted, transformer: restartable());
    on<MonumentSearchQueryChanged>(_onQueryChanged, transformer: restartable());
    on<MonumentSearchNextPageRequested>(
      _onNextPageRequested,
      transformer: droppable(),
    );
    on<MonumentSearchRetryRequested>(
      _onRetryRequested,
      transformer: droppable(),
    );
  }

  final SearchMonumentsUseCase _search;

  /// Her ilk sayfa isteğinde artar; farklı nesle ait yanıt uygulanmaz.
  int _generation = 0;

  Future<void> _onStarted(
    MonumentSearchStarted event,
    Emitter<MonumentSearchState> emit,
  ) => _loadFirstPage(
    emit,
    state.copyWith(languageCode: event.languageCode, query: event.query),
  );

  Future<void> _onQueryChanged(
    MonumentSearchQueryChanged event,
    Emitter<MonumentSearchState> emit,
  ) async {
    if (event.query == state.query &&
        state.status != MonumentSearchStatus.initial) {
      return;
    }
    await _loadFirstPage(emit, state.copyWith(query: event.query));
  }

  Future<void> _onRetryRequested(
    MonumentSearchRetryRequested event,
    Emitter<MonumentSearchState> emit,
  ) async {
    if (state.loadMoreFailure != null) {
      await _loadNextPage(emit);
    } else {
      await _loadFirstPage(emit, state);
    }
  }

  Future<void> _onNextPageRequested(
    MonumentSearchNextPageRequested event,
    Emitter<MonumentSearchState> emit,
  ) async {
    if (!state.hasMore ||
        state.isLoadingMore ||
        state.loadMoreFailure != null ||
        state.status != MonumentSearchStatus.success) {
      return;
    }
    await _loadNextPage(emit);
  }

  Future<void> _loadFirstPage(
    Emitter<MonumentSearchState> emit,
    MonumentSearchState next,
  ) async {
    final generation = ++_generation;
    // Önceki sonuçlar yeni sonuç gelene kadar gösterilir (titreme yok).
    emit(
      next.copyWith(
        status: MonumentSearchStatus.loading,
        failure: null,
        loadMoreFailure: null,
        isLoadingMore: false,
      ),
    );
    final result = await _search(
      SearchMonumentsParams(query: next.query, languageCode: next.languageCode),
    );
    if (generation != _generation) {
      return;
    }
    result.fold(
      (failure) => emit(
        state.copyWith(status: MonumentSearchStatus.failure, failure: failure),
      ),
      (page) => emit(
        state.copyWith(
          status: MonumentSearchStatus.success,
          items: page.items,
          total: page.total,
          nextCursor: page.nextCursor,
          places: page.places,
          facets: page.facets,
          lastPageSize: page.items.length,
        ),
      ),
    );
  }

  Future<void> _loadNextPage(Emitter<MonumentSearchState> emit) async {
    final generation = _generation;
    emit(state.copyWith(isLoadingMore: true, loadMoreFailure: null));
    final result = await _search(
      SearchMonumentsParams(
        query: state.query,
        languageCode: state.languageCode,
        cursor: state.nextCursor,
      ),
    );
    if (generation != _generation) {
      return;
    }
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoadingMore: false, loadMoreFailure: failure)),
      (page) => emit(
        state.copyWith(
          isLoadingMore: false,
          items: [...state.items, ...page.items],
          total: page.total,
          nextCursor: page.nextCursor,
          lastPageSize: page.items.length,
        ),
      ),
    );
  }
}
