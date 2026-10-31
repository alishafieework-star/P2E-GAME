import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

/// Full-screen look at the media shelf pictures (D-126).
///
/// The picture keeps its own shape on the page color. A horizontal drag moves
/// to the next picture. The back arrow is the component arrow, on the start
/// corner, so it sits on the right in Persian.
class GameMediaViewer extends StatefulWidget {
  const GameMediaViewer({
    super.key,
    required this.images,
    required this.labels,
    required this.initialIndex,
    required this.backLabel,
    required this.onClose,
  });

  final List<ImageProvider> images;
  final List<String> labels;
  final int initialIndex;
  final String backLabel;
  final VoidCallback onClose;

  @override
  State<GameMediaViewer> createState() => _GameMediaViewerState();
}

class _GameMediaViewerState extends State<GameMediaViewer> {
  late final PageController _pages = PageController(
    initialPage: widget.initialIndex,
  );

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: GameDetailsRoles.page.resolve(context),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pages,
            itemCount: widget.images.length,
            itemBuilder: (context, index) => Image(
              image: widget.images[index],
              fit: BoxFit.contain,
              semanticLabel: widget.labels[index],
              errorBuilder: (_, _, _) => const SizedBox.expand(),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.topStart,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(
                  GameDetailsTokens.pagePadding,
                ),
                child: Semantics(
                  button: true,
                  label: widget.backLabel,
                  child: GestureDetector(
                    key: const ValueKey('game.details.media.viewer.back'),
                    onTap: widget.onClose,
                    child: AssetAppIcon(
                      AppIconId.arrowLeft,
                      style: AppIconStyle.fill,
                      color: GameDetailsRoles.emphasis.resolve(context),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
