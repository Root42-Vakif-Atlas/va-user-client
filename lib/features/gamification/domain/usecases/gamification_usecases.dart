import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/gamification/domain/entities/gamification_profile.dart';
import 'package:vakif_atlas/features/gamification/domain/repositories/gamification_repository.dart';

class GetGamificationProfileUseCase
    implements UseCase<GamificationProfile, String> {
  const GetGamificationProfileUseCase(this._repository);

  final GamificationRepository _repository;

  /// [params]: içerik dili (rozet ve seviye adları).
  @override
  ResultFuture<GamificationProfile> call(String params) =>
      _repository.getProfile(languageCode: params);
}

/// Boş liste için istek yapılmaz.
class AcknowledgeUnlocksUseCase implements UseCase<Unit, List<String>> {
  const AcknowledgeUnlocksUseCase(this._repository);

  final GamificationRepository _repository;

  @override
  ResultFuture<Unit> call(List<String> params) async {
    final ids = {
      for (final id in params)
        if (id.isNotEmpty) id,
    }.toList();
    if (ids.isEmpty) {
      return const Right(unit);
    }
    return _repository.acknowledge(ids);
  }
}
