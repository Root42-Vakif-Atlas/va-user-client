// Gerçek backend'e karşı sözleşme doğrulaması: uygulamanın kendi remote data
// source'ları ve DTO'ları (mock'ta kullanılanlarla aynı) çalışan bir sunucuya
// istek atar, yanıtları ayrıştırıp domain nesnelerine çevirir.
//
// Önkoşul: backend çalışıyor (`backend/deploy/compose`, http://localhost:8080/v1/).
//   flutter test tool/backend_contract_check_test.dart
//   flutter test tool/backend_contract_check_test.dart --dart-define=API=https://api.staging.vakifatlas.gov.tr/v1/
//
// `test/` dışında olduğundan normal `flutter test` çalıştırmasına dahil değildir.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/map/map_tiles.dart';
import 'package:vakif_atlas/core/storage/installation_id_service.dart';
import 'package:vakif_atlas/features/ai_assistant/data/dtos/guide_dtos.dart';
import 'package:vakif_atlas/features/ai_assistant/data/sources/digital_guide_remote_data_source.dart';
import 'package:vakif_atlas/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:vakif_atlas/features/auth/domain/entities/legal_document.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/monument_dtos.dart';
import 'package:vakif_atlas/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:vakif_atlas/features/catalog/data/sources/catalog_local_data_source.dart';
import 'package:vakif_atlas/features/catalog/data/sources/catalog_remote_data_source.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_filter.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/civil_protection/data/dtos/damage_report_dtos.dart';
import 'package:vakif_atlas/features/civil_protection/data/sources/damage_report_remote_data_source.dart';
import 'package:vakif_atlas/features/feedback/data/dtos/feedback_dtos.dart';
import 'package:vakif_atlas/features/feedback/data/sources/feedback_remote_data_source.dart';
import 'package:vakif_atlas/features/gamification/data/sources/gamification_remote_data_source.dart';
import 'package:vakif_atlas/features/memory_corner/data/dtos/memory_dtos.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/data/sources/memory_remote_data_source.dart';
import 'package:vakif_atlas/features/route_export/data/dtos/route_export_dtos.dart';
import 'package:vakif_atlas/features/route_export/data/sources/route_export_remote_data_source.dart';
import 'package:vakif_atlas/features/route_planner/data/dtos/route_dtos.dart';
import 'package:vakif_atlas/features/route_planner/data/sources/route_remote_data_source.dart';
import 'package:vakif_atlas/features/saved_monuments/data/dtos/saved_monument_dtos.dart';
import 'package:vakif_atlas/features/saved_monuments/data/sources/saved_monuments_remote_data_source.dart';

const String _api = String.fromEnvironment(
  'API',
  defaultValue: 'http://localhost:8080/v1/',
);
const String _demoEmail = 'vatandas@vakifatlas.dev';
const String _demoPassword = 'Atlas2026!';

/// Kurulum kimliği sabit (rotalar cihaza bağlıdır).
final class _FixedInstallation implements InstallationIdService {
  _FixedInstallation(this._id);

  final String _id;

  @override
  Future<String> resolve() async => _id;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Uygulamadaki `AuthInterceptor`'ın sadeleştirilmiş hali: oturum anahtarı ve dil.
final class _Session extends Interceptor {
  String? accessToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] ??= 'tr';
    final skip = options.extra['skipAuth'] == true;
    if (!skip && accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }
}

/// 8×8 gri JPEG (sunucu yeniden kodlar).
final Uint8List _jpeg = Uint8List.fromList(
  // ignore: lines_longer_than_80_chars
  const [
    255,
    216,
    255,
    224,
    0,
    16,
    74,
    70,
    73,
    70,
    0,
    1,
    1,
    0,
    0,
    1,
    0,
    1,
    0,
    0,
    255,
    219,
    0,
    67,
    0,
    8,
    6,
    6,
    7,
    6,
    5,
    8,
    7,
    7,
    7,
    9,
    9,
    8,
    10,
    12,
    20,
    13,
    12,
    11,
    11,
    12,
    25,
    18,
    19,
    15,
    20,
    29,
    26,
    31,
    30,
    29,
    26,
    28,
    28,
    32,
    36,
    46,
    39,
    32,
    34,
    44,
    35,
    28,
    28,
    40,
    55,
    41,
    44,
    48,
    49,
    52,
    52,
    52,
    31,
    39,
    57,
    61,
    56,
    50,
    60,
    46,
    51,
    52,
    50,
    255,
    192,
    0,
    11,
    8,
    0,
    8,
    0,
    8,
    1,
    1,
    17,
    0,
    255,
    196,
    0,
    20,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    8,
    255,
    196,
    0,
    20,
    16,
    1,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    255,
    218,
    0,
    8,
    1,
    1,
    0,
    0,
    63,
    0,
    84,
    223,
    255,
    217,
  ],
);

