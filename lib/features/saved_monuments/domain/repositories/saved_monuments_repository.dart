import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/entities/saved_monument.dart';

/// Cihaza (kuruluma) bağlı kaydedilen eserler: giriş gerekmez, sunucuyla
/// eşitlenir, çevrimdışı da çalışır.
abstract interface class SavedMonumentsRepository {
  /// En son kaydedilen önce.
  ResultFuture<List<SavedMonument>> getSaved();

  /// Eseri ekler; kayıtlıysa dokunmaz, sınır doluysa eklemez. Denetim ve
  /// yazım tek adımdır (eşzamanlı iki kaydetme sınırı aşamaz).
  ResultFuture<SaveMonumentOutcome> save(SavedMonument monument);

  /// Kayıtlı değilse değişiklik yapmaz.
  ResultFuture<Unit> remove(String monumentId);

  /// Her başarılı değişiklikten sonra güncel liste (en yeni önce).
  Stream<List<SavedMonument>> get changes;
}
