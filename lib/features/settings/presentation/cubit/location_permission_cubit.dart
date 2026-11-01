import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/location/location_service.dart';

part 'location_permission_cubit.freezed.dart';

@freezed
abstract class LocationPermissionState with _$LocationPermissionState {
  const factory LocationPermissionState({
    /// `null` → durum henüz okunmadı.
    LocationAccess? access,

    /// Sistem penceresi veya ayarlar açıkken `true`.
    @Default(false) bool isBusy,

    /// Kalıcı ret / kapalı servis sistem ayarlarından çözülebiliyorsa `true`.
    @Default(false) bool canOpenSettings,
  }) = _LocationPermissionState;
}

/// Tanıtımdaki ve ayarlardaki konum izni kartının durumu (ekran bazlı).
///
/// İzin yalnızca kullanıcı "Konum iznini ver"e bastığında istenir; konum
/// okunmaz. Kalıcı ret veya kapalı konum servislerinde ilgili sistem
/// ayarları açılır, uygulamaya dönülünce durum yeniden okunur ([refresh]).
@injectable
class LocationPermissionCubit extends Cubit<LocationPermissionState> {
  LocationPermissionCubit(this._location)
    : super(const LocationPermissionState());

  final LocationService _location;

  Future<void> refresh() async {
    final access = await _location.checkAccess();
    if (!isClosed) {
      emit(_withAccess(access).copyWith(isBusy: false));
    }
  }

  /// İzin ister veya çözüm için sistem ayarlarını açar.
  Future<void> resolve() async {
    final access = state.access;
    if (state.isBusy || access == null) {
      return;
    }
    emit(state.copyWith(isBusy: true));
    final issue = access.settingsIssue;
    if (issue != null) {
      await _location.openSettings(issue);
      if (!isClosed) {
        emit(state.copyWith(isBusy: false));
      }
      return;
    }
    final next = await _location.requestAccess();
    if (!isClosed) {
      emit(_withAccess(next).copyWith(isBusy: false));
    }
  }

  /// İzni geri almak için uygulama ayarlarını açar.
  Future<void> manageInSettings() =>
      _location.openSettings(LocationIssue.permissionDenied);

  bool get canManageInSettings =>
      _location.canOpenSettings(LocationIssue.permissionDenied);

  LocationPermissionState _withAccess(LocationAccess access) {
    final issue = access.settingsIssue;
    return state.copyWith(
      access: access,
      canOpenSettings: issue != null && _location.canOpenSettings(issue),
    );
  }
}
