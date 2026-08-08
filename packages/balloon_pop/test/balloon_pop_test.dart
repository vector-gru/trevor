import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_pop/balloon_pop.dart';
import 'package:shared_models/shared_models.dart';

void main() {
  group('BalloonPopState', () {
    test('starts with defaults', () {
      const state = BalloonPopState();
      expect(state.balloons, isEmpty);
      expect(state.score, 0);
      expect(state.stars, 0);
      expect(state.isPlaying, true);
    });

    test('copyWith updates score', () {
      const state = BalloonPopState();
      final updated = state.copyWith(score: 10, stars: 3);
      expect(updated.score, 10);
      expect(updated.stars, 3);
      expect(updated.balloons, isEmpty);
    });
  });

  group('BalloonData', () {
    const balloon = BalloonData(
      id: 'b1',
      type: BalloonType.red,
      x: 0.5,
      startY: 1.1,
      speed: 80,
      size: 90,
    );

    test('copyWith popped', () {
      final popped = balloon.copyWith(popped: true);
      expect(popped.popped, true);
      expect(popped.id, 'b1');
    });
  });
}
