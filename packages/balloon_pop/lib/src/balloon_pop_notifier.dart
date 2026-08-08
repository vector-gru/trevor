import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_models/shared_models.dart';
import 'package:shared_utils/shared_utils.dart';
import 'balloon_pop_state.dart';

/// Controls game logic for Balloon Pop.
class BalloonPopNotifier extends Notifier<BalloonPopState> {
  static const _maxBalloons = 8;
  static const _spawnInterval = Duration(milliseconds: 1200);

  Timer? _spawnTimer;
  int _idCounter = 0;

  @override
  BalloonPopState build() {
    ref.onDispose(() => _spawnTimer?.cancel());
    return const BalloonPopState();
  }

  /// Starts spawning balloons.
  void startGame() {
    state = const BalloonPopState(isPlaying: true);
    _scheduleSpawn();
  }

  void _scheduleSpawn() {
    _spawnTimer?.cancel();
    _spawnTimer = Timer.periodic(_spawnInterval, (_) {
      if (state.balloons.length < _maxBalloons) _spawnBalloon();
    });
  }

  void _spawnBalloon() {
    final types = BalloonType.values;
    final weights = types.map((t) => t.spawnWeight).toList();
    final type = RandomUtils.weightedRandom(types, weights);

    final balloon = BalloonData(
      id: 'balloon_${_idCounter++}',
      type: type,
      x: RandomUtils.nextDouble(0.1, 0.9),
      startY: 1.1,
      speed: RandomUtils.nextDouble(60, 130),
      size: RandomUtils.nextDouble(70, 110),
    );

    state = state.copyWith(balloons: [...state.balloons, balloon]);
  }

  /// Called when the child taps a balloon.
  void popBalloon(String id) {
    final balloon = state.balloons.firstWhere(
      (b) => b.id == id,
      orElse: () => throw StateError('Balloon $id not found'),
    );
    if (balloon.popped) return;

    final updated = state.balloons.map((b) {
      return b.id == id ? b.copyWith(popped: true) : b;
    }).toList();

    state = state.copyWith(
      balloons: updated,
      score: state.score + balloon.type.points,
      stars: state.stars + _starsFor(balloon.type),
    );

    // Remove the balloon shortly after marking it popped
    // (the widget handles the pop animation then calls this)
    Timer(const Duration(milliseconds: 500), () {
      state = state.copyWith(
        balloons: state.balloons.where((b) => b.id != id).toList(),
      );
    });
  }

  /// Removes a balloon that floated off screen without being popped.
  void removeBalloon(String id) {
    state = state.copyWith(
      balloons: state.balloons.where((b) => b.id != id).toList(),
    );
  }

  int _starsFor(BalloonType type) => switch (type) {
    BalloonType.golden => 3,
    BalloonType.rainbow => 2,
    _ => 1,
  };
}

final balloonPopProvider =
    NotifierProvider<BalloonPopNotifier, BalloonPopState>(
      BalloonPopNotifier.new,
    );
