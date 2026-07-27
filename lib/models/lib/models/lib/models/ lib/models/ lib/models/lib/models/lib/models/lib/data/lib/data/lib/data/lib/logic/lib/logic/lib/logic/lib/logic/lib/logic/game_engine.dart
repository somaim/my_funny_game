import '../data/advisors_database.dart';
import '../data/scenarios_database.dart';
import '../data/word_banks.dart';
import '../models/advisor.dart';
import '../models/scenario.dart';
import '../models/choice_type.dart';
import '../models/round_result.dart';
import '../models/episode.dart';
import '../models/legend_card.dart';
import '../models/player_profile.dart';
import 'random_service.dart';
import 'template_filler.dart';
import 'wit_analyzer.dart';
import 'storage_service.dart';

class RoundPreview {
  final Scenario scenario;
  final Advisor advisor;
  final String adviceText;

  RoundPreview({
    required this.scenario,
    required this.advisor,
    required this.adviceText,
  });
}

class GameEngine {
  final RandomService random;
  final StorageService storage;
  PlayerProfile profile;
  Episode? currentEpisode;

  GameEngine({
    required this.random,
    required this.storage,
  }) : profile = PlayerProfile.initial();

  Future<void> loadProfile() async {
    profile = await storage.loadProfile();
  }

  Future<void> saveProfile() async {
    await storage.saveProfile(profile);
  }

  List<Advisor> get unlockedAdvisors {
    return allAdvisors.where((a) => profile.isAdvisorUnlocked(a)).toList();
  }

  Episode startNewEpisode() {
    final episode = Episode(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startedAt: DateTime.now(),
    );
    currentEpisode = episode;
    return episode;
  }

  RoundPreview generateRound() {
    final scenario = random.pickScenario(allScenarios);
    final advisor = random.pickAdvisor(unlockedAdvisors);
    final template = random.pickOne(advisor.followAdviceTemplates);
    final adviceText = TemplateFiller.fill(
      template,
      random: random,
      scenario: scenario,
      advisorName: advisor.name,
    );
    return RoundPreview(
      scenario: scenario,
      advisor: advisor,
      adviceText: adviceText,
    );
  }

  RoundResult resolveChoice({
    required Scenario scenario,
    required Advisor advisor,
    required String adviceTextShown,
    required ChoiceType choice,
    String? argueText,
  }) {
    bool? argueWon;
    String consequenceText;
    String finalAdviceText = adviceTextShown;
    int chaosValue = 1 + random.nextInt(3);

    if (choice == ChoiceType.follow) {
      final template = random.pickOne(advisor.consequenceFollowTemplates);
      consequenceText = TemplateFiller.fill(
        template,
        random: random,
        scenario: scenario,
        advisorName: advisor.name,
      );
    } else if (choice == ChoiceType.rebel) {
      final rebelTemplate = random.pickOne(advisor.rebelAdviceTemplates);
      finalAdviceText = TemplateFiller.fill(
        rebelTemplate,
        random: random,
        scenario: scenario,
        advisorName: advisor.name,
      );
      final template = random.pickOne(advisor.consequenceRebelTemplates);
      consequenceText = TemplateFiller.fill(
        template,
        random: random,
        scenario: scenario,
        advisorName: advisor.name,
      );
      chaosValue += 1;
    } else {
      final text = argueText ?? '';
      argueWon = WitAnalyzer.judge(text, advisor);
      final responseTemplate = argueWon
          ? random.pickOne(advisor.argueWinResponses)
          : random.pickOne(advisor.argueLoseResponses);
      finalAdviceText = TemplateFiller.fill(
        responseTemplate,
        random: random,
        scenario: scenario,
        advisorName: advisor.name,
      );
      final consequenceTemplate = argueWon
          ? random.pickOne(advisor.consequenceArgueWinTemplates)
          : random.pickOne(advisor.consequenceArgueLoseTemplates);
      consequenceText = TemplateFiller.fill(
        consequenceTemplate,
        random: random,
        scenario: scenario,
        advisorName: advisor.name,
      );
      chaosValue += argueWon ? 2 : 1;
    }

    final result = RoundResult(
      scenarioId: scenario.id,
      advisorId: advisor.id,
      scenarioSetupText: scenario.setup,
      advisorAdviceText: finalAdviceText,
      choiceType: choice,
      argueText: argueText,
      argueWon: argueWon,
      consequenceText: consequenceText,
      roundChaosValue: chaosValue,
    );

    currentEpisode?.addRound(result);
    profile.registerChoice(
      advisor: advisor,
      choice: choice,
      argueWon: argueWon,
    );

    return result;
  }

  bool isEpisodeComplete() {
    return currentEpisode != null && currentEpisode!.isComplete;
  }

  LegendCard finalizeEpisode() {
    final episode = currentEpisode;
    if (episode == null) {
      throw StateError('No active episode to finalize.');
    }

    int followCount = 0;
    int argueCount = 0;
    int argueWinCount = 0;
    int rebelCount = 0;
    final Set<String> advisorIds = {};

    for (final round in episode.rounds) {
      advisorIds.add(round.advisorId);
      switch (round.choiceType) {
        case ChoiceType.follow:
          followCount++;
          break;
        case ChoiceType.argue:
          argueCount++;
          if (round.argueWon == true) argueWinCount++;
          break;
        case ChoiceType.rebel:
          rebelCount++;
          break;
      }
    }

    String dominantStyle;
    if (rebelCount >= followCount && rebelCount >= argueCount) {
      dominantStyle = 'Chaos Agent';
    } else if (argueCount >= followCount && argueCount >= rebelCount) {
      dominantStyle = 'Silver Tongue';
    } else {
      dominantStyle = 'Compliant Soul';
    }

    final chaosScore = episode.totalChaosAccumulated.clamp(0, 100);

    final verb = chaosScore >= 15
        ? random.pickOne(WordBanks.headlineVerbsChaotic)
        : random.pickOne(WordBanks.headlineVerbsPositive);

    final subject = random.pickOne(WordBanks.professions);
    final place = random.pickOne(WordBanks.places);
    final absurdThing = random.pickOne(WordBanks.absurdThings);
    final noun = random.pickOne(WordBanks.nouns);

    final headline =
        'LOCAL $subject $verb $place, INVOLVES $absurdThing AND ONE VERY CONFUSED $noun'
            .toUpperCase();

    final subheadline =
        'Chaos Rating: $chaosScore/100 — Dominant Style: $dominantStyle';

    final buffer = StringBuffer();
    buffer.writeln(
        'Today\'s saga began with ${episode.rounds.isNotEmpty ? episode.rounds.first.scenarioSetupText : "an ordinary day"}');
    buffer.writeln();
    for (final round in episode.rounds) {
      buffer.writeln('• ${round.consequenceText}');
    }
    buffer.writeln();
    buffer.writeln(
        'Final tally: $followCount followed, $argueCount argued ($argueWinCount won), $rebelCount rebelled.');

    final card = LegendCard(
      id: 'legend_${DateTime.now().millisecondsSinceEpoch}',
      headline: headline,
      subheadline: subheadline,
      bodyText: buffer.toString(),
      createdAt: DateTime.now(),
      chaosScore: chaosScore,
      advisorsInvolved: advisorIds.toList(),
      dominantStyle: dominantStyle,
    );

    episode.legendCard = card;
    profile.almanac.add(card);
    profile.totalEpisodesPlayed += 1;
    profile.checkTraitUnlocks();

    return card;
  }

  void resetSessionMemory() {
    random.resetMemory();
  }
}
