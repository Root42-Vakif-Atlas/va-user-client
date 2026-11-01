import 'dart:convert';
import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:vakif_atlas/core/media/photo_draft.dart';
import 'package:vakif_atlas/features/civil_protection/data/dtos/damage_report_dtos.dart';
import 'package:vakif_atlas/features/civil_protection/data/sources/damage_report_remote_data_source.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report_draft.dart';

import '../auth/auth_mock_api.dart';
import '../catalog/catalog_fixtures.dart';
import '../gamification/mock_activity_ledger.dart';
import '../mock_api.dart';
import '../mock_photo_storage.dart';
import 'mock_damage_report_store.dart';

/// Civil Protection mikro servisinin mock implementasyonu
/// (`docs/api-contracts.md` → Sivil Koruma).
///
/// - Tüm uç noktalar Bearer ister; kullanıcı yalnızca kendi raporlarını
///   görür (başkasının raporu `404`).
/// - Konum paylaşıldıysa esere uzaklık hesaplanır: [onSiteRadius] içinde ve
///   doğruluğu [maxAccuracy]'den iyi ise "yerinde"; ham koordinat yanıtta
///   dönmez.
/// - Demo için durum zamanla ilerler: [reviewDelay] sonra "inceleniyor",
///   [forwardDelay] sonra "iletildi". Gerçek sistemde VGM Yönetim Paneli
///   günceller.
/// - Hesap silinince raporlar silinmez, kişiyle bağı kaldırılır (kültür
///   varlığı koruma kaydı; KVKK anonimleştirme).
class CivilProtectionMockApi implements MockApi {
  CivilProtectionMockApi(MockDamageReportStore store, AuthMockApi auth)
    : this.withClock(store: store, auth: auth, clock: DateTime.now);

  /// Uygulamada: gönderilen raporlar oyunlaştırma defterine yazılır (gerçek
  /// sistemde `DamageReportSubmitted` olayı).
  CivilProtectionMockApi.withLedger(
    MockDamageReportStore store,
    AuthMockApi auth,
    MockActivityLedger ledger,
  ) : this.withClock(
        store: store,
        auth: auth,
        clock: DateTime.now,
        ledger: ledger,
      );

  CivilProtectionMockApi.withClock({
    required this._store,
    required this._auth,
    required DateTime Function() clock,
    Random? random,
    this._ledger,
  }) : _now = clock,
       _random = random ?? Random.secure() {
    _auth.addAccountDeletionListener(_anonymize);
  }

  final MockDamageReportStore _store;
  final MockActivityLedger? _ledger;
  final AuthMockApi _auth;
  final DateTime Function() _now;
  final Random _random;

  static const int defaultLimit = 20;
  static const int maxLimit = 50;
  static const int maxReportsPerHour = 5;
  static const int onSiteRadius = DamageReportRules.onSiteRadiusMeters;
  static const double maxAccuracy = 200;
  static const Duration reviewDelay = Duration(minutes: 2);
  static const Duration forwardDelay = Duration(minutes: 10);

  static const Set<String> _supportedLanguages = {'tr', 'en'};

  List<Map<String, dynamic>>? _reports;
  int _sequence = 100;

  late final MockPhotoStorage _storage = MockPhotoStorage(
    bucket: 'civil-protection-photos',
    clock: _now,
    random: _random,
  );

  @override
  List<MockRoute> get routes => [
    MockRoute('GET', DamageReportEndpoints.reports, _list),
    MockRoute('POST', DamageReportEndpoints.reports, _submit),
    MockRoute('GET', '${DamageReportEndpoints.reports}/:id', _detail),
    MockRoute('POST', DamageReportEndpoints.photoUploads, _requestUpload),
    ..._storage.routes,
  ];

  Future<MockResponse> _list(MockRequest request) async {
    final account = await _auth.accountFor(request);
    if (account == null) {
      return MockResponse.error(401, 'unauthorized');
    }
    final limit = int.tryParse(
      request.queryParameters['limit'] ?? '$defaultLimit',
    );
    if (limit == null || limit < 1 || limit > maxLimit) {
      return MockResponse.error(400, 'invalid_request');
    }
    final own = [
      for (final report in await _load())
        if (report['ownerId'] == account.id) report,
    ]..sort(_newestFirst);
    var start = 0;
    final cursor = request.queryParameters['cursor'];
    if (cursor != null) {
      final position = _decodeCursor(cursor);
      if (position == null) {
        return MockResponse.error(400, 'invalid_cursor');
      }
      start = own.indexWhere((report) => _newestFirst(report, position) > 0);
      if (start < 0) {
        start = own.length;
      }
    }
    final page = own.skip(start).take(limit).toList();
    final hasMore = start + page.length < own.length;
    final language = _language(request);
    return MockResponse.ok({
      'items': [for (final report in page) _json(report, language)],
      'total': own.length,
      'nextCursor': hasMore ? _encodeCursor(page.last) : null,
    });
  }

