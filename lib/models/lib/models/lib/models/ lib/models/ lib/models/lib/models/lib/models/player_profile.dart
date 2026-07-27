import 'advisor.dart';
import 'choice_type.dart';
import 'legend_card.dart';

class PlayerProfile {
  Map<String, int> reputationCounters;
  Set<String> unlockedTraits;
  Set<String> advisorsMet;
  List<LegendCard> almanac;
  int totalEpisodesPlayed;

  PlayerProfile({
    required this.reputationCounters,
    required this.unlockedTraits,
    required this.advisorsMet,
    required this.almanac,
    required this.totalEpisodesPlayed,
  });

  factory PlayerProfile.initial() {
    return PlayerProfile(
      reputationCounters: <String, int>{},
      unlockedTraits: <String>{},
      advisorsMet: <String>{},
      almanac: <LegendCard>[],
      totalEpisodesPlayed: 0,
    );
  }

  void _increment(String key, [int amount = 1]) {
    reputationCounters[key] = (reputationCounters[key] ?? 0) + amount;
  }

  int counter(String key) => reputationCounters[key] ?? 0;

  void registerChoice({
    required Advisor advisor,
    required ChoiceType choice,
    bool? argueWon,
  }) {
    advisorsMet.add(advisor.id);
    _increment('total_choices');
    _increment('${choice.name}_total');

    for (final tag in advisor.personalityTags) {
      _increment('${choice.name}_$tag');
    }

    if (choice == ChoiceType.argue) {
      if (argueWon == true) {
        _increment('argue_win_total');
        _increment('argue_win_vs_${advisor.id}');
      } else {
        _increment('argue_lose_total');
        _increment('argue_lose_vs_${advisor.id}');
      }
    }

    checkTraitUnlocks();
  }

  void checkTraitUnlocks() {
    if (counter('rebel_total') >= 5) {
      unlockedTraits.add('chaos_agent');
    }
    if (counter('follow_total') >= 5) {
      unlockedTraits.add('compliant_soul');
    }
    if (counter('argue_win_total') >= 5) {
      unlockedTraits.add('silver_tongue');
    }
    if (counter('argue_win_total') >= 1 && counter('argue_lose_total') >= 1) {
      unlockedTraits.add('mixed_bag_debater');
    }
    if (advisorsMet.contains('ghost_cat') &&
        counter('argue_win_vs_ghost_cat') >= 1) {
      unlockedTraits.add('ghost_whisperer');
    }
    if (unlockedTraits.contains('ghost_whisperer') &&
        counter('rebel_total') >= 10) {
      unlockedTraits.add('lincoln_unlocked');
    }
    if (counter('follow_aggressive') >= 3) {
      unlockedTraits.add('conqueror_energy');
    }
    if (counter('rebel_corporate') >= 3) {
      unlockedTraits.add('corporate_menace');
    }
    if (totalEpisodesPlayed >= 10) {
      unlockedTraits.add('veteran_of_chaos');
    }
  }

  bool isAdvisorUnlocked(Advisor advisor) {
    if (!advisor.isLegendary) return true;
    if (advisor.unlockTraitRequired == null) return true;
    return unlockedTraits.contains(advisor.unlockTraitRequired);
  }

  String computeTitle() {
    final followScore = counter('follow_total');
    final argueScore = counter('argue_win_total');
    final rebelScore = counter('rebel_total');

    if (followScore == 0 && argueScore == 0 && rebelScore == 0) {
      return 'The Undecided';
    }

    if (rebelScore >= followScore && rebelScore >= argueScore) {
      return 'The Chaos Agent';
    } else if (argueScore >= followScore && argueScore >= rebelScore) {
      return 'The Silver Tongue';
    } else {
      return 'The Compliant One';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'reputationCounters': reputationCounters,
      'unlockedTraits': unlockedTraits.toList(),
      'advisorsMet': advisorsMet.toList(),
      'almanac': almanac.map((c) => c.toJson()).toList(),
      'totalEpisodesPlayed': totalEpisodesPlayed,
    };
  }

  factory PlayerProfile.fromJson(Map<String, dynamic> json) {
    return PlayerProfile(
      reputationCounters: Map<String, int>.from(
        (json['reputationCounters'] as Map).map(
          (k, v) => MapEntry(k as String, v as int),
        ),
      ),
      unlockedTraits: Set<String>.from(json['unlockedTraits'] as List),
      advisorsMet: Set<String>.from(json['advisorsMet'] as List),
      almanac: (json['almanac'] as List)
          .map((c) => LegendCard.fromJson(c as Map<String, dynamic>))
          .toList(),
      totalEpisodesPlayed: json['totalEpisodesPlayed'] as int,
    );
  }
}
