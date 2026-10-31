import 'package:flutter/material.dart';

import '../tokens/button_motion.dart';

/// Paint-only scale: the layout and untransformed hit target stay unchanged.
class PressAction extends StatefulWidget {
  const PressAction({
    super.key,
    required this.onPressed,
    required this.style,
    this.child,
    this.childBuilder,
    this.pressedScale = ButtonMotion.pressedScale,
    this.statesController,
    this.focusNode,
    this.interactionSuppressed = false,
  }) : assert(child != null || childBuilder != null);
  final VoidCallback? onPressed;
  final ButtonStyle style;
  final Widget? child;
  final Widget Function(BuildContext context, bool pressed, bool hovered)?
  childBuilder;
  final double pressedScale;
  final WidgetStatesController? statesController;
  final FocusNode? focusNode;
  final bool interactionSuppressed;
  @override
  State<PressAction> createState() => _PressActionState();
}

class _PressActionState extends State<PressAction> {
  late WidgetStatesController controller;
  bool pressed = false;
  bool hovered = false;
  @override
  void initState() {
    super.initState();
    attach();
  }

  void attach() {
    controller = widget.statesController ?? WidgetStatesController();
    sync();
    controller.addListener(changed);
  }

  void detach() {
    controller.removeListener(changed);
    if (widget.statesController == null) controller.dispose();
  }

  void sync() {
    final allow = widget.onPressed != null && !widget.interactionSuppressed;
    pressed = allow && controller.value.contains(WidgetState.pressed);
    hovered = allow && controller.value.contains(WidgetState.hovered);
  }

  void changed() {
    final wasPressed = pressed;
    final wasHovered = hovered;
    sync();
    if ((pressed != wasPressed || hovered != wasHovered) && mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(PressAction old) {
    super.didUpdateWidget(old);
    if (old.statesController != widget.statesController) {
      controller.removeListener(changed);
      if (old.statesController == null) controller.dispose();
      attach();
    }
    if (widget.onPressed == null || widget.interactionSuppressed) {
      pressed = false;
      hovered = false;
    } else {
      sync();
    }
  }

  @override
  void dispose() {
    detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced =
        MediaQuery.disableAnimationsOf(context) ||
        widget.onPressed == null ||
        widget.interactionSuppressed;
    final target = pressed && !reduced
        ? widget.pressedScale
        : ButtonMotion.restScale;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: ButtonMotion.restScale, end: target),
      duration: reduced
          ? Duration.zero
          : pressed
          ? ButtonMotion.pressDuration
          : ButtonMotion.releaseDuration,
      curve: ButtonMotion.curve,
      builder: (context, value, child) => Transform.scale(
        key: const ValueKey('app-button-press-transform'),
        scale: value,
        transformHitTests: false,
        child: child,
      ),
      child: TextButton(
        focusNode: widget.focusNode,
        onPressed: widget.onPressed,
        style: widget.style,
        statesController: controller,
        child:
            widget.childBuilder?.call(
              context,
              pressed && !reduced,
              hovered && !reduced,
            ) ??
            widget.child!,
      ),
    );
  }
}
