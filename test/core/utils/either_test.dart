import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/utils/either.dart';

void main() {
  group('Either', () {
    const Either<String, int> left = Left('hata');
    const Either<String, int> right = Right(2);

    test('isLeft / isRight durumu doğru raporlar', () {
      expect(left.isLeft, isTrue);
      expect(left.isRight, isFalse);
      expect(right.isRight, isTrue);
      expect(right.isLeft, isFalse);
    });

    test('fold ilgili dalı çalıştırır', () {
      expect(left.fold((l) => 'L:$l', (r) => 'R:$r'), 'L:hata');
      expect(right.fold((l) => 'L:$l', (r) => 'R:$r'), 'R:2');
    });

    test('map yalnızca başarı değerini dönüştürür', () {
      expect(right.map((r) => r * 10), const Right<String, int>(20));
      expect(left.map((r) => r * 10), const Left<String, int>('hata'));
    });

    test('flatMap zincirlemede ilk başarısızlıkta durur', () {
      Either<String, int> half(int value) =>
          value.isEven ? Right(value ~/ 2) : const Left('tek sayı');

      expect(right.flatMap(half), const Right<String, int>(1));
      expect(
        const Right<String, int>(3).flatMap(half),
        const Left<String, int>('tek sayı'),
      );
      expect(left.flatMap(half), const Left<String, int>('hata'));
    });

    test('getOrNull başarısızlıkta null döner', () {
      expect(right.getOrNull(), 2);
      expect(left.getOrNull(), isNull);
    });

    test('değer eşitliği uygular', () {
      expect(const Right<String, int>(1), const Right<String, int>(1));
      expect(const Left<String, int>('a'), isNot(const Right<String, int>(1)));
      expect(
        const Right<String, int>(1).hashCode,
        const Right<String, int>(1).hashCode,
      );
    });
  });
}
