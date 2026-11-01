import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/feedback/domain/entities/feedback_submission.dart';

/// Uygulama deneyimi geri bildirimi (Feedback servisi; giriş gerekmez).
abstract interface class FeedbackRepository {
  ResultFuture<Unit> submit(FeedbackSubmission submission);
}
