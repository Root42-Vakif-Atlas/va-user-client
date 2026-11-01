import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/media/photo_attacher.dart';
import 'package:vakif_atlas/core/media/photo_picker_service.dart';
import 'package:vakif_atlas/core/permissions/permission_service.dart';

import '../../helpers/memory_test_utils.dart';
import '../../helpers/permission_test_utils.dart';

void main() {
  late FakePhotoPickerService picker;

  setUp(() {
    picker = FakePhotoPickerService();
    picker.results.add(
      PhotosPicked([Uint8List.fromList(List<int>.filled(16, 1))]),
    );
  });

  Future<PhotoNotice?> attach(
    FakePermissionService permissions,
    PhotoSource source,
  ) => PhotoAttacher(picker, const FakePhotoProcessor(), permissions).attach(
    source,
    remaining: 4,
    maxBytes: 1 << 20,
    onProcessing: (_) {},
    onProcessed: (_) {},
  );

  test('kamera izni sorulmadıysa çekimden önce istenir', () async {
    final permissions = FakePermissionService(
      access: {AppPermission.camera: PermissionAccess.denied},
    )..requestResults[AppPermission.camera] = PermissionAccess.granted;

    final notice = await attach(permissions, PhotoSource.camera);

    expect(notice, isNull);
    expect(permissions.requested, [AppPermission.camera]);
    expect(picker.requests.single.source, PhotoSource.camera);
  });

  test('kamera izni reddedilirse kamera açılmaz', () async {
    final permissions = FakePermissionService(
      access: {AppPermission.camera: PermissionAccess.denied},
    );

    final notice = await attach(permissions, PhotoSource.camera);

    expect(notice?.kind, PhotoNoticeKind.cameraDenied);
    expect(picker.requests, isEmpty);
  });

  test('kalıcı retde izin yeniden istenmez; ayarlar bildirimi döner', () async {
    final permissions = FakePermissionService(
      access: {AppPermission.camera: PermissionAccess.deniedForever},
    );

    final notice = await attach(permissions, PhotoSource.camera);

    expect(notice?.kind, PhotoNoticeKind.cameraDenied);
    expect(notice?.isPermissionDenied, isTrue);
    expect(permissions.requested, isEmpty);
    expect(picker.requests, isEmpty);
  });

  test('galeri sistem seçicisini izin sormadan açar', () async {
    final permissions = FakePermissionService();

    final notice = await attach(permissions, PhotoSource.gallery);

    expect(notice, isNull);
    expect(permissions.requested, isEmpty);
    expect(picker.requests.single.source, PhotoSource.gallery);
  });

  test('ayarlar izin servisiyle açılır', () async {
    final permissions = FakePermissionService();
    await PhotoAttacher(
      picker,
      const FakePhotoProcessor(),
      permissions,
    ).openAppSettings();
    expect(permissions.settingsOpened, 1);
  });
}
