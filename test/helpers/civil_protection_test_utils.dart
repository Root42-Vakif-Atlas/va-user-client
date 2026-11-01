import 'package:dio/dio.dart';
import 'package:vakif_atlas/core/events/user_activity_events.dart';
import 'package:vakif_atlas/core/location/location_service.dart';
import 'package:vakif_atlas/core/media/photo_attacher.dart';
import 'package:vakif_atlas/features/civil_protection/data/repositories/damage_report_repository_impl.dart';
import 'package:vakif_atlas/features/civil_protection/data/sources/damage_report_remote_data_source.dart';
import 'package:vakif_atlas/features/civil_protection/domain/usecases/damage_report_usecases.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/bloc/damage_report_wizard_bloc.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/cubit/damage_report_detail_cubit.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/cubit/damage_report_list_cubit.dart';

import '../support/mock_api/auth/auth_mock_api.dart';
import '../support/mock_api/auth/mock_user_store.dart';
import '../support/mock_api/civil_protection/civil_protection_mock_api.dart';
import '../support/mock_api/civil_protection/mock_damage_report_store.dart';
import '../support/mock_api/mock_mailbox.dart';
import 'catalog_test_utils.dart';
import 'location_test_utils.dart';
import 'memory_test_utils.dart';
import 'network_test_utils.dart';
import 'permission_test_utils.dart';

/// Mock Civil Protection API'ye süreç içinde bağlı ortam: gerçek
/// repository, DTO ayrıştırma ve sunucu kuralları uçtan uca çalışır.
final class CivilProtectionTestEnvironment {
  factory CivilProtectionTestEnvironment({DateTime Function()? clock}) {
    final now = clock ?? (() => memoryTestNow);
    final mailbox = MockMailbox();
    final auth = AuthMockApi.withClock(
      store: InMemoryMockUserStore(),
      mailbox: mailbox,
      clock: now,
    );
    final api = CivilProtectionMockApi.withClock(
      store: InMemoryMockDamageReportStore(),
      auth: auth,
      clock: now,
    );
    final dio = testDio([...auth.routes, ...api.routes]);
    final environment = CivilProtectionTestEnvironment._(
      dio,
      auth,
      api,
      DamageReportRepositoryImpl(
        DamageReportRemoteDataSourceImpl(dio, dio),
        UserActivityEvents(),
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = environment._token;
          if (token != null && !options.path.startsWith('auth/')) {
            options.headers['Authorization'] = 'Bearer $token';
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

  CivilProtectionTestEnvironment._(
    this.dio,
    this.auth,
    this.api,
    this.repository,
  );

  final Dio dio;
  final AuthMockApi auth;
  final CivilProtectionMockApi api;
  final DamageReportRepositoryImpl repository;
  String? _token;
  final List<String> _codes = [];

  /// Demo hesabıyla (iki geçmiş raporu olan `usr_demo_001`) giriş yapar.
  Future<void> signIn() async {
    final response = await dio.post<Map<String, dynamic>>(
      'auth/login',
      data: {
        'email': AuthMockApi.demoEmail,
        'password': AuthMockApi.demoPassword,
      },
    );
    _token = response.data!['accessToken'] as String;
  }

  /// Yeni bir hesap kaydedip doğrular ve onunla giriş yapar.
  Future<void> signInAs(String displayName, String email) async {
    _token = null;
    await dio.post<void>(
      'auth/register',
      data: {
        'displayName': displayName,
        'email': email,
        'password': 'uzun-ve-guvenli-sifre-2026',
        'consents': {'acceptedTerms': true, 'acknowledgedPrivacyNotice': true},
      },
    );
    final response = await dio.post<Map<String, dynamic>>(
      'auth/verify-email',
      data: {
        'email': email,
        'code': _codes.last,
        'password': 'uzun-ve-guvenli-sifre-2026',
      },
    );
    _token = response.data!['accessToken'] as String;
  }

  void signOut() => _token = null;

  String? get authorization => _token == null ? null : 'Bearer $_token';

  ({
    GetDamageReportsUseCase list,
    GetDamageReportUseCase detail,
    SubmitDamageReportUseCase submit,
    WatchSubmittedReportsUseCase watch,
  })
  get useCases => (
    list: GetDamageReportsUseCase(repository),
    detail: GetDamageReportUseCase(repository),
    submit: SubmitDamageReportUseCase(repository),
    watch: WatchSubmittedReportsUseCase(repository),
  );

  DamageReportListCubit listCubit() =>
      DamageReportListCubit(useCases.list, useCases.watch);

  DamageReportDetailCubit detailCubit() =>
      DamageReportDetailCubit(useCases.detail);

  DamageReportWizardBloc wizardBloc({
    FakePhotoPickerService? picker,
    LocationService? location,
    FakePermissionService? permissions,
  }) => DamageReportWizardBloc(
    catalogUseCases().pins,
    useCases.submit,
    PhotoAttacher(
      picker ?? FakePhotoPickerService(),
      const FakePhotoProcessor(),
      permissions ?? FakePermissionService(),
    ),
    location ?? FakeLocationService(),
  );
}
