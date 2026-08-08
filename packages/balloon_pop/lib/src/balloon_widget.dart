import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_audio/shared_audio.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:shared_utils/shared_utils.dart';
import 'package:shared_models/shared_models.dart';
import 'balloon_pop_notifier.dart';
import 'balloon_pop_state.dart';

/// Animated balloon that floats upward and pops when tapped.
class BalloonWidget extends ConsumerStatefulWidget {
  final BalloonData data;

  const BalloonWidget({super.key, required this.data});

  @override
  ConsumerState<BalloonWidget> createState() => _BalloonWidgetState();
}

class _BalloonWidgetState extends ConsumerState<BalloonWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final Animation<double> _yAnim;
  late final Animation<double> _sway;

  @override
  void initState() {
    super.initState();

    const approxScreenH = 900.0;
    final duration = Duration(
      milliseconds: (approxScreenH / widget.data.speed * 1000).toInt(),
    );

    _floatCtrl = AnimationController(vsync: this, duration: duration);

    _yAnim = Tween<double>(
      begin: 1.1,
      end: -0.2,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.linear));

    _sway = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatCtrl, curve: const _SineCurve(count: 3)),
    );

    _floatCtrl.forward().then((_) {
      if (mounted && !widget.data.popped) {
        ref.read(balloonPopProvider.notifier).removeBalloon(widget.data.id);
      }
    });
  }

  @override
  void didUpdateWidget(covariant BalloonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data.popped && !oldWidget.data.popped) {
      _floatCtrl.stop();
    }
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  void _onTap() {
    if (widget.data.popped) return;
    HapticUtils.pop();

    // Play the right sound for this balloon type
    final audio = ref.read(audioServiceProvider);
    final sound = switch (widget.data.type) {
      BalloonType.rainbow => SoundId.balloonRainbowPop,
      BalloonType.golden => SoundId.balloonGoldenPop,
      BalloonType.gift => SoundId.balloonGiftPop,
      BalloonType.animal => SoundId.balloonAnimalPop,
      _ => SoundId.balloonPop,
    };
    audio.playSound(sound);

    ref.read(balloonPopProvider.notifier).popBalloon(widget.data.id);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return AnimatedBuilder(
      animation: _floatCtrl,
      builder: (_, _) {
        final x = widget.data.x * screenSize.width + _sway.value;
        final y = _yAnim.value * screenSize.height;

        return Positioned(
          left: x - widget.data.size / 2,
          top: y - widget.data.size / 2,
          child: GestureDetector(
            onTap: _onTap,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: widget.data.popped ? 0.0 : 1.0,
              child: BouncyScale(
                duration: const Duration(milliseconds: 300),
                child: _BalloonPainter(
                  type: widget.data.type,
                  size: widget.data.size,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Paints the balloon with a radial gradient and a string.
class _BalloonPainter extends StatelessWidget {
  final dynamic type;
  final double size;

  const _BalloonPainter({required this.type, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // String
          Positioned(
            bottom: 0,
            child: Container(
              width: 2,
              height: size * 0.25,
              color: Colors.brown.withValues(alpha: 0.5),
            ),
          ),
          // Balloon body
          Positioned(
            top: 0,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: type.color,
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.3, -0.3),
                  radius: 0.8,
                  colors: [
                    (type.color as Color).withValues(alpha: 0.9),
                    type.color as Color,
                    (type.color as Color).withValues(alpha: 0.7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(4, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  type.emoji as String,
                  style: TextStyle(fontSize: size * 0.4),
                ),
              ),
            ),
          ),
          // Shine highlight
          Positioned(
            top: size * 0.1,
            left: size * 0.2,
            child: Container(
              width: size * 0.2,
              height: size * 0.12,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(size),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A sinusoidal curve for the balloon sway animation.
class _SineCurve extends Curve {
  final double count;
  const _SineCurve({this.count = 1});

  @override
  double transformInternal(double t) => math.sin(t * math.pi * 2 * count);
}
