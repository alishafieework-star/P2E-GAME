import 'dart:math' as math;

import '../../theme/skin_theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../icons/app_icon.dart';
import '../../identity/element_identity.dart';
import '../../tokens/field_spec.dart';
import 'field_identity.dart';
import 'input_lease.dart';

Color? otpStatusAccent(FieldSpec spec, AppOtpFeedbackTone tone) {
  if (tone != AppOtpFeedbackTone.status || spec.skin == null) return null;
  final role = switch (spec.data['state']) {
    'Success' => 'Actions/Success/On Container',
    'Error' => 'Actions/Error/On Container',
    _ => null,
  };
  if (role == null) return null;
  return spec.skin!.valuesFor(spec.brightness).color(role);
}

class AppOtpCell extends StatelessWidget {
  const AppOtpCell({
    super.key,
    required this.spec,
    this.value = '',
    this.visualKey,
    this.feedbackTone = AppOtpFeedbackTone.source,
  });
  final FieldSpec spec;
  final String value;
  final Key? visualKey;
  final AppOtpFeedbackTone feedbackTone;
  @override
  Widget build(BuildContext context) {
    final spec = this.spec.withSkin(SkinTheme.of(context));
    final state = spec.data['state'],
        active = state == 'Focused' || state == 'Edit';
    final accent = otpStatusAccent(spec, feedbackTone);
    final child = state == 'Success'
        ? AssetAppIcon(
            spec.icon(spec.icons.single).id,
            style: AppIconStyle.values.byName(
              spec.icons.single['style'] as String,
            ),
            size: (spec.icons.single['width'] as num).toDouble(),
            color: accent ?? spec.iconPaint(spec.icons.single),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (value.isNotEmpty)
                Text(
                  value,
                  style: spec
                      .textStyle(
                        'otpText',
                        persian:
                            Directionality.of(context) == TextDirection.rtl,
                      )
                      .copyWith(color: accent),
                ),
              if (active)
                ColoredBox(
                  color: spec.paint(spec.part('caret'), 'strokes')!,
                  child: SizedBox(
                    width: spec.number('caret', 'strokeWeight'),
                    height: spec.number('caret', 'width'),
                  ),
                ),
            ],
          );
    return TweenAnimationBuilder<Decoration?>(
      tween: DecorationTween(
        end: BoxDecoration(
          color: spec.color('body'),
          border: Border.all(
            color: accent ?? spec.color('body', stroke: true)!,
            width: spec.number('body', 'strokeWeight'),
          ),
          borderRadius: BorderRadiusDirectional.all(
            Radius.circular(spec.number('body', 'cornerRadius')),
          ),
        ),
      ),
      duration: FieldMotion.effective(
        context,
        feedbackTone == AppOtpFeedbackTone.status
            ? FieldMotion.statusColor
            : FieldMotion.color,
      ),
      curve: FieldMotion.curve,
      builder: (context, value, child) =>
          DecoratedBox(decoration: value!, child: child),
      child: SizedBox(
        key: visualKey,
        width: spec.number('body', 'width'),
        height: spec.number('body', 'height'),
        child: Center(child: child),
      ),
    );
  }
}

class AppOtpField extends StatefulWidget {
  const AppOtpField({
    super.key,
    required this.elementId,
    this.runtimeLocator,
    required this.label,
    this.length = 6,
    this.controller,
    this.focusNode,
    this.feedback = const FieldFeedback.neutral(),
    this.supportingText,
    this.inputFormatters = const [],
    this.keyboardType = TextInputType.text,
    this.autofillHints = const [AutofillHints.oneTimeCode],
    this.enabled = true,
    this.readOnly = false,
    this.sourceDivider = false,
    this.feedbackTone = AppOtpFeedbackTone.source,
    this.onChanged,
    this.onCompleted,
    this.onSnapshot,
  }) : assert(length > 0);
  final String elementId, label;
  final UiRuntimeLocator? runtimeLocator;
  final int length;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FieldFeedback feedback;
  final String? supportingText;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final Iterable<String> autofillHints;
  final bool enabled, readOnly, sourceDivider;
  final AppOtpFeedbackTone feedbackTone;
  final ValueChanged<String>? onChanged, onCompleted;
  final ValueChanged<FieldRuntimeSnapshot>? onSnapshot;
  @override
  State<AppOtpField> createState() => _AppOtpFieldState();
}

