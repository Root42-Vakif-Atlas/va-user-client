import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/location/location_service.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/cubit/user_location_cubit.dart';

import '../../../helpers/location_test_utils.dart';

void main() {
  late FakeLocationService location;
  late UserLocationCubit cubit;

  setUp(() {
    location = FakeLocationService(
      result: const LocationFound(testIstanbulPosition),
    );
    cubit = UserLocationCubit(location);
  });

  tearDown(() => cubit.close());

  test('ilk basış konumu alır, takibi açar ve akışı dinler', () async {
    await cubit.locate();

    expect(cubit.state.status, UserLocationStatus.active);
    expect(cubit.state.position, testIstanbulPosition);
    expect(cubit.state.following, isTrue);
    expect(cubit.state.centerRequest, 1);
    expect(location.hasListeners, isTrue);

    const moved = DevicePosition(
      latitude: 41.01,
      longitude: 28.98,
      accuracyMeters: 10,
    );
    location.updates.add(moved);
    await pumpEventQueue();
    expect(cubit.state.position, moved);
  });

  test('takip bırakıldıktan sonra basış izin istemeden ortalar', () async {
    await cubit.locate();
    cubit.stopFollowing();
    expect(cubit.state.following, isFalse);

    await cubit.locate();
    expect(cubit.state.following, isTrue);
    expect(cubit.state.centerRequest, 2);
    expect(location.currentPositionCalls, 1);
  });

  test('hata nedeni yayınlanır; yeni denemede temizlenip yeniden '
      'yayınlanır', () async {
    location.result = const LocationFailed(LocationIssue.serviceDisabled);
    final issues = <LocationIssue?>[];
    final subscription = cubit.stream.listen((s) => issues.add(s.issue));

    await cubit.locate();
    await cubit.locate();
    await pumpEventQueue();

    expect(issues, [
      null,
      LocationIssue.serviceDisabled,
      null,
      LocationIssue.serviceDisabled,
    ]);
    expect(cubit.state.status, UserLocationStatus.idle);
    await subscription.cancel();
  });

  test('sayfa görünmezken akış durur, görünür olunca yeniden başlar', () async {
    await cubit.locate();
    cubit.setVisible(visible: false);
    await pumpEventQueue();
    expect(location.hasListeners, isFalse);
    expect(cubit.state.position, testIstanbulPosition);

    cubit.setVisible(visible: true);
    expect(location.hasListeners, isTrue);
  });

  test('akış kapanırsa (izin geri alındı) bayat konum gösterilmez', () async {
    await cubit.locate();
    await location.updates.close();
    await pumpEventQueue();

    expect(cubit.state.status, UserLocationStatus.idle);
    expect(cubit.state.position, isNull);
    expect(cubit.state.following, isFalse);
  });

  test('desteklenmeyen platformda hiçbir şey yapılmaz', () async {
    final unsupported = UserLocationCubit(
      FakeLocationService(isSupported: false),
    );
    await unsupported.locate();
    expect(unsupported.state.isSupported, isFalse);
    expect(unsupported.state.status, UserLocationStatus.idle);
    await unsupported.close();
  });

  test('konum loglara koordinat yazmaz', () {
    expect(testIstanbulPosition.toString(), isNot(contains('41')));
  });
}
