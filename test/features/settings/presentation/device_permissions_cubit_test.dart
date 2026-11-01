import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/permissions/permission_service.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/device_permissions_cubit.dart';

import '../../../helpers/permission_test_utils.dart';

void main() {
  test('durum okunmadan istek yapılmaz', () async {
    final permissions = FakePermissionService();
    final cubit = DevicePermissionsCubit(permissions);

    await cubit.resolve(AppPermission.camera);

    expect(permissions.requested, isEmpty);
    await cubit.close();
  });

  test('tüm izinler okunur; yalnızca istenen izin istenir', () async {
    final permissions = FakePermissionService(
      access: {
        AppPermission.camera: PermissionAccess.denied,
        AppPermission.microphone: PermissionAccess.denied,
      },
    )..requestResults[AppPermission.camera] = PermissionAccess.granted;
    final cubit = DevicePermissionsCubit(permissions);
    await cubit.refresh();
    expect(cubit.state.access, {
      AppPermission.camera: PermissionAccess.denied,
      AppPermission.microphone: PermissionAccess.denied,
    });

    await cubit.resolve(AppPermission.camera);

    expect(permissions.requested, [AppPermission.camera]);
    expect(cubit.state.access[AppPermission.camera], PermissionAccess.granted);
    expect(
      cubit.state.access[AppPermission.microphone],
      PermissionAccess.denied,
    );
    expect(cubit.state.busy, isNull);
    await cubit.close();
  });

  test('kalıcı retde istek yerine uygulama ayarları açılır', () async {
    final permissions = FakePermissionService(
      access: {AppPermission.microphone: PermissionAccess.deniedForever},
    );
    final cubit = DevicePermissionsCubit(permissions);
    await cubit.refresh();
    expect(cubit.state.canOpenSettings, isTrue);

    await cubit.resolve(AppPermission.microphone);

    expect(permissions.requested, isEmpty);
    expect(permissions.settingsOpened, 1);
    expect(cubit.state.busy, isNull);
    await cubit.close();
  });

  test('ayarlar açılamayan platformda (web) bayrak kapalıdır', () async {
    final cubit = DevicePermissionsCubit(
      FakePermissionService(canOpenAppSettings: false),
    );
    expect(cubit.state.canOpenSettings, isFalse);
    await cubit.close();
  });
}
