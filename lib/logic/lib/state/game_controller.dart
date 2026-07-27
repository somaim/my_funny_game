import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../logic/game_engine.dart';
import '../logic/random_service.dart';
import '../logic/storage_service.dart';
import '../logic/sound_service.dart';
import '../models/choice_type.dart';
import '../models/round_result.dart';
import '../models/legend_card.dart';
import '../models/player_profile.dart';
import '../models/episode.dart';

class GameController extends ChangeNotifier {
  final GameEngine engine;
  final SoundService soundService = SoundService();
  bool isLoading = true;
  bool argueMode = false;
  bool showingConsequence = false;
  bool justUnlockedTrait = false;
  String? newlyUnlockedTraitName;
  RoundPreview? currentPreview;
  RoundResult? lastResult;
  LegendCard? lastLegendCard;

  GameController()
      : engine = GameEngine(
          random: RandomService(),
          storage: StorageService(),
        );

  PlayerProfile get profile => engine.profile;
  Episode? get currentEpisode => engine.currentEpisode;

  Future<void> init() async {
    isLoading = true;
    notifyListeners();
    await engine.loadProfile();
    isLoading = false;
    notifyListeners();
  }

  void startNewEpisode() {
    engine.resetSessionMemory();
    engine.startNewEpisode();
    lastLegendCard = null;
    lastResult = null;
    showingConsequence = false;
    argueMode = false;
    currentPreview = engine.generateRound();
    notifyListeners();
  }

  void openArgueInput() {
    soundService.play(GameSoundEvent.buttonTap);
    argueMode = true;
    notifyListeners();
  }

  void cancelArgueInput() {
    argueMode = false;
    notifyListeners();
  }

  void chooseFollow() {
    soundService.play(GameSoundEvent.follow);
    HapticFeedback.selectionClick();
    _resolve(ChoiceType.follow);
  }

  void chooseRebel() {
    soundService.play(GameSoundEvent.rebel);
    HapticFeedback.selectionClick();
    _resolve(ChoiceType.rebel);
  }

  void submitArgue(String text) {
    soundService.play(GameSoundEvent.argueSubmit);
    HapticFeedback.mediumImpact();
    argueMode = false;
    _resolve(ChoiceType.argue, argueText: text);
  }

  void _resolve(ChoiceType choice, {String? argueText}) {
    final preview = currentPreview;
    if (preview == null) return;

    final traitsBefore = Set<String>.from(profile.unlockedTraits);

    lastResult = engine.resolveChoice(
      scenario: preview.scenario,
      advisor: preview.advisor,
      adviceTextShown: preview.adviceText,
      choice: choice,
      argueText: argueText,
    );

    if (choice == ChoiceType.argue) {
      if (lastResult!.argueWon == true) {
        soundService.play(GameSoundEvent.argueWin);
      } else {
        soundService.play(GameSoundEvent.argueLose);
      }
    }

    final traitsAfter = profile.unlockedTraits;
    final newTraits = traitsAfter.difference(traitsBefore);
    if (newTraits.isNotEmpty) {
      justUnlockedTrait = true;
      newlyUnlockedTraitName = newTraits.first;
      soundService.play(GameSoundEvent.traitUnlocked);
    } else {
      justUnlockedTrait = false;
      newlyUnlockedTraitName = null;
    }

    showingConsequence = true;
    notifyListeners();
  }

  bool get isEpisodeComplete => engine.isEpisodeComplete();

  Future<void> proceedNext() async {
    if (engine.isEpisodeComplete()) {
      soundService.play(GameSoundEvent.episodeComplete);
      lastLegendCard = engine.finalizeEpisode();
      await engine.saveProfile();
      currentPreview = null;
      showingConsequence = false;
      lastResult = null;
    } else {
      soundService.play(GameSoundEvent.roundAdvance);
      currentPreview = engine.generateRound();
      lastResult = null;
      showingConsequence = false;
      argueMode = false;
    }
    justUnlockedTrait = false;
    newlyUnlockedTraitName = null;
    notifyListeners();
  }

  Future<void> resetProgress() async {
    await engine.storage.clearProfile();
    engine.profile = PlayerProfile.initial();
    engine.currentEpisode = null;
    lastLegendCard = null;
    lastResult = null;
    currentPreview = null;
    notifyListeners();
  }

  void toggleSound() {
    soundService.toggleSound();
    notifyListeners();
  }

  void toggleHaptics() {
    soundService.toggleHaptics();
    notifyListeners();
  }

  int get episodeRoundNumber => engine.currentEpisode?.currentRoundNumber ?? 1;

  int get episodeChaosSoFar =>
      engine.currentEpisode?.totalChaosAccumulated ?? 0;
}