  Future<MockResponse> _detail(MockRequest request) async {
    final account = await _auth.accountFor(request);
    if (account == null) {
      return MockResponse.error(401, 'unauthorized');
    }
    final id = request.pathParameters['id'];
    final report = (await _load())
        .where((r) => r['id'] == id && r['ownerId'] == account.id)
        .firstOrNull;
    if (report == null) {
      return MockResponse.error(404, 'not_found');
    }
    return MockResponse.ok(_json(report, _language(request)));
  }

  Future<MockResponse> _requestUpload(MockRequest request) async {
    final account = await _auth.accountFor(request);
    if (account == null) {
      return MockResponse.error(401, 'unauthorized');
    }
    return _storage.issueTicket(
      ownerId: account.id,
      body: request.body,
      maxBytes: DamageReportRules.maxPhotoBytes,
    );
  }

  Future<MockResponse> _submit(MockRequest request) async {
    final account = await _auth.accountFor(request);
    if (account == null) {
      return MockResponse.error(401, 'unauthorized');
    }
    final body = _parse(request.body);
    if (body == null) {
      return MockResponse.error(400, 'invalid_report');
    }
    final reports = await _load();
    final hourAgo = _now().subtract(const Duration(hours: 1));
    final recent = reports.where(
      (report) =>
          report['ownerId'] == account.id &&
          DateTime.parse(report['createdAt'] as String).isAfter(hourAgo),
    );
    if (recent.length >= maxReportsPerHour) {
      return const MockResponse(
        429,
        body: {'code': 'too_many_requests', 'retryAfter': 3600},
      );
    }
    final monument = CatalogFixtures.monuments
        .where((m) => m.id == body.monumentId)
        .firstOrNull;
    final uploadIds = [for (final photo in body.photos) photo.uploadId];
    final uploads = _storage.claim(uploadIds, account.id);
    final issue = DamageReportRules.validate(
      DamageReportDraft(
        monumentId: body.monumentId,
        category: body.category,
        urgency: body.urgency,
        description: body.description,
        photos: [
          for (var i = 0; i < (uploads?.length ?? 0); i++)
            PhotoDraft(
              localId: uploads![i].id,
              bytes: uploads[i].bytes!,
              width: uploads[i].width,
              height: uploads[i].height,
              description: body.photos[i].description ?? '',
            ),
        ],
      ),
    );
    final location = body.location;
    final locationValid =
        location == null ||
        (location.latitude.abs() <= 90 &&
            location.longitude.abs() <= 180 &&
            location.accuracyMeters >= 0);
    if (monument == null ||
        uploads == null ||
        issue != null ||
        !locationValid) {
      return MockResponse.error(400, 'invalid_report');
    }

    final createdAt = _now().toUtc();
    final record = <String, dynamic>{
      'id': 'rpt_${_randomHex(12)}',
      'referenceCode':
          'SK-${createdAt.year}-${(++_sequence).toString().padLeft(6, '0')}',
      'ownerId': account.id,
      'monumentId': monument.id,
      'category': body.category.name,
      'urgency': body.urgency.name,
      'description': body.description.trim(),
      'photos': [
        for (var i = 0; i < uploads.length; i++)
          MockPhotoStorage.photoJson(
            uploads[i],
            description: body.photos[i].description,
          ),
      ],
      'locationCheck': _locationCheck(
        location,
        monument.latitude,
        monument.longitude,
      ),
      'createdAt': createdAt.toIso8601String(),
    };
    _storage.release(uploadIds);
    reports.add(record);
    await _persist();
    await _ledger?.recordFor(
      request,
      kind: MockActivityKind.damageReported,
      refId: record['id'] as String,
      monumentIds: [monument.id],
    );
    return MockResponse(201, body: _json(record, _language(request)));
  }

  /// Ham koordinat saklanmaz; yalnızca doğrulama sonucu ve mesafe.
  static Map<String, Object?> _locationCheck(
    ReportLocationDto? location,
    double monumentLatitude,
    double monumentLongitude,
  ) {
    if (location == null) {
      return {'verification': 'notProvided'};
    }
    final distance = DamageReportRules.distanceMeters(
      location.latitude,
      location.longitude,
      monumentLatitude,
      monumentLongitude,
    ).round();
    final onSite =
        distance <= onSiteRadius && location.accuracyMeters <= maxAccuracy;
    return {
      'verification': onSite ? 'onSite' : 'distant',
      'distanceMeters': distance,
    };
  }

  /// Durum ve geçmiş kayıttan ve saatten türetilir (demo ilerlemesi).
  Map<String, Object?> _json(Map<String, dynamic> report, String language) {
    final monument = CatalogFixtures.monuments.firstWhere(
      (m) => m.id == report['monumentId'],
    );
    final createdAt = DateTime.parse(report['createdAt'] as String);
    final stored = report['history'] as List<dynamic>?;
    final history = stored == null
        ? [
            {'status': 'received', 'at': createdAt.toIso8601String()},
            for (final (status, delay) in [
              ('inReview', reviewDelay),
              ('forwarded', forwardDelay),
            ])
              if (!_now().isBefore(createdAt.add(delay)))
                {
                  'status': status,
                  'at': createdAt.add(delay).toIso8601String(),
                },
          ]
        : [for (final change in stored) change as Map<String, dynamic>];
    return {
      'id': report['id'],
      'referenceCode': report['referenceCode'],
      'monument': {
        'id': monument.id,
        'name': monument.name.resolve(language),
        'city': monument.city,
        'district': monument.district,
      },
      'category': report['category'],
      'urgency': report['urgency'],
      'description': report['description'],
      'photos': report['photos'],
      'locationCheck': report['locationCheck'],
      'status': history.last['status'],
      'history': history,
      'createdAt': report['createdAt'],
    };
  }

