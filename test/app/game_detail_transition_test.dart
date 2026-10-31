import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/app/router/game_detail_transition.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'game details squeezes the page below, then slides in from the end',
    (tester) async {
      final context = await _pumpHome(tester);
      _pushDetails(context);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(
        ModalRoute.of(tester.element(find.byKey(const Key('details'))))!
            .transitionDuration,
        GameDetailTransition.duration,
      );
      expect(_squeezeScale(tester), lessThan(1));
      expect(_squeezeScale(tester), greaterThan(GameDetailTransition.squeeze));
      expect(
        ModalRoute.of(
          tester.element(find.byKey(const Key('home'), skipOffstage: false)),
        )!.offstage,
        isFalse,
      );
      expect(_detailsLeft(tester), greaterThan(700));

      await tester.pump(GameDetailTransition.duration);
      expect(
        _squeezeScale(tester),
        closeTo(GameDetailTransition.squeeze, 0.001),
      );
      expect(_detailsLeft(tester), 0);
    },
  );

  testWidgets('game details slides in from the start edge in RTL', (
    tester,
  ) async {
    final context = await _pumpHome(tester, direction: TextDirection.rtl);
    _pushDetails(context);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(_detailsLeft(tester), lessThan(0));
  });

  testWidgets('reduced motion shows game details immediately', (tester) async {
    final context = await _pumpHome(tester, reduced: true);
    _pushDetails(context);
    await tester.pump();

    final route = ModalRoute.of(
      tester.element(find.byKey(const Key('details'))),
    )!;
    expect(route.transitionDuration, Duration.zero);
    expect(route.reverseTransitionDuration, Duration.zero);
    expect(_detailsLeft(tester), 0);
    expect(
      find.ancestor(
        of: find.byKey(const Key('home'), skipOffstage: false),
        matching: find.byType(Transform),
      ),
      findsNothing,
    );
  });
}

Future<BuildContext> _pumpHome(
  WidgetTester tester, {
  bool reduced = false,
  TextDirection direction = TextDirection.ltr,
}) async {
  tester.view.physicalSize = const Size(800, 600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  late BuildContext homeContext;
  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(disableAnimations: reduced),
          child: Directionality(textDirection: direction, child: child!),
        );
      },
      home: Builder(
        builder: (context) {
          homeContext = context;
          return const SizedBox.expand(key: Key('home'), child: Text('home'));
        },
      ),
    ),
  );
  return homeContext;
}

void _pushDetails(BuildContext context) {
  Navigator.of(context).push<void>(
    GameDetailTransitionPage(
      child: const SizedBox.expand(key: Key('details'), child: Text('details')),
    ).createRoute(context),
  );
}

double _squeezeScale(WidgetTester tester) {
  final box = tester.renderObject<RenderBox>(
    find.byKey(const Key('home'), skipOffstage: false),
  );
  final left = box.localToGlobal(Offset.zero).dx;
  final right = box.localToGlobal(Offset(box.size.width, 0)).dx;
  return (right - left) / box.size.width;
}

double _detailsLeft(WidgetTester tester) =>
    tester.getTopLeft(find.byKey(const Key('details'))).dx;
