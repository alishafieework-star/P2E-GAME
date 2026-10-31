import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../identity/element_identity.dart';
import '../../theme/skin_theme.dart';
import '../../tokens/button_motion.dart';
import '../../tokens/generated/html_journey_tokens.g.dart';
import '../../tokens/field_spec.dart' show FieldMotion;

/// Provisional checkbox from the HTML prototype (D-144). Figma only has the
/// white-square Radio artwork, which the owner replaced with this control:
/// an 8px-radius box that fills sky blue and draws a white tick, with the
/// HTML box and tick pop. Light/Dark is read from the theme.
class AppCheckbox extends StatefulWidget {
  const AppCheckbox({
    super.key,
    required this.elementId,
    this.runtimeLocator,
    required this.label,
    required this.value,
    required this.onChanged,
    this.focusNode,
  });

  final String elementId, label;
  final UiRuntimeLocator? runtimeLocator;
  final bool value;

  /// Null makes the control honestly unavailable.
  final ValueChanged<bool>? onChanged;
  final FocusNode? focusNode;

  @override
  State<AppCheckbox> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox>
    with SingleTickerProviderStateMixin {
  late final AnimationController pop;
  late FocusNode node;
  var hover = false, focused = false, down = false;

  @override
  void initState() {
    super.initState();
    node = widget.focusNode ?? FocusNode();
    pop = AnimationController(vsync: this, duration: HtmlJourneyTokens.cbPopMs)
      ..value = 1;
  }

  @override
  void didUpdateWidget(AppCheckbox old) {
    super.didUpdateWidget(old);
    if (old.focusNode != widget.focusNode) {
      if (old.focusNode == null) node.dispose();
      node = widget.focusNode ?? FocusNode();
    }
    if (widget.value &&
        !old.value &&
        !MediaQuery.disableAnimationsOf(context)) {
      pop.forward(from: 0);
    }
  }

  @override
  void dispose() {
    pop.dispose();
    if (widget.focusNode == null) node.dispose();
    super.dispose();
  }

  void toggle() => widget.onChanged?.call(!widget.value);

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final enabled = widget.onChanged != null;
    final reduced = MediaQuery.disableAnimationsOf(context);
    final checked = widget.value;
    final accent = roles.color('Action/Accent');
    final label = Theme.of(context).textTheme.bodyLarge!;
    final style = label.copyWith(
      color: roles.color('On Surface/Base'),
      fontSize: HtmlJourneyTokens.cbLabelSize,
      height: HtmlJourneyTokens.cbLabelLine / HtmlJourneyTokens.cbLabelSize,
      fontWeight: FontWeight.w400,
    );
    return ElementIdentity(
      elementId: widget.elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: widget.runtimeLocator,
      ),
      componentId: 'field.checkbox',
      structureRef: 'field.checkbox',
      fileKey: '',
      variantId: null,
      componentSetId: null,
      rawSetName: 'Checkbox',
      rawVariantName: checked ? 'checked' : 'unchecked',
      variants: {'checked': '$checked', 'enabled': '$enabled'},
      resolved: const {'source': 'HTML .radio (D-144)'},
      declared: {'enabled': enabled, 'checked': checked, 'focused': focused},
      child: Semantics(
        checked: checked,
        enabled: enabled,
        label: widget.label,
        onTap: enabled ? toggle : null,
        child: FocusableActionDetector(
          focusNode: node,
          enabled: enabled,
          onFocusChange: (v) => setState(() => focused = v),
          onShowHoverHighlight: (v) => setState(() => hover = v),
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          },
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                toggle();
                return null;
              },
            ),
          },
          child: GestureDetector(
            excludeFromSemantics: true,
            behavior: HitTestBehavior.opaque,
            onTapDown: enabled ? (_) => setState(() => down = true) : null,
            onTapUp: (_) => setState(() => down = false),
            onTapCancel: () => setState(() => down = false),
            onTap: enabled ? toggle : null,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: FieldMotion.tapExtent),
              child: ExcludeSemantics(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.all(
                        HtmlJourneyTokens.cbPad,
                      ),
                      child: AnimatedBuilder(
                        animation: pop,
                        builder: (context, _) => _Box(
                          key: ValueKey('${widget.elementId}.box'),
                          checked: checked,
                          focused: focused && !hover,
                          pressed: down && enabled && !reduced,
                          pop: pop.value,
                          accent: accent,
                          outline: roles.color('Outline/Base'),
                          mark: HtmlJourneyTokens.obWhite,
                          duration: reduced
                              ? Duration.zero
                              : HtmlJourneyTokens.cbMs,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: HtmlJourneyTokens.cbLabelPad,
                        ),
                        child: Text(widget.label, style: style),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({
    super.key,
    required this.checked,
    required this.focused,
    required this.pressed,
    required this.pop,
    required this.accent,
    required this.outline,
    required this.mark,
    required this.duration,
  });

  final bool checked, focused, pressed;
  final double pop;
  final Color accent, outline, mark;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    // `boxPop`: .88 -> 1.08 (60%) -> 1, only right after checking.
    final boxPop = pop >= 1
        ? 1.0
        : pop < 0.6
        ? 0.88 + (1.08 - 0.88) * (pop / 0.6)
        : 1.08 + (1 - 1.08) * ((pop - 0.6) / 0.4);
    final tick = HtmlJourneyTokens.spring.transform(pop.clamp(0.0, 1.0));
    final scale = pressed ? ButtonMotion.togglePressedScale : boxPop;
    return AnimatedScale(
      scale: scale,
      duration: pressed || pop >= 1
          ? HtmlJourneyTokens.cbPressMs
          : Duration.zero,
      curve: HtmlJourneyTokens.ease,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (focused)
            PositionedDirectional(
              start:
                  -(HtmlJourneyTokens.cbFocusGap +
                      HtmlJourneyTokens.cbFocusRing),
              end:
                  -(HtmlJourneyTokens.cbFocusGap +
                      HtmlJourneyTokens.cbFocusRing),
              top:
                  -(HtmlJourneyTokens.cbFocusGap +
                      HtmlJourneyTokens.cbFocusRing),
              bottom:
                  -(HtmlJourneyTokens.cbFocusGap +
                      HtmlJourneyTokens.cbFocusRing),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    HtmlJourneyTokens.cbRadius +
                        HtmlJourneyTokens.cbFocusGap +
                        HtmlJourneyTokens.cbFocusRing,
                  ),
                  border: Border.all(
                    color: accent,
                    width: HtmlJourneyTokens.cbFocusRing,
                  ),
                ),
              ),
            ),
          AnimatedContainer(
            duration: duration,
            curve: Curves.ease,
            width: HtmlJourneyTokens.cbBox,
            height: HtmlJourneyTokens.cbBox,
            decoration: BoxDecoration(
              color: checked ? accent : null,
              borderRadius: BorderRadius.circular(HtmlJourneyTokens.cbRadius),
              border: Border.all(
                color: checked ? accent : outline,
                width: HtmlJourneyTokens.cbBorder,
              ),
            ),
            child: checked
                ? Opacity(
                    opacity: pop >= 1 ? 1 : tick.clamp(0.0, 1.0),
                    child: CustomPaint(
                      painter: _TickPainter(
                        color: mark,
                        scale: pop >= 1 ? 1 : tick,
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

/// HTML `::after`: a 9 x 5 box with 2px left and bottom borders, rotated -45deg
/// and nudged by (1, -1). The scale animates from .3.
class _TickPainter extends CustomPainter {
  const _TickPainter({required this.color, required this.scale});

  final Color color;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    const w = HtmlJourneyTokens.cbTickW;
    const h = HtmlJourneyTokens.cbTickH;
    const stroke = HtmlJourneyTokens.cbTickStroke;
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-math.pi / 4);
    canvas.translate(
      HtmlJourneyTokens.cbTickNudge,
      -HtmlJourneyTokens.cbTickNudge,
    );
    canvas.scale(scale);
    canvas.translate(-(w + stroke) / 2, -(h + stroke) / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter
      ..color = color;
    // Box is (w + stroke) wide because CSS content-box adds the 2px border.
    final path = Path()
      ..moveTo(stroke / 2, 0)
      ..lineTo(stroke / 2, h + stroke / 2)
      ..lineTo(w + stroke, h + stroke / 2);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_TickPainter old) =>
      old.color != color || old.scale != scale;
}
