import 'dart:math';
import 'package:flutter/material.dart';

/// Spawns animated floating stars from a given position.
///
/// Typically overlaid on the game screen after a balloon is popped.
class StarBurst extends StatefulWidget {
  final Offset origin;
  final int count;
  final VoidCallback? onComplete;

  const StarBurst({
    super.key,
    required this.origin,
    this.count = 6,
    this.onComplete,
  });

  @override
  State<StarBurst> createState() => _StarBurstState();
}

class _StarBurstState extends State<StarBurst> with TickerProviderStateMixin {
  final List<_StarParticle> _particles = [];
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.count; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500 + _rng.nextInt(400)),
      );

      final angle = (i / widget.count) * 2 * pi + _rng.nextDouble() * 0.5;
      final distance = 60.0 + _rng.nextDouble() * 60;

      _particles.add(
        _StarParticle(
          controller: ctrl,
          angle: angle,
          distance: distance,
          size: 16 + _rng.nextDouble() * 16,
        ),
      );

      ctrl.forward().then((_) {
        if (i == widget.count - 1) widget.onComplete?.call();
      });
    }
  }

  @override
  void dispose() {
    for (final p in _particles) {
      p.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: _particles.map((p) {
          return AnimatedBuilder(
            animation: p.controller,
            builder: (_, _) {
              final t = p.controller.value;
              final x = widget.origin.dx + cos(p.angle) * p.distance * t;
              final y =
                  widget.origin.dy + sin(p.angle) * p.distance * t - 40 * t;
              final opacity = (1.0 - t).clamp(0.0, 1.0);
              return Positioned(
                left: x - p.size / 2,
                top: y - p.size / 2,
                child: Opacity(
                  opacity: opacity,
                  child: Text('⭐', style: TextStyle(fontSize: p.size)),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class _StarParticle {
  final AnimationController controller;
  final double angle;
  final double distance;
  final double size;

  _StarParticle({
    required this.controller,
    required this.angle,
    required this.distance,
    required this.size,
  });
}
