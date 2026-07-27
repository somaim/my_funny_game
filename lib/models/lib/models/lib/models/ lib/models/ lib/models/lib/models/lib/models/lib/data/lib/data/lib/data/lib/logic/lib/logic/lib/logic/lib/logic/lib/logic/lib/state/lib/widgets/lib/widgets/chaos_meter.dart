import 'package:flutter/material.dart';

class ChaosMeter extends StatelessWidget {
  final int chaosValue;
  final int maxChaos;

  const ChaosMeter({
    super.key,
    required this.chaosValue,
    this.maxChaos = 35,
  });

  Color _colorForRatio(double ratio) {
    if (ratio < 0.33) return const Color(0xFF6BCB77);
    if (ratio < 0.66) return const Color(0xFFFFD93D);
    return const Color(0xFFFF6B6B);
  }

  @override
  Widget build(BuildContext context) {
    final ratio = (chaosValue / maxChaos).clamp(0.0, 1.0);
    final color = _colorForRatio(ratio);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'CHAOS METER',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              '$chaosValue',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: ratio),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: Colors.white.withOpacity(0.12),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              );
            },
          ),
        ),
      ],
    );
  }
}
