import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/settings/domain/entities/app_settings.dart';

part 'app_settings_state.freezed.dart';

@freezed
abstract class AppSettingsState with _$AppSettingsState {
  const factory AppSettingsState({
    required AppSettings settings,

    /// Son kaydetme denemesi başarısız olduysa nedeni. Değişiklik bu oturumda
    /// uygulanmaya devam eder.
    Failure? saveFailure,
  }) = _AppSettingsState;
}
