import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/settings/domain/entities/app_settings.dart';

abstract interface class SettingsRepository {
  /// Açılışta yüklenmiş tercihleri senkron okur.
  AppSettings load();

  ResultFuture<Unit> save(AppSettings settings);
}
