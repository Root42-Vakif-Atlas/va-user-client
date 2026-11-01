import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/storage/preferences_service.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/onboarding/domain/repositories/onboarding_repository.dart';

@LazySingleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._preferences);

  /// Tanıtımın içeriği (adımlar, istenen izinler) önemli ölçüde değiştiğinde
  /// artırılır; daha eski sürümü tamamlamış kullanıcılara yeniden gösterilir.
  static const int currentVersion = 1;

  final PreferencesService _preferences;

  @override
  bool get isCompleted =>
      (_preferences.onboardingVersion ?? 0) >= currentVersion;

  @override
  ResultFuture<Unit> markCompleted() async {
    try {
      await _preferences.setOnboardingVersion(currentVersion);
      return const Right(unit);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }
}
