import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/catalog_guide/catalog_guide.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/repositories/digital_guide_repository.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/usecases/digital_guide_usecases.dart';
import 'package:vakif_atlas/features/catalog/domain/repositories/catalog_repository.dart';

/// Domain sınıfları DI anotasyonu taşımadığından kayıtları burada yapılır.
@module
abstract class AiAssistantModule {
  @lazySingleton
  CatalogGuide catalogGuide(CatalogRepository catalog) => CatalogGuide(catalog);

  @lazySingleton
  AskGuideUseCase askGuideUseCase(DigitalGuideRepository repository) =>
      AskGuideUseCase(repository);

  @lazySingleton
  EndGuideConversationUseCase endGuideConversationUseCase(
    DigitalGuideRepository repository,
  ) => EndGuideConversationUseCase(repository);
}
