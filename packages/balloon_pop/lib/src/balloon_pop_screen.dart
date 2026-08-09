import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_audio/shared_audio.dart';
import 'package:shared_ui/shared_ui.dart';
import 'balloon_pop_notifier.dart';
import 'balloon_widget.dart';

/// Full-screen Balloon Pop game.
class BalloonPopScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const BalloonPopScreen({super.key, required this.onBack});

  @override
  ConsumerState<BalloonPopScreen> createState() => _BalloonPopScreenState();
}

class _BalloonPopScreenState extends ConsumerState<BalloonPopScreen> {
  bool _showConfetti = false;
  int _lastScore = 0;
  AudioService? _audio;

  // Active bird animations keyed by unique id.
  final Map<int, Offset> _birds = {};
  int _birdCounter = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache audio service reference here — safe to call ref, and runs before build
    _audio ??= ref.read(audioServiceProvider);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(balloonPopProvider.notifier).startGame();
      // Stop any home screen greeting, then announce the game.
      _audio?.playGameStart(SoundId.balloonsStart);
      _audio?.playMusic(SoundId.bgBalloonPop);
    });
  }

  @override
  void dispose() {
    _audio?.stopMusic();
    super.dispose();
  }

  void _spawnBird(Offset position) {
    if (!mounted) return;
    setState(() {
      _birds[_birdCounter++] = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(balloonPopProvider);

    // Trigger confetti and sounds on big-point balloon pops
    ref.listen(balloonPopProvider, (prev, next) {
      if (next.score > _lastScore + 4) {
        _lastScore = next.score;
        setState(() => _showConfetti = true);
        _audio?.playSound(SoundId.confetti);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) setState(() => _showConfetti = false);
        });
      } else if (prev != null && next.score > prev.score) {
        _audio?.playSound(SoundId.starCollect);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // Sky gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF87CEEB),
                  Color(0xFFE0F7FA),
                  Color(0xFFFFF9C4),
                ],
              ),
            ),
          ),

          // Decorative clouds
          const _CloudLayer(),

          // Balloons
          ...state.balloons.map(
            (b) => BalloonWidget(
              key: ValueKey(b.id),
              data: b,
              onGiftPopped: _spawnBird,
            ),
          ),

          // Score HUD
          Positioned(
            top: MediaQuery.paddingOf(context).top + 12,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _HudButton(
                  onTap: widget.onBack,
                  child: const Text('🏠', style: TextStyle(fontSize: 28)),
                ),
                _ScoreBadge(score: state.score, stars: state.stars),
              ],
            ),
          ),

          // Bird animations (gift balloon surprise)
          ..._birds.entries.map(
            (e) => BirdFlyAnimation(
              key: ValueKey('bird_${e.key}'),
              origin: e.value,
              onComplete: () {
                if (mounted) setState(() => _birds.remove(e.key));
              },
            ),
          ),

          // Confetti overlay
          if (_showConfetti)
            ConfettiOverlay(
              onComplete: () {
                if (mounted) setState(() => _showConfetti = false);
              },
            ),
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final int score;
  final int stars;

  const _ScoreBadge({required this.score, required this.stars});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('⭐', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 4),
          Text(
            '$stars',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: TrevorColors.textDark,
            ),
          ),
          const SizedBox(width: 12),
          const Text('🎈', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 4),
          Text(
            '$score',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: TrevorColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _HudButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _HudButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}

/// Simple decorative cloud layer painted behind the balloons.
class _CloudLayer extends StatelessWidget {
  const _CloudLayer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _cloud(left: 30, top: 80, scale: 1.0),
        _cloud(left: 200, top: 140, scale: 0.7),
        _cloud(right: 20, top: 60, scale: 0.9),
        _cloud(right: 100, top: 200, scale: 0.6),
      ],
    );
  }

  Widget _cloud({
    double? left,
    double? right,
    required double top,
    required double scale,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      child: Transform.scale(scale: scale, child: const _CloudShape()),
    );
  }
}

class _CloudShape extends StatelessWidget {
  const _CloudShape();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 60,
      child: CustomPaint(painter: _CloudPainter()),
    );
  }
}

class _CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.75);
    final cx = size.width / 2;
    final cy = size.height * 0.6;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: size.width,
        height: size.height * 0.55,
      ),
      paint,
    );
    canvas.drawCircle(
      Offset(cx - size.width * 0.15, cy - size.height * 0.15),
      size.height * 0.35,
      paint,
    );
    canvas.drawCircle(
      Offset(cx + size.width * 0.15, cy - size.height * 0.12),
      size.height * 0.28,
      paint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
