/// Neutral scenario handle. Product types stay in the product host.
class InspectionScenarioRef {
  const InspectionScenarioRef({
    required this.id,
    required this.label,
    required this.sectionId,
  });
  final String id;
  final String label;

  /// Main area this state belongs to: auth, home, games, shop, and the rest.
  final String sectionId;
}

typedef ScenarioActivator = Future<void> Function(String id);

class ScenarioCatalog {
  const ScenarioCatalog({
    required this.scenarios,
    required this.activate,
    this.activeId,
  });
  final List<InspectionScenarioRef> scenarios;
  final ScenarioActivator activate;
  final String? activeId;
}
