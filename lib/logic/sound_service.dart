import 'package:flutter/services.dart';

enum GameSoundEvent {
  buttonTap,
  follow,
  rebel,
  argueSubmit,
  argueWin,
  argueLose,
  roundAdvance,
  episodeComplete,
  traitUnlocked,
}

class SoundService {
  bool soundEnabled = true;
  bool hapticsEnabled = true;

  void play(GameSoundEvent event) {
    switch (event) {
      case GameSoundEvent.buttonTap:
        _click();
        _lightHaptic();
        break;
      case GameSoundEvent.follow:
        _click();
        _selectionHaptic();
        break;
      case GameSoundEvent.rebel:
        _alert();
        _mediumHaptic();
        break;
      case GameSoundEvent.argueSubmit:
        _click();
        _mediumHaptic();
        break;
      case GameSoundEvent.argueWin:
        _alert();
        _heavyHaptic();
        break;
      case GameSoundEvent.argueLose:
        _click();
        _lightHaptic();
        break;
      case GameSoundEvent.roundAdvance:
        _click();
        _selectionHaptic();
        break;
      case GameSoundEvent.episodeComplete:
        _alert();
        _celebrationHapticSequence();
        break;
      case GameSoundEvent.traitUnlocked:
        _alert();
        _heavyHaptic();
        break;
    }
  }

  void _click() {
    if (!soundEnabled) return;
    SystemSound.play(SystemSoundType.click);
  }

  void _alert() {
    if (!soundEnabled) return;
    SystemSound.play(SystemSoundType.alert);
  }

  void _lightHaptic() {
    if (!hapticsEnabled) return;
    HapticFeedback.lightImpact();
  }

  void _mediumHaptic() {
    if (!hapticsEnabled) return;
    HapticFeedback.mediumImpact();
  }

  void _heavyHaptic() {
    if (!hapticsEnabled) return;
    HapticFeedback.heavyImpact();
  }

  void _selectionHaptic() {
    if (!hapticsEnabled) return;
    HapticFeedback.selectionClick();
  }

  Future<void> _celebrationHapticSequence() async {
    if (!hapticsEnabled) return;
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 120));
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 120));
    HapticFeedback.heavyImpact();
  }

  void toggleSound() {
    soundEnabled = !soundEnabled;
  }

  void toggleHaptics() {
    hapticsEnabled = !hapticsEnabled;
  }
}
