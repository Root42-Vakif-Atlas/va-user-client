import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/location/location_service.dart';

part 'user_location_cubit.freezed.dart';
part 'user_location_state.dart';

/// Haritadaki "konumum" butonunun durumu (ekran bazlı, factory).
///
/// - İzin yalnızca butona basıldığında istenir.
/// - İlk konumdan sonra harita kullanıcıyı takip eder; kullanıcı haritayı
///   kaydırınca takip bırakılır, nokta güncellenmeye devam eder.
/// - Sayfa görünmezken (başka sekme) konum akışı durdurulur (pil).
/// - Konum cihazda kalır; sunucuya ve loglara yazılmaz.
@injectable
class UserLocationCubit extends Cubit<UserLocationState> {
  UserLocationCubit(this._location)
    : super(UserLocationState(isSupported: _location.isSupported));

  final LocationService _location;
  StreamSubscription<DevicePosition>? _updates;
  bool _visible = true;

  /// Konum butonu: takip etmiyorsa son konuma döner ve takibe başlar; konum
  /// yoksa izin isteyip yeni konum okur.
  Future<void> locate() async {
    if (!state.isSupported || state.status == UserLocationStatus.locating) {
      return;
    }
    final position = state.position;
    if (state.status == UserLocationStatus.active && position != null) {
      emit(
        state.copyWith(
          following: true,
          centerRequest: state.centerRequest + 1,
          issue: null,
        ),
      );
      return;
    }

    emit(state.copyWith(status: UserLocationStatus.locating, issue: null));
    final result = await _location.currentPosition();
    if (isClosed) {
      return;
    }
    switch (result) {
      case LocationFound(:final position):
        emit(
          state.copyWith(
            status: UserLocationStatus.active,
            position: position,
            following: true,
            centerRequest: state.centerRequest + 1,
          ),
        );
        _startUpdates();
      case LocationFailed(:final issue):
        emit(
          state.copyWith(
            status: state.position == null
                ? UserLocationStatus.idle
                : UserLocationStatus.active,
            issue: issue,
          ),
        );
    }
  }

  /// Kullanıcı haritayı elle hareket ettirdi.
  void stopFollowing() {
    if (state.following) {
      emit(state.copyWith(following: false));
    }
  }

  /// Sayfa görünürlüğü (sekme değişimi). Görünmezken konum akışı kapalıdır.
  void setVisible({required bool visible}) {
    if (visible == _visible) {
      return;
    }
    _visible = visible;
    if (visible) {
      _startUpdates();
    } else {
      unawaited(_stopUpdates());
    }
  }

  bool canOpenSettings(LocationIssue issue) => _location.canOpenSettings(issue);

  Future<void> openSettings(LocationIssue issue) async {
    await _location.openSettings(issue);
  }

  void _startUpdates() {
    if (_updates != null ||
        !_visible ||
        state.status != UserLocationStatus.active) {
      return;
    }
    _updates = _location.positionUpdates().listen(
      (position) {
        if (!isClosed) {
          emit(state.copyWith(position: position));
        }
      },
      onDone: () {
        _updates = null;
        // İzin geri alındı veya servis kapandı: bayat konum gösterilmez.
        // Sayfa gizlenirken iptal edilen akış `onDone` çağırmaz.
        if (!isClosed) {
          emit(
            state.copyWith(
              status: UserLocationStatus.idle,
              position: null,
              following: false,
            ),
          );
        }
      },
    );
  }

  Future<void> _stopUpdates() async {
    final cancelled = _updates?.cancel();
    _updates = null;
    await cancelled;
  }

  @override
  Future<void> close() async {
    await _stopUpdates();
    return super.close();
  }
}
