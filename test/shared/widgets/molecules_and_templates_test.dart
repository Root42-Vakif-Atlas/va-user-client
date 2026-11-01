import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_text_field.dart';
import 'package:vakif_atlas/shared/widgets/templates/form_page_template.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('AppTextField', () {
    testWidgets('şifre alanı göster/gizle butonuyla değişir', (tester) async {
      await tester.pumpApp(
        const Padding(
          padding: EdgeInsets.all(16),
          child: AppTextField(label: 'Şifre', isPassword: true),
        ),
      );

      TextField field() => tester.widget<TextField>(find.byType(TextField));
      expect(field().obscureText, isTrue);
      expect(find.byTooltip('Şifreyi göster'), findsOneWidget);

      await tester.tap(find.byTooltip('Şifreyi göster'));
      await tester.pump();

      expect(field().obscureText, isFalse);
      expect(find.byTooltip('Şifreyi gizle'), findsOneWidget);
      final toggle = tester.getSize(find.byType(IconButton));
      expect(toggle.width, greaterThanOrEqualTo(48));
      expect(toggle.height, greaterThanOrEqualTo(48));
    });

    testWidgets('hata metni görünür', (tester) async {
      await tester.pumpApp(
        const Padding(
          padding: EdgeInsets.all(16),
          child: AppTextField(
            label: 'E-posta',
            errorText: 'Geçerli bir e-posta adresi girin.',
          ),
        ),
      );
      expect(find.text('Geçerli bir e-posta adresi girin.'), findsOneWidget);
    });
  });

  group('StatusMessageView', () {
    testWidgets('%200 metin ölçeğinde taşmadan çizilir', (tester) async {
      await tester.pumpApp(
        StatusMessageView(
          icon: Icons.construction_outlined,
          title: 'Bu bölüm hazırlanıyor',
          message: 'Rota Planlayıcı bir sonraki sürümde kullanıma açılacak.',
          actionLabel: 'Ana sayfaya dön',
          onAction: () {},
        ),
        textScale: 2,
        surfaceSize: const Size(320, 640),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Bu bölüm hazırlanıyor'), findsOneWidget);
    });
  });

  group('FormPageTemplate', () {
    testWidgets('içerik kaydırılabilir ve taşmaz', (tester) async {
      await tester.pumpApp(
        FormPageTemplate(
          children: [
            for (var i = 0; i < 12; i++) AppTextField(label: 'Alan $i'),
          ],
        ),
        textScale: 2,
        surfaceSize: const Size(320, 480),
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(CustomScrollView), findsOneWidget);
    });
  });
}
