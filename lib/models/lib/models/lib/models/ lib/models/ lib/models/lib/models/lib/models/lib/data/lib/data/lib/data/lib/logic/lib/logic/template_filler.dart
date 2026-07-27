import '../data/word_banks.dart';
import '../models/scenario.dart';
import 'random_service.dart';

class TemplateFiller {
  static String fill(
    String template, {
    required RandomService random,
    required Scenario scenario,
    String? advisorName,
  }) {
    String result = template;

    result = result.replaceAll('{context}', scenario.shortContext);

    if (advisorName != null) {
      result = result.replaceAll('{advisor}', advisorName);
    }

    while (result.contains('{noun}')) {
      result = result.replaceFirst('{noun}', random.pickOne(WordBanks.nouns));
    }
    while (result.contains('{adjective}')) {
      result = result.replaceFirst(
          '{adjective}', random.pickOne(WordBanks.adjectives));
    }
    while (result.contains('{absurd}')) {
      result = result.replaceFirst(
          '{absurd}', random.pickOne(WordBanks.absurdThings));
    }
    while (result.contains('{place}')) {
      result =
          result.replaceFirst('{place}', random.pickOne(WordBanks.places));
    }
    while (result.contains('{animal}')) {
      result =
          result.replaceFirst('{animal}', random.pickOne(WordBanks.animals));
    }
    while (result.contains('{food}')) {
      result = result.replaceFirst('{food}', random.pickOne(WordBanks.foods));
    }
    while (result.contains('{profession}')) {
      result = result.replaceFirst(
          '{profession}', random.pickOne(WordBanks.professions));
    }
    while (result.contains('{emotion}')) {
      result = result.replaceFirst(
          '{emotion}', random.pickOne(WordBanks.emotions));
    }
    while (result.contains('{historical}')) {
      result = result.replaceFirst(
          '{historical}', random.pickOne(WordBanks.historicalFigures));
    }

    return result;
  }
}
