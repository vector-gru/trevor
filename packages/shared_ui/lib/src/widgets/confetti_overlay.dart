import 'dart:math';
import 'package:flutter/material.dart';

/// A full-screen confetti animation for special balloon pops.
class ConfettiOverlay extends StatefulWidget {
  final VoidCallback? onComplete;

  const ConfettiOverlay({super.key, this.onComplete});

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  final _rng = Random();
  late final List<_ConfettiPiece> _pieces;

  static const _colors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();
    _pieces = List.generate(60, (_) {
      return _ConfettiPiece(
        startX: _rng.nextDouble(),
        endX: _rng.nextDouble(),
        startY: -0.1,
        endY: 1.1 + _rng.nextDouble() * 0.2,
        color: _colors[_rng.nextInt(_colors.length)],
        size: 6 + _rng.nextDouble() * 8,
        rotations: _rng.nextDouble() * 4,
        delay: _rng.nextDouble() * 0.4,
      );
    });

    _ctrl.forward().then((_) => widget.onComplete?.call());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, _) {
          return Stack(
            children: _pieces.map((p) {
              final t = ((_ctrl.value - p.delay) / (1.0 - p.delay)).clamp(
                0.0,
                1.0,
              );
              final x = (p.startX + (p.endX - p.startX) * t) * size.width;
              final y = (p.startY + (p.endY - p.startY) * t) * size.height;
              final angle = t * p.rotations * 2 * pi;
              return Positioned(
                left: x,
                top: y,
                child: Transform.rotate(
                  angle: angle,
                  child: Container(
                    width: p.size,
                    height: p.size / 2,
                    color: p.color.withValues(alpha: (1 - t).clamp(0, 1)),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _ConfettiPiece {
  final double startX, endX, startY, endY;
  final Color color;
  final double size;
  final double rotations;
  final double delay;

  const _ConfettiPiece({
    required this.startX,
    required this.endX,
    required this.startY,
    required this.endY,
    required this.color,
    required this.size,
    required this.rotations,
    required this.delay,
  });
}
