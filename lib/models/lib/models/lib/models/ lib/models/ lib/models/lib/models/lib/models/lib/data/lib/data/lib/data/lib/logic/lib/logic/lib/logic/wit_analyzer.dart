import 'dart:math';
import '../models/advisor.dart';

class WitAnalyzer {
  static final Random _rand = Random();

  static bool judge(String argueText, Advisor advisor) {
    final trimmed = argueText.trim();
    if (trimmed.isEmpty) return false;
    if (trimmed.length < 3) return false;

    int score = 0;
    final lower = trimmed.toLowerCase();

    final lengthBonus = (trimmed.length.clamp(0, 180) ~/ 12);
    score += lengthBonus;

    for (final keyword in advisor.weaknessKeywords) {
      if (lower.contains(keyword.toLowerCase())) {
        score += 12;
      }
    }

    final funnyMarkers = [
      'lol', 'literally', 'ridiculous', 'absurd', 'never', 'why would',
      'seriously', 'bro', 'dude', 'actually', 'no offense', 'listen',
      'honestly', 'okay but', 'exactly', 'because'
    ];
    for (final marker in funnyMarkers) {
      if (lower.contains(marker)) {
        score += 4;
      }
    }

    if (trimmed.contains('?')) score += 3;
    if (trimmed.contains('!')) score += 2;

    final wordCount = trimmed.split(RegExp(r'\s+')).length;
    if (wordCount >= 6) score += 6;
    if (wordCount >= 12) score += 6;
    if (wordCount > 40) score -= 10;

    score += _rand.nextInt(18);

    return score >= 24;
  }

  static int witScore(String argueText, Advisor advisor) {
    final trimmed = argueText.trim();
    if (trimmed.isEmpty) return 0;

    int score = 0;
    final lower = trimmed.toLowerCase();

    score += (trimmed.length.clamp(0, 180) ~/ 12);

    for (final keyword in advisor.weaknessKeywords) {
      if (lower.contains(keyword.toLowerCase())) {
        score += 12;
      }
    }

    final wordCount = trimmed.split(RegExp(r'\s+')).length;
    if (wordCount >= 6) score += 6;
    if (wordCount >= 12) score += 6;

    return score.clamp(0, 100);
  }
}
