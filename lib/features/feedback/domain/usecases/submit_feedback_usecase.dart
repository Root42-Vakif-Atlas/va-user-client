import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/feedback/domain/entities/feedback_submission.dart';
import 'package:vakif_atlas/features/feedback/domain/repositories/feedback_repository.dart';

class SubmitFeedbackUseCase implements UseCase<Unit, FeedbackSubmission> {
  const SubmitFeedbackUseCase(this._repository);

  final FeedbackRepository _repository;

  @override
  ResultFuture<Unit> call(FeedbackSubmission submission) =>
      _repository.submit(submission);
}
