import 'dart:convert';

import '../core/inspection.dart';
import '../core/problems.dart';
import '../core/selection.dart';

/// One source-versus-measured axis from an existing inspection snapshot.
class ComparisonRow {
  const ComparisonRow({
    required this.axis,
    required this.status,
    required this.source,
    required this.measured,
    this.reason,
  });
  final String axis, status, source, measured;
  final String? reason;
}

/// Readable view of `inspectionComparison`. It does not invent a difference
/// when the snapshot already says the source is unavailable.
class ComparisonSummary {
  const ComparisonSummary({
    required this.elementId,
    required this.componentId,
    required this.status,
    required this.matches,
    required this.differs,
    required this.rows,
  });
  final String elementId, componentId, status;
  final int matches, differs;
  final List<ComparisonRow> rows;
}

InspectionNode? focusNode(InspectionSession session) {
  final selected = session.selected;
  if (selected != null && selected.element.mounted) return selected;
  final mounted = session.tree.where((node) => node.element.mounted);
  final visible = mounted.where((node) => node.visible);
  final pool = visible.isEmpty ? mounted : visible;
  if (pool.isEmpty) return null;
  return pool.reduce((a, b) => a.depth <= b.depth ? a : b);
}

ComparisonSummary? comparisonSummary(Map<String, Object?> snapshot) {
  final identity = snapshot['identity'] as Map?;
  final resolved = snapshot['resolved'] as Map?;
  final comparison =
      (resolved?['inspectionComparison'] as Map?)?['value'] as Map?;
  if (identity == null || comparison == null) return null;
  final rows = <ComparisonRow>[];
  var matches = 0, differs = 0;
  for (final entry in comparison.entries) {
    final metric = entry.value;
    if (metric is! Map) continue;
    final status = '${metric['status']}';
    if (status == 'match') matches++;
    if (status == 'differs') differs++;
    final reason = metric['reason'];
    rows.add(
      ComparisonRow(
        axis: entry.key.toString(),
        status: status,
        source: _value(metric['source']),
        measured: _value(metric['measured']),
        reason: reason == null || '$reason'.isEmpty ? null : '$reason',
      ),
    );
  }
  return ComparisonSummary(
    elementId: '${identity['elementId'] ?? 'unavailable'}',
    componentId: '${identity['componentId'] ?? 'unavailable'}',
    status: '${(resolved?['status'] as Map?)?['value'] ?? 'unavailable'}',
    matches: matches,
    differs: differs,
    rows: rows,
  );
}

/// Allowlisted problem fields only. Raw exception text is not part of the model.
String problemReport(List<InspectionProblem> problems) {
  if (problems.isEmpty) return 'No problems.';
  final buffer = StringBuffer();
  for (final problem in problems) {
    final size = problem.device.size;
    buffer.writeln(
      '${problem.kind} | ${problem.elementId ?? 'unavailable'} | '
      '${size.width.toStringAsFixed(0)}×${size.height.toStringAsFixed(0)}',
    );
    buffer.writeln(problem.summary);
    buffer.writeln();
  }
  return buffer.toString().trimRight();
}

String _value(Object? value) {
  if (value == null) return '—';
  if (value is num) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
  }
  if (value is String) return value;
  return jsonEncode(value);
}
