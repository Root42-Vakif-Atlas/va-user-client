import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:vakif_atlas/core/storage/installation_id_service.dart';
import 'package:vakif_atlas/features/route_planner/data/dtos/route_dtos.dart';
import 'package:vakif_atlas/features/route_planner/data/polyline_codec.dart';
import 'package:vakif_atlas/features/route_planner/data/sources/route_remote_data_source.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';

import '../auth/auth_mock_api.dart';
import '../catalog/catalog_fixtures.dart';
import '../gamification/mock_activity_ledger.dart';
import '../mock_api.dart';
import 'mock_route_store.dart';
import 'route_leg_fixtures.dart';

/// Rota mikro servisinin mock implementasyonu (`docs/api-contracts.md`).
///
/// - `X-Installation-Id` zorunlu; oturum açıksa rotalar hesaba aittir
///   (kurulumun misafir rotaları hesaba taşınır), misafirde kuruluma.
///   Geçersiz Bearer → 401 (istemci anahtarı yeniler).
/// - Bacaklar, mock katalogdaki 10 eser için OSRM'den bir kez alınmış
///   gerçek karayolu verisiyle (`RouteLegFixtures`) hesaplanır.
/// - Sunucu, istemciyle aynı plan kurallarını (`RoutePlanRules`) uygular ve
///   eserlerin katalogda bulunduğunu doğrular.
/// - Eser adları `Accept-Language` diline göre döner.
class RouteMockApi implements MockApi {
  RouteMockApi(MockRouteStore store, {AuthMockApi? auth})
    : this.withClock(store: store, clock: DateTime.now, auth: auth);

  /// Uygulamada: oturum açıkken oluşturulan rotalar oyunlaştırma defterine
  /// yazılır (gerçek sistemde `RouteCreated` olayı).
  RouteMockApi.withLedger(
    MockRouteStore store,
    MockActivityLedger ledger, {
    AuthMockApi? auth,
  }) : this.withClock(
         store: store,
         clock: DateTime.now,
         ledger: ledger,
         auth: auth,
       );

  RouteMockApi.withClock({
    required this._store,
    required DateTime Function() clock,
    Random? random,
    this._ledger,
    this._auth,
  }) : _now = clock,
       _random = random ?? Random.secure() {
    // Hesap silinince hesabın rotaları silinir (gerçekte `AccountDeleted`).
    _auth?.addAccountDeletionListener((userId) => _store.save('u:$userId', []));
  }

  final MockRouteStore _store;
  final MockActivityLedger? _ledger;

  /// Verilmezse Bearer yok sayılır (yalnızca kurulum kapsamı).
  final AuthMockApi? _auth;
  final DateTime Function() _now;
  final Random _random;

  static const Set<String> _supportedLanguages = {'tr', 'en'};

  @override
  List<MockRoute> get routes => [
    MockRoute('GET', RouteEndpoints.routes, _list),
    MockRoute('POST', RouteEndpoints.routes, _create),
    MockRoute('GET', '${RouteEndpoints.routes}/:id', _detail),
    MockRoute('PUT', '${RouteEndpoints.routes}/:id', _update),
    MockRoute('DELETE', '${RouteEndpoints.routes}/:id', _delete),
  ];

  Future<MockResponse> _list(MockRequest request) async {
    final (owner, rejection) = await _owner(request);
    if (owner == null) {
      return rejection!;
    }
    // En yeni önce; aynı anda oluşturulanlarda son eklenen öne gelir
    // (`List.sort` kararlı değildir, sıra açıkça belirlenir).
    final stored = await _store.load(owner);
    final records =
        [
          for (var i = stored.length - 1; i >= 0; i--)
            (index: i, value: stored[i]),
        ]..sort((a, b) {
          final byDate = (b.value['createdAt'] as String).compareTo(
            a.value['createdAt'] as String,
          );
          return byDate != 0 ? byDate : b.index.compareTo(a.index);
        });
    return MockResponse.ok({
      'items': [for (final record in records) _overviewJson(record.value)],
    });
  }

