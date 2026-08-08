import 'package:flutter/material.dart';
import '../theme/trevor_colors.dart';

/// A large, rounded, kid-friendly button with a satisfying press animation.
class TrevorButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color color;
  final double size;

  const TrevorButton({
    super.key,
    required this.child,
    this.onTap,
    this.color = TrevorColors.coral,
    this.size = 80,
  });

  @override
  State<TrevorButton> createState() => _TrevorButtonState();
}

class _TrevorButtonState extends State<TrevorButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    reverseDuration: const Duration(milliseconds: 180),
    lowerBound: 0.88,
    upperBound: 1.0,
    value: 1.0,
  );

  void _onTapDown(TapDownDetails _) => _controller.reverse();
  void _onTapUp(TapUpDetails _) {
    _controller.forward();
    widget.onTap?.call();
  }

  void _onTapCancel() => _controller.forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _controller,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(
              widget.size.isFinite ? widget.size * 0.25 : 24.0,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}
