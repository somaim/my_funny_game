import 'package:flutter/material.dart';
import '../models/choice_type.dart';

class ChoiceButtons extends StatelessWidget {
  final VoidCallback onFollow;
  final VoidCallback onArgue;
  final VoidCallback onRebel;

  const ChoiceButtons({
    super.key,
    required this.onFollow,
    required this.onArgue,
    required this.onRebel,
  });

  Widget _buildButton({
    required String emoji,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.6), width: 1.5),
            ),
            child: Column(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildButton(
          emoji: ChoiceType.follow.emoji,
          label: ChoiceType.follow.displayLabel,
          color: const Color(0xFF6BCB77),
          onTap: onFollow,
        ),
        const SizedBox(width: 10),
        _buildButton(
          emoji: ChoiceType.argue.emoji,
          label: ChoiceType.argue.displayLabel,
          color: const Color(0xFF4DA8FF),
          onTap: onArgue,
        ),
        const SizedBox(width: 10),
        _buildButton(
          emoji: ChoiceType.rebel.emoji,
          label: ChoiceType.rebel.displayLabel,
          color: const Color(0xFFFF6B6B),
          onTap: onRebel,
        ),
      ],
    );
  }
}
