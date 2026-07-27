import 'choice_type.dart';

class RoundResult {
  final String scenarioId;
  final String advisorId;
  final String scenarioSetupText;
  final String advisorAdviceText;
  final ChoiceType choiceType;
  final String? argueText;
  final bool? argueWon;
  final String consequenceText;
  final int roundChaosValue;

  RoundResult({
    required this.scenarioId,
    required this.advisorId,
    required this.scenarioSetupText,
    required this.advisorAdviceText,
    required this.choiceType,
    this.argueText,
    this.argueWon,
    required this.consequenceText,
    required this.roundChaosValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'scenarioId': scenarioId,
      'advisorId': advisorId,
      'scenarioSetupText': scenarioSetupText,
      'advisorAdviceText': advisorAdviceText,
      'choiceType': choiceType.name,
      'argueText': argueText,
      'argueWon': argueWon,
      'consequenceText': consequenceText,
      'roundChaosValue': roundChaosValue,
    };
  }

  factory RoundResult.fromJson(Map<String, dynamic> json) {
    return RoundResult(
      scenarioId: json['scenarioId'] as String,
      advisorId: json['advisorId'] as String,
      scenarioSetupText: json['scenarioSetupText'] as String,
      advisorAdviceText: json['advisorAdviceText'] as String,
      choiceType: ChoiceTypeExtension.fromName(json['choiceType'] as String),
      argueText: json['argueText'] as String?,
      argueWon: json['argueWon'] as bool?,
      consequenceText: json['consequenceText'] as String,
      roundChaosValue: json['roundChaosValue'] as int,
    );
  }
}
