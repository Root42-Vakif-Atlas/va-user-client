import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/repositories/digital_guide_repository.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/usecases/digital_guide_usecases.dart';

/// Domain sınıfları DI anotasyonu taşımadığından kayıtları burada yapılır.
@module
abstract class AiAssistantModule {
  @lazySingleton
  AskGuideUseCase askGuideUseCase(DigitalGuideRepository repository) =>
      AskGuideUseCase(repository);

  @lazySingleton
  EndGuideConversationUseCase endGuideConversationUseCase(
    DigitalGuideRepository repository,
  ) => EndGuideConversationUseCase(repository);
}
