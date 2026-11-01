import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Saniyede bir kalan süreyi yayınlayan sayaç.
typedef CountdownTicker = Stream<int> Function(int seconds);

/// "Kodu tekrar gönder" butonunun bekleme süresi (saniye).
///
/// Sunucunun bildirdiği `resendAfter` / `retryAfter` süresiyle başlatılır;
/// durum 0 olduğunda yeniden gönderim yapılabilir.
@injectable
class ResendCooldownCubit extends Cubit<int> {
  ResendCooldownCubit() : this.withTicker(_periodicTicker);

  ResendCooldownCubit.withTicker(this._ticker) : super(0);

  final CountdownTicker _ticker;
  StreamSubscription<int>? _subscription;

  bool get isCoolingDown => state > 0;

  void start(Duration duration) {
    unawaited(_cancelTicker());
    final seconds = duration.inMilliseconds <= 0
        ? 0
        : (duration.inMilliseconds / 1000).ceil();
    emit(seconds);
    if (seconds == 0) {
      return;
    }
    // Geri sayım bittiğinde tamamlanmış abonelik bırakılır.
    _subscription = _ticker(seconds)
        .listen(emit, onDone: () => _subscription = null);
  }

  /// İptal senkron başlatılır ve referans hemen bırakılır; böylece hemen
  /// ardından `start` ile atanan yeni abonelik yanlışlıkla silinmez.
  Future<void> _cancelTicker() {
    final cancellation = _subscription?.cancel();
    _subscription = null;
    return cancellation ?? Future<void>.value();
  }

  static Stream<int> _periodicTicker(int seconds) => Stream<int>.periodic(
    const Duration(seconds: 1),
    (elapsed) => seconds - elapsed - 1,
  ).take(seconds);

  @override
  Future<void> close() async {
    await _cancelTicker();
    return super.close();
  }
}
