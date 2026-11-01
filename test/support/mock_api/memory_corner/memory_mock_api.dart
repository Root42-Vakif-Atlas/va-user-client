import 'dart:convert';
import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:vakif_atlas/core/media/photo_draft.dart';
import 'package:vakif_atlas/features/memory_corner/data/dtos/memory_dtos.dart';
import 'package:vakif_atlas/features/memory_corner/data/sources/memory_remote_data_source.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';

import '../auth/auth_mock_api.dart';
import '../catalog/catalog_fixtures.dart';
import '../gamification/mock_activity_ledger.dart';
import '../mock_api.dart';
import '../mock_photo_storage.dart';
import 'memory_fixtures.dart';
import 'mock_memory_store.dart';
import 'mock_moderation_scorer.dart';

/// Memory mikro servisinin mock implementasyonu (`docs/api-contracts.md`
/// → Anı Köşesi).
///
/// - Liste herkese açıktır; Bearer varsa bildirdiği anılar kullanıcıya
///   gösterilmez. [hideAfterReports] farklı kullanıcının bildirdiği anı
///   inceleme bitene kadar herkese gizlenir.
/// - Paylaşma iki adımlıdır: ön imzalı yükleme adresi
///   (`memories/photo-uploads`) → `PUT` → `POST memories`. Mock depo
///   fotoğrafı `data:` adresi olarak döndürür (gerçek serviste CDN).
/// - YZ moderasyonu (ADR 58) paylaşım yanıtında karar verir:
///   [MockModerationScorer] skoruna göre `approved` / `pending` (VGM
///   incelemesi) / `rejected`. Herkese açık listede yalnızca `approved`
///   görünür; oyunlaştırma yalnızca yayında olanı sayar.
class MemoryMockApi implements MockApi {
  MemoryMockApi(MockMemoryStore store, AuthMockApi auth)
    : this.withClock(store: store, auth: auth, clock: DateTime.now);

  /// Uygulamada: paylaşılan anılar oyunlaştırma defterine yazılır (gerçek
  /// sistemde moderasyon onayı sonrası `MemoryPublished` olayı).
  MemoryMockApi.withLedger(
    MockMemoryStore store,
    AuthMockApi auth,
    MockActivityLedger ledger,
  ) : this.withClock(
        store: store,
        auth: auth,
        clock: DateTime.now,
        ledger: ledger,
      );

  MemoryMockApi.withClock({
    required this._store,
    required this._auth,
    required DateTime Function() clock,
    Random? random,
    this._ledger,
  }) : _now = clock,
       _random = random ?? Random.secure() {
    _auth.addAccountDeletionListener(_deleteAccountData);
  }

  final MockMemoryStore _store;
  final MockActivityLedger? _ledger;
  final AuthMockApi _auth;
  final DateTime Function() _now;
  final Random _random;

  static const int defaultLimit = 20;
  static const int maxLimit = 50;
  static const int hideAfterReports = 3;

  /// Kullanıcı başına saatlik paylaşım sınırı (spam koruması).
  static const int maxMemoriesPerHour = 10;

  List<Map<String, dynamic>>? _memories;
  Map<String, Set<String>>? _reports;
  late final MockPhotoStorage _storage = MockPhotoStorage(
    bucket: 'memory-photos',
    clock: _now,
    random: _random,
  );

  @override
  List<MockRoute> get routes => [
    MockRoute('GET', MemoryEndpoints.memories, _list),
    MockRoute('GET', MemoryEndpoints.mine, _mine),
    MockRoute('POST', MemoryEndpoints.memories, _create),
    MockRoute('POST', MemoryEndpoints.photoUploads, _requestUpload),
    ..._storage.routes,
    MockRoute('DELETE', '${MemoryEndpoints.memories}/:id', _delete),
    MockRoute('POST', '${MemoryEndpoints.memories}/:id/reports', _report),
  ];

  // ── Okuma ───────────────────────────────────────────────────────────────

