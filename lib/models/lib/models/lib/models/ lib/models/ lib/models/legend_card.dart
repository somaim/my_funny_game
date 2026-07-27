class LegendCard {
  final String id;
  final String headline;
  final String subheadline;
  final String bodyText;
  final DateTime createdAt;
  final int chaosScore;
  final List<String> advisorsInvolved;
  final String dominantStyle;

  LegendCard({
    required this.id,
    required this.headline,
    required this.subheadline,
    required this.bodyText,
    required this.createdAt,
    required this.chaosScore,
    required this.advisorsInvolved,
    required this.dominantStyle,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'headline': headline,
      'subheadline': subheadline,
      'bodyText': bodyText,
      'createdAt': createdAt.toIso8601String(),
      'chaosScore': chaosScore,
      'advisorsInvolved': advisorsInvolved,
      'dominantStyle': dominantStyle,
    };
  }

  factory LegendCard.fromJson(Map<String, dynamic> json) {
    return LegendCard(
      id: json['id'] as String,
      headline: json['headline'] as String,
      subheadline: json['subheadline'] as String,
      bodyText: json['bodyText'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      chaosScore: json['chaosScore'] as int,
      advisorsInvolved: List<String>.from(json['advisorsInvolved'] as List),
      dominantStyle: json['dominantStyle'] as String,
    );
  }
}
