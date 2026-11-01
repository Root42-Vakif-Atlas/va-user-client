import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('A11yAnnouncer', () {
    test('mesajı varsayılan olarak kibar (polite) duyurur', () async {
      final sent = <(String, Assertiveness)>[];
      final announcer = A11yAnnouncer.withSender((
        view,
        message,
        direction,
        assertiveness,
      ) async {
        sent.add((message, assertiveness));
      });

      await announcer.announce('3 eser bulundu');

      expect(sent, [('3 eser bulundu', Assertiveness.polite)]);
    });

    test('hata duyurusu assertive gönderilir', () async {
      final sent = <Assertiveness>[];
      final announcer = A11yAnnouncer.withSender((
        view,
        message,
        direction,
        assertiveness,
      ) async {
        sent.add(assertiveness);
      });

      await announcer.announce('Bağlantı kurulamadı', assertive: true);

      expect(sent, [Assertiveness.assertive]);
    });

    test('boş mesaj gönderilmez', () async {
      var calls = 0;
      final announcer = A11yAnnouncer.withSender((_, _, _, _) async => calls++);

      await announcer.announce('   ');

      expect(calls, 0);
    });

    test(
      'varsayılan gönderici erişilebilirlik kanalına duyuru iletir',
      () async {
        final messages = <Object?>[];
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(
              SystemChannels.accessibility,
              (message) async {
                messages.add(message);
                return null;
              },
            );
        addTearDown(
          () => TestDefaultBinaryMessengerBinding
              .instance
              .defaultBinaryMessenger
              .setMockDecodedMessageHandler<Object?>(
                SystemChannels.accessibility,
                null,
              ),
        );

        await A11yAnnouncer().announce('Rota hesaplandı');

        expect(messages, hasLength(1));
        final event = messages.single! as Map<Object?, Object?>;
        expect(event['type'], 'announce');
        expect(
          (event['data']! as Map<Object?, Object?>)['message'],
          'Rota hesaplandı',
        );
      },
    );
  });
}
