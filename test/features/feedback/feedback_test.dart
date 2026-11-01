import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/feedback/domain/entities/feedback_submission.dart';
import 'package:vakif_atlas/features/feedback/domain/repositories/feedback_repository.dart';
import 'package:vakif_atlas/features/feedback/presentation/cubit/feedback_form_cubit.dart';
import 'package:vakif_atlas/features/feedback/presentation/pages/feedback_page.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/test_di.dart';
import '../../support/mock_api/feedback/feedback_mock_api.dart';

void main() {
  group('FeedbackRules', () {
    test('puan veya metin gerekir; metin en çok 2000 karakter', () {
      expect(
        FeedbackRules.validate(rating: null, message: '   '),
        FeedbackIssue.ratingOrMessageRequired,
      );
      expect(FeedbackRules.validate(rating: 4, message: ''), isNull);
      expect(FeedbackRules.validate(rating: null, message: 'Güzel'), isNull);
      expect(
        FeedbackRules.validate(rating: 5, message: 'a' * 2001),
        FeedbackIssue.messageTooLong,
      );
    });

    test('metin loglara yazılmaz', () {
      const submission = FeedbackSubmission(
        category: FeedbackCategory.bug,
        message: 'gizli metin',
      );
      expect(submission.toString(), isNot(contains('gizli')));
      expect(
        const FeedbackFormState(message: 'gizli metin').toString(),
        isNot(contains('gizli')),
      );
    });
  });

  group('Mock API ile', () {
    late TestDependencies deps;

    setUp(() async => deps = await TestDependencies.setUp());
    tearDown(resetDependencies);

    test(
      'misafir gönderir; sürüm ve platform eklenir, metin kırpılır',
      () async {
        final result = await getIt<FeedbackRepository>().submit(
          const FeedbackSubmission(
            category: FeedbackCategory.suggestion,
            rating: 5,
            message: '  Harita çok kullanışlı  ',
          ),
        );
        expect(result.isRight, isTrue);
        final sent = getIt<FeedbackMockApi>().received.single;
        expect(sent['category'], 'suggestion');
        expect(sent['rating'], 5);
        expect(sent['message'], 'Harita çok kullanışlı');
        expect(sent['appVersion'], isA<String>());
        expect(sent['userId'], isNull);
      },
    );

    test('saatlik sınır aşılınca bekleme süreli hata', () async {
      const submission = FeedbackSubmission(
        category: FeedbackCategory.other,
        rating: 3,
        message: '',
      );
      for (var i = 0; i < FeedbackMockApi.maxPerHour; i++) {
        expect(
          (await getIt<FeedbackRepository>().submit(submission)).isRight,
          isTrue,
        );
      }
      final result = await getIt<FeedbackRepository>().submit(submission);
      expect(
        result.fold((failure) => failure, (_) => null),
        isA<TooManyRequestsFailure>(),
      );
    });

    group('FeedbackPage', () {
      late int submitted;

      Future<void> pumpPage(WidgetTester tester, {double textScale = 1}) async {
        submitted = 0;
        await tester.pumpApp(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: getIt<A11yAnnouncer>()),
              RepositoryProvider.value(value: getIt<HapticFeedbackService>()),
            ],
            child: BlocProvider(
              create: (_) => getIt<FeedbackFormCubit>(),
              child: FeedbackPage(onSubmitted: () => submitted++),
            ),
          ),
          textScale: textScale,
          surfaceSize: const Size(390, 844),
        );
        await tester.pumpAndSettle();
      }

      Future<void> tapVisible(WidgetTester tester, Key key) async {
        final target = find.byKey(key);
        await tester.ensureVisible(target);
        await tester.pumpAndSettle();
        await tester.tap(target);
        await tester.pumpAndSettle();
      }

      testWidgets('boş gönderim engellenir; hata görünür ve duyurulur', (
        tester,
      ) async {
        await pumpPage(tester);
        await tapVisible(tester, const Key('feedback_submit_button'));

        expect(
          find.byKey(const Key('feedback_required_error')),
          findsOneWidget,
        );
        expect(
          deps.announcements,
          contains('Bir puan verin veya mesaj yazın.'),
        );
        expect(getIt<FeedbackMockApi>().received, isEmpty);
        expect(submitted, 0);
      });

      testWidgets('puan, konu ve mesajla gönderilir; teşekkür edilir', (
        tester,
      ) async {
        await pumpPage(tester);

        await tapVisible(tester, const Key('feedback_star_4'));
        expect(find.text('4 / 5 · İyi'), findsOneWidget);
        await tapVisible(tester, const Key('feedback_category_bug'));
        await tester.enterText(
          find.byKey(const Key('feedback_message')),
          'Dışa aktarımda hata',
        );
        await tapVisible(tester, const Key('feedback_submit_button'));
        await tester.runAsync(() => Future<void>.delayed(Duration.zero));
        await tester.pumpAndSettle();

        final sent = getIt<FeedbackMockApi>().received.single;
        expect(sent['rating'], 4);
        expect(sent['category'], 'bug');
        expect(sent['message'], 'Dışa aktarımda hata');
        expect(submitted, 1);
        expect(
          deps.announcements,
          contains('Teşekkürler! Geri bildiriminiz alındı.'),
        );
      });

      testWidgets('aynı yıldıza tekrar dokunmak puanı kaldırır', (
        tester,
      ) async {
        await pumpPage(tester);
        await tapVisible(tester, const Key('feedback_star_2'));
        await tapVisible(tester, const Key('feedback_star_2'));
        expect(find.text('Puan vermek isteğe bağlıdır.'), findsOneWidget);
      });

      testWidgets('erişilebilirlik kılavuzları ve %200 metin', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpPage(tester, textScale: 2);
        expect(tester.takeException(), isNull);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        expect(
          tester.getSemantics(find.byKey(const Key('feedback_star_5'))),
          isSemantics(tooltip: '5 yıldız', isButton: true),
        );
        handle.dispose();
      });
    });
  });
}
