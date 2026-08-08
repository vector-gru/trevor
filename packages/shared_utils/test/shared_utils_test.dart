import 'package:flutter_test/flutter_test.dart';
import 'package:shared_utils/shared_utils.dart';

void main() {
  group('RandomUtils', () {
    test('nextDouble returns value in range', () {
      for (var i = 0; i < 100; i++) {
        final v = RandomUtils.nextDouble(5.0, 10.0);
        expect(v, greaterThanOrEqualTo(5.0));
        expect(v, lessThan(10.0));
      }
    });

    test('nextInt returns value in range', () {
      for (var i = 0; i < 100; i++) {
        final v = RandomUtils.nextInt(0, 5);
        expect(v, greaterThanOrEqualTo(0));
        expect(v, lessThan(5));
      }
    });

    test('weightedRandom picks from items', () {
      final items = ['a', 'b', 'c'];
      final weights = [1.0, 1.0, 1.0];
      final result = RandomUtils.weightedRandom(items, weights);
      expect(items.contains(result), true);
    });
  });
}
