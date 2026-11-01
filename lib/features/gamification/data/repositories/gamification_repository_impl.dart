import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/error_mapper.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/gamification/data/sources/gamification_remote_data_source.dart';
import 'package:vakif_atlas/features/gamification/domain/entities/gamification_profile.dart';
import 'package:vakif_atlas/features/gamification/domain/repositories/gamification_repository.dart';

@LazySingleton(as: GamificationRepository)
class GamificationRepositoryImpl implements GamificationRepository {
  GamificationRepositoryImpl(this._remote);

  final GamificationRemoteDataSource _remote;

  @override
  ResultFuture<GamificationProfile> getProfile({
    required String languageCode,
  }) => _guard(() async {
    final profile = await _remote.getProfile(languageCode: languageCode);
    return profile.toDomain();
  });

  @override
  ResultFuture<Unit> acknowledge(List<String> unlockIds) => _guard(() async {
    await _remote.acknowledge(unlockIds);
    return unit;
  });

  static ResultFuture<T> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on Exception catch (error) {
      return Left(ErrorMapper.toFailure(error));
    }
  }
}
