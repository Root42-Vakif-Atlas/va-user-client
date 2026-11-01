import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/utils/turkish_text.dart';

void main() {
  group('TurkishText.fold', () {
    test('Türkçe büyük/küçük harf ve aksanlar katlanır', () {
      expect(TurkishText.fold('SÜLEYMANİYE'), 'suleymaniye');
      expect(TurkishText.fold('Süleymaniye'), 'suleymaniye');
      expect(TurkishText.fold('DİYARBAKIR'), 'diyarbakir');
      expect(TurkishText.fold('Kızlarağası Hanı'), 'kizlaragasi hani');
      expect(TurkishText.fold('Çifte Minareli'), 'cifte minareli');
      expect(TurkishText.fold('Darüşşifâ'), 'darussifa');
    });

    test('Türkçe I/İ kuralları uygulanır', () {
      expect(TurkishText.toLowerCase('IŞIK İZİ'), 'ışık izi');
      expect(TurkishText.toUpperCase('ışık izi'), 'IŞIK İZİ');
    });
  });

  group('TurkishText.compare', () {
    test('Türk alfabesi sırasıyla sıralar', () {
      final names = [
        'Sivas',
        'Çorum',
        'Şanlıurfa',
        'Ankara',
        'İzmir',
        'Isparta',
      ]..sort(TurkishText.compare);
      expect(names, [
        'Ankara',
        'Çorum',
        'Isparta',
        'İzmir',
        'Sivas',
        'Şanlıurfa',
      ]);
    });
  });
}
