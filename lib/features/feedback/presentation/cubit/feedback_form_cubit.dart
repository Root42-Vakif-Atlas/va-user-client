import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/feedback/domain/entities/feedback_submission.dart';
import 'package:vakif_atlas/features/feedback/domain/usecases/submit_feedback_usecase.dart';

part 'feedback_form_cubit.freezed.dart';

enum FeedbackFormStatus { editing, invalid, submitting, success, failure }

@freezed
abstract class FeedbackFormState with _$FeedbackFormState {
  const factory FeedbackFormState({
    @Default(FeedbackCategory.suggestion) FeedbackCategory category,
    int? rating,
    @Default('') String message,
    @Default(FeedbackFormStatus.editing) FeedbackFormStatus status,
    @Default(false) bool showValidationErrors,

    /// Her geçersiz gönderimde artar (hata duyurusu tekrarlanır).
    @Default(0) int invalidSubmissions,
    Failure? failure,
  }) = _FeedbackFormState;

  const FeedbackFormState._();

  FeedbackIssue? get issue =>
      FeedbackRules.validate(rating: rating, message: message);

  bool get isSubmitting => status == FeedbackFormStatus.submitting;

  /// Metin kişisel veri içerebilir; loglara yazılmaz.
  @override
  String toString() =>
      'FeedbackFormState(status: $status, category: $category, '
      'rating: $rating, failure: $failure)';
}

/// "Geri bildirim gönder" formu (ekran bazlı, factory).
@injectable
class FeedbackFormCubit extends Cubit<FeedbackFormState> {
  FeedbackFormCubit(this._submit) : super(const FeedbackFormState());

  final SubmitFeedbackUseCase _submit;

  void selectCategory(FeedbackCategory category) => emit(
    state.copyWith(category: category, status: FeedbackFormStatus.editing),
  );

  /// Aynı puana tekrar dokunmak puanı kaldırır.
  void rate(int rating) => emit(
    state.copyWith(
      rating: state.rating == rating ? null : rating,
      status: FeedbackFormStatus.editing,
    ),
  );

  void changeMessage(String message) => emit(
    state.copyWith(message: message, status: FeedbackFormStatus.editing),
  );

  Future<void> submit() async {
    if (state.isSubmitting || state.status == FeedbackFormStatus.success) {
      return;
    }
    if (state.issue != null) {
      emit(
        state.copyWith(
          status: FeedbackFormStatus.invalid,
          showValidationErrors: true,
          invalidSubmissions: state.invalidSubmissions + 1,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: FeedbackFormStatus.submitting,
        showValidationErrors: true,
        failure: null,
      ),
    );
    final result = await _submit(
      FeedbackSubmission(
        category: state.category,
        rating: state.rating,
        message: state.message,
      ),
    );
    if (isClosed) {
      return;
    }
    emit(
      result.fold(
        (failure) => state.copyWith(
          status: FeedbackFormStatus.failure,
          failure: failure,
        ),
        (_) => state.copyWith(status: FeedbackFormStatus.success),
      ),
    );
  }
}
