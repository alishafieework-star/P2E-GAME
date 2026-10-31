import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:p2e_design_system/design_system.dart';

import 'game_surface.dart';

/// About copy. The section header owns Read More; this card only shows text.
class GameAboutCard extends StatelessWidget {
  const GameAboutCard({
    super.key,
    required this.elementId,
    required this.description,
    required this.maxLines,
    this.runtimeLocator,
  });

  final String elementId, description;
  final int? maxLines;
  final UiRuntimeLocator? runtimeLocator;

  @override
  Widget build(BuildContext context) {
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'game.about-card',
      structureRef: 'game.about-card',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: '18526:12068',
      componentSetId: null,
      rawSetName: 'About',
      rawVariantName: 'abstract',
      variants: const {},
      resolved: const {'source': '18526:12059'},
      declared: const {},
      child: GameSurface(
        padding: const EdgeInsetsDirectional.all(GameDetailsTokens.cardPadding),
        child: Text(
          description,
          maxLines: maxLines,
          overflow: maxLines == null ? null : TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: GameDetailsText.body.copyWith(
            color: GameDetailsRoles.body.resolve(context),
          ),
        ),
      ),
    );
  }
}

class GameFactCard extends StatelessWidget {
  const GameFactCard({
    super.key,
    required this.elementId,
    required this.label,
    required this.value,
    this.platform,
    this.runtimeLocator,
  });

  final String elementId, label, value;
  final GameFactPlatform? platform;
  final UiRuntimeLocator? runtimeLocator;

  @override
  Widget build(BuildContext context) {
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'game.fact-card',
      structureRef: 'game.fact-card',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: '18526:12071',
      componentSetId: null,
      rawSetName: 'About fact',
      rawVariantName: platform == null ? 'date' : 'platform',
      variants: {'platform': platform?.name ?? 'none'},
      resolved: const {'source': '18526:12070'},
      declared: const {},
      child: GameSurface(
        padding: const EdgeInsetsDirectional.all(GameDetailsTokens.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GameDetailsText.labelSmall.copyWith(
                color: GameDetailsRoles.emphasis.resolve(context),
              ),
            ),
            const SizedBox(height: GameDetailsTokens.creatorGap),
            Row(
              children: [
                Flexible(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GameDetailsText.mutedNumber.copyWith(
                      color: GameDetailsRoles.body.resolve(context),
                    ),
                  ),
                ),
                if (platform != null) ...[
                  const SizedBox(width: GameDetailsTokens.creatorGap),
                  const PlatformGlyph(),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// [ios] is reserved until a glyph exists (E-117, R-102); today only the
/// Android platform is ever shown and the glyph below is the Android one.
enum GameFactPlatform { android, ios }

/// Android glyph exported from Figma node 18526:12082. It is not in the icon
/// registry (E-117, R-102).
class PlatformGlyph extends StatelessWidget {
  const PlatformGlyph({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/platforms/android.svg',
      width: GameDetailsTokens.platformGlyph,
      height: GameDetailsTokens.platformGlyph,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
    );
  }
}
