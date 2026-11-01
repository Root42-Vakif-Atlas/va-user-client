import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';

part 'complex_members_cubit.freezed.dart';
part 'complex_members_state.dart';

/// Külliyenin tüm yapıları (`/complex/:id/monuments`): kategori çipleriyle
/// süzülen, imleçle sayfalanan liste (ekran bazlı, factory).
///
/// - İlk sayfa her yeni süzgeçte yeniden istenir; eski isteğin yanıtı nesil
///   sayacıyla yok sayılır (restartable).
/// - Sonraki sayfa isteği sürerken gelen yeni istek düşürülür (droppable).
/// - Kategori çipleri ilk süzülmemiş yanıttaki üyelerin türlerinden kurulur
///   (külliyelerde üye sayısı küçüktür; boş seçenek gösterilmez).
@injectable
class ComplexMembersCubit extends Cubit<ComplexMembersState> {
  ComplexMembersCubit(this._getMembers) : super(const ComplexMembersState());

  final GetComplexMembersUseCase _getMembers;

  int _generation = 0;

  Future<void> load({
    required String complexId,
    required String languageCode,
  }) async {
    emit(
      state.copyWith(
        complexId: complexId,
        languageCode: languageCode,
        categories: const {},
        availableCategories: const [],
      ),
    );
    await _loadFirstPage();
  }

  Future<void> toggleCategory(MonumentCategory category) async {
    final categories = {...state.categories};
    if (!categories.remove(category)) {
      categories.add(category);
    }
    emit(state.copyWith(categories: categories));
    await _loadFirstPage();
  }

  Future<void> clearCategories() async {
    if (state.categories.isEmpty) {
      return;
    }
    emit(state.copyWith(categories: const {}));
    await _loadFirstPage();
  }

  Future<void> retry() => state.items.isEmpty ? _loadFirstPage() : loadMore();

  Future<void> _loadFirstPage() async {
    final complexId = state.complexId;
    if (complexId == null) {
      return;
    }
    final generation = ++_generation;
    emit(
      state.copyWith(
        status: ComplexMembersStatus.loading,
        isLoadingMore: false,
        failure: null,
      ),
    );
    final result = await _getMembers(
      GetComplexMembersParams(
        complexId: complexId,
        languageCode: state.languageCode,
        categories: state.categories,
      ),
    );
    if (isClosed || generation != _generation) {
      return;
    }
    result.fold(
      (failure) => emit(
        state.copyWith(status: ComplexMembersStatus.failure, failure: failure),
      ),
      (page) => emit(
        state.copyWith(
          status: ComplexMembersStatus.success,
          items: page.items,
          total: page.total,
          nextCursor: page.nextCursor,
          availableCategories: state.availableCategories.isEmpty
              ? _categoriesOf(page.items)
              : state.availableCategories,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    final complexId = state.complexId;
    final cursor = state.nextCursor;
    if (complexId == null ||
        cursor == null ||
        state.isLoadingMore ||
        state.status != ComplexMembersStatus.success) {
      return;
    }
    final generation = _generation;
    emit(state.copyWith(isLoadingMore: true, failure: null));
    final result = await _getMembers(
      GetComplexMembersParams(
        complexId: complexId,
        languageCode: state.languageCode,
        categories: state.categories,
        cursor: cursor,
      ),
    );
    if (isClosed || generation != _generation) {
      return;
    }
    result.fold(
      (failure) => emit(state.copyWith(isLoadingMore: false, failure: failure)),
      (page) => emit(
        state.copyWith(
          isLoadingMore: false,
          items: [...state.items, ...page.items],
          total: page.total,
          nextCursor: page.nextCursor,
        ),
      ),
    );
  }

  /// Türler enum sırasıyla; aynı tür bir kez.
  static List<MonumentCategory> _categoriesOf(List<MonumentSummary> items) {
    final present = {for (final item in items) item.category};
    return [
      for (final category in MonumentCategory.values)
        if (present.contains(category)) category,
    ];
  }
}
