import 'package:flutter/material.dart';
import 'state/game_controller.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const WhoAskedApp());
}

class WhoAskedApp extends StatefulWidget {
  const WhoAskedApp({super.key});

  @override
  State<WhoAskedApp> createState() => _WhoAskedAppState();
}

class _WhoAskedAppState extends State<WhoAskedApp> {
  late final GameController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GameController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WHO ASKED?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1F1D36),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC857),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      ),
      home: SplashScreen(controller: _controller),
    );
  }
}
