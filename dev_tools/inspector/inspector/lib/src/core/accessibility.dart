import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:p2e_design_system/design_system.dart';

import 'device.dart';

/// Semantics-tree finding. Labels and field values are never stored.
class AccessibilityFinding {
  AccessibilityFinding(
    this.kind,
    this.summary,
    this.ownerKey,
    this.elementId,
    this.device, {
    required this.facts,
    this.scenarioId,
  });
  final String kind, summary;
  final String? ownerKey, elementId, scenarioId;
  final FrameSettings device;
  final Map<String, Object?> facts;

  String get group =>
      '$kind|${ownerKey ?? elementId ?? 'unavailable'}|$scenarioId';

  Map<String, Object?> toJson() => {
    'kind': kind,
    'summary': summary,
    'ownerKey': ownerKey,
    'elementId': elementId,
    'scenarioId': scenarioId,
    'facts': facts,
    'device': device.toJson(),
  };
}

class AccessibilityAuditor extends ChangeNotifier {
  final List<AccessibilityFinding> findings = [];
  int collectorFailures = 0;
  int visited = 0;
  String? lastFailure;
  SemanticsHandle? _handle;
  final _keys = <String>{};

  void attach() {
    _handle ??= SemanticsBinding.instance.ensureSemantics();
  }

  /// Size sweeps rebuild continuously. Keeping semantics compilation on during
  /// that rebuild hits framework assertions, so the sweep pauses it.
  void suspend() {
    _handle?.dispose();
    _handle = null;
  }

  void resume() => attach();

  void sample(
    Element? root,
    FrameSettings device, {
    String? scenarioId,
    Set<String> suppressedOwners = const {},
  }) {
    if (root == null) return;
    lastFailure = null;
    visited = 0;
    try {
      final nodes = <_Seen>[];
      void visit(Element element, ElementIdentity? owner) {
        final widget = element.widget;
        if (widget is ElementIdentity) owner = widget;
        final semantics = element.renderObject?.debugSemantics;
        if (semantics != null) {
          nodes.add(_Seen(semantics, owner));
        }
        element.visitChildren((child) => visit(child, owner));
      }

      visit(root, null);
      final unique = <int, _Seen>{};
      for (final seen in nodes) {
        unique.putIfAbsent(seen.node.id, () => seen);
      }
      final duplicates = _duplicateGroups(unique.values);
      visited = unique.length;
      for (final seen in unique.values) {
        _inspect(seen, device, scenarioId, suppressedOwners, duplicates);
      }
      _orderFindings(unique.values, device, scenarioId);
    } catch (error) {
      collectorFailures++;
      lastFailure = error.runtimeType.toString();
    }
    notifyListeners();
  }

  void _inspect(
    _Seen seen,
    FrameSettings device,
    String? scenarioId,
    Set<String> suppressedOwners,
    Map<int, String> duplicates,
  ) {
    final node = seen.node;
    final flags = node.flagsCollection;
    if (flags.isHidden) return;
    final interactive =
        flags.isButton ||
        flags.isLink ||
        flags.isTextField ||
        node.getSemanticsData().actions != 0;
    if (!interactive) return;
    final ownerKey = seen.owner?.effectiveKey;
    final elementId = seen.owner?.elementId;
    final hasName =
        node.label.trim().isNotEmpty ||
        node.value.trim().isNotEmpty ||
        node.hint.trim().isNotEmpty ||
        node.tooltip.trim().isNotEmpty;
    final facts = <String, Object?>{
      'hasLabel': hasName,
      'isButton': flags.isButton,
      'isLink': flags.isLink,
      'isTextField': flags.isTextField,
      'width': _rect(node).width,
      'height': _rect(node).height,
    };
    if (!hasName) {
      _add(
        AccessibilityFinding(
          'a11y-missing-name',
          'Interactive semantics node has no accessible name. This is not a platform screen-reader certification.',
          ownerKey,
          elementId,
          device,
          facts: facts,
          scenarioId: scenarioId,
        ),
      );
    }
    final duplicate = duplicates[node.id];
    if (duplicate != null && !_sensitive(seen.owner)) {
      _add(
        AccessibilityFinding(
          'a11y-duplicate-name',
          'Sibling interactive nodes share one accessible name. The name is not exported.',
          ownerKey,
          elementId,
          device,
          facts: {...facts, 'duplicateGroup': duplicate},
          scenarioId: scenarioId,
        ),
      );
    }
    final rect = _rect(node);
    final small =
        rect.width > 0 &&
        rect.height > 0 &&
        (rect.width < FieldMotion.tapExtent ||
            rect.height < FieldMotion.tapExtent);
    if (small && (ownerKey == null || !suppressedOwners.contains(ownerKey))) {
      _add(
        AccessibilityFinding(
          'a11y-touch-target',
          'Interactive semantics rect is below ${FieldMotion.tapExtent} logical pixels.',
          ownerKey,
          elementId,
          device,
          facts: facts,
          scenarioId: scenarioId,
        ),
      );
    }
  }

