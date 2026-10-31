import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

import '../password_rules.dart';

/// Strength meter and the four rules under Set a New Password.
class PasswordStrength extends StatelessWidget {
  const PasswordStrength({
    super.key,
    required this.password,
    required this.strengthLabel,
    required this.level,
    required this.longLabel,
    required this.numberLabel,
    required this.caseLabel,
    required this.symbolLabel,
  });

  final String password, strengthLabel, level;
  final String longLabel, numberLabel, caseLabel, symbolLabel;

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final display = PasswordRules.level(password);
    final idle = roles.color('Outline/Variant');
    final levelColor = switch (display) {
      1 => HtmlJourneyTokens.jlRose,
      2 => const Color(0xFFFF9F0A), // OVERRIDE(O-001): HTML --amber.
      3 => HtmlJourneyTokens.splashGradientMid,
      4 => HtmlJourneyTokens.success,
      _ => idle,
    };
    // The met-rule checks stay one fixed green (HTML ICON_OK), never the
    // level color.
    final metColor = HtmlJourneyTokens.success;
    final rules = [
      (PasswordRules.longEnough(password), longLabel),
      (PasswordRules.hasNumber(password), numberLabel),
      (PasswordRules.hasMixedCase(password), caseLabel),
      (PasswordRules.hasSymbol(password), symbolLabel),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              strengthLabel,
              style: AuthTextTokens.byName['English/Muted/Label-Small']!
                  .copyWith(color: roles.color('On Surface/Variant')),
            ),
            const Spacer(),
            if (display > 0)
              Text(
                level,
                style: AuthTextTokens.byName['English/Baseline/Label-Small']!
                    .copyWith(color: levelColor),
              ),
          ],
        ),
        SizedBox(height: AuthEntryTokens.fieldGap),
        Row(
          children: [
            for (var index = 0; index < 4; index++) ...[
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: index < display ? levelColor : idle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AuthEntryTokens.amountUnitGap),
                    ),
                  ),
                  child: SizedBox(height: AuthEntryTokens.amountUnitGap),
                ),
              ),
              if (index < 3) SizedBox(width: AuthEntryTokens.amountUnitGap),
            ],
          ],
        ),
        SizedBox(height: AuthEntryTokens.fieldGap),
        for (final (met, label) in rules)
          Padding(
            padding: const EdgeInsetsDirectional.only(
              bottom: AuthEntryTokens.fieldGap,
            ),
            child: Row(
              children: [
                if (met)
                  AssetAppIcon(
                    AppIconId.check,
                    size: AuthEntryTokens.crownSize,
                    color: metColor,
                    semanticLabel: label,
                  )
                else
                  SizedBox.square(
                    dimension: AuthEntryTokens.crownSize,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: idle,
                          width: AuthEntryTokens.bodyStroke,
                        ),
                      ),
                    ),
                  ),
                SizedBox(width: AuthEntryTokens.fieldGap),
                Expanded(
                  child: Text(
                    label,
                    style: AuthTextTokens
                        .byName['English/Baseline/Label-Small']!
                        .copyWith(
                          color: met
                              ? roles.color('On Surface/Emphasis')
                              : roles.color('On Surface/Variant'),
                        ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
