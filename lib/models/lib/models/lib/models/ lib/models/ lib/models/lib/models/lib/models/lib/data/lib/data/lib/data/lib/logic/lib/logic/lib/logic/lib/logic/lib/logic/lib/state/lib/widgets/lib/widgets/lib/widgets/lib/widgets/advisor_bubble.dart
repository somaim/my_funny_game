import 'package:flutter/material.dart';
import '../models/advisor.dart';

class AdvisorBubble extends StatelessWidget {
  final Advisor advisor;
  final String introLine;
  final String adviceText;

  const AdvisorBubble({
    super.key,
    required this.advisor,
    required this.introLine,
    required this.adviceText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFC857).withOpacity(0.15),
                border: Border.all(
                  color: const Color(0xFFFFC857).withOpacity(0.5),
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(advisor.emoji, style: const TextStyle(fontSize: 26)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    advisor.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    advisor.tagline,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          introLine,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFC857).withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFC857).withOpacity(0.3)),
          ),
          child: Text(
            '"$adviceText"',
            style: const TextStyle(
              color: Color(0xFFFFC857),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
