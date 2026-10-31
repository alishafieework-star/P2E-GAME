import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

/// Single-owner OTP prompt. The countdown is text; the action is a link.
class OtpPromptRow extends StatelessWidget {
  const OtpPromptRow({
    super.key,
    required this.elementId,
    required this.prompt,
    required this.action,
    required this.promptStyleName,
    required this.actionStyleName,
    this.onAction,
  });
  final String elementId, prompt, action, promptStyleName, actionStyleName;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final promptStyle = AuthTextTokens.byName[promptStyleName]!.copyWith(
      color: roles.color('On Surface/Variant'),
    );
    final actionStyle = AuthTextTokens.byName[actionStyleName]!.copyWith(
      color: onAction == null
          ? roles.color('On Surface/Disabled')
          : roles.actionAccent,
    );
    return Row(
      key: ValueKey(elementId),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(prompt, style: promptStyle),
        SizedBox(width: AuthEntryTokens.fieldGap),
        if (onAction == null)
          Text(action, style: actionStyle)
        else
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsetsDirectional.zero,
              foregroundColor: roles.actionAccent,
              textStyle: actionStyle,
            ),
            onPressed: onAction,
            child: Text(action),
          ),
      ],
    );
  }
}
