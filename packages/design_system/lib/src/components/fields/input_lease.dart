import 'package:flutter/widgets.dart';

/// Owns only objects it creates; listener updates do not replace editing values.
class InputLease {
  InputLease(
    TextEditingController? controller,
    FocusNode? focus,
    VoidCallback onChange,
  ) : _externalController = controller,
      _externalFocus = focus,
      changed = onChange {
    this.controller = controller ?? TextEditingController();
    this.focus = focus ?? FocusNode();
    _listen();
  }
  late TextEditingController controller;
  late FocusNode focus;
  TextEditingController? _externalController;
  FocusNode? _externalFocus;
  final VoidCallback changed;
  void _listen() {
    controller.addListener(changed);
    focus.addListener(changed);
  }

  void update(TextEditingController? nextController, FocusNode? nextFocus) {
    if (nextController != _externalController) {
      final ownedController = _externalController == null;
      final retired = controller;
      final value = retired.value;
      retired.removeListener(changed);
      controller = nextController ?? TextEditingController.fromValue(value);
      _externalController = nextController;
      controller.addListener(changed);
      // The still-mounted editable keeps pointing at the replaced object
      // until it rebuilds with the new one; disposing it here would assert.
      if (ownedController) _retire(retired.dispose);
    }
    if (nextFocus != _externalFocus) {
      final ownedFocus = _externalFocus == null;
      final retiredFocus = focus;
      retiredFocus.removeListener(changed);
      focus = nextFocus ?? FocusNode();
      _externalFocus = nextFocus;
      focus.addListener(changed);
      if (ownedFocus) _retire(retiredFocus.dispose);
    }
  }

  /// Disposes a replaced internally-owned object after this frame's build,
  /// when the previous editable no longer references it.
  void _retire(VoidCallback disposeObject) {
    WidgetsBinding.instance.addPostFrameCallback((_) => disposeObject());
  }

  void dispose() {
    controller.removeListener(changed);
    focus.removeListener(changed);
    if (_externalController == null) controller.dispose();
    if (_externalFocus == null) focus.dispose();
  }
}
