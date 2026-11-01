import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/observability/app_bloc_observer.dart';
import 'package:vakif_atlas/core/observability/app_logger.dart';
import 'package:vakif_atlas/core/observability/telemetry_service.dart';

class _MockTelemetry extends Mock implements TelemetryService {}

class _SecretState {
  const _SecretState(this.email);

  final String email;

  @override
  String toString() => 'SecretState($email)';
}

class _TestCubit extends Cubit<_SecretState> {
  _TestCubit() : super(const _SecretState('ayse@example.org'));

  void change() => emit(const _SecretState('veli@example.org'));

  void fail() => addError(StateError('boom'), StackTrace.current);
}

void main() {
  late _MockTelemetry telemetry;
  late List<String> breadcrumbs;

  setUp(() {
    telemetry = _MockTelemetry();
    breadcrumbs = [];
    when(() => telemetry.addBreadcrumb(any())).thenAnswer((invocation) {
      breadcrumbs.add(invocation.positionalArguments.single as String);
    });
    when(
      () => telemetry.recordError(
        any<Object>(),
        any(),
        reason: any(named: 'reason'),
      ),
    ).thenAnswer((_) async {});
    Bloc.observer = AppBlocObserver(
      AppLogger.withLogger(Logger(level: Level.off)),
      telemetry,
    );
  });

  test('durum geçişleri yalnızca tip adlarıyla izlenir (PII yok)', () async {
    final cubit = _TestCubit()..change();
    await cubit.close();

    expect(breadcrumbs.single, '_TestCubit: _SecretState → _SecretState');
    expect(breadcrumbs.single, isNot(contains('@')));
  });

  test('hatalar telemetriye raporlanır', () async {
    final cubit = _TestCubit()..fail();
    await cubit.close();

    verify(
      () => telemetry.recordError(
        isA<StateError>(),
        any(),
        reason: '_TestCubit.onError',
      ),
    ).called(1);
  });
}
