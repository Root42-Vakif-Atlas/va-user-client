import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/media/camera_capture_controller.dart';
import 'package:vakif_atlas/shared/widgets/templates/camera_capture_page.dart';

import '../../../helpers/pump_app.dart';

class _FakeCamera implements CameraCaptureController {
  _FakeCamera({this.cameras = 1});

  final int cameras;
  final List<CameraCaptureIssue?> openResults = [];
  Uint8List? picture = Uint8List.fromList([1, 2, 3]);
  int opens = 0;
  int switches = 0;
  int disposes = 0;

  @override
  bool get canSwitch => cameras > 1;

  @override
  Future<CameraCaptureIssue?> open() async {
    opens++;
    return openResults.isEmpty ? null : openResults.removeAt(0);
  }

  @override
  Future<CameraCaptureIssue?> switchCamera() async {
    switches++;
    return null;
  }

  @override
  Widget buildPreview() =>
      const SizedBox(key: Key('fake_preview'), width: 320, height: 240);

  @override
  Future<Uint8List?> takePicture() async => picture;

  @override
  Future<void> dispose() async => disposes++;
}

void main() {
  late List<String> announcements;
  late Object? result;

  setUp(() {
    announcements = [];
    result = 'not-popped';
  });

  Future<void> pump(WidgetTester tester, _FakeCamera camera) async {
    await tester.pumpApp(
      RepositoryProvider<A11yAnnouncer>.value(
        value: A11yAnnouncer.withSender(
          (_, message, _, _) async => announcements.add(message),
        ),
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await Navigator.of(context).push<Uint8List>(
                MaterialPageRoute(
                  // Uygulamada A11yAnnouncer kökte (tüm rotaların üstünde).
                  builder: (_) => RepositoryProvider<A11yAnnouncer>.value(
                    value: context.read<A11yAnnouncer>(),
                    child: CameraCapturePage(controller: camera),
                  ),
                ),
              );
            },
            child: const Text('aç'),
          ),
        ),
      ),
      surfaceSize: const Size(390, 844),
    );
    await tester.tap(find.text('aç'));
    await tester.pumpAndSettle();
  }

  Future<void> expectAccessible(WidgetTester tester) async {
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  }

  testWidgets('kamera açılır; deklanşör fotoğrafla kapanır', (tester) async {
    final camera = _FakeCamera();
    await pump(tester, camera);

    expect(find.byKey(const Key('fake_preview')), findsOneWidget);
    expect(find.byKey(const Key('camera_capture_switch')), findsNothing);
    expect(
      announcements,
      contains('Kamera hazır. Fotoğrafı çekmek için deklanşöre dokunun.'),
    );
    expect(find.bySemanticsLabel('Fotoğrafı çek'), findsOneWidget);
    await expectAccessible(tester);

    await tester.tap(find.byKey(const Key('camera_capture_shutter')));
    await tester.pumpAndSettle();

    expect(result, Uint8List.fromList([1, 2, 3]));
    expect(camera.disposes, 1);
  });

  testWidgets('birden fazla kamerada ön/arka geçişi yapılır', (tester) async {
    final camera = _FakeCamera(cameras: 2);
    await pump(tester, camera);

    await tester.tap(find.byKey(const Key('camera_capture_switch')));
    await tester.pumpAndSettle();

    expect(camera.switches, 1);
    expect(find.byKey(const Key('fake_preview')), findsOneWidget);
  });

  testWidgets('izin verilmezse nasıl verileceği anlatılır; tekrar denenir', (
    tester,
  ) async {
    final camera = _FakeCamera()
      ..openResults.add(CameraCaptureIssue.permissionDenied);
    await pump(tester, camera);

    expect(find.text('Kamera izni verilmedi'), findsOneWidget);
    expect(find.textContaining('site ayarlarından'), findsOneWidget);
    expect(announcements, contains('Kamera izni verilmedi'));
    await expectAccessible(tester);

    await tester.tap(find.text('Tekrar dene'));
    await tester.pumpAndSettle();
    expect(camera.opens, 2);
    expect(find.byKey(const Key('fake_preview')), findsOneWidget);
  });

  testWidgets('kamera yoksa galeri önerilir; kapatınca sonuç yok', (
    tester,
  ) async {
    final camera = _FakeCamera()..openResults.add(CameraCaptureIssue.noCamera);
    await pump(tester, camera);

    expect(find.text('Kamera bulunamadı'), findsOneWidget);
    await tester.tap(find.text('Kapat').last);
    await tester.pumpAndSettle();
    expect(result, isNull);
  });

  testWidgets('çekim başarısızsa ekranda kalınır ve bildirilir', (
    tester,
  ) async {
    final camera = _FakeCamera()..picture = null;
    await pump(tester, camera);

    await tester.tap(find.byKey(const Key('camera_capture_shutter')));
    await tester.pump();
    await tester.pump();

    expect(find.text('Fotoğraf çekilemedi. Tekrar deneyin.'), findsOneWidget);
    expect(find.byKey(const Key('fake_preview')), findsOneWidget);
    expect(result, 'not-popped');
  });

  testWidgets('kapat butonu sonuçsuz kapanır', (tester) async {
    final camera = _FakeCamera();
    await pump(tester, camera);

    await tester.tap(find.byKey(const Key('camera_capture_close')));
    await tester.pumpAndSettle();
    expect(result, isNull);
  });
}
