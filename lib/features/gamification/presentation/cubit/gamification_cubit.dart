import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/events/user_activity_events.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/gamification/domain/entities/gamification_profile.dart';
import 'package:vakif_atlas/features/gamification/domain/usecases/gamification_usecases.dart';

part 'gamification_cubit.freezed.dart';

enum GamificationStatus {
  /// Oturum yok; oyunlaştırma yalnızca hesapla çalışır.
  inactive,
  loading,
  ready,
  failure,
}

@freezed
abstract class GamificationState with _$GamificationState {
  const factory GamificationState({
    @Default(GamificationStatus.inactive) GamificationStatus status,

    /// Yenileme başarısız olsa da son profil gösterilmeye devam eder.
    GamificationProfile? profile,
    Failure? failure,
  }) = _GamificationState;

  const GamificationState._();

  /// Kutlanacak, henüz görülmemiş kazanımlar.
  List<GamificationUnlock> get pendingUnlocks =>
      profile?.unseen ?? const <GamificationUnlock>[];
}

/// Uygulama genelinde oturum açık kullanıcının seviye ve rozetleri (tek
/// örnek). Kök widget oturum açılınca [start], kapanınca [stop] çağırır.
///
/// Profil oturum açılınca, uygulamaya dönülünce, dil değişince ve her
/// katkıdan sonra ([UserActivityEvents]) yenilenir. XP sunucuda hesaplanır;
/// istemci yalnızca okur ve kutlanan kazanımları görüldü işaretler.
@lazySingleton
class GamificationCubit extends Cubit<GamificationState> {
  GamificationCubit(
    this._getProfile,
    this._acknowledge,
    UserActivityEvents events,
  ) : super(const GamificationState()) {
    _contributions = events.onContribution.listen((_) => unawaited(refresh()));
  }

  final GetGamificationProfileUseCase _getProfile;
  final AcknowledgeUnlocksUseCase _acknowledge;
  late final StreamSubscription<void> _contributions;

  String? _languageCode;
  bool _active = false;

  /// Oturum değişince geç gelen eski yanıt yok sayılır.
  int _generation = 0;

  Future<void> start({required String languageCode}) async {
    if (_active && languageCode == _languageCode) {
      return;
    }
    _active = true;
    _languageCode = languageCode;
    await refresh();
  }

  void stop() {
    _active = false;
    _generation++;
    if (!isClosed) {
      emit(const GamificationState());
    }
  }

  /// Rozet ve seviye adları arayüz dilinde gelir.
  Future<void> setLanguage(String languageCode) async {
    if (languageCode == _languageCode) {
      return;
    }
    _languageCode = languageCode;
    await refresh();
  }

  Future<void> refresh() async {
    final languageCode = _languageCode;
    if (!_active || languageCode == null || isClosed) {
      return;
    }
    final generation = ++_generation;
    if (state.profile == null) {
      emit(state.copyWith(status: GamificationStatus.loading, failure: null));
    }
    final result = await _getProfile(languageCode);
    if (isClosed || generation != _generation) {
      return;
    }
    switch (result) {
      case Left(value: final failure):
        emit(
          state.copyWith(status: GamificationStatus.failure, failure: failure),
        );
      case Right(value: final profile):
        emit(
          state.copyWith(
            status: GamificationStatus.ready,
            profile: profile,
            failure: null,
          ),
        );
    }
  }

  /// Kutlama kapatıldı: kazanımlar listeden düşer ve sunucuda görüldü
  /// işaretlenir. İşaretleme başarısız olursa bir sonraki yenilemede
  /// yeniden kutlanır.
  Future<void> acknowledge(List<GamificationUnlock> unlocks) async {
    final profile = state.profile;
    if (profile == null || unlocks.isEmpty) {
      return;
    }
    final ids = {for (final unlock in unlocks) unlock.id};
    emit(
      state.copyWith(
        profile: GamificationProfile(
          level: profile.level,
          levelTitle: profile.levelTitle,
          xp: profile.xp,
          levelStartXp: profile.levelStartXp,
          nextLevelXp: profile.nextLevelXp,
          achievements: profile.achievements,
          unseen: [
            for (final unlock in profile.unseen)
              if (!ids.contains(unlock.id)) unlock,
          ],
        ),
      ),
    );
    await _acknowledge(ids.toList());
  }

  @override
  Future<void> close() async {
    await _contributions.cancel();
    return super.close();
  }
}
