import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

/// Provisional section failure (R-009): a message and one retry action. Figma
/// defines no section error state yet.
class SectionError extends StatelessWidget {
  const SectionError({
    super.key,
    required this.elementId,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
    this.retrying = false,
  });

  final String elementId, message, retryLabel;
  final VoidCallback? onRetry;
  final bool retrying;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.symmetric(
      horizontal: CollectionTokens.sectionPadding,
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            message,
            textAlign: TextAlign.start,
            style: HomeText.creator.copyWith(
              color: HomeRoles.infoSupporting.resolve(context),
            ),
          ),
        ),
        const SizedBox(width: HomeTokens.infoActionGap),
        AppButton(
          elementId: '$elementId.retry',
          label: retryLabel,
          onPressed: onRetry,
          loading: retrying,
          family: AppButtonFamily.hug,
          size: AppButtonSize.small,
          type: AppButtonType.tonal,
        ),
      ],
    ),
  );
}
