import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vakif_atlas/core/error/error_mapper.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/feedback/data/dtos/feedback_dtos.dart';
import 'package:vakif_atlas/features/feedback/data/sources/feedback_remote_data_source.dart';
import 'package:vakif_atlas/features/feedback/domain/entities/feedback_submission.dart';
import 'package:vakif_atlas/features/feedback/domain/repositories/feedback_repository.dart';

/// Geri bildirime uygulama sürümü ve platform eklenir (hata ayıklama için;
/// cihaz kimliği veya model gönderilmez).
@LazySingleton(as: FeedbackRepository)
class FeedbackRepositoryImpl implements FeedbackRepository {
  FeedbackRepositoryImpl(this._remote, this._packageInfo)
    : _platform = platformName(defaultTargetPlatform, isWeb: kIsWeb);

  @visibleForTesting
  FeedbackRepositoryImpl.forPlatform(
    this._remote,
    this._packageInfo,
    this._platform,
  );

  final FeedbackRemoteDataSource _remote;
  final PackageInfo _packageInfo;
  final String? _platform;

  static String? platformName(TargetPlatform platform, {required bool isWeb}) {
    if (isWeb) {
      return 'web';
    }
    return switch (platform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      TargetPlatform.macOS => 'macos',
      TargetPlatform.windows => 'windows',
      TargetPlatform.linux => 'linux',
      TargetPlatform.fuchsia => null,
    };
  }

  @override
  ResultFuture<Unit> submit(FeedbackSubmission submission) async {
    final build = _packageInfo.buildNumber;
    try {
      await _remote.submit(
        FeedbackRequestDto(
          category: submission.category.wireName,
          rating: submission.rating,
          message: submission.message.trim(),
          appVersion: build.isEmpty
              ? _packageInfo.version
              : '${_packageInfo.version}+$build',
          platform: _platform,
        ),
      );
      return const Right(unit);
    } on Exception catch (error) {
      return Left(ErrorMapper.toFailure(error));
    }
  }
}
