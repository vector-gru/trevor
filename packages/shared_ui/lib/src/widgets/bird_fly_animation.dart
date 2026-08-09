import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A bird that bursts out from a position and flies off screen.
///
/// Shown when a gift balloon is popped. The bird starts at [origin],
/// flaps its wings, arcs upward, and fades out as it leaves the screen.
class BirdFlyAnimation extends StatefulWidget {
  /// Where the bird spawns (center of the popped balloon).
  final Offset origin;
  final VoidCallback? onComplete;

  const BirdFlyAnimation({
    super.key,
    required this.origin,
    this.onComplete,
  });

  @override
  State<BirdFlyAnimation> createState() => _BirdFlyAnimationState();
}

class _BirdFlyAnimationState extends State<BirdFlyAnimation>
    with TickerProviderStateMixin {
  // Flight path controller — moves the bird across the screen.
  late final AnimationController _flightCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  // Wing flap controller — oscillates quickly.
  late final AnimationController _flapCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );

  late final Animation<double> _opacity = TweenSequence([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10),
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 70),
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
  ]).animate(_flightCtrl);

  late final Animation<double> _scale = TweenSequence([
    TweenSequenceItem(
      tween: Tween(begin: 0.3, end: 1.2)
          .chain(CurveTween(curve: Curves.elasticOut)),
      weight: 25,
    ),
    TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.6), weight: 75),
  ]).animate(_flightCtrl);

  // Random direction — bird flies to a random upper corner.
  final _rng = math.Random();
  late final double _targetDx;
  late final double _targetDy;
  late final double _arcHeight;

  @override
  void initState() {
    super.initState();

    // Pick a random upper-screen exit point.
    _targetDx = (_rng.nextBool() ? 1.0 : -1.0) *
        (150 + _rng.nextDouble() * 120);
    _targetDy = -(250 + _rng.nextDouble() * 150);
    _arcHeight = 60 + _rng.nextDouble() * 40;

    _flapCtrl.repeat(reverse: true);
    _flightCtrl.forward().then((_) {
      _flapCtrl.stop();
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _flightCtrl.dispose();
    _flapCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flightCtrl,
      builder: (_, _) {
        final t = _flightCtrl.value;
        // Arc: parabolic curve so the bird swoops up then away.
        final dx = widget.origin.dx + _targetDx * t;
        final dy = widget.origin.dy +
            _targetDy * t -
            _arcHeight * math.sin(t * math.pi);

        return Positioned(
          left: dx - 24,
          top: dy - 24,
          child: Opacity(
            opacity: _opacity.value,
            child: Transform.scale(
              scale: _scale.value,
              // Mirror horizontally if flying left.
              child: Transform.flip(
                flipX: _targetDx < 0,
                child: _FlapBird(flapCtrl: _flapCtrl),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Draws a simple emoji bird with a wing-flap effect.
class _FlapBird extends StatelessWidget {
  final AnimationController flapCtrl;

  const _FlapBird({required this.flapCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: flapCtrl,
      builder: (_, _) {
        // Squeeze vertically to simulate wing flap.
        final squeeze = 0.75 + flapCtrl.value * 0.5;
        return Transform.scale(
          scaleY: squeeze,
          child: const Text('🐦', style: TextStyle(fontSize: 40)),
        );
      },
    );
  }
}
