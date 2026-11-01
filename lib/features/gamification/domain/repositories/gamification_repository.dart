import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/gamification/domain/entities/gamification_profile.dart';

/// Oyunlaştırma servisi (oturum gerekir). İstemci XP talep edemez; profil
/// sunucuda katkı olaylarından hesaplanır.
abstract interface class GamificationRepository {
  ResultFuture<GamificationProfile> getProfile({required String languageCode});

  /// Kutlanan kazanımları görüldü olarak işaretler.
  ResultFuture<Unit> acknowledge(List<String> unlockIds);
}
