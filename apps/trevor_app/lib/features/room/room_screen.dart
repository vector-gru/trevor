import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';

/// Trevor's Room — the home screen.
///
/// Children tap toys/objects in the room to enter mini-games.
/// Layout (portrait):
///
///   ┌──────────────────────────┐
///   │         🪟  Window        │
///   │                           │
///   │  🧸 Teddy    📚 Bookshelf │
///   │                           │
///   │  🎈 Balloons  🧩 Puzzle   │
///   │                           │
///   │  🎹 Piano    🎨 Paint     │
///   │                           │
///   │       🧒 Trevor           │
///   └──────────────────────────┘
class RoomScreen extends ConsumerWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Room background
          const _RoomBackground(),

          // Window (top center) with "Trevor's" left and "Room" right
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Trevor's",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: TrevorColors.textDark,
                  ),
                ),
                const SizedBox(width: 12),
                const _WindowDecoration(),
                const SizedBox(width: 12),
                const Text(
                  'Room',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: TrevorColors.textDark,
                  ),
                ),
              ],
            ),
          ),

          // Toy grid — two columns
          Positioned(
            top: 140,
            left: 24,
            right: 24,
            bottom: 160,
            child: _ToyGrid(context: context),
          ),

          // Trevor character (bottom center)
          const Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(child: _TrevorCharacter()),
          ),
        ],
      ),
    );
  }
}

class _ToyGrid extends StatelessWidget {
  final BuildContext context;
  const _ToyGrid({required this.context});

  @override
  Widget build(BuildContext ctx) {
    final toys = [
      _ToyItem(
        emoji: '🎈',
        label: 'Balloons',
        color: TrevorColors.balloonRed,
        available: true,
        onTap: () => context.push('/balloon-pop'),
      ),
      _ToyItem(
        emoji: '🧸',
        label: 'Teddy',
        color: TrevorColors.coral,
        available: false,
        onTap: null,
      ),
      _ToyItem(
        emoji: '📚',
        label: 'Bookshelf',
        color: TrevorColors.skyBlue,
        available: false,
        onTap: null,
      ),
      _ToyItem(
        emoji: '🧩',
        label: 'Puzzle',
        color: TrevorColors.softGreen,
        available: false,
        onTap: null,
      ),
      _ToyItem(
        emoji: '🎹',
        label: 'Piano',
        color: TrevorColors.lavender,
        available: false,
        onTap: null,
      ),
      _ToyItem(
        emoji: '🎨',
        label: 'Paint',
        color: TrevorColors.mint,
        available: false,
        onTap: null,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      physics: const NeverScrollableScrollPhysics(),
      children: toys.asMap().entries.map((entry) {
        final i = entry.key;
        final toy = entry.value;
        return BouncyScale(
          delay: Duration(milliseconds: i * 80),
          child: _ToyCard(toy: toy),
        );
      }).toList(),
    );
  }
}

class _ToyCard extends StatelessWidget {
  final _ToyItem toy;
  const _ToyCard({required this.toy});

  @override
  Widget build(BuildContext context) {
    return TrevorButton(
      onTap: toy.available ? toy.onTap : null,
      color: toy.available ? toy.color : Colors.grey.shade300,
      size: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(toy.emoji, style: const TextStyle(fontSize: 44)),
          const SizedBox(height: 6),
          Text(
            toy.label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: toy.available
                  ? TrevorColors.textDark
                  : Colors.grey.shade500,
            ),
          ),
          if (!toy.available)
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                'Coming soon',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}

class _ToyItem {
  final String emoji;
  final String label;
  final Color color;
  final bool available;
  final VoidCallback? onTap;

  const _ToyItem({
    required this.emoji,
    required this.label,
    required this.color,
    required this.available,
    required this.onTap,
  });
}

/// Soft room-colored background with a floor line.
class _RoomBackground extends StatelessWidget {
  const _RoomBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _RoomPainter());
  }
}

class _RoomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Wall
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.78),
      Paint()..color = const Color(0xFFFFF8E1),
    );
    // Floor
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.78, size.width, size.height * 0.22),
      Paint()..color = const Color(0xFFD7CCC8),
    );
    // Baseboard
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.775, size.width, 6),
      Paint()..color = const Color(0xFFBCAAA4),
    );
    // Wallpaper dots
    final dotPaint = Paint()
      ..color = const Color(0xFFFFE082).withValues(alpha: 0.5);
    for (var row = 0; row < 12; row++) {
      for (var col = 0; col < 8; col++) {
        canvas.drawCircle(
          Offset(col * size.width / 7 + 20, row * 70.0 + 30),
          4,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _WindowDecoration extends StatelessWidget {
  const _WindowDecoration();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFF87CEEB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBCAAA4), width: 6),
      ),
      child: Stack(
        children: [
          // Cross bars
          Center(
            child: Container(
              width: 120,
              height: 3,
              color: const Color(0xFFBCAAA4),
            ),
          ),
          Center(
            child: Container(
              width: 3,
              height: 90,
              color: const Color(0xFFBCAAA4),
            ),
          ),
          // Sun
          const Positioned(
            top: 8,
            right: 12,
            child: Text('☀️', style: TextStyle(fontSize: 22)),
          ),
        ],
      ),
    );
  }
}

class _TrevorCharacter extends StatefulWidget {
  const _TrevorCharacter();

  @override
  State<_TrevorCharacter> createState() => _TrevorCharacterState();
}

class _TrevorCharacterState extends State<_TrevorCharacter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  late final Animation<double> _bob = Tween<double>(
    begin: 0,
    end: -8,
  ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Emoji + name bob together
        AnimatedBuilder(
          animation: _bob,
          builder: (_, child) =>
              Transform.translate(offset: Offset(0, _bob.value), child: child),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🧒', style: TextStyle(fontSize: 64)),
              Text(
                'Trevor',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: TrevorColors.textDark,
                ),
              ),
            ],
          ),
        ),
        // Tagline stays still
        const SizedBox(height: 4),
        const Text(
          'Play. Learn. Smile.',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: TrevorColors.coral,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