  Future<MockResponse> _list(MockRequest request) async {
    final query = request.queryParameters;
    final monumentId = query['monumentId'];
    final limit = int.tryParse(query['limit'] ?? '$defaultLimit');
    final DateTime? from;
    final DateTime? to;
    try {
      from = CalendarDateJson.parse(query['from']);
      to = CalendarDateJson.parse(query['to']);
    } on FormatException {
      return MockResponse.error(400, 'invalid_request');
    }
    if (monumentId == null ||
        monumentId.isEmpty ||
        limit == null ||
        limit < 1 ||
        limit > maxLimit ||
        (from != null && to != null && from.isAfter(to))) {
      return MockResponse.error(400, 'invalid_request');
    }
    final viewer = await _auth.accountFor(request);
    final reports = await _loadReports();
    final visible = [
      for (final memory in await _loadMemories())
        if (memory['monumentId'] == monumentId &&
            memory['status'] == 'approved' &&
            (reports[memory['id']]?.length ?? 0) < hideAfterReports &&
            !(viewer != null &&
                (reports[memory['id']]?.contains(viewer.id) ?? false)))
          _withMemoryDate(memory),
    ];
    // Yıl sayıları tarih filtresinden bağımsızdır (seçili olmayan yıllar da
    // sayısıyla görünür).
    final years = <int, int>{};
    for (final memory in visible) {
      final year = int.parse((memory['memoryDate'] as String).substring(0, 4));
      years[year] = (years[year] ?? 0) + 1;
    }
    final fromKey = CalendarDateJson.format(from);
    final toKey = CalendarDateJson.format(to);
    final filtered = [
      for (final memory in visible)
        if ((fromKey == null ||
                (memory['memoryDate'] as String).compareTo(fromKey) >= 0) &&
            (toKey == null ||
                (memory['memoryDate'] as String).compareTo(toKey) <= 0))
          memory,
    ]..sort(_timelineOrder);

    var start = 0;
    final cursor = query['cursor'];
    if (cursor != null) {
      final position = _decodeCursor(cursor);
      if (position == null) {
        return MockResponse.error(400, 'invalid_cursor');
      }
      // Keyset: imleçteki kayıttan sonra gelen ilk kayıt (silinse de çalışır).
      start = filtered.indexWhere(
        (memory) => _timelineOrder(memory, position) > 0,
      );
      if (start < 0) {
        start = filtered.length;
      }
    }
    final page = filtered.skip(start).take(limit).toList();
    final hasMore = start + page.length < filtered.length;
    return MockResponse.ok({
      'items': page,
      'total': filtered.length,
      'nextCursor': hasMore ? _encodeCursor(page.last) : null,
      if (query['include'] == 'facets')
        'facets': {
          'years': [
            for (final year in years.keys.toList()..sort((a, b) => b - a))
              {'year': year, 'count': years[year]},
          ],
        },
    });
  }

  /// Kullanıcının kendi anıları: tüm durumlar, bildirilerek başkalarına
  /// gizlenmiş olanlar dahil; en son paylaşılan önce (`createdAt|id`).
  Future<MockResponse> _mine(MockRequest request) async {
    final account = await _auth.accountFor(request);
    if (account == null) {
      return MockResponse.error(401, 'unauthorized');
    }
    final query = request.queryParameters;
    final limit = int.tryParse(query['limit'] ?? '$defaultLimit');
    if (limit == null || limit < 1 || limit > maxLimit) {
      return MockResponse.error(400, 'invalid_request');
    }
    final own = [
      for (final memory in await _loadMemories())
        if ((memory['author'] as Map<String, dynamic>)['id'] == account.id)
          _withMemoryDate(memory),
    ]..sort(_sharedOrder);
    var start = 0;
    final cursor = query['cursor'];
    if (cursor != null) {
      final position = _decodeCursor(cursor);
      if (position == null) {
        return MockResponse.error(400, 'invalid_cursor');
      }
      start = own.indexWhere((memory) => _sharedOrder(memory, position) > 0);
      if (start < 0) {
        start = own.length;
      }
    }
    final page = own.skip(start).take(limit).toList();
    final hasMore = start + page.length < own.length;
    return MockResponse.ok({
      'items': page,
      'total': own.length,
      'nextCursor': hasMore ? _encodeCursor(page.last) : null,
    });
  }

  /// Anı tarihi: ziyaret günü, yoksa paylaşım günü (Türkiye saati, UTC+3).
  static Map<String, dynamic> _withMemoryDate(Map<String, dynamic> memory) {
    final visited = memory['visitedOn'] as String?;
    final created = DateTime.parse(memory['createdAt'] as String)
        .toUtc()
        .add(_turkeyOffset);
    return {
      ...memory,
      'memoryDate':
          visited ??
          CalendarDateJson.format(
            DateTime(created.year, created.month, created.day),
          ),
    };
  }

  static const Duration _turkeyOffset = Duration(hours: 3);

