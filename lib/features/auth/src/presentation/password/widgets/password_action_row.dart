import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

/// Remember-me control and the forgot-password link. Figma 18618:12990.
class PasswordActionRow extends StatelessWidget {
  const PasswordActionRow({
    super.key,
    required this.rememberLabel,
    required this.forgotLabel,
    required this.remember,
    required this.enabled,
    required this.onRemember,
    required this.onForgot,
  });
  final String rememberLabel, forgotLabel;
  final bool remember, enabled;
  final ValueChanged<bool> onRemember;
  final VoidCallback onForgot;

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    return Row(
      children: [
        Expanded(
          child: AppCheckbox(
            elementId: 'auth.password.remember',
            label: rememberLabel,
            value: remember,
            onChanged: enabled ? onRemember : null,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: roles.actionAccent,
            textStyle: AuthTextTokens.byName['English/Baseline/Label-Small'],
            padding: EdgeInsetsDirectional.zero,
          ),
          onPressed: enabled ? onForgot : null,
          child: Text(forgotLabel),
        ),
      ],
    );
  }
}
