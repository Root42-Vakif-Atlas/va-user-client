import 'dart:async';

import 'package:dio/dio.dart';
import 'package:vakif_atlas/core/network/network_status.dart';

import '../support/mock_api/mock_api.dart';

const String testBaseUrl = 'https://mock.vakifatlas.invalid/api/';

/// Testte tanımlanan uç noktalar.
final class TestMockApi implements MockApi {
  TestMockApi(this.routes);

  @override
  final List<MockRoute> routes;
}

/// Gecikmesiz mock adaptörlü, interceptor'sız `Dio`.
Dio testDio(List<MockRoute> routes) {
  return Dio(BaseOptions(baseUrl: testBaseUrl))
    ..httpClientAdapter = MockApiAdapter(apis: [TestMockApi(routes)]);
}

/// Elle değiştirilebilen cihaz ağ durumu (varsayılan: çevrimiçi).
final class FakeNetworkStatus implements NetworkStatus {
  // Ad, `online` ayarlayıcısıyla aynı olduğundan alan ayrıca atanır.
  // ignore: prefer_initializing_formals
  FakeNetworkStatus({bool online = true}) : _online = online;

  final StreamController<bool> _changes = StreamController<bool>.broadcast();
  bool _online;

  @override
  bool get isOnline => _online;

  @override
  Stream<bool> get changes => _changes.stream;

  set online(bool value) {
    if (value == _online) {
      return;
    }
    _online = value;
    _changes.add(value);
  }

  @override
  Future<bool> refresh() async => _online;

  @override
  Future<void> dispose() => _changes.close();
}