/// Önbelleksiz katalog (repository'nin külliye geri dönüşünü denemek için).
final class _NoCache implements CatalogLocalDataSource {
  @override
  Future<MonumentDetailDto?> readMonumentDetail(String id, String lang) async =>
      null;

  @override
  Future<void> saveMonumentDetail(String lang, MonumentDetailDto m) async {}
}

/// Veri yokluğundan denenemeyen bölüm (hata değil; çıktıda listelenir).
void _skip(String section, String reason) =>
    // ignore: avoid_print
    print('ATLANDI $section: $reason');

/// Başarısız isteğin yöntemini, adresini ve gövdesini yazar.
final class _FailureLog extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final request = err.requestOptions;
    // ignore: avoid_print
    print(
      'HATA ${request.method} ${request.uri} → '
      '${err.response?.statusCode} ${err.response?.data}',
    );
    handler.next(err);
  }
}

void main() {
  // flutter_test HTTP'yi engeller; bu araç gerçek sunucuya bağlanır.
  HttpOverrides.global = null;

  final session = _Session();
  final dio = Dio(
    BaseOptions(
      baseUrl: _api,
      contentType: Headers.jsonContentType,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  )..interceptors.addAll([session, _FailureLog()]);
  // Ön imzalı yüklemeler: Bearer ve uygulama başlıkları olmadan.
  final storageDio = Dio(BaseOptions(baseUrl: _api));

  final auth = AuthRemoteDataSourceImpl(dio);
  final catalog = CatalogRemoteDataSourceImpl(dio);
  final routes = RouteRemoteDataSourceImpl(
    dio,
    _FixedInstallation('6f1c8c8e-5e7a-4f55-9a3c-2b6f5d1e9a10'),
  );
  final memories = MemoryRemoteDataSourceImpl(dio, storageDio);
  final reports = DamageReportRemoteDataSourceImpl(dio, storageDio);
  final guide = DigitalGuideRemoteDataSourceImpl(dio);
  final gamification = GamificationRemoteDataSourceImpl(dio);
  final savedMonuments = SavedMonumentsRemoteDataSourceImpl(
    dio,
    _FixedInstallation('3d2a0f57-8c1b-4e6a-9f0d-6b7c8e9a1b2c'),
  );
  final feedback = FeedbackRemoteDataSourceImpl(dio);
  final exports = RouteExportRemoteDataSourceImpl(
    dio,
    storageDio,
    _FixedInstallation('3d2a0f57-8c1b-4e6a-9f0d-6b7c8e9a1b2c'),
  );
  final guestExports = RouteExportRemoteDataSourceImpl(
    dio,
    storageDio,
    _FixedInstallation('6f1e2d3c-4b5a-4c6d-8e7f-0a1b2c3d4e5f'),
  );

  test('backend, istemcinin DTO sözleşmesini karşılar', () async {
    // Kimlik doğrulama
    final login = await auth.login(email: _demoEmail, password: _demoPassword);
    session.accessToken = login.accessToken;
    expect(login.user?.email, _demoEmail);
    expect((await auth.fetchCurrentUser()).email, _demoEmail);
    final legal = LegalDocumentRemoteDataSourceImpl(dio);
    for (final type in LegalDocumentType.values) {
      try {
        final document = await legal.fetch(type, languageCode: 'tr');
        expect(document.body, isNotEmpty);
      } on DioException catch (error) {
        // Yasal metinler `seed/legal.json`'dan gelir; dosya yoksa 404.
        _skip('legal/documents/${type.name}', '${error.response?.statusCode}');
      }
    }

    // Katalog: arama + facet + yer, detay, karo, kapsam, anahtarla çözme.
    // Veri içe aktarılan VGM kayıtlarıdır: örnekler sorgu sonucundan seçilir.
    final firstPage = (await catalog.searchMonuments(
      query: MonumentSearchQuery.empty,
      languageCode: 'tr',
      limit: 50,
      includeExtras: true,
    )).toDomain();
    expect(firstPage.items, isNotEmpty, reason: 'katalog boş');
    expect(firstPage.facets.cities, isNotEmpty);
    final sample = firstPage.items.first;
    expect(sample.cityCode, isNotNull);
    final byCity = (await catalog.searchMonuments(
      query: MonumentSearchQuery(
        text: sample.name,
        filter: MonumentFilter(cities: {sample.cityCode!}),
      ),
      languageCode: 'tr',
      limit: 20,
      includeExtras: true,
    )).toDomain();
    expect(byCity.items.map((m) => m.id), contains(sample.id));
    expect(byCity.items.every((m) => m.cityCode == sample.cityCode), isTrue);
    final detail = (await catalog.fetchMonumentDetail(
      id: sample.id,
      languageCode: 'en',
    )).toDomain();
    expect(detail.id, sample.id);
    final extent = (await catalog.fetchMapExtent(
      query: MonumentSearchQuery.empty,
      languageCode: 'tr',
    )).toDomain();
    final pinIds = [for (final m in firstPage.items.take(2)) m.id];
    final pins = await catalog.fetchMonumentPins(
      ids: pinIds,
      languageCode: 'tr',
    );
    expect(pins.items.map((p) => p.toDomain().id).toSet(), pinIds.toSet());
    final located = [
      for (final m in firstPage.items)
        if (m.location != null) m,
    ];
    if (extent.bounds case final bounds?) {
      final center = bounds.center;
      final (mx, my) = MapTiles.project(center.latitude, center.longitude);
      final items = [
        for (final item in await catalog.fetchMapTile(
          tile: TileId(6, (mx * 64).floor(), (my * 64).floor()),
          query: MonumentSearchQuery.empty,
          version: extent.version,
          languageCode: 'tr',
        ))
          item.toDomain(),
      ];
      expect(items.nonNulls, hasLength(items.length));
    } else {
      _skip('catalog/map/tiles', 'konumlu eser yok (extent.total = 0)');
    }

    // Külliye: liste → detay + gömülü yapılar, yapı alt koleksiyonu; külliye
    // anahtarıyla eser detayı istenince külliye kaydı döner (harita önizlemesi).
    final complexes = await dio.get<Map<String, dynamic>>(
      CatalogEndpoints.complexes,
      queryParameters: {'limit': 50},
    );
    final complexItems = complexes.data!['items'] as List<dynamic>;
    final complexKey = complexItems.isEmpty
        ? null
        : (complexItems.first as Map<String, dynamic>)['key'] as String;
    if (complexKey != null) {
      final complex = (await catalog.fetchComplexDetail(
        id: complexKey,
        languageCode: 'tr',
      )).toDomain();
      expect(complex.id, complexKey);
      expect(complex.monument.isComplex, isTrue);
      expect(complex.members.items, isNotEmpty);
      expect(complex.members.items.first.complex?.id, complexKey);
      final members = (await catalog.fetchComplexMembers(
        id: complexKey,
        languageCode: 'tr',
        limit: 20,
      )).toDomain();
      expect(members.total, complex.memberCount);
      final category = members.items.first.category;
      final filtered = (await catalog.fetchComplexMembers(
        id: complexKey,
        languageCode: 'tr',
        limit: 20,
        categories: {category},
      )).toDomain();
      expect(filtered.items.every((m) => m.category == category), isTrue);
      final member = (await catalog.fetchMonumentDetail(
        id: members.items.first.id,
        languageCode: 'tr',
      )).toDomain();
      expect(member.complex?.id, complexKey);
      final asMonument = await CatalogRepositoryImpl(
        catalog,
        _NoCache(),
      ).getMonumentDetail(id: complexKey, languageCode: 'tr');
      expect(asMonument.fold((_) => null, (m) => m.isComplex), isTrue);
    } else {
      _skip('catalog/complexes', 'külliye yok');
    }

    // Rotalar (oturum açıkken oluşturma → oyunlaştırma); yalnızca konumlu
    // eserlerle kurulabilir.
    final routeStops = [for (final m in located.take(2)) m.id];
    final created = routeStops.length < 2
        ? null
        : await routes.createRoute(
            plan: RoutePlanRequestDto.fromJson({
              'name': 'Sözleşme kontrolü',
              'travelMode': 'driving',
              'stops': [
                for (final id in routeStops)
                  {'monumentId': id, 'visitMinutes': 60, 'breaks': <Object>[]},
              ],
            }),
            languageCode: 'tr',
          );
    if (created != null) {
      expect(created.toDomain().legs, hasLength(1));
      expect(await routes.fetchRoutes(languageCode: 'tr'), isNotEmpty);
      await routes.deleteRoute(id: created.id);

      // Oluşturucunun ön hesabı ve optimizasyon matrisi (bizim OSRM).
      final stopIds = routeStops;
      final preview = (await routes.previewRoute(monumentIds: stopIds))
          .toDomain(stopIds);
      expect(preview.legs, hasLength(stopIds.length - 1));
      expect(preview.distanceMeters, greaterThan(0));
      final matrix = (await routes.fetchTravelMatrix(monumentIds: stopIds))
          .toDomain(stopIds.length);
      expect(matrix.size, stopIds.length);
      expect(matrix.distances[0][1], preview.legs.first.distanceMeters);
    } else {
      _skip('routes', 'konumlu en az iki eser yok');
      expect(await routes.fetchRoutes(languageCode: 'tr'), isA<List<Object>>());
    }

    // Kaydedilen eserler (kuruluma bağlı küme)
    final saved = await savedMonuments.replace([
      SavedMonumentDto(
        monumentId: pinIds.first,
        savedAt: DateTime.utc(2026, 10, 19, 12),
      ),
      SavedMonumentDto(
        monumentId: pinIds.last,
        savedAt: DateTime.utc(2026, 10, 19, 12, 5),
      ),
    ]);
    expect(saved.map((item) => item.monumentId), [pinIds.last, pinIds.first]);
    expect(
      (await savedMonuments.fetch()).map((item) => item.toDomain()),
      saved.map((item) => item.toDomain()),
    );
    await savedMonuments.replace(const []);

    // Rota PDF arşivi (ön imzalı yükleme + SHA-256 + indirme)
    final pdf = Uint8List.fromList(
      utf8.encode('%PDF-1.4\n% Sözleşme kontrolü\n'),
    );
    final export = await exports.upload(
      RouteExportUploadRequestDto(
        routeId: created?.id ?? 'rt_contract_check',
        routeName: 'Sözleşme kontrolü',
        fileName: 'vakif-atlas-sozlesme.pdf',
        byteSize: pdf.length,
        stopCount: 2,
        sha256: sha256.convert(pdf).toString(),
      ),
      pdf,
    );
    expect(
      (await exports.fetchExports(limit: 50)).items.map((item) => item.id),
      contains(export.id),
    );
    expect(await exports.download(export.id), pdf);
    final link = await exports.createShareLink(export.id);
    expect(
      link.expiresAt.difference(DateTime.now()).inDays,
      inInclusiveRange(6, 7),
    );
    final shared = await storageDio.get<List<int>>(
      link.url,
      options: Options(responseType: ResponseType.bytes),
    );
    expect(shared.data, pdf);
    expect(shared.headers.value('content-disposition'), startsWith('inline'));
    await exports.delete(export.id);

    // Misafir dışa aktarımı kuruluma aittir; girişte hesaba taşınır.
    final token = session.accessToken;
    session.accessToken = null;
    final guestExport = await guestExports.upload(
      RouteExportUploadRequestDto(
        routeId: created?.id ?? 'rt_contract_check',
        routeName: 'Misafir dışa aktarımı',
        fileName: 'vakif-atlas-misafir.pdf',
        byteSize: pdf.length,
        stopCount: 2,
        sha256: sha256.convert(pdf).toString(),
      ),
      pdf,
    );
    expect(
      (await guestExports.fetchExports(limit: 50)).items.map((item) => item.id),
      [guestExport.id],
    );
    session.accessToken = token;
    expect(
      (await guestExports.fetchExports(limit: 50)).items.map((item) => item.id),
      contains(guestExport.id),
    );
    session.accessToken = null;
    expect((await guestExports.fetchExports(limit: 50)).items, isEmpty);
    session.accessToken = token;
    await guestExports.delete(guestExport.id);

    // Geri bildirim (oturum açık; sürüm ve platformla)
    await feedback.submit(
      const FeedbackRequestDto(
        category: 'suggestion',
        message: 'Sözleşme kontrolü',
        rating: 5,
        appVersion: '1.0.0+1',
        platform: 'android',
      ),
    );

    // Anı Köşesi: zaman çizelgesi + fotoğraflı paylaşım + Anılarım
    final timeline = await memories.fetchMemories(
      monumentId: sample.id,
      limit: 20,
      includeFacets: true,
    );
    expect(timeline.toDomain().items, isA<List<Object>>());
    final memoryTicket = await memories.requestPhotoUpload(
      PhotoUploadRequestDto.fromJson({
        'contentType': 'image/jpeg',
        'byteSize': _jpeg.length,
        'width': 8,
        'height': 8,
      }),
    );
    await memories.uploadPhoto(memoryTicket, _jpeg);
    final memory = await memories.createMemory(
      CreateMemoryRequestDto.fromJson({
        'monumentId': sample.id,
        'text': 'Sözleşme kontrolü anısı',
        'photos': [
          {'uploadId': memoryTicket.id, 'description': 'Kubbe'},
        ],
      }),
    );
    expect(memory.toDomain().photos, hasLength(1));
    // Fotoğraflı anı görsel moderasyonu nedeniyle incelemeye düşebilir.
    expect(memory.toDomain().status, isNot(MemoryModerationStatus.rejected));
    // YZ moderasyonu (ADR 58): karar paylaşım yanıtında; kaldırılan anı
    // yazarın listesinde "rejected" olarak görünür.
    final abusive = await memories.createMemory(
      CreateMemoryRequestDto.fromJson({
        'monumentId': sample.id,
        'text': 'Buraya gelen herkes aptal, salak turistler.',
        'photos': <Object>[],
      }),
    );
    expect(abusive.toDomain().status, MemoryModerationStatus.rejected);
    final mine = (await memories.fetchMyMemories(limit: 20)).toDomain().items;
    expect(
      mine.firstWhere((m) => m.id == abusive.id).status,
      MemoryModerationStatus.rejected,
    );
    await memories.deleteMemory(abusive.id);
    await memories.deleteMemory(memory.id);

    // Sivil Koruma
    final reportTicket = await reports.requestPhotoUpload(
      ReportPhotoUploadRequestDto.fromJson({
        'contentType': 'image/jpeg',
        'byteSize': _jpeg.length,
        'width': 8,
        'height': 8,
      }),
    );
    await reports.uploadPhoto(reportTicket, _jpeg);
    final report = await reports.submitReport(
      SubmitDamageReportRequestDto.fromJson({
        'monumentId': sample.id,
        'category': 'vandalism',
        'urgency': 'medium',
        'description': 'Sözleşme kontrolü: avlu duvarında yazılar var.',
        'photos': [
          {'uploadId': reportTicket.id},
        ],
        'location': {
          'latitude': 40.1826,
          'longitude': 29.0665,
          'accuracyMeters': 12,
        },
      }),
      languageCode: 'tr',
    );
    expect(report.toDomain().referenceCode, startsWith('SK-'));
    expect(
      (await reports.fetchReports(
        limit: 20,
        languageCode: 'tr',
      )).toDomain().items,
      isNotEmpty,
    );

    // Dijital Rehber
    final reply = await guide.ask(
      AskGuideRequestDto.fromJson({'message': '${sample.name} nerede?'}),
      languageCode: 'tr',
    );
    if (reply.toDomain().message.sources.isEmpty) {
      _skip('assistant/messages', 'yanıtta kaynak yok (rehber bilgi tabanı)');
    }
    await guide.deleteConversation(reply.conversationId);

    // Oyunlaştırma (katkılar olaylarla işlenir)
    await Future<void>.delayed(const Duration(seconds: 2));
    final profile = await gamification.getProfile(languageCode: 'tr');
    expect(profile.toDomain().xp, greaterThan(0));
  });
}
