import 'dart:math';
import 'package:flutter/material.dart';

class _ConfettiPiece {
  double x;
  double y;
  double velocityX;
  double velocityY;
  double rotation;
  double rotationSpeed;
  final Color color;
  final double size;

  _ConfettiPiece({
    required this.x,
    required this.y,
    required this.velocityX,
    required this.velocityY,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.size,
  });
}

class ConfettiOverlay extends StatefulWidget {
  final bool trigger;
  final Widget child;

  const ConfettiOverlay({
    super.key,
    required this.trigger,
    required this.child,
  });

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ConfettiPiece> _pieces = [];
  final Random _random = Random();
  bool _hasFired = false;

  static const List<Color> _palette = [
    Color(0xFFFFC857),
    Color(0xFF6BCB77),
    Color(0xFF4DA8FF),
    Color(0xFFFF6B6B),
    Color(0xFFB983FF),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(_onTick);

    if (widget.trigger) {
      _fire();
    }
  }

  @override
  void didUpdateWidget(covariant ConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !_hasFired) {
      _fire();
    }
    if (!widget.trigger) {
      _hasFired = false;
    }
  }

  void _fire() {
    _hasFired = true;
    _pieces.clear();
    for (int i = 0; i < 60; i++) {
      _pieces.add(
        _ConfettiPiece(
          x: 0.5 + (_random.nextDouble() - 0.5) * 0.3,
          y: 0.0,
          velocityX: (_random.nextDouble() - 0.5) * 2.4,
          velocityY: 1.0 + _random.nextDouble() * 1.8,
          rotation: _random.nextDouble() * pi * 2,
          rotationSpeed: (_random.nextDouble() - 0.5) * 8,
          color: _palette[_random.nextInt(_palette.length)],
          size: 6 + _random.nextDouble() * 6,
        ),
      );
    }
    _controller.reset();
    _controller.forward();
  }

  void _onTick() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onTick);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_controller.isAnimating)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _ConfettiPainter(
                  pieces: _pieces,
                  progress: _controller.value,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> pieces;
  final double progress;

  _ConfettiPainter({required this.pieces, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final t = progress * 3.0;

    for (final piece in pieces) {
      final currentX = (piece.x + piece.velocityX * t * 0.15) * size.width;
      final currentY =
          (piece.y + piece.velocityY * t * 0.35 + 0.5 * t * t * 0.12) *
              size.height;
      final currentRotation = piece.rotation + piece.rotationSpeed * t;

      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      paint.color = piece.color.withOpacity(opacity);

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(currentRotation);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: piece.size,
          height: piece.size * 0.5,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
