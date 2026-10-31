import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

import '../../email_display.dart';

/// Single-owner account row on Enter Your Password. Figma 18618:12990.
class PasswordAccountCard extends StatelessWidget {
  const PasswordAccountCard({
    super.key,
    required this.email,
    required this.loggingInLabel,
    required this.changeLabel,
    this.onChange,
  });
  final String email, loggingInLabel, changeLabel;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final shown = compactEmail(email);
    return _RowPress(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: roles.color('Surface Container/High'),
          borderRadius: BorderRadius.all(
            Radius.circular(AuthEntryTokens.pillRadius),
          ),
          border: Border.all(
            color: roles.color('Outline/Variant'),
            width: AuthEntryTokens.bodyStroke,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AuthEntryTokens.bonusInset),
          child: Row(
            children: [
              SizedBox.square(
                dimension: AuthEntryTokens.brandSize,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: roles.color('Primary/Purple'),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      emailInitial(email),
                      style: AuthTextTokens
                          .byName['English/Baseline/Label-Medium']!
                          .copyWith(color: roles.color('Alpha/White')),
                    ),
                  ),
                ),
              ),
              SizedBox(width: AuthEntryTokens.socialGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loggingInLabel,
                      style: AuthTextTokens.byName['English/Muted/Label-Small']!
                          .copyWith(color: roles.color('On Surface/Variant')),
                    ),
                    Text(
                      '\u2066$shown\u2069',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AuthTextTokens
                          .byName['English/Baseline/Label-Small']!
                          .copyWith(color: roles.color('On Surface/Emphasis')),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: roles.actionAccent,
                  textStyle:
                      AuthTextTokens.byName['English/Baseline/Label-Small'],
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AuthEntryTokens.bonusInset,
                  ),
                ),
                onPressed: onChange,
                child: Text(changeLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowPress extends StatefulWidget {
  const _RowPress({required this.child});
  final Widget child;
  @override
  State<_RowPress> createState() => _RowPressState();
}

class _RowPressState extends State<_RowPress> {
  bool down = false;

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    return Listener(
      onPointerDown: (_) => setState(() => down = true),
      onPointerUp: (_) => setState(() => down = false),
      onPointerCancel: (_) => setState(() => down = false),
      child: AnimatedScale(
        scale: down && !reduced ? ButtonMotion.rowPressedScale : 1,
        duration: reduced ? Duration.zero : ButtonMotion.pressDuration,
        curve: ButtonMotion.curve,
        child: widget.child,
      ),
    );
  }
}
