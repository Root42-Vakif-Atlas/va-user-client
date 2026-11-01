import 'dart:async';

import 'package:injectable/injectable.dart';

/// Kullanıcının katkıda bulunduğunu (rota oluşturma, anı paylaşma, hasar
/// bildirimi) duyurur. Oyunlaştırma bu akışla profilini yeniler; XP sunucuda
/// hesaplanır, istemci yalnızca "yeni katkı var" bilgisini taşır.
///
/// Katkı feature'ları ile oyunlaştırma birbirine bağımlı olmasın diye
/// çekirdektedir (`SessionEvents` deseni).
@lazySingleton
class UserActivityEvents {
  final StreamController<void> _contributions =
      StreamController<void>.broadcast();

  Stream<void> get onContribution => _contributions.stream;

  void notifyContribution() {
    if (!_contributions.isClosed) {
      _contributions.add(null);
    }
  }

  @disposeMethod
  Future<void> dispose() => _contributions.close();
}