  // ── Fotoğraf yükleme ────────────────────────────────────────────────────

  Future<MockResponse> _requestUpload(MockRequest request) async {
    final account = await _auth.accountFor(request);
    if (account == null) {
      return MockResponse.error(401, 'unauthorized');
    }
    return _storage.issueTicket(
      ownerId: account.id,
      body: request.body,
      maxBytes: MemoryRules.maxPhotoBytes,
    );
  }

  // ── Paylaşma ────────────────────────────────────────────────────────────

  Future<MockResponse> _create(MockRequest request) async {
    final account = await _auth.accountFor(request);
    if (account == null) {
      return MockResponse.error(401, 'unauthorized');
    }
    final body = _parse(request.body, CreateMemoryRequestDto.fromJson);
    if (body == null) {
      return MockResponse.error(400, 'invalid_memory');
    }

    final memories = await _loadMemories();
    final hourAgo = _now().subtract(const Duration(hours: 1));
    final recent = memories.where(
      (memory) =>
          (memory['author'] as Map<String, dynamic>)['id'] == account.id &&
          DateTime.parse(memory['createdAt'] as String).isAfter(hourAgo),
    );
    if (recent.length >= maxMemoriesPerHour) {
      return const MockResponse(
        429,
        body: {'code': 'too_many_requests', 'retryAfter': 3600},
      );
    }

    final monumentExists = CatalogFixtures.monuments.any(
      (monument) => monument.id == body.monumentId,
    );
    final uploadIds = [for (final photo in body.photos) photo.uploadId];
    final uploads = _storage.claim(uploadIds, account.id);
    final DateTime? visitedOn;
    try {
      visitedOn = CalendarDateJson.parse(body.visitedOn);
    } on FormatException {
      return MockResponse.error(400, 'invalid_memory');
    }
    final draftIssue = MemoryRules.validate(
      MemoryDraft(
        monumentId: body.monumentId,
        text: body.text,
        visitedOn: visitedOn,
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
      today: _now(),
    );
    if (!monumentExists || uploads == null || draftIssue != null) {
      return MockResponse.error(400, 'invalid_memory');
    }

    final record = <String, dynamic>{
      'id': 'mem_${_randomHex(12)}',
      'monumentId': body.monumentId,
      'author': {
        'id': account.id,
        'displayName': MemoryRules.publicDisplayName(account.displayName),
      },
      'text': body.text.trim(),
      'photos': [
        for (var i = 0; i < uploads.length; i++)
          MockPhotoStorage.photoJson(
            uploads[i],
            description: body.photos[i].description,
          ),
      ],
      'createdAt': _now().toUtc().toIso8601String(),
      'visitedOn': ?body.visitedOn,
      'status': MockModerationScorer.statusFor([
        body.text,
        for (final photo in body.photos) ?photo.description,
      ]),
    };
    _storage.release(uploadIds);
    memories.add(record);
    await _persist();
    if (record['status'] == 'approved') {
      await _ledger?.recordFor(
        request,
        kind: MockActivityKind.memoryShared,
        refId: record['id'] as String,
        monumentIds: [body.monumentId],
      );
    }
    return MockResponse(201, body: _withMemoryDate(record));
  }

  // ── Silme ve bildirme ───────────────────────────────────────────────────

  Future<MockResponse> _delete(MockRequest request) async {
    final account = await _auth.accountFor(request);
    if (account == null) {
      return MockResponse.error(401, 'unauthorized');
    }
    final memories = await _loadMemories();
    final id = request.pathParameters['id'];
    final index = memories.indexWhere(
      (memory) =>
          memory['id'] == id &&
          (memory['author'] as Map<String, dynamic>)['id'] == account.id,
    );
    // Başkasının anısı da 404 döner (varlığı ve sahibi sızdırılmaz).
    if (index < 0) {
      return MockResponse.error(404, 'not_found');
    }
    memories.removeAt(index);
    (await _loadReports()).remove(id);
    await _persist();
    return const MockResponse.noContent();
  }

  Future<MockResponse> _report(MockRequest request) async {
    final account = await _auth.accountFor(request);
    if (account == null) {
      return MockResponse.error(401, 'unauthorized');
    }
    final id = request.pathParameters['id'];
    final memory = (await _loadMemories())
        .where((memory) => memory['id'] == id)
        .firstOrNull;
    if (memory == null) {
      return MockResponse.error(404, 'not_found');
    }
    if ((memory['author'] as Map<String, dynamic>)['id'] == account.id) {
      return MockResponse.error(400, 'cannot_report_own');
    }
    final report = _parse(request.body, MemoryReportRequestDto.fromJson);
    if (report == null) {
      return MockResponse.error(400, 'invalid_report');
    }
    if ((report.note?.runes.length ?? 0) > MemoryRules.maxReportNoteLength) {
      return MockResponse.error(400, 'invalid_report');
    }
    // Aynı kullanıcının tekrar bildirimi sayılmaz (idempotent).
    (await _loadReports()).putIfAbsent(id!, () => {}).add(account.id);
    await _persist();
    return const MockResponse(202);
  }

  /// Hesap silindiğinde kullanıcının anıları ve bildirimleri silinir.
  Future<void> _deleteAccountData(String userId) async {
    final memories = await _loadMemories();
    final removed = {
      for (final memory in memories)
        if ((memory['author'] as Map<String, dynamic>)['id'] == userId)
          memory['id'] as String,
    };
    memories.removeWhere((memory) => removed.contains(memory['id']));
    final reports = await _loadReports();
    removed.forEach(reports.remove);
    for (final reporters in reports.values) {
      reporters.remove(userId);
    }
    _storage.removeOwner(userId);
    await _persist();
  }

  // ── Yardımcılar ─────────────────────────────────────────────────────────

  /// Gövde beklenen JSON nesnesi değilse veya alanlar geçersizse `null`.
  static T? _parse<T>(
    Object? body,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    if (body is! Map<String, dynamic>) {
      return null;
    }
    try {
      return fromJson(body);
    } on CheckedFromJsonException {
      return null;
    }
  }

  /// Anı tarihi, sonra paylaşım zamanı, sonra kimlik — en yeni önce.
  static int _timelineOrder(Map<String, dynamic> a, Map<String, dynamic> b) {
    final byDay = (b['memoryDate'] as String).compareTo(
      a['memoryDate'] as String,
    );
    if (byDay != 0) {
      return byDay;
    }
    final byTime = DateTime.parse(b['createdAt'] as String)
        .compareTo(DateTime.parse(a['createdAt'] as String));
    return byTime != 0
        ? byTime
        : (b['id'] as String).compareTo(a['id'] as String);
  }

  /// Paylaşım zamanı, sonra kimlik — en yeni önce ("Anılarım").
  static int _sharedOrder(Map<String, dynamic> a, Map<String, dynamic> b) {
    final byTime = DateTime.parse(b['createdAt'] as String)
        .compareTo(DateTime.parse(a['createdAt'] as String));
    return byTime != 0
        ? byTime
        : (b['id'] as String).compareTo(a['id'] as String);
  }

  static String _encodeCursor(Map<String, dynamic> memory) => base64Url
      .encode(
        utf8.encode(
          '${memory['memoryDate']}|${memory['createdAt']}|${memory['id']}',
        ),
      )
      .replaceAll('=', '');

  static Map<String, dynamic>? _decodeCursor(String cursor) {
    try {
      final parts = utf8
          .decode(base64Url.decode(base64Url.normalize(cursor)))
          .split('|');
      if (parts.length != 3) {
        return null;
      }
      CalendarDateJson.parse(parts[0]);
      DateTime.parse(parts[1]);
      return {'memoryDate': parts[0], 'createdAt': parts[1], 'id': parts[2]};
    } on FormatException {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> _loadMemories() async {
    await _load();
    return _memories!;
  }

  Future<Map<String, Set<String>>> _loadReports() async {
    await _load();
    return _reports!;
  }

  Future<void> _load() async {
    if (_memories != null) {
      return;
    }
    final state = await _store.load();
    if (state == null) {
      _memories = MemoryFixtures.memories;
      _reports = {};
      return;
    }
    _memories = [
      for (final memory in state['memories'] as List<dynamic>)
        memory as Map<String, dynamic>,
    ];
    _reports = {
      for (final MapEntry(:key, :value)
          in (state['reports'] as Map<String, dynamic>).entries)
        key: {for (final user in value as List<dynamic>) user as String},
    };
  }

  Future<void> _persist() => _store.save({
    'memories': _memories,
    'reports': {
      for (final MapEntry(:key, :value) in _reports!.entries)
        key: value.toList(),
    },
  });

  String _randomHex(int bytes) => [
    for (var i = 0; i < bytes; i++)
      _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ].join();
}
