import 'package:flutter/material.dart';
import '../state/game_controller.dart';
import '../models/choice_type.dart';
import '../models/episode.dart';
import '../widgets/scenario_card.dart';
import '../widgets/advisor_bubble.dart';
import '../widgets/choice_buttons.dart';
import '../widgets/chaos_meter.dart';
import '../widgets/round_progress_dots.dart';
import 'episode_summary_screen.dart';

class GameScreen extends StatefulWidget {
  final GameController controller;

  const GameScreen({super.key, required this.controller});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _argueTextController = TextEditingController();
  final FocusNode _argueFocusNode = FocusNode();
  String? _cachedIntroLine;
  String? _cachedIntroForAdvisorId;

  @override
  void dispose() {
    _argueTextController.dispose();
    _argueFocusNode.dispose();
    super.dispose();
  }

  String _introLineFor(String advisorId, List<String> introLines) {
    if (_cachedIntroForAdvisorId == advisorId && _cachedIntroLine != null) {
      return _cachedIntroLine!;
    }
    final chosen = introLines[
        (DateTime.now().millisecondsSinceEpoch) % introLines.length];
    _cachedIntroForAdvisorId = advisorId;
    _cachedIntroLine = chosen;
    return chosen;
  }

  void _handleArgueSubmit() {
    final text = _argueTextController.text.trim();
    if (text.isEmpty) return;
    widget.controller.submitArgue(text);
    _argueTextController.clear();
    _argueFocusNode.unfocus();
  }

  void _handleNext() async {
    final wasLastRound = widget.controller.isEpisodeComplete;
    await widget.controller.proceedNext();
    if (wasLastRound && mounted) {
      final card = widget.controller.lastLegendCard;
      if (card != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => EpisodeSummaryScreen(controller: widget.controller),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final preview = widget.controller.currentPreview;
        if (preview == null) {
          return const Scaffold(
            backgroundColor: Color(0xFF1F1D36),
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC857)),
              ),
            ),
          );
        }

        final result = widget.controller.lastResult;
        final showingConsequence = widget.controller.showingConsequence;
        final argueMode = widget.controller.argueMode;
        final completedRounds =
            widget.controller.currentEpisode?.rounds.length ?? 0;
        final roundNumber = widget.controller.episodeRoundNumber
            .clamp(1, Episode.roundsPerEpisode);

        final introLine = _introLineFor(preview.advisor.id, preview.advisor.introLines);

        return Scaffold(
          backgroundColor: const Color(0xFF1F1D36),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close, color: Colors.white54),
                          ),
                          Text(
                            'ROUND $roundNumber / ${Episode.roundsPerEpisode}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 8),
                      RoundProgressDots(completedRounds: completedRounds),
                      const SizedBox(height: 14),
                      ChaosMeter(chaosValue: widget.controller.episodeChaosSoFar),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.05),
                            end: Offset.zero,
                          ).animate(anim),
                          child: child,
                        ),
                      ),
                      child: showingConsequence
                          ? _buildConsequenceView(result!)
                          : _buildDecisionView(preview, introLine, argueMode),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDecisionView(
    dynamic preview,
    String introLine,
    bool argueMode,
  ) {
    return Column(
      key: const ValueKey('decision'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ScenarioCard(scenario: preview.scenario),
        const SizedBox(height: 18),
        AdvisorBubble(
          advisor: preview.advisor,
          introLine: introLine,
          adviceText: preview.adviceText,
        ),
        const SizedBox(height: 22),
        if (!argueMode)
          ChoiceButtons(
            onFollow: widget.controller.chooseFollow,
            onArgue: widget.controller.openArgueInput,
            onRebel: widget.controller.chooseRebel,
          )
        else
          _buildArgueInput(),
      ],
    );
  }

  Widget _buildArgueInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4DA8FF).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4DA8FF).withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Type your rebuttal. Make it count. 🗣️',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _argueTextController,
            focusNode: _argueFocusNode,
            autofocus: true,
            maxLength: 140,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'e.g. "Absolutely not, and here\'s why..."',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              counterStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (_) => _handleArgueSubmit(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.controller.cancelArgueInput();
                    _argueTextController.clear();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: BorderSide(color: Colors.white.withOpacity(0.2)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('CANCEL'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _handleArgueSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4DA8FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'SUBMIT REBUTTAL',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConsequenceView(dynamic result) {
    final choice = result.choiceType as ChoiceType;
    final argueWon = result.argueWon as bool?;

    Color accentColor;
    String badgeText;

    if (choice == ChoiceType.follow) {
      accentColor = const Color(0xFF6BCB77);
      badgeText = 'YOU FOLLOWED THE ADVICE';
    } else if (choice == ChoiceType.rebel) {
      accentColor = const Color(0xFFFF6B6B);
      badgeText = 'YOU WENT ROGUE';
    } else {
      if (argueWon == true) {
        accentColor = const Color(0xFF4DA8FF);
        badgeText = 'YOU WON THE ARGUMENT';
      } else {
        accentColor = const Color(0xFFFFA24D);
        badgeText = 'YOU LOST THE ARGUMENT';
      }
    }

    final isLastRound = widget.controller.isEpisodeComplete;

    return Column(
      key: const ValueKey('consequence'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: accentColor.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                badgeText,
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            '"${result.advisorAdviceText}"',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [accentColor.withOpacity(0.18), Colors.transparent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: accentColor.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WHAT HAPPENED NEXT',
                style: TextStyle(
                  color: accentColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                result.consequenceText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        ElevatedButton(
          onPressed: _handleNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFC857),
            foregroundColor: const Color(0xFF1F1D36),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            isLastRound ? '🏆  SEE MY LEGEND CARD' : '➡️  NEXT SITUATION',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
