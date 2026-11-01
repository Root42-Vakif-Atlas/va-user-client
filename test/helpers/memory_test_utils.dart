import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:image/image.dart' as img;
import 'package:vakif_atlas/core/events/user_activity_events.dart';
import 'package:vakif_atlas/core/media/photo_draft.dart';
import 'package:vakif_atlas/core/media/photo_picker_service.dart';
import 'package:vakif_atlas/core/media/photo_processor.dart';
import 'package:vakif_atlas/features/memory_corner/data/repositories/memory_repository_impl.dart';
import 'package:vakif_atlas/features/memory_corner/data/sources/memory_remote_data_source.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/domain/usecases/memory_usecases.dart';

import '../support/mock_api/auth/auth_mock_api.dart';
import '../support/mock_api/auth/mock_user_store.dart';
import '../support/mock_api/memory_corner/memory_mock_api.dart';
import '../support/mock_api/memory_corner/mock_memory_store.dart';
import '../support/mock_api/mock_mailbox.dart';
import 'network_test_utils.dart';

/// Testlerde sabit "şimdi" (mock anıların tarihlerinden sonra).
final DateTime memoryTestNow = DateTime.utc(2026, 10, 18, 12);

/// Mock Memory API'ye süreç içinde bağlı ortam: gerçek repository, DTO
/// ayrıştırma ve sunucu kuralları uçtan uca çalışır. [signIn] ile Bearer
/// anahtarı alınır (gerçek uygulamada `AuthInterceptor` ekler).
final class MemoryTestEnvironment {
  factory MemoryTestEnvironment({
    Map<String, dynamic>? initialState,
    DateTime Function()? clock,
  }) {
    final now = clock ?? (() => memoryTestNow);
    final mailbox = MockMailbox();
    final auth = AuthMockApi.withClock(
      store: InMemoryMockUserStore(),
      mailbox: mailbox,
      clock: now,
    );
    final api = MemoryMockApi.withClock(
      store: InMemoryMockMemoryStore(initialState),
      auth: auth,
      clock: now,
    );
    final dio = testDio([...auth.routes, ...api.routes]);
    final environment = MemoryTestEnvironment._(
      dio,
      auth,
      api,
      MemoryRepositoryImpl(
        MemoryRemoteDataSourceImpl(dio, dio),
        UserActivityEvents(),
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final authorization = environment.lastAuthorization;
          if (authorization != null && !options.path.startsWith('auth/')) {
            options.headers['Authorization'] = authorization;
          }
          handler.next(options);
        },
      ),
    );
    mailbox.emails.listen((email) {
      final code = email.code;
      if (code != null) {
        environment._codes.add(code);
      }
    });
    return environment;
  }

  MemoryTestEnvironment._(this.dio, this.auth, this.api, this.repository);

  final Dio dio;
  final AuthMockApi auth;
  final MemoryMockApi api;
  final MemoryRepositoryImpl repository;
  String? _token;

  /// Oturum açıksa `Bearer <anahtar>`.
  String? get lastAuthorization => _token == null ? null : 'Bearer $_token';

  void _setToken(String? token) => _token = token;

  /// Demo hesabıyla (Ayşe Yılmaz, `usr_demo_001`) giriş yapar.
  Future<void> signIn() async {
    final response = await dio.post<Map<String, dynamic>>(
      'auth/login',
      data: {
        'email': AuthMockApi.demoEmail,
        'password': AuthMockApi.demoPassword,
      },
    );
    _setToken(response.data!['accessToken'] as String);
  }

  /// Yeni bir hesap kaydedip doğrular ve onunla giriş yapar.
  Future<String> signInAs(String displayName, String email) async {
    _setToken(null);
    await dio.post<void>(
      'auth/register',
      data: {
        'displayName': displayName,
        'email': email,
        'password': 'uzun-ve-guvenli-sifre-2026',
        'consents': {'acceptedTerms': true, 'acknowledgedPrivacyNotice': true},
      },
    );
    final code = _lastCode!;
    final response = await dio.post<Map<String, dynamic>>(
      'auth/verify-email',
      data: {
        'email': email,
        'code': code,
        'password': 'uzun-ve-guvenli-sifre-2026',
      },
    );
    _setToken(response.data!['accessToken'] as String);
    return (response.data!['user'] as Map<String, dynamic>)['id'] as String;
  }

  String? get _lastCode => _codes.isEmpty ? null : _codes.last;
  final List<String> _codes = [];

  void signOut() => _setToken(null);

  ({
    GetMemoriesUseCase get,
    GetMyMemoriesUseCase mine,
    CreateMemoryUseCase create,
    DeleteMemoryUseCase delete,
    ReportMemoryUseCase report,
    WatchMemoryChangesUseCase watch,
  })
  get useCases => (
    get: GetMemoriesUseCase(repository),
    mine: GetMyMemoriesUseCase(repository),
    create: CreateMemoryUseCase(repository, clock: () => memoryTestNow),
    delete: DeleteMemoryUseCase(repository),
    report: ReportMemoryUseCase(repository),
    watch: WatchMemoryChangesUseCase(repository),
  );
}