  Future<MockResponse> _create(MockRequest request) async {
    final (owner, rejection) = await _owner(request);
    if (owner == null) {
      return rejection!;
    }
    final plan = _parsePlan(request.body);
    if (plan == null) {
      return MockResponse.error(400, 'invalid_route');
    }
    final timestamp = _now().toUtc().toIso8601String();
    final record = <String, dynamic>{
      'id': 'rt_${_randomHex(12)}',
      ...plan.toJson(),
      'createdAt': timestamp,
      'updatedAt': timestamp,
    };
    final records = await _store.load(owner);
    await _store.save(owner, [...records, record]);
    await _ledger?.recordFor(
      request,
      kind: MockActivityKind.routeCreated,
      refId: record['id'] as String,
      monumentIds: [for (final stop in plan.stops) stop.monumentId],
    );
    return MockResponse(201, body: _detailJson(record, _language(request)));
  }

  Future<MockResponse> _detail(MockRequest request) async {
    final (owner, rejection) = await _owner(request);
    if (owner == null) {
      return rejection!;
    }
    final record = _find(
      await _store.load(owner),
      request.pathParameters['id'],
    );
    if (record == null) {
      return MockResponse.error(404, 'not_found');
    }
    return MockResponse.ok(_detailJson(record, _language(request)));
  }

  Future<MockResponse> _update(MockRequest request) async {
    final (owner, rejection) = await _owner(request);
    if (owner == null) {
      return rejection!;
    }
    final records = await _store.load(owner);
    final existing = _find(records, request.pathParameters['id']);
    if (existing == null) {
      return MockResponse.error(404, 'not_found');
    }
    final plan = _parsePlan(request.body);
    if (plan == null) {
      return MockResponse.error(400, 'invalid_route');
    }
    final updated = <String, dynamic>{
      'id': existing['id'],
      ...plan.toJson(),
      'createdAt': existing['createdAt'],
      'updatedAt': _now().toUtc().toIso8601String(),
    };
    await _store.save(owner, [
      for (final record in records)
        record['id'] == existing['id'] ? updated : record,
    ]);
    return MockResponse.ok(_detailJson(updated, _language(request)));
  }

  Future<MockResponse> _delete(MockRequest request) async {
    final (owner, rejection) = await _owner(request);
    if (owner == null) {
      return rejection!;
    }
    final records = await _store.load(owner);
    final id = request.pathParameters['id'];
    if (_find(records, id) == null) {
      return MockResponse.error(404, 'not_found');
    }
    await _store.save(owner, [
      for (final record in records)
        if (record['id'] != id) record,
    ]);
    return const MockResponse.noContent();
  }

  /// Depo anahtarı: oturum açıksa `u:<kullanıcı>`, değilse kurulum kimliği.
  Future<(String?, MockResponse?)> _owner(MockRequest request) async {
    final installation = _installation(request);
    if (installation == null) {
      return (null, _installationRequired);
    }
    final auth = _auth;
    if (auth == null || request.headers['authorization'] == null) {
      return (installation, null);
    }
    final account = await auth.accountFor(request);
    if (account == null) {
      return (null, MockResponse.error(401, 'unauthorized'));
    }
    final owner = 'u:${account.id}';
    final guest = await _store.load(installation);
    if (guest.isNotEmpty) {
      await _store.save(owner, [...await _store.load(owner), ...guest]);
      await _store.save(installation, []);
    }
    return (owner, null);
  }

  static final MockResponse _installationRequired = MockResponse.error(
    400,
    'installation_id_required',
  );

  static String? _installation(MockRequest request) {
    final id = request.headers['x-installation-id'];
    return id != null && InstallationIdService.isValid(id) ? id : null;
  }

  static String _language(MockRequest request) {
    final header = request.headers['accept-language'] ?? '';
    final primary = header.split(',').first.split('-').first.trim();
    return _supportedLanguages.contains(primary) ? primary : 'tr';
  }

  /// Gövdeyi ayrıştırır ve sunucu kurallarıyla doğrular; geçersizse `null`.
  static RoutePlanRequestDto? _parsePlan(Object? body) {
    if (body is! Map<String, dynamic>) {
      return null;
    }
    final RoutePlanRequestDto plan;
    try {
      plan = RoutePlanRequestDto.fromJson(body);
    } on CheckedFromJsonException {
      return null;
    }
    final known = {
      for (final monument in CatalogFixtures.monuments) monument.id,
    };
    final valid =
        plan.travelMode == RouteTravelModes.driving &&
        RoutePlanRules.validate(plan.toDomain()) == null &&
        plan.stops.every((stop) => known.contains(stop.monumentId));
    return valid ? plan.copyWith(name: plan.name.trim()) : null;
  }

