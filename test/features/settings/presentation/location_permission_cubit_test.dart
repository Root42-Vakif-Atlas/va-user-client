import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/location/location_service.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/location_permission_cubit.dart';

import '../../../helpers/location_test_utils.dart';

void main() {
  test('durum okunmadan istek yapılmaz', () async {
    final location = FakeLocationService();
    final cubit = LocationPermissionCubit(location);

    await cubit.resolve();

    expect(location.requestAccessCalls, 0);
    await cubit.close();
  });

  test('izin istenir; konum okunmaz', () async {
    final location = FakeLocationService();
    final cubit = LocationPermissionCubit(location);
    await cubit.refresh();
    expect(cubit.state.access, LocationAccess.denied);

    await cubit.resolve();

    expect(cubit.state.access, LocationAccess.granted);
    expect(cubit.state.isBusy, isFalse);
    expect(location.currentPositionCalls, 0);
    await cubit.close();
  });

  test('kapalı konum servisi için konum ayarları açılır', () async {
    final location = FakeLocationService(
      access: LocationAccess.serviceDisabled,
    );
    final cubit = LocationPermissionCubit(location);
    await cubit.refresh();
    expect(cubit.state.canOpenSettings, isTrue);

    await cubit.resolve();

    expect(location.openedSettings, [LocationIssue.serviceDisabled]);
    expect(location.requestAccessCalls, 0);
    await cubit.close();
  });

  test('ayar sayfası açılamayan platformda çözüm sunulmaz', () async {
    final location = FakeLocationService(
      access: LocationAccess.deniedForever,
      settingsAvailable: false,
    );
    final cubit = LocationPermissionCubit(location);
    await cubit.refresh();

    expect(cubit.state.canOpenSettings, isFalse);
    await cubit.close();
  });

  test('ayarlardan dönünce yeni durum okunur', () async {
    final location = FakeLocationService(access: LocationAccess.deniedForever);
    final cubit = LocationPermissionCubit(location);
    await cubit.refresh();

    location.access = LocationAccess.granted;
    await cubit.refresh();

    expect(cubit.state.access, LocationAccess.granted);
    expect(cubit.state.canOpenSettings, isFalse);
    await cubit.close();
  });
}
