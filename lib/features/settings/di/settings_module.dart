import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/features/settings/domain/repositories/settings_repository.dart';
import 'package:vakif_atlas/features/settings/domain/usecases/get_app_settings_usecase.dart';
import 'package:vakif_atlas/features/settings/domain/usecases/save_app_settings_usecase.dart';

/// Domain sınıfları DI anotasyonu taşımadığından kayıtları burada yapılır.
@module
abstract class SettingsModule {
  @lazySingleton
  GetAppSettingsUseCase getAppSettingsUseCase(SettingsRepository repository) =>
      GetAppSettingsUseCase(repository);

  @lazySingleton
  SaveAppSettingsUseCase saveAppSettingsUseCase(
    SettingsRepository repository,
  ) => SaveAppSettingsUseCase(repository);
}
