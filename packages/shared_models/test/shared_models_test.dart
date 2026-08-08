import 'package:flutter_test/flutter_test.dart';
import 'package:shared_models/shared_models.dart';

void main() {
  group('BalloonType', () {
    test('red balloon worth 1 point', () {
      expect(BalloonType.red.points, 1);
    });

    test('rainbow balloon worth 5 points', () {
      expect(BalloonType.rainbow.points, 5);
    });

    test('golden balloon worth 10 points', () {
      expect(BalloonType.golden.points, 10);
    });

    test('spawn weights sum to 1.0', () {
      final total = BalloonType.values.fold(
        0.0,
        (sum, t) => sum + t.spawnWeight,
      );
      expect(total, closeTo(1.0, 0.001));
    });
  });

  group('GameProgress', () {
    test('serializes and deserializes correctly', () {
      final progress = GameProgress(
        gameId: 'balloon_pop',
        highScore: 42,
        totalPlays: 7,
        lastPlayed: DateTime(2026, 8, 7),
      );
      final json = progress.toJson();
      final restored = GameProgress.fromJson(json);
      expect(restored.highScore, 42);
      expect(restored.totalPlays, 7);
      expect(restored.gameId, 'balloon_pop');
    });
  });
}
