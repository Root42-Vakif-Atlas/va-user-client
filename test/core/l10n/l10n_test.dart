import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';

Map<String, dynamic> _readArb(String locale) {
  final file = File('lib/core/l10n/arb/app_$locale.arb');
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

Set<String> _messageKeys(Map<String, dynamic> arb) =>
    arb.keys.where((key) => !key.startsWith('@')).toSet();

void main() {
  test('TR ve EN ARB dosyaları aynı anahtarları içerir', () {
    final tr = _messageKeys(_readArb('tr'));
    final en = _messageKeys(_readArb('en'));
    expect(tr.difference(en), isEmpty, reason: 'EN dosyasında eksik');
    expect(en.difference(tr), isEmpty, reason: 'TR dosyasında eksik');
  });

  test('desteklenen diller TR (birincil) ve EN', () {
    expect(AppLocalizations.supportedLocales.first, const Locale('tr'));
    expect(AppLocalizations.supportedLocales, contains(const Locale('en')));
  });

  final failures = <Failure>[
    const ServerFailure(kind: ServerFailureKind.invalidRequest),
    const ServerFailure(kind: ServerFailureKind.notFound),
    const ServerFailure(kind: ServerFailureKind.unavailable),
    const ServerFailure(kind: ServerFailureKind.unknown),
    const UnauthorizedFailure(),
    for (final reason in AuthFailureReason.values) AuthFailure(reason),
    const TooManyRequestsFailure(),
    const TooManyRequestsFailure(retryAfter: Duration(seconds: 61)),
    const ModerationRejectedFailure(),
    const NetworkFailure(),
    const CacheFailure(),
    const SecurityViolationFailure(),
    const UnexpectedFailure(),
  ];

  for (final locale in AppLocalizations.supportedLocales) {
    test('${locale.languageCode}: her Failure için kullanıcı mesajı var', () {
      final l10n = lookupAppLocalizations(locale);
      for (final failure in failures) {
        expect(failure.toUserMessage(l10n), isNotEmpty, reason: '$failure');
      }
    });
  }

  test('TRD hata tablosundaki mesajlar doğru eşlenir', () {
    final l10n = lookupAppLocalizations(const Locale('tr'));
    expect(
      const ModerationRejectedFailure().toUserMessage(l10n),
      'Paylaşımınız topluluk kurallarına uygun bulunmadı.',
    );
    expect(
      const ServerFailure(kind: ServerFailureKind.notFound).toUserMessage(l10n),
      'İstenen kaynak bulunamadı.',
    );
  });

  test('bekleme süresi yukarı yuvarlanmış dakika olarak gösterilir', () {
    final l10n = lookupAppLocalizations(const Locale('tr'));
    expect(
      const TooManyRequestsFailure(retryAfter: Duration(seconds: 61))
          .toUserMessage(l10n),
      'Çok fazla deneme yapıldı. 2 dakika sonra tekrar deneyin.',
    );
  });

  testWidgets('context.l10n aktif dili verir', (tester) async {
    late String title;
    await tester.pumpWidget(
      Localizations(
        locale: const Locale('en'),
        delegates: AppLocalizations.localizationsDelegates,
        child: Builder(
          builder: (context) {
            title = context.l10n.settingsTitle;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pump();
    expect(title, 'Settings');
  });
}
