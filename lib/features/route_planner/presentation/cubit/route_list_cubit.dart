import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/features/route_planner/domain/usecases/route_usecases.dart';

part 'route_list_cubit.freezed.dart';

enum RouteListStatus { initial, loading, success, failure }

@freezed
abstract class RouteListState with _$RouteListState {
  const factory RouteListState({
    @Default(RouteListStatus.initial) RouteListStatus status,

    /// Son başarılı yüklemenin rotaları; yenileme sırasında da gösterilir.
    @Default(<RouteOverview>[]) List<RouteOverview> routes,
    Failure? failure,
  }) = _RouteListState;
}

/// "Rotalarım" listesi. Oluşturma, güncelleme veya silme olduğunda kendini
/// yeniler. Ekran bazlıdır (factory).
@injectable
class RouteListCubit extends Cubit<RouteListState> {
  RouteListCubit(this._getRoutes, WatchRouteChangesUseCase watchChanges)
    : super(const RouteListState()) {
    _changes = watchChanges(const NoParams())
        .listen((_) => unawaited(refresh()));
  }

  final GetRoutesUseCase _getRoutes;
  late final StreamSubscription<RouteChange> _changes;
  String? _languageCode;

  /// Üst üste yüklemelerde (hesap değişimi + oluşturma) eski yanıt yenisinin
  /// üzerine yazmasın diye her yükleme bir nesil alır.
  int _request = 0;

  Future<void> load(String languageCode) async {
    _languageCode = languageCode;
    final request = ++_request;
    emit(state.copyWith(status: RouteListStatus.loading, failure: null));
    final result = await _getRoutes(
      GetRoutesParams(languageCode: languageCode),
    );
    if (isClosed || request != _request) {
      return;
    }
    emit(
      result.fold(
        (failure) =>
            state.copyWith(status: RouteListStatus.failure, failure: failure),
        (routes) =>
            state.copyWith(status: RouteListStatus.success, routes: routes),
      ),
    );
  }

  Future<void> refresh() async {
    final languageCode = _languageCode;
    if (languageCode != null && !isClosed) {
      await load(languageCode);
    }
  }

  @override
  Future<void> close() async {
    await _changes.cancel();
    return super.close();
  }
}
