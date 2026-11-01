import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/network/session_events.dart';
import 'package:vakif_atlas/features/route_export/domain/repositories/route_export_repository.dart';

/// Hesap silindiğinde kullanıcının cihazdaki dışa aktarım önbelleğini siler
/// (KVKK md. 7: silme). Oturum kapatmada hesabın önbelleği korunur ve
/// yalnızca aynı hesapla yeniden girişte görünür.
///
/// Oturum değişince misafir önbelleği de silinir: girişte kurulumun misafir
/// kayıtları sunucuda hesaba taşınır (hesabın önbelleğine gerektiğinde
/// yeniden indirilir), çıkıştan sonra misafir görünümü sunucudan gelir.
///
/// Uygulama açılışında başlatılır (`BootstrapSequence`).
@lazySingleton
class RouteExportAccountCleanup {
  RouteExportAccountCleanup(this._sessionEvents, this._repository);

  final SessionEvents _sessionEvents;
  final RouteExportRepository _repository;
  final List<StreamSubscription<Object?>> _subscriptions = [];

  void start() {
    if (_subscriptions.isNotEmpty) {
      return;
    }
    _subscriptions
      ..add(
        _sessionEvents.onAccountDeleted.listen(
          (userId) => unawaited(_repository.deleteAllForOwner(userId)),
        ),
      )
      ..add(
        _sessionEvents.onAccountChanged.listen(
          (_) => unawaited(_repository.deleteAllForOwner(null)),
        ),
      );
  }

  @disposeMethod
  Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
  }
}