class _AppOtpFieldState extends State<AppOtpField>
    with SingleTickerProviderStateMixin {
  late InputLease lease;
  late final AnimationController shake;
  String? lastComplete;
  Map<String, Object?>? published;
  late String previousText;
  int? tapped;
  @override
  void initState() {
    super.initState();
    lease = InputLease(widget.controller, widget.focusNode, changed);
    previousText = lease.controller.text;
    shake = AnimationController(vsync: this, duration: FieldMotion.statusShake);
  }

  void _enterError(AppOtpField previous) {
    final entered =
        widget.feedbackTone == AppOtpFeedbackTone.status &&
        widget.feedback.validation == FieldValidation.error &&
        previous.feedback.validation != FieldValidation.error;
    if (!entered) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      shake.value = 0;
      return;
    }
    shake.forward(from: 0);
  }

  @override
  void didUpdateWidget(AppOtpField old) {
    super.didUpdateWidget(old);
    lease.update(widget.controller, widget.focusNode);
    if (old.length != widget.length) lastComplete = null;
    _enterError(old);
  }

  @override
  void dispose() {
    shake.dispose();
    lease.dispose();
    super.dispose();
  }

  void changed() {
    if (!mounted) return;
    setState(() {});
    final text = lease.controller.text;
    if (text == previousText) return;
    previousText = text;
    if (text.characters.length != widget.length) {
      lastComplete = null;
    } else if (lastComplete != text) {
      lastComplete = text;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && lastComplete == text) widget.onCompleted?.call(text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.length <= 0) throw ArgumentError.value(widget.length, 'length');
    final brightness = Theme.of(context).brightness,
        chars = lease.controller.text.characters.toList();
    final active = lease.focus.hasFocus
        ? lease.controller.text
              .substring(
                0,
                lease.controller.selection.extentOffset.clamp(
                  0,
                  lease.controller.text.length,
                ),
              )
              .characters
              .length
              .clamp(0, widget.length - 1)
        : -1;
    final state = FieldStateMapper.otp(
      active: lease.focus.hasFocus,
      populated: chars.isNotEmpty,
      validation: widget.feedback.validation,
    );
    final spec = FieldSpec.lookup(
          FieldFamily.otp,
          state,
          brightness,
        ).withSkin(SkinTheme.of(context)),
        composition = FieldMotion.otpComposition;
    final pad = (composition['padding'] as List).cast<num>();
    final message = widget.feedback.supporting(widget.supportingText);
    final snapshot = FieldRuntimeSnapshot(
      spec: spec,
      state: state,
      elementId: widget.elementId,
      locator: UiIdentityScope.resolve(
        context,
        override: widget.runtimeLocator,
      ),
      validation: widget.feedback.validation,
      focused: lease.focus.hasFocus,
      hasContent: chars.isNotEmpty,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      codeLength: widget.length,
      complete: chars.length == widget.length,
      supporting: message?.trim().isNotEmpty ?? false,
      effectiveFontFamily: spec
          .textStyle(
            'otpText',
            persian: Directionality.of(context) == TextDirection.rtl,
          )
          .fontFamily,
      textScale: MediaQuery.textScalerOf(context).scale(1),
      motionReduced: MediaQuery.disableAnimationsOf(context),
      feedbackTone: widget.feedbackTone,
      resolvedTypography: {
        'otpText': spec.typographyMetadata('otpText'),
        if (message?.trim().isNotEmpty ?? false)
          'groupHelper':
              FieldSpec.lookup(
                    FieldFamily.textField,
                    widget.feedback.validation == FieldValidation.error
                        ? FieldVisualState.error
                        : FieldVisualState.defaultState,
                    brightness,
                  )
                  .withSkin(SkinTheme.of(context))
                  .typographyMetadata(
                    'supportText',
                    persian: Directionality.of(context) == TextDirection.rtl,
                  ),
      },
      runtimeExtension: 'otp-group composition; cell basis only',
    );
    final descriptor = snapshot.toJson();
    if (!identityValueEquals(published, descriptor)) {
      published = descriptor;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onSnapshot?.call(snapshot);
      });
    }
    final cellWidth = spec.number('body', 'width').toDouble();
    final gap = (composition['gap'] as num).toDouble();
    // PHYSICAL: the composition has a fixed Figma width; narrow screens scale
    // the whole group uniformly instead of clipping the last cell.
    final groupWidth =
        pad[0] +
        pad[2] +
        widget.length * cellWidth +
        (widget.sourceDivider
            ? ((composition['divider'] as Map)['width'] as num).toDouble()
            : 0.0) +
        (widget.length + (widget.sourceDivider ? 1 : 0) - 1) * gap;
    final children = <Widget>[];
    for (var i = 0; i < widget.length; i++) {
      if (i > 0) {
        children.add(SizedBox(width: (composition['gap'] as num).toDouble()));
      }
      if (widget.sourceDivider && i == composition['dividerAfter']) {
        final line = composition['dividerLine'] as Map<String, dynamic>,
            divider = composition['divider'] as Map;
        children.add(
          ColoredBox(
            color: spec.paint(line, 'strokes')!,
            child: SizedBox(
              width: (divider['width'] as num).toDouble(),
              height: (line['strokeWeight'] as num).toDouble(),
            ),
          ),
        );
        children.add(SizedBox(width: (composition['gap'] as num).toDouble()));
      }
      final cellState = FieldStateMapper.otp(
        active: active == i,
        populated: i < chars.length,
        validation: widget.feedback.validation,
      );
      final cellSpec = FieldSpec.lookup(
        FieldFamily.otp,
        cellState,
        brightness,
      ).withSkin(SkinTheme.of(context));
      children.add(
        FieldRuntimeSnapshot(
          spec: cellSpec,
          state: cellState,
          elementId: widget.elementId,
          locator: snapshot.locator,
          validation: widget.feedback.validation,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          focused: active == i,
          hasContent: i < chars.length,
          feedbackTone: widget.feedbackTone,
        ).wrap(
          AppOtpCell(
            spec: cellSpec,
            value: i < chars.length ? chars[i] : '',
            visualKey: ValueKey('${widget.elementId}.cell.$i'),
            feedbackTone: widget.feedbackTone,
          ),
          slotPath: 'cells.cell${i + 1}',
        ),
      );
    }
    // PHYSICAL: logical code order is LTR regardless of the surrounding UI.
    final cells = Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          pad[0].toDouble(),
          pad[1].toDouble(),
          pad[2].toDouble(),
          pad[3].toDouble(),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
    final editor = TextField(
      key: ValueKey('${widget.elementId}.editor'),
      controller: lease.controller,
      focusNode: lease.focus,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      autofillHints: widget.autofillHints,
      textDirection: TextDirection.ltr,
      inputFormatters: [
        ...widget.inputFormatters,
        LengthLimitingTextInputFormatter(widget.length),
      ],
      onChanged: widget.onChanged,
      onTap: () {
        if (tapped != null) {
          lease.controller.selection = TextSelection.collapsed(
            offset: chars.take(tapped!.clamp(0, chars.length)).join().length,
          );
        }
      },
      style: spec.textStyle(
        'otpText',
        persian: Directionality.of(context) == TextDirection.rtl,
      ),
      decoration: const InputDecoration.collapsed(hintText: ''),
    );
    return snapshot.wrap(
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: widget.label,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final available = constraints.maxWidth;
                final group = Listener(
                  onPointerDown: (event) {
                    final pitch = cellWidth + gap;
                    var x = event.localPosition.dx - pad[0];
                    if (widget.sourceDivider && x > pitch) {
                      x -= (composition['divider'] as Map)['width'] as num;
                      x -= gap;
                    }
                    tapped = (x / pitch).floor().clamp(0, widget.length);
                  },
                  child: AnimatedBuilder(
                    animation: shake,
                    builder: (context, child) {
                      // PHYSICAL: the shake is a horizontal pixel offset, not a
                      // directional layout change (D-069).
                      final t = shake.value;
                      final dx =
                          widget.feedbackTone == AppOtpFeedbackTone.status
                          ? FieldMotion.statusShakeAmplitude *
                                math.sin(
                                  FieldMotion.statusShakeCycles *
                                      2 *
                                      math.pi *
                                      t,
                                ) *
                                (1 - t)
                          : 0.0;
                      return Transform.translate(
                        key: const ValueKey('otp.shake'),
                        offset: Offset(dx, 0),
                        child: child,
                      );
                    },
                    child: Stack(
                      key: ValueKey('${widget.elementId}.visual'),
                      children: [
                        ExcludeSemantics(child: cells),
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0,
                            alwaysIncludeSemantics: true,
                            child: editor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                if (!available.isFinite ||
                    available <= 0 ||
                    available >= groupWidth) {
                  return group;
                }
                return SizedBox(
                  width: available,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: group,
                  ),
                );
              },
            ),
          ),
          if (message != null && message.trim().isNotEmpty)
            Padding(
              padding: EdgeInsetsDirectional.only(
                top: (composition['gap'] as num).toDouble(),
              ),
              child: Semantics(
                liveRegion: widget.feedback.validation == FieldValidation.error,
                child: Text(
                  message,
                  style:
                      FieldSpec.lookup(
                            FieldFamily.textField,
                            widget.feedback.validation == FieldValidation.error
                                ? FieldVisualState.error
                                : FieldVisualState.defaultState,
                            brightness,
                          )
                          .withSkin(SkinTheme.of(context))
                          .textStyle(
                            'supportText',
                            persian:
                                Directionality.of(context) == TextDirection.rtl,
                          ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