  void _orderFindings(
    Iterable<_Seen> nodes,
    FrameSettings device,
    String? scenarioId,
  ) {
    final byParent = <int, List<SemanticsNode>>{};
    for (final seen in nodes) {
      final parent = seen.node.parent;
      if (parent == null) continue;
      byParent.putIfAbsent(parent.id, () => []).add(seen.node);
    }
    for (final children in byParent.values) {
      final ordered = children.first.parent?.debugListChildrenInOrder(
        DebugSemanticsDumpOrder.traversalOrder,
      );
      if (ordered == null) continue;
      final interactive = [
        for (final node in ordered)
          if (_interactive(node)) node,
      ];
      final kinds = siblingOrderKinds([
        for (final node in interactive)
          SiblingProbe(_rect(node), direction: node.textDirection),
      ]);
      for (var i = 0; i < kinds.length; i++) {
        final node = interactive[kinds[i].index];
        final owner = _ownerFor(nodes, node);
        _add(
          AccessibilityFinding(
            kinds[i].kind,
            kinds[i].kind == 'a11y-focus-order'
                ? 'Sibling traversal order moves upward within one column.'
                : 'RTL sibling traversal moves toward the physical right on one row.',
            owner?.effectiveKey,
            owner?.elementId,
            device,
            facts: {'traversalIndex': kinds[i].index},
            scenarioId: scenarioId,
          ),
        );
      }
    }
  }

  void _add(AccessibilityFinding finding) {
    if (_keys.add(
      '${finding.group}|${finding.device.size.width}|${finding.device.size.height}',
    )) {
      findings.add(finding);
    }
  }

  Map<String, Object?> toJson() => {
    'format': 'p2e-a11y-audit-v1',
    'note': 'Semantics tree as built in this embed. Not a TalkBack or VoiceOver certification.',
    'collectorFailures': collectorFailures,
    'findings': [for (final finding in findings) finding.toJson()],
  };

  void clear() {
    findings.clear();
    _keys.clear();
    collectorFailures = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _handle?.dispose();
    _handle = null;
    super.dispose();
  }
}

class SiblingProbe {
  const SiblingProbe(this.rect, {this.direction});
  final Rect rect;
  final TextDirection? direction;
}

class OrderHit {
  const OrderHit(this.kind, this.index);
  final String kind;
  final int index;
}

/// Traversal-order geometry. [probes] are already the interactive siblings.
List<OrderHit> siblingOrderKinds(List<SiblingProbe> probes) {
  final hits = <OrderHit>[];
  for (var i = 1; i < probes.length; i++) {
    final previous = probes[i - 1].rect;
    final current = probes[i].rect;
    final sameColumn =
        previous.left < current.right && previous.right > current.left;
    if (sameColumn && current.center.dy + 12 < previous.center.dy) {
      hits.add(OrderHit('a11y-focus-order', i));
    }
    if (probes[i].direction == TextDirection.rtl &&
        (previous.center.dy - current.center.dy).abs() <= 12 &&
        current.center.dx > previous.center.dx + 8) {
      hits.add(OrderHit('a11y-rtl-order', i));
    }
  }
  return hits;
}

class _Seen {
  _Seen(this.node, this.owner);
  final SemanticsNode node;
  final ElementIdentity? owner;
}

Rect _rect(SemanticsNode node) {
  var rect = node.rect;
  var current = node;
  while (current.parent != null) {
    final transform = current.transform;
    if (transform != null) rect = MatrixUtils.transformRect(transform, rect);
    current = current.parent!;
  }
  return rect;
}

bool _interactive(SemanticsNode node) {
  final flags = node.flagsCollection;
  return !flags.isHidden &&
      (flags.isButton ||
          flags.isLink ||
          flags.isTextField ||
          node.getSemanticsData().actions != 0);
}

bool _sensitive(ElementIdentity? owner) {
  final id = '${owner?.elementId ?? ''} ${owner?.componentId ?? ''}'
      .toLowerCase();
  return id.contains('password') ||
      id.contains('otp') ||
      id.contains('identifier');
}

Map<int, String> _duplicateGroups(Iterable<_Seen> nodes) {
  final grouped = <String, List<_Seen>>{};
  for (final seen in nodes) {
    if (!_interactive(seen.node) || _sensitive(seen.owner)) continue;
    final name = seen.node.label.trim();
    if (name.isEmpty) continue;
    final parent = seen.node.parent?.id ?? -1;
    grouped.putIfAbsent('$parent|${_fingerprint(name)}', () => []).add(seen);
  }
  final result = <int, String>{};
  for (final entry in grouped.entries) {
    if (entry.value.length < 2) continue;
    for (final seen in entry.value) {
      result[seen.node.id] = entry.key.split('|').last;
    }
  }
  return result;
}

ElementIdentity? _ownerFor(Iterable<_Seen> nodes, SemanticsNode node) {
  for (final seen in nodes) {
    if (seen.node.id == node.id) return seen.owner;
  }
  return null;
}

String _fingerprint(String value) {
  var hash = 2166136261;
  for (final unit in value.codeUnits) {
    hash ^= unit;
    hash = (hash * 16777619) & 0x7fffffff;
  }
  return hash.toRadixString(16);
}
