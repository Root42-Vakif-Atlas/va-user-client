import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/location/location_service.dart';
import 'package:vakif_atlas/core/media/photo_picker_service.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report_draft.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/bloc/damage_report_wizard_bloc.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/cubit/damage_report_list_cubit.dart';

import '../../../helpers/catalog_test_utils.dart';
import '../../../helpers/civil_protection_test_utils.dart';
import '../../../helpers/location_test_utils.dart';
import '../../../helpers/memory_test_utils.dart';

Future<S> _settle<S>(Stream<S> stream, S current, bool Function(S) test) =>
    test(current) ? Future.value(current) : stream.firstWhere(test);

void main() {
  const description = 'Kuzey cephedeki kemerde belirgin bir çatlak oluşmuş.';

  Future<DamageReportWizardBloc> started(
    CivilProtectionTestEnvironment env, {
    String? monumentId,
    FakeLocationService? location,
    FakePhotoPickerService? picker,
  }) async {
    final bloc = env.wizardBloc(location: location, picker: picker)
      ..add(
        DamageReportWizardEvent.started(
          languageCode: 'tr',
          monumentId: monumentId,
        ),
      );
    if (monumentId != null) {
      await _settle(
        bloc.stream,
        bloc.state,
        (s) => s.monument != null || s.monumentFailure != null,
      );
    } else {
      await _settle(bloc.stream, bloc.state, (s) => s.languageCode == 'tr');
    }
    return bloc;
  }

  test(
    'eser detayından gelinince eser seçili başlar, hasar türüne geçilir',
    () async {
      final env = CivilProtectionTestEnvironment();
      final bloc = await started(env, monumentId: 'selimiye-camii');

      expect(bloc.state.monument?.name, 'Selimiye Camii');
      expect(bloc.state.step, ReportStep.category);
      await bloc.close();
    },
  );

  test('eksik adım geçilmez; hata sayacı artar', () async {
    final env = CivilProtectionTestEnvironment();
    final bloc = await started(env);

    bloc.add(const DamageReportWizardEvent.nextRequested());
    var state = await _settle(
      bloc.stream,
      bloc.state,
      (s) => s.stepErrorCount == 1,
    );
    expect(state.step, ReportStep.monument);
    expect(state.showStepError, isTrue);
    expect(state.stepIssue, DamageReportIssue.monumentMissing);

    bloc
      ..add(DamageReportWizardEvent.monumentSelected(fixturePins().first))
      ..add(const DamageReportWizardEvent.nextRequested());
    state = await _settle(
      bloc.stream,
      bloc.state,
      (s) => s.step == ReportStep.category,
    );
    expect(state.showStepError, isFalse);

    bloc
      ..add(
        const DamageReportWizardEvent.categorySelected(DamageCategory.theft),
      )
      ..add(const DamageReportWizardEvent.nextRequested())
      ..add(const DamageReportWizardEvent.urgencySelected(ReportUrgency.low))
      ..add(const DamageReportWizardEvent.nextRequested())
      ..add(const DamageReportWizardEvent.descriptionChanged('kısa'))
      ..add(const DamageReportWizardEvent.nextRequested());
    state = await _settle(
      bloc.stream,
      bloc.state,
      (s) => s.stepErrorCount == 2,
    );
    expect(state.step, ReportStep.details);
    expect(state.stepIssue, DamageReportIssue.descriptionTooShort);

    bloc.add(const DamageReportWizardEvent.backRequested());
    state = await _settle(
      bloc.stream,
      bloc.state,
      (s) => s.step == ReportStep.urgency,
    );
    expect(
      state.urgency,
      ReportUrgency.low,
      reason: 'Geri dönmek seçimi korur',
    );
    await bloc.close();
  });

  test('konum açılınca bir kez okunur, esere tahmini uzaklık hesaplanır; '
      'kapatılınca rapordan çıkar', () async {
    final env = CivilProtectionTestEnvironment();
    final location = FakeLocationService(
      result: const LocationFound(
        DevicePosition(
          latitude: 41.6790,
          longitude: 26.5600,
          accuracyMeters: 12,
        ),
      ),
    );
    final bloc = await started(
      env,
      monumentId: 'selimiye-camii',
      location: location,
    );

    bloc.add(
      const DamageReportWizardEvent.locationSharingChanged(enabled: true),
    );
    var state = await _settle(
      bloc.stream,
      bloc.state,
      (s) => s.locationStatus == ReportLocationStatus.found,
    );
    expect(location.currentPositionCalls, 1);
    expect(state.estimatedDistanceMeters, lessThan(200));
    expect(state.draft.location, isNotNull);

    bloc.add(
      const DamageReportWizardEvent.locationSharingChanged(enabled: false),
    );
    state = await _settle(
      bloc.stream,
      bloc.state,
      (s) => s.locationStatus == ReportLocationStatus.off,
    );
    expect(state.draft.location, isNull);
    await bloc.close();
  });

  test(
    'konum izni reddedilirse neden bildirilir, rapor konumsuz kalır',
    () async {
      final env = CivilProtectionTestEnvironment();
      final bloc = await started(
        env,
        location: FakeLocationService(
          result: const LocationFailed(LocationIssue.permissionDeniedForever),
        ),
      );
      bloc.add(
        const DamageReportWizardEvent.locationSharingChanged(enabled: true),
      );
      final state = await _settle(
        bloc.stream,
        bloc.state,
        (s) => s.locationStatus == ReportLocationStatus.failed,
      );
      expect(state.locationIssue, LocationIssue.permissionDeniedForever);
      expect(state.draft.location, isNull);
      await bloc.close();
    },
  );

  test(
    'çift gönderim tek rapor oluşturur; liste yeni raporu başa ekler',
    () async {
      final env = CivilProtectionTestEnvironment();
      await env.signIn();
      final list = env.listCubit();
      await list.start('tr');
      expect(list.state.total, 2);

      final picker = FakePhotoPickerService()
        ..results.add(PhotosPicked([testJpeg()]));
      final bloc = await started(
        env,
        monumentId: 'selimiye-camii',
        picker: picker,
      );
      bloc
        ..add(
          const DamageReportWizardEvent.categorySelected(
            DamageCategory.vandalism,
          ),
        )
        ..add(const DamageReportWizardEvent.nextRequested())
        ..add(
          const DamageReportWizardEvent.urgencySelected(ReportUrgency.medium),
        )
        ..add(const DamageReportWizardEvent.nextRequested())
        ..add(const DamageReportWizardEvent.descriptionChanged(description))
        ..add(
          const DamageReportWizardEvent.photosRequested(PhotoSource.gallery),
        );
      await _settle(bloc.stream, bloc.state, (s) => s.photos.length == 1);
      bloc
        ..add(const DamageReportWizardEvent.nextRequested())
        ..add(const DamageReportWizardEvent.nextRequested());
      await _settle(
        bloc.stream,
        bloc.state,
        (s) => s.step == ReportStep.review,
      );

      bloc
        ..add(const DamageReportWizardEvent.submitted())
        ..add(const DamageReportWizardEvent.submitted());
      final state = await _settle(
        bloc.stream,
        bloc.state,
        (s) => s.submitStatus == ReportSubmitStatus.submitted,
      );

      expect(state.submitted?.referenceCode, 'SK-2026-000103');
      expect(state.submitted?.photos, hasLength(1));
      expect(state.isDirty, isFalse);
      final listState = await _settle(
        list.stream,
        list.state,
        (s) => s.total == 3,
      );
      expect(listState.items.first.id, state.submitted?.id);
      expect(listState.status, DamageReportListStatus.success);
      await bloc.close();
      await list.close();
    },
  );

  test('oturum yoksa gönderim hatası; taslak korunur', () async {
    final env = CivilProtectionTestEnvironment();
    final bloc = await started(env, monumentId: 'selimiye-camii');
    bloc
      ..add(
        const DamageReportWizardEvent.categorySelected(DamageCategory.other),
      )
      ..add(const DamageReportWizardEvent.urgencySelected(ReportUrgency.low))
      ..add(const DamageReportWizardEvent.descriptionChanged(description))
      ..add(const DamageReportWizardEvent.stepSelected(ReportStep.review))
      ..add(const DamageReportWizardEvent.submitted());
    final state = await _settle(
      bloc.stream,
      bloc.state,
      (s) => s.submitFailure != null,
    );
    expect(state.submitStatus, ReportSubmitStatus.idle);
    expect(state.isDirty, isTrue);
    await bloc.close();
  });
}
