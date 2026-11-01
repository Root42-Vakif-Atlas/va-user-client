import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/features/feedback/domain/repositories/feedback_repository.dart';
import 'package:vakif_atlas/features/feedback/domain/usecases/submit_feedback_usecase.dart';

/// Domain sınıfları DI anotasyonu taşımadığından kayıtları burada yapılır.
@module
abstract class FeedbackModule {
  @lazySingleton
  SubmitFeedbackUseCase submitFeedbackUseCase(FeedbackRepository repository) =>
      SubmitFeedbackUseCase(repository);
}
