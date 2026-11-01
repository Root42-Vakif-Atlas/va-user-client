part of 'complex_detail_cubit.dart';

@freezed
sealed class ComplexDetailState with _$ComplexDetailState {
  const factory ComplexDetailState.initial() = ComplexDetailInitial;

  const factory ComplexDetailState.loading() = ComplexDetailLoading;

  const factory ComplexDetailState.loaded(ComplexDetail complex) =
      ComplexDetailLoaded;

  const factory ComplexDetailState.failure(Failure failure) =
      ComplexDetailFailure;

  const ComplexDetailState._();

  /// Külliye katalogda yok veya kayıt külliye değil (404).
  bool get isNotFound => switch (this) {
    ComplexDetailFailure(
      failure: ServerFailure(kind: ServerFailureKind.notFound),
    ) =>
      true,
    _ => false,
  };
}
