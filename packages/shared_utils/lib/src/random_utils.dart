import 'dart:math';

/// Utility helpers for random value generation.
class RandomUtils {
  RandomUtils._();

  static final _rng = Random();

  /// Returns a random double between [min] and [max].
  static double nextDouble(double min, double max) =>
      min + _rng.nextDouble() * (max - min);

  /// Returns a random int between [min] (inclusive) and [max] (exclusive).
  static int nextInt(int min, int max) => min + _rng.nextInt(max - min);

  /// Picks a weighted random item from [items] using parallel [weights].
  ///
  /// All weights must be positive. They do not need to sum to 1.
  static T weightedRandom<T>(List<T> items, List<double> weights) {
    assert(items.length == weights.length, 'items and weights must match');
    final total = weights.reduce((a, b) => a + b);
    var roll = _rng.nextDouble() * total;
    for (var i = 0; i < items.length; i++) {
      roll -= weights[i];
      if (roll <= 0) return items[i];
    }
    return items.last;
  }
}
