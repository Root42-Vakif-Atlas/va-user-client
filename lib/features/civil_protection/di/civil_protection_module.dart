import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/features/civil_protection/domain/repositories/damage_report_repository.dart';
import 'package:vakif_atlas/features/civil_protection/domain/usecases/damage_report_usecases.dart';

/// Domain sınıfları DI anotasyonu taşımadığından kayıtları burada yapılır.
@module
abstract class CivilProtectionModule {
  @lazySingleton
  GetDamageReportsUseCase getDamageReportsUseCase(
    DamageReportRepository repository,
  ) => GetDamageReportsUseCase(repository);

  @lazySingleton
  GetDamageReportUseCase getDamageReportUseCase(
    DamageReportRepository repository,
  ) => GetDamageReportUseCase(repository);

  @lazySingleton
  SubmitDamageReportUseCase submitDamageReportUseCase(
    DamageReportRepository repository,
  ) => SubmitDamageReportUseCase(repository);

  @lazySingleton
  WatchSubmittedReportsUseCase watchSubmittedReportsUseCase(
    DamageReportRepository repository,
  ) => WatchSubmittedReportsUseCase(repository);
}
