import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/features/onboarding/domain/usecases/onboarding_usecases.dart';

enum OnboardingStatus { pending, completed }

/// İlk açılış tanıtımının uygulama genelindeki durumu.
///
/// Router'ın `LaunchGuard`'ı bu durumu dinler: tanıtım tamamlanana kadar
/// (yasal metinler hariç) tüm rotalar tanıtıma yönlendirilir.
@lazySingleton
class OnboardingCubit extends Cubit<OnboardingStatus> {
  OnboardingCubit(IsOnboardingCompletedUseCase isCompleted, this._complete)
    : super(
        isCompleted() ? OnboardingStatus.completed : OnboardingStatus.pending,
      );

  final CompleteOnboardingUseCase _complete;

  bool get isCompleted => state == OnboardingStatus.completed;

  /// Durum hemen güncellenir; kayıt başarısız olursa (depolama hatası)
  /// tanıtım yalnızca bir sonraki açılışta yeniden gösterilir.
  Future<void> complete() async {
    if (isCompleted) {
      return;
    }
    emit(OnboardingStatus.completed);
    await _complete(const NoParams());
  }
}
