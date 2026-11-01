part of 'user_location_cubit.dart';

enum UserLocationStatus {
  /// Konum hiç alınmadı veya akış kapandı.
  idle,

  /// İzin isteniyor / ilk konum okunuyor.
  locating,

  /// Konum biliniyor ve güncelleniyor.
  active,
}

@freezed
abstract class UserLocationState with _$UserLocationState {
  const factory UserLocationState({
    /// `false` → platformda konum yok; buton gösterilmez.
    required bool isSupported,
    @Default(UserLocationStatus.idle) UserLocationStatus status,
    DevicePosition? position,

    /// Kamera konumu takip ediyor (buton dolu ikonla gösterilir).
    @Default(false) bool following,

    /// Her artışta harita kullanıcı konumuna gider (butona basıldı).
    @Default(0) int centerRequest,

    /// Son denemenin hatası; yeni denemede temizlenir.
    LocationIssue? issue,
  }) = _UserLocationState;
}