/// Gerçek bir JPEG (isteğe bağlı EXIF/GPS ile).
Uint8List testJpeg({int width = 64, int height = 48, img.ExifData? exif}) {
  final image = img.Image(width: width, height: height)
    ..clear(img.ColorRgb8(120, 160, 140));
  if (exif != null) {
    image.exif = exif;
  }
  return img.encodeJpg(image);
}

PhotoDraft testPhotoDraft({
  String localId = 'photo_1',
  String description = '',
  int width = 64,
  int height = 48,
}) => PhotoDraft(
  localId: localId,
  bytes: testJpeg(width: width, height: height),
  width: width,
  height: height,
  description: description,
);

Memory testMemory({
  String id = 'mem_1',
  String monumentId = 'selimiye-camii',
  String authorId = 'usr_other',
  String authorName = 'Mehmet K.',
  String text = 'Kubbenin altında uzun süre oturduk.',
  List<MemoryPhoto> photos = const [],
  DateTime? createdAt,
  DateTime? visitedOn,
}) => Memory(
  id: id,
  monumentId: monumentId,
  author: MemoryAuthor(id: authorId, displayName: authorName),
  text: text,
  photos: photos,
  createdAt: createdAt ?? DateTime.utc(2026, 10, 12, 16, 40),
  visitedOn: visitedOn,
);

/// [count] anılık yapay veri (yalnızca sayfalama testleri): en yeni önce
/// sıralandığında numara sırası korunur.
Map<String, dynamic> syntheticMemoryState(
  int count, {
  String monumentId = 'selimiye-camii',
}) => {
  'memories': [
    for (var i = 0; i < count; i++)
      {
        'id': 'mem_test_${i.toString().padLeft(3, '0')}',
        'monumentId': monumentId,
        'author': {'id': 'usr_seed_$i', 'displayName': 'Ziyaretçi $i'},
        'text': 'Test anısı $i',
        'photos': <Map<String, dynamic>>[],
        'createdAt': DateTime.utc(
          2026,
          1,
          1,
        ).add(Duration(hours: count - i)).toIso8601String(),
        'status': 'approved',
      },
  ],
  'reports': <String, dynamic>{},
};

/// Sonuçları sırayla döndüren sahte fotoğraf seçici.
class FakePhotoPickerService implements PhotoPickerService {
  FakePhotoPickerService({this.supportsCamera = true});

  @override
  final bool supportsCamera;

  final List<PhotoPickResult> results = [];
  final List<({PhotoSource source, int limit})> requests = [];

  @override
  Future<PhotoPickResult> pick(PhotoSource source, {required int limit}) async {
    requests.add((source: source, limit: limit));
    return results.isEmpty ? const PhotosPicked([]) : results.removeAt(0);
  }
}

/// İsolate kullanmadan fotoğrafı "hazırlar"; boş bayt çözümlenemez kabul
/// edilir.
class FakePhotoProcessor extends PhotoProcessor {
  const FakePhotoProcessor();

  @override
  Future<ProcessedPhoto?> process(Uint8List bytes) async => bytes.isEmpty
      ? null
      : ProcessedPhoto(bytes: bytes, width: 800, height: 600);
}

/// "Anılarım" testleri: demo hesabının (`usr_demo_001`) [ownCount] anısı
/// (her biri bir saat arayla, farklı eserlerde) + başka bir kullanıcının
/// anısı. [reportedOwnId] üç farklı kullanıcı tarafından bildirilmiştir
/// (herkese gizli, sahibine görünür).
Map<String, dynamic> ownMemoryState(
  int ownCount, {
  List<String> monumentIds = const [
    'selimiye-camii',
    'suleymaniye-camii',
    'bursa-ulu-camii',
  ],
  String? reportedOwnId,

  /// Kendi anılarının moderasyon durumu (varsayılan `approved`; ADR 58).
  Map<String, String> statuses = const {},
}) => {
  'memories': [
    for (var i = 0; i < ownCount; i++)
      {
        'id': 'mem_own_${i.toString().padLeft(3, '0')}',
        'monumentId': monumentIds[i % monumentIds.length],
        'author': {'id': 'usr_demo_001', 'displayName': 'Ayşe Y.'},
        'text': 'Benim anım $i',
        'photos': <Map<String, dynamic>>[],
        'createdAt': DateTime.utc(
          2026,
          10,
          1,
        ).add(Duration(hours: i)).toIso8601String(),
        'status':
            statuses['mem_own_${i.toString().padLeft(3, '0')}'] ?? 'approved',
      },
    {
      'id': 'mem_other_001',
      'monumentId': 'selimiye-camii',
      'author': {'id': 'usr_other', 'displayName': 'Mehmet K.'},
      'text': 'Başkasının anısı',
      'photos': <Map<String, dynamic>>[],
      'createdAt': DateTime.utc(2026, 10, 15).toIso8601String(),
      'status': 'approved',
    },
  ],
  'reports': <String, dynamic>{
    'mem_other_001': <String>[],
    ?reportedOwnId: ['usr_a', 'usr_b', 'usr_c'],
  },
};
