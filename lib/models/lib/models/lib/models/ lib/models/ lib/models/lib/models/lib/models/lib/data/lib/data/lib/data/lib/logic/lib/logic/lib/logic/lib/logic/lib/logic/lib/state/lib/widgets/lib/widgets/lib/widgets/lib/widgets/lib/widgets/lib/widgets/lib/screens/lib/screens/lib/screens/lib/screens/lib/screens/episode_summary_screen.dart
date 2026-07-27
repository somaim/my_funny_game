import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/game_controller.dart';
import '../widgets/legend_card_view.dart';
import '../widgets/confetti_overlay.dart';
import 'home_screen.dart';
import 'game_screen.dart';

class EpisodeSummaryScreen extends StatefulWidget {
  final GameController controller;

  const EpisodeSummaryScreen({super.key, required this.controller});

  @override
  State<EpisodeSummaryScreen> createState() => _EpisodeSummaryScreenState();
}

class _EpisodeSummaryScreenState extends State<EpisodeSummaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(parent: _animController, curve: Curves.elasticOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String headline, String subheadline, String body) {
    final fullText = '$headline\n\n$subheadline\n\n$body';
    Clipboard.setData(ClipboardData(text: fullText));
    setState(() {
      _copied = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  void _goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => HomeScreen(controller: widget.controller),
      ),
      (route) => false,
    );
  }

  void _playAgain() {
    widget.controller.startNewEpisode();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => GameScreen(controller: widget.controller),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.controller.lastLegendCard;

    if (card == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF1F1D36),
        body: Center(
          child: ElevatedButton(
            onPressed: _goHome,
            child: const Text('Return Home'),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1F1D36),
      body: SafeArea(
        child: ConfettiOverlay(
          trigger: true,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
                child: Text(
                  '🎉 YOUR DAY IS COMPLETE',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    child: LegendCardView(card: card),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _copyToClipboard(
                          card.headline,
                          card.subheadline,
                          card.bodyText,
                        ),
                        icon: Icon(
                          _copied ? Icons.check : Icons.copy,
                          color: _copied ? const Color(0xFF6BCB77) : Colors.white70,
                          size: 18,
                        ),
                        label: Text(
                          _copied ? 'COPIED!' : 'COPY LEGEND TO CLIPBOARD',
                          style: TextStyle(
                            color: _copied ? const Color(0xFF6BCB77) : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white.withOpacity(0.2)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _goHome,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.white.withOpacity(0.3)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              '🏠 HOME',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _playAgain,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFC857),
                              foregroundColor: const Color(0xFF1F1D36),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              '🔁 PLAY AGAIN',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
