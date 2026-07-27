class Advisor {
  final String id;
  final String name;
  final String emoji;
  final String tagline;
  final List<String> personalityTags;
  final List<String> introLines;
  final List<String> followAdviceTemplates;
  final List<String> rebelAdviceTemplates;
  final List<String> argueWinResponses;
  final List<String> argueLoseResponses;
  final List<String> consequenceFollowTemplates;
  final List<String> consequenceRebelTemplates;
  final List<String> consequenceArgueWinTemplates;
  final List<String> consequenceArgueLoseTemplates;
  final List<String> weaknessKeywords;
  final List<String> reputationNicknames;
  final bool isLegendary;
  final String? unlockTraitRequired;

  const Advisor({
    required this.id,
    required this.name,
    required this.emoji,
    required this.tagline,
    required this.personalityTags,
    required this.introLines,
    required this.followAdviceTemplates,
    required this.rebelAdviceTemplates,
    required this.argueWinResponses,
    required this.argueLoseResponses,
    required this.consequenceFollowTemplates,
    required this.consequenceRebelTemplates,
    required this.consequenceArgueWinTemplates,
    required this.consequenceArgueLoseTemplates,
    required this.weaknessKeywords,
    required this.reputationNicknames,
    this.isLegendary = false,
    this.unlockTraitRequired,
  });
}
