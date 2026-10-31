import 'package:flutter/material.dart';

import '../../icons/app_icon.dart';
import '../../identity/element_identity.dart';
import '../../interaction/press_action.dart';
import '../../tokens/button_motion.dart';
import '../../tokens/generated/collection_tokens.g.dart';

/// Provisional section title with an optional trailing text action.
/// Source: detached frame 18533:4266, and the two-tone Game Details headers
/// (D-101, D-121, E-114).
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.elementId,
    this.title = '',
    this.lead,
    this.subject,
    this.showMark = false,
    this.actionLabel,
    this.onAction,
    this.actionChevron = true,
    this.runtimeLocator,
  }) : assert(title != '' || (subject != null && subject != '')),
       assert(title == '' || (lead == null && subject == null)),
       assert(!showMark || (subject != null && subject != '')),
       assert(actionLabel == null || actionLabel != '');

  final String elementId;

  /// One-tone title used by Home. Empty when [subject] carries the title.
  final String title;

  /// Muted prefix of a two-tone title, such as "About" or "More by".
  final String? lead;

  /// Emphasized subject of a two-tone title. Replaces [title].
  final String? subject;
  final bool showMark;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Home actions include the trailing chevron. Game Details actions do not
  /// (E-114).
  final bool actionChevron;
  final UiRuntimeLocator? runtimeLocator;

  static const _mark = '®';

  @override
  Widget build(BuildContext context) {
    final split = subject != null;
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'collection.section-header',
      structureRef: 'collection.section-header',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: split ? '18526:12060' : '18533:4266',
      componentSetId: null,
      rawSetName: 'Section Header',
      rawVariantName: split ? 'two-tone' : 'detached',
      variants: {
        'action': actionLabel == null ? 'hidden' : 'visible',
        'title': split ? 'twoTone' : 'single',
        'chevron': actionLabel == null
            ? 'hidden'
            : actionChevron
            ? 'visible'
            : 'hidden',
      },
      resolved: const {'source': '18533:4266'},
      declared: const {},
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: CollectionTokens.sectionHeaderHeight,
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: CollectionTokens.sectionTitleInsetStart,
                  end: CollectionTokens.sectionTitleInsetEnd,
                ),
                child: split
                    ? _SplitTitle(
                        lead: lead,
                        subject: subject!,
                        showMark: showMark,
                      )
                    : Text(
                        title,
                        textAlign: TextAlign.start,
                        style: CollectionText.sectionTitle.copyWith(
                          color: CollectionRoles.sectionTitle.resolve(context),
                        ),
                      ),
              ),
            ),
            if (actionLabel != null) ...[
              const SizedBox(width: CollectionTokens.sectionGap),
              _SectionAction(
                label: actionLabel!,
                onPressed: onAction,
                showChevron: actionChevron,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SplitTitle extends StatelessWidget {
  const _SplitTitle({
    required this.lead,
    required this.subject,
    required this.showMark,
  });

  final String? lead;
  final String subject;
  final bool showMark;

  @override
  Widget build(BuildContext context) {
    final subjectStyle = CollectionText.sectionTitle.copyWith(
      color: CollectionRoles.sectionTitle.resolve(context),
    );
    return Row(
      children: [
        if (lead != null && lead!.isNotEmpty) ...[
          Text(
            lead!,
            style: CollectionText.sectionTitle.copyWith(
              color: CollectionRoles.sectionLead.resolve(context),
            ),
          ),
          const SizedBox(width: CollectionTokens.sectionTitlePartGap),
        ],
        Flexible(
          child: Text(
            subject,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: subjectStyle,
          ),
        ),
        if (showMark) ...[
          const SizedBox(width: CollectionTokens.sectionMarkGap),
          Text(AppSectionHeader._mark, style: subjectStyle),
        ],
      ],
    );
  }
}

class _SectionAction extends StatelessWidget {
  const _SectionAction({
    required this.label,
    required this.onPressed,
    required this.showChevron,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final color = CollectionRoles.sectionAction.resolve(context);
    return PressAction(
      onPressed: onPressed,
      pressedScale: ButtonMotion.viewMorePressedScale,
      style:
          TextButton.styleFrom(
            foregroundColor: color,
            backgroundColor: color.withValues(alpha: 0),
            padding: const EdgeInsetsDirectional.all(
              CollectionTokens.sectionActionPadding,
            ),
            minimumSize: const Size(0, CollectionTokens.sectionHeaderHeight),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.all(
                Radius.circular(CollectionTokens.sectionActionRadius),
              ),
            ),
            splashFactory: NoSplash.splashFactory,
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.hovered)
                  ? color.withValues(alpha: ButtonMotion.viewMoreHoverAlpha)
                  : color.withValues(alpha: 0),
            ),
            animationDuration: ButtonMotion.hoverDuration,
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: CollectionText.sectionAction.copyWith(color: color),
          ),
          if (showChevron) ...[
            const SizedBox(width: CollectionTokens.sectionActionGap),
            AssetAppIcon(
              AppIconId.chevronRight,
              style: AppIconStyle.fill,
              size: CollectionTokens.sectionActionIcon,
              color: color,
            ),
          ],
        ],
      ),
    );
  }
}
