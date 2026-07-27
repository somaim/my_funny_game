class Scenario {
  final String id;
  final String setup;
  final String shortContext;
  final List<String> tags;
  final int minChaos;
  final int maxChaos;

  const Scenario({
    required this.id,
    required this.setup,
    required this.shortContext,
    required this.tags,
    required this.minChaos,
    required this.maxChaos,
  });
}