  static Map<String, dynamic>? _find(
    List<Map<String, dynamic>> records,
    String? id,
  ) {
    for (final record in records) {
      if (record['id'] == id) {
        return record;
      }
    }
    return null;
  }

  static MockMonument _monument(String id) =>
      CatalogFixtures.monuments.firstWhere((monument) => monument.id == id);

  static List<RouteStopPlanDto> _stops(Map<String, dynamic> record) =>
      RoutePlanRequestDto.fromJson(record).stops;

  /// [from] → [to] karayolu bacağı; fikstür ters yönde kayıtlıysa
  /// geometri ters çevrilir.
  static ({int distance, int duration, String geometry}) _leg(
    String from,
    String to,
  ) {
    final forward = RouteLegFixtures.legs['$from|$to'];
    if (forward != null) {
      return (
        distance: forward.distanceMeters,
        duration: forward.durationSeconds,
        geometry: forward.geometry,
      );
    }
    final backward = RouteLegFixtures.legs['$to|$from']!;
    return (
      distance: backward.distanceMeters,
      duration: backward.durationSeconds,
      geometry: PolylineCodec.encode(
        PolylineCodec.decode(backward.geometry).reversed.toList(),
      ),
    );
  }

  static Map<String, int> _summary(List<RouteStopPlanDto> stops) {
    var distance = 0;
    var travel = 0;
    for (var i = 1; i < stops.length; i++) {
      final leg = _leg(stops[i - 1].monumentId, stops[i].monumentId);
      distance += leg.distance;
      travel += leg.duration;
    }
    final visit = stops.fold(0, (sum, stop) => sum + stop.visitMinutes * 60);
    final breaks = stops.fold(
      0,
      (sum, stop) =>
          sum +
          stop.breaks.fold(0, (total, pause) => total + pause.minutes) * 60,
    );
    return {
      'distanceMeters': distance,
      'travelSeconds': travel,
      'visitSeconds': visit,
      'breakSeconds': breaks,
      'totalSeconds': travel + visit + breaks,
    };
  }

  static Map<String, Object?> _overviewJson(Map<String, dynamic> record) {
    final stops = _stops(record);
    return {
      'id': record['id'],
      'name': record['name'],
      'createdAt': record['createdAt'],
      'stopCount': stops.length,
      'cities': [for (final stop in stops) _monument(stop.monumentId).city],
      'summary': _summary(stops),
    };
  }

  static Map<String, Object?> _detailJson(
    Map<String, dynamic> record,
    String language,
  ) {
    final stops = _stops(record);
    return {
      'id': record['id'],
      'name': record['name'],
      'createdAt': record['createdAt'],
      'updatedAt': record['updatedAt'],
      'travelMode': RouteTravelModes.driving,
      'stops': [for (final stop in stops) _stopJson(stop, language)],
      'legs': [
        for (var i = 1; i < stops.length; i++)
          _legJson(stops[i - 1].monumentId, stops[i].monumentId),
      ],
      'summary': _summary(stops),
    };
  }

  static Map<String, Object?> _stopJson(
    RouteStopPlanDto stop,
    String language,
  ) {
    final monument = _monument(stop.monumentId);
    return {
      'monumentId': monument.id,
      'name': monument.name.resolve(language),
      'city': monument.city,
      'district': monument.district,
      'category': monument.category.name,
      'location': {
        'latitude': monument.latitude,
        'longitude': monument.longitude,
      },
      'visitMinutes': stop.visitMinutes,
      'breaks': [for (final pause in stop.breaks) pause.toJson()],
    };
  }

  static Map<String, Object?> _legJson(String from, String to) {
    final leg = _leg(from, to);
    return {
      'distanceMeters': leg.distance,
      'durationSeconds': leg.duration,
      'geometry': leg.geometry,
    };
  }

  String _randomHex(int bytes) => [
    for (var i = 0; i < bytes; i++)
      _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ].join();
}
