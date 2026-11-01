import 'package:vakif_atlas/features/settings/domain/entities/app_settings.dart';
import 'package:vakif_atlas/features/settings/domain/repositories/settings_repository.dart';

/// Kayıtlı tercihleri okur. İlk çizimin gecikmemesi için senkrondur.
class GetAppSettingsUseCase {
  const GetAppSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  AppSettings call() => _repository.load();
}
