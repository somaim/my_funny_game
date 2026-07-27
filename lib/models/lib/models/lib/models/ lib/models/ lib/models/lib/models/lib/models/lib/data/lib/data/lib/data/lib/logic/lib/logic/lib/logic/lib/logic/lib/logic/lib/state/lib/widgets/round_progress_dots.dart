import 'package:flutter/material.dart';
import '../models/episode.dart';

class RoundProgressDots extends StatelessWidget {
  final int completedRounds;

  const RoundProgressDots({super.key, required this.completedRounds});

  @override
  Widget build(BuildContext context) {
    final total = Episode.roundsPerEpisode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final filled = index < completedRounds;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: filled ? 14 : 10,
          height: filled ? 14 : 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled
                ? const Color(0xFFFFC857)
                : Colors.white.withOpacity(0.25),
            boxShadow: filled
                ? [
                    BoxShadow(
                      color: const Color(0xFFFFC857).withOpacity(0.6),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
