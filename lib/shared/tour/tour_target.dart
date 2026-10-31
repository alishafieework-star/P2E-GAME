import 'package:flutter/material.dart';

/// A layout slot the Home tour can point at. Features mark slots without
/// importing the tour (D-142). The tour measures the live render box each
/// frame, so only the build context is registered, never a cached rect.
class TourTarget extends StatefulWidget {
  const TourTarget({super.key, required this.id, required this.child});
  final String id;
  final Widget child;

  static final contexts = <String, BuildContext>{};

  static BuildContext? contextFor(String id) {
    final target = contexts[id];
    if (target == null || !target.mounted) return null;
    return target;
  }

  @override
  State<TourTarget> createState() => _TourTargetState();
}

class _TourTargetState extends State<TourTarget> {
  @override
  void dispose() {
    if (TourTarget.contexts[widget.id] == context) {
      TourTarget.contexts.remove(widget.id);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TourTarget.contexts[widget.id] = context;
    return widget.child;
  }
}
