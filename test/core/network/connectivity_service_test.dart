import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/network/connectivity_service.dart';

import '../../helpers/network_test_utils.dart';
import '../../support/mock_api/mock_api.dart';

class _MockConnectivity extends Mock implements Connectivity {}

class _OfflineAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    throw DioException.connectionError(
      requestOptions: options,
      reason: 'offline',
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _MockConnectivity connectivity;

  setUp(() => connectivity = _MockConnectivity());

  Dio reachableProbe() =>
      Dio(BaseOptions(baseUrl: testBaseUrl))
        ..httpClientAdapter = MockApiAdapter(apis: [const HealthMockApi()]);

  test('ağ arayüzü yoksa sunucuya gitmeden false döner', () async {
    when(connectivity.checkConnectivity)
        .thenAnswer((_) async => [ConnectivityResult.none]);
    final service = ConnectivityService(connectivity, reachableProbe());

    expect(await service.hasInternetAccess(), isFalse);
  });

  test('arayüz açık ve sunucu yanıt veriyorsa true döner', () async {
    when(connectivity.checkConnectivity)
        .thenAnswer((_) async => [ConnectivityResult.wifi]);
    final service = ConnectivityService(connectivity, reachableProbe());

    expect(await service.hasInternetAccess(), isTrue);
  });

  test('arayüz açık ama paket çıkışı yoksa false döner', () async {
    when(connectivity.checkConnectivity)
        .thenAnswer((_) async => [ConnectivityResult.mobile]);
    final probe = Dio(BaseOptions(baseUrl: testBaseUrl))
      ..httpClientAdapter = _OfflineAdapter();
    final service = ConnectivityService(connectivity, probe);

    expect(await service.hasInternetAccess(), isFalse);
  });

  test('sunucu hata koduyla yanıt verse de erişim vardır', () async {
    when(connectivity.checkConnectivity)
        .thenAnswer((_) async => [ConnectivityResult.ethernet]);
    final service = ConnectivityService(connectivity, testDio([]));

    expect(await service.hasInternetAccess(), isTrue);
  });
}
