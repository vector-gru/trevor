import 'package:shared_models/shared_models.dart';

/// Immutable state for the Balloon Pop game.
class BalloonPopState {
  final List<BalloonData> balloons;
  final int score;
  final int stars;
  final bool isPlaying;

  const BalloonPopState({
    this.balloons = const [],
    this.score = 0,
    this.stars = 0,
    this.isPlaying = true,
  });

  BalloonPopState copyWith({
    List<BalloonData>? balloons,
    int? score,
    int? stars,
    bool? isPlaying,
  }) {
    return BalloonPopState(
      balloons: balloons ?? this.balloons,
      score: score ?? this.score,
      stars: stars ?? this.stars,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

/// A single balloon on screen.
class BalloonData {
  final String id;
  final BalloonType type;
  final double x; // 0.0 – 1.0, relative to screen width
  final double startY; // relative to screen height (starts below screen)
  final double speed; // pixels per second
  final double size;
  final bool popped;

  const BalloonData({
    required this.id,
    required this.type,
    required this.x,
    required this.startY,
    required this.speed,
    required this.size,
    this.popped = false,
  });

  BalloonData copyWith({bool? popped}) =>
      BalloonData(
        id: id,
        type: type,
        x: x,
        startY: startY,
        speed: speed,
        size: size,
        popped: popped ?? this.popped,
      );
}
