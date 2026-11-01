import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/settings/domain/entities/app_settings.dart';
import 'package:vakif_atlas/features/settings/domain/repositories/settings_repository.dart';

class SaveAppSettingsUseCase implements UseCase<Unit, AppSettings> {
  const SaveAppSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  ResultFuture<Unit> call(AppSettings settings) => _repository.save(settings);
}
