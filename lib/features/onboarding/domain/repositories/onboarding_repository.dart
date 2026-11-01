import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';

abstract interface class OnboardingRepository {
  /// Geçerli tanıtım sürümü bu cihazda tamamlandıysa `true`. Açılışta
  /// yüklenmiş tercihlerden senkron okunur.
  bool get isCompleted;

  /// Geçerli tanıtım sürümünü tamamlandı olarak kaydeder.
  ResultFuture<Unit> markCompleted();
}