  Future<void> _anonymize(String userId) async {
    final reports = await _load();
    for (final report in reports) {
      if (report['ownerId'] == userId) {
        report['ownerId'] = null;
      }
    }
    _storage.removeOwner(userId);
    await _persist();
  }

  static SubmitDamageReportRequestDto? _parse(Object? body) {
    if (body is! Map<String, dynamic>) {
      return null;
    }
    try {
      return SubmitDamageReportRequestDto.fromJson(body);
    } on CheckedFromJsonException {
      return null;
    }
  }

  static String _language(MockRequest request) {
    final header = request.headers['accept-language'] ?? '';
    final primary = header.split(',').first.split('-').first.trim();
    return _supportedLanguages.contains(primary) ? primary : 'tr';
  }

  static int _newestFirst(Map<String, dynamic> a, Map<String, dynamic> b) {
    final byDate = DateTime.parse(b['createdAt'] as String)
        .compareTo(DateTime.parse(a['createdAt'] as String));
    return byDate != 0
        ? byDate
        : (b['id'] as String).compareTo(a['id'] as String);
  }

  static String _encodeCursor(Map<String, dynamic> report) => base64Url
      .encode(utf8.encode('${report['createdAt']}|${report['id']}'))
      .replaceAll('=', '');

  static Map<String, dynamic>? _decodeCursor(String cursor) {
    try {
      final parts = utf8
          .decode(base64Url.decode(base64Url.normalize(cursor)))
          .split('|');
      if (parts.length != 2) {
        return null;
      }
      DateTime.parse(parts[0]);
      return {'createdAt': parts[0], 'id': parts[1]};
    } on FormatException {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final cached = _reports;
    if (cached != null) {
      return cached;
    }
    final state = await _store.load();
    if (state == null) {
      _sequence = 102;
      return _reports = _seed();
    }
    _sequence = state['sequence'] as int;
    return _reports = [
      for (final report in state['reports'] as List<dynamic>)
        report as Map<String, dynamic>,
    ];
  }

  Future<void> _persist() =>
      _store.save({'reports': _reports, 'sequence': _sequence});

  /// Demo hesabının geçmiş iki raporu (biri sonuçlanmış).
  static List<Map<String, dynamic>> _seed() => [
    {
      'id': 'rpt_seed_0001',
      'referenceCode': 'SK-2026-000101',
      'ownerId': 'usr_demo_001',
      'monumentId': 'kizlaragasi-hani',
      'category': 'vandalism',
      'urgency': 'medium',
      'description':
          'Avluya açılan doğu kapısının sağındaki taş duvarda sprey boyayla '
          'yazılar var. Yaklaşık iki metrelik bir alanı kaplıyor.',
      'photos': <Map<String, dynamic>>[],
      'locationCheck': {'verification': 'onSite', 'distanceMeters': 18},
      'createdAt': '2026-09-14T08:20:00Z',
      'history': [
        {'status': 'received', 'at': '2026-09-14T08:20:00Z'},
        {'status': 'inReview', 'at': '2026-09-14T09:05:00Z'},
        {'status': 'forwarded', 'at': '2026-09-15T07:40:00Z'},
        {
          'status': 'resolved',
          'at': '2026-09-29T13:10:00Z',
          'note':
              'Duvar yüzeyi uzman ekip tarafından taş dokusuna zarar '
              'vermeden temizlendi. Bildiriminiz için teşekkür ederiz.',
        },
      ],
    },
    {
      'id': 'rpt_seed_0002',
      'referenceCode': 'SK-2026-000102',
      'ownerId': 'usr_demo_001',
      'monumentId': 'bursa-ulu-camii',
      'category': 'structuralDamage',
      'urgency': 'high',
      'description':
          'Kuzey cephedeki pencere kemerinin üstünde son haftalarda belirgin '
          'şekilde büyüyen bir çatlak var; altına taş kırıntıları düşmüş.',
      'photos': <Map<String, dynamic>>[],
      'locationCheck': {'verification': 'notProvided'},
      'createdAt': '2026-10-10T15:45:00Z',
      'history': [
        {'status': 'received', 'at': '2026-10-10T15:45:00Z'},
        {'status': 'inReview', 'at': '2026-10-11T08:30:00Z'},
      ],
    },
  ];

  String _randomHex(int bytes) => [
    for (var i = 0; i < bytes; i++)
      _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ].join();
}
