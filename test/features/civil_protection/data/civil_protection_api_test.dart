import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report_draft.dart';

import '../../../helpers/civil_protection_test_utils.dart';
import '../../../helpers/memory_test_utils.dart';
import '../../../support/mock_api/civil_protection/civil_protection_mock_api.dart';

T _right<T>(Either<Failure, T> result) =>
    result.fold((failure) => fail('Beklenmeyen hata: $failure'), (v) => v);

Failure _left<T>(Either<Failure, T> result) =>
    result.fold((failure) => failure, (v) => fail('Hata bekleniyordu: $v'));

const String _description =
    'Kuzey cephedeki kemerde belirgin bir çatlak oluşmuş.';

DamageReportDraft _draft({
  String monumentId = 'selimiye-camii',
  ReportLocation? location,
  String description = _description,
}) => DamageReportDraft(
  monumentId: monumentId,
  category: DamageCategory.structuralDamage,
  urgency: ReportUrgency.high,
  description: description,
  location: location,
);

void main() {
  test('tüm uç noktalar oturum ister (401)', () async {
    final env = CivilProtectionTestEnvironment();
    expect(
      _left(await env.repository.getReports(limit: 20, languageCode: 'tr')),
      const UnauthorizedFailure(),
    );
    expect(
      _left(await env.repository.submitReport(_draft(), languageCode: 'tr')),
      const UnauthorizedFailure(),
    );
  });

  test('kullanıcı yalnızca kendi raporlarını görür, en yeni önce', () async {
    final env = CivilProtectionTestEnvironment();
    await env.signIn();
    final page = _right(
      await env.repository.getReports(limit: 20, languageCode: 'tr'),
    );

    expect(page.items.map((r) => r.referenceCode), [
      'SK-2026-000102',
      'SK-2026-000101',
    ]);
    final resolved = page.items.last;
    expect(resolved.status, DamageReportStatus.resolved);
    expect(resolved.history.map((h) => h.status), [
      DamageReportStatus.received,
      DamageReportStatus.inReview,
      DamageReportStatus.forwarded,
      DamageReportStatus.resolved,
    ]);
    expect(resolved.history.last.note, isNotNull);
    expect(resolved.monument.name, 'Kızlarağası Hanı');

    await env.signInAs('Başka Kullanıcı', 'baska@example.org');
    final other = _right(
      await env.repository.getReports(limit: 20, languageCode: 'tr'),
    );
    expect(other.items, isEmpty);
    expect(
      _left(
        await env.repository.getReport(id: 'rpt_seed_0001', languageCode: 'tr'),
      ),
      const ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
      reason: 'Başkasının raporu varlığı sızdırılmadan 404',
    );
  });

  test('eser adı istek dilinde döner', () async {
    final env = CivilProtectionTestEnvironment();
    await env.signIn();
    final report = _right(
      await env.repository.getReport(id: 'rpt_seed_0002', languageCode: 'en'),
    );
    expect(report.monument.name, 'Bursa Grand Mosque');
  });

  test('fotoğraflı rapor gönderilir; kayıt numarası verilir, akışa düşer, '
      'durum zamanla ilerler', () async {
    var now = memoryTestNow;
    final env = CivilProtectionTestEnvironment(clock: () => now);
    await env.signIn();
    final submitted = <DamageReport>[];
    final subscription = env.repository.submitted.listen(submitted.add);
    final progress = <double>[];

    final report = _right(
      await env.repository.submitReport(
        DamageReportDraft(
          monumentId: 'selimiye-camii',
          category: DamageCategory.vandalism,
          urgency: ReportUrgency.medium,
          description: 'Avlu duvarında sprey boyayla yapılmış yazılar var.',
          photos: [testPhotoDraft(description: 'Avlu duvarı')],
        ),
        languageCode: 'tr',
        onProgress: progress.add,
      ),
    );

    expect(report.referenceCode, 'SK-2026-000103');
    expect(report.status, DamageReportStatus.received);
    expect(report.photos.single.description, 'Avlu duvarı');
    expect(report.locationCheck, ReportLocationCheck.notProvided);
    expect(progress.last, 1);
    await Future<void>.delayed(Duration.zero);
    expect(submitted.single.id, report.id);

    now = now.add(CivilProtectionMockApi.reviewDelay);
    var latest = _right(
      await env.repository.getReport(id: report.id, languageCode: 'tr'),
    );
    expect(latest.status, DamageReportStatus.inReview);

    now = now.add(CivilProtectionMockApi.forwardDelay);
    latest = _right(
      await env.repository.getReport(id: report.id, languageCode: 'tr'),
    );
    expect(latest.status, DamageReportStatus.forwarded);
    expect(latest.history, hasLength(3));
    await subscription.cancel();
  });

  test('konum: 500 m içinde yerinde, uzakta "uzak"; ham koordinat '
      'yanıtta yok', () async {
    final env = CivilProtectionTestEnvironment();
    await env.signIn();
    // Selimiye Camii ≈ 41.6781, 26.5592.
    final near = _right(
      await env.repository.submitReport(
        _draft(
          location: const ReportLocation(
            latitude: 41.6790,
            longitude: 26.5600,
            accuracyMeters: 12,
          ),
        ),
        languageCode: 'tr',
      ),
    );
    expect(near.locationCheck.verification, LocationVerification.onSite);
    expect(near.locationCheck.distanceMeters, lessThan(200));

    final far = _right(
      await env.repository.submitReport(
        _draft(
          location: const ReportLocation(
            latitude: 41.0086,
            longitude: 28.9802,
            accuracyMeters: 10,
          ),
        ),
        languageCode: 'tr',
      ),
    );
    expect(far.locationCheck.verification, LocationVerification.distant);
    expect(far.locationCheck.distanceMeters, greaterThan(200000));

    final response = await env.dio.get<Map<String, dynamic>>(
      'civil-protection/reports/${near.id}',
    );
    expect(response.data.toString(), isNot(contains('41.679')));
  });

  test('doğruluğu düşük konum yakın olsa da yerinde sayılmaz', () async {
    final env = CivilProtectionTestEnvironment();
    await env.signIn();
    final report = _right(
      await env.repository.submitReport(
        _draft(
          location: const ReportLocation(
            latitude: 41.6781,
            longitude: 26.5592,
            accuracyMeters: 900,
          ),
        ),
        languageCode: 'tr',
      ),
    );
    expect(report.locationCheck.verification, LocationVerification.distant);
  });

  test('kurallara uymayan gövde 400; istemci kuralı sunucuya gitmeden '
      'reddeder', () async {
    final env = CivilProtectionTestEnvironment();
    await env.signIn();
    expect(
      _left(
        await env.repository.submitReport(
          _draft(description: 'kısa'),
          languageCode: 'tr',
        ),
      ),
      isA<ServerFailure>(),
    );
    for (final body in [
      {
        'monumentId': 'yok',
        'category': 'vandalism',
        'urgency': 'low',
        'description': _description,
      },
      {
        'monumentId': 'selimiye-camii',
        'category': 'vandalism',
        'urgency': 'low',
        'description': 'kısa',
      },
      {
        'monumentId': 'selimiye-camii',
        'category': 'vandalism',
        'description': _description,
      },
    ]) {
      final response = await env.dio.post<Map<String, dynamic>>(
        'civil-protection/reports',
        data: body,
        options: Options(validateStatus: (_) => true),
      );
      expect(response.statusCode, 400, reason: '$body');
    }
  });

  test(
    'saatte en fazla ${CivilProtectionMockApi.maxReportsPerHour} rapor',
    () async {
      final env = CivilProtectionTestEnvironment();
      await env.signIn();
      for (var i = 0; i < CivilProtectionMockApi.maxReportsPerHour; i++) {
        _right(await env.repository.submitReport(_draft(), languageCode: 'tr'));
      }
      expect(
        _left(await env.repository.submitReport(_draft(), languageCode: 'tr')),
        const TooManyRequestsFailure(retryAfter: Duration(hours: 1)),
      );
    },
  );

  group('DamageReportRules', () {
    test('adım kuralları', () {
      expect(DamageReportRules.validate(_draft()), isNull);
      expect(
        DamageReportRules.validate(
          const DamageReportDraft(
            monumentId: null,
            category: null,
            urgency: null,
            description: '',
          ),
        ),
        DamageReportIssue.monumentMissing,
      );
      expect(
        DamageReportRules.validate(
          _draft(
            description: 'a' * (DamageReportRules.minDescriptionLength - 1),
          ),
        ),
        DamageReportIssue.descriptionTooShort,
      );
      expect(
        DamageReportRules.validate(_draft(description: 'a' * 2001)),
        DamageReportIssue.descriptionTooLong,
      );
    });

    test('mesafe (haversine)', () {
      // Edirne Selimiye – İstanbul Sultanahmet ≈ 210 km.
      final distance = DamageReportRules.distanceMeters(
        41.6781,
        26.5592,
        41.0086,
        28.9802,
      );
      expect(distance, closeTo(215000, 10000));
      expect(DamageReportRules.distanceMeters(41, 29, 41, 29), 0);
    });
  });
}
