import 'round_result.dart';
import 'legend_card.dart';

class Episode {
  final String id;
  final DateTime startedAt;
  final List<RoundResult> rounds;
  LegendCard? legendCard;
  static const int roundsPerEpisode = 7;

  Episode({
    required this.id,
    required this.startedAt,
    List<RoundResult>? rounds,
    this.legendCard,
  }) : rounds = rounds ?? <RoundResult>[];

  bool get isComplete => rounds.length >= roundsPerEpisode;

  int get currentRoundNumber => rounds.length + 1;

  void addRound(RoundResult result) {
    rounds.add(result);
  }

  int get totalChaosAccumulated {
    int total = 0;
    for (final r in rounds) {
      total += r.roundChaosValue;
    }
    return total;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startedAt': startedAt.toIso8601String(),
      'rounds': rounds.map((r) => r.toJson()).toList(),
      'legendCard': legendCard?.toJson(),
    };
  }

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      rounds: (json['rounds'] as List)
          .map((r) => RoundResult.fromJson(r as Map<String, dynamic>))
          .toList(),
      legendCard: json['legendCard'] != null
          ? LegendCard.fromJson(json['legendCard'] as Map<String, dynamic>)
          : null,
    );
  }
}
