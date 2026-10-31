import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

/// One countdown unit, display-ready: localized digits and a localized label.
@immutable
class CountdownUnit {
  const CountdownUnit({required this.digits, required this.label})
    : assert(digits != '' && label != '');
  final String digits, label;
}

/// Feature-internal quest countdown from the quest card footer. One box per
/// digit, units separated by two dots, centered as a group. The caller
/// formats the remaining time from a server deadline (D-102).
class Countdown extends StatelessWidget {
  const Countdown({super.key, required this.units, required this.semanticLabel})
    : assert(units.length > 0);

  final List<CountdownUnit> units;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final value = HomeRoles.countdownValue.resolve(context);
    final surface = HomeRoles.countdownSurface.resolve(context);
    final digitStyle = HomeText.countdownDigit.copyWith(color: value);
    return Semantics(
      container: true,
      excludeSemantics: true,
      label: semanticLabel,
      child: Center(
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < units.length; i++) ...[
                if (i > 0) ...[
                  const SizedBox(width: HomeTokens.countdownGap),
                  _Dots(color: value),
                  const SizedBox(width: HomeTokens.countdownGap),
                ],
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      // PHYSICAL: clock digits read in fixed ascending order
                      // in every locale and direction.
                      textDirection: TextDirection.ltr,
                      children: [
                        for (final (index, digit)
                            in units[i].digits.characters.indexed) ...[
                          if (index > 0)
                            const SizedBox(width: HomeTokens.countdownDigitGap),
                          SizedBox(
                            width: HomeTokens.countdownDigitWidth,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: surface,
                                borderRadius: const BorderRadiusDirectional.all(
                                  Radius.circular(
                                    HomeTokens.countdownDigitRadius,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.symmetric(
                                  vertical: HomeTokens.countdownDigitPadding,
                                ),
                                child: Text(
                                  digit,
                                  textAlign: TextAlign.center,
                                  style: digitStyle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: HomeTokens.countdownUnitGap),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: HomeTokens.countdownLabelPadHorizontal,
                      ),
                      child: Text(
                        units[i].label,
                        textAlign: TextAlign.center,
                        style: HomeText.countdownLabel.copyWith(color: value),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    final dot = DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: const SizedBox.square(dimension: HomeTokens.countdownDot),
    );
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        bottom: HomeTokens.countdownDotInsetBottom,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dot,
          const SizedBox(height: HomeTokens.countdownDotGap),
          dot,
        ],
      ),
    );
  }
}
