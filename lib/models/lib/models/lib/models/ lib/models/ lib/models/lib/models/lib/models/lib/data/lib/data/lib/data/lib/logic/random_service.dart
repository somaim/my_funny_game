import 'dart:math';
import '../models/scenario.dart';
import '../models/advisor.dart';

class RandomService {
  final Random _random = Random();
  final List<String> _recentScenarios = [];
  final List<String> _recentAdvisors = [];
  static const int _memorySize = 6;

  T pickOne<T>(List<T> list) {
    return list[_random.nextInt(list.length)];
  }

  List<T> pickN<T>(List<T> list, int n) {
    final shuffled = List<T>.from(list)..shuffle(_random);
    if (n >= shuffled.length) return shuffled;
    return shuffled.sublist(0, n);
  }

  int nextInt(int max) => _random.nextInt(max);

  bool chance(double probability) => _random.nextDouble() < probability;

  Scenario pickScenario(List<Scenario> all) {
    var available =
        all.where((s) => !_recentScenarios.contains(s.id)).toList();
    if (available.isEmpty) available = all;
    final chosen = pickOne(available);
    _recentScenarios.add(chosen.id);
    if (_recentScenarios.length > _memorySize) {
      _recentScenarios.removeAt(0);
    }
    return chosen;
  }

  Advisor pickAdvisor(List<Advisor> unlockedAdvisors) {
    var available =
        unlockedAdvisors.where((a) => !_recentAdvisors.contains(a.id)).toList();
    if (available.isEmpty) available = unlockedAdvisors;
    final chosen = pickOne(available);
    _recentAdvisors.add(chosen.id);
    if (_recentAdvisors.length > _memorySize) {
      _recentAdvisors.removeAt(0);
    }
    return chosen;
  }

  void resetMemory() {
    _recentScenarios.clear();
    _recentAdvisors.clear();
  }
}
