import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_design_system/design_system.dart';
import 'package:p2e_dev_inspector/inspector.dart';

void main() {
  testWidgets('comparison summary counts a measured difference', (
    tester,
  ) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeFactory.build(
          brightness: Brightness.dark,
          skin: productSkin,
        ),
        home: SizedBox.expand(
          key: key,
          child: const UiIdentityScope(
            routeName: 'probe',
            instanceKey: 'one',
            child: Scaffold(
              body: Center(
                child: AppBadge(elementId: 'probe.badge', label: 'Badge'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final session = InspectionSession(key);
    addTearDown(session.dispose);
    session.scan();
    final node = session.tree.single;
    RenderPadding? padding;
    void read(Element element) {
      if (element is RenderObjectElement &&
          element.renderObject is RenderPadding) {
        padding ??= element.renderObject as RenderPadding;
      }
      element.visitChildren(read);
    }

    read(node.element);
    padding!.padding = const EdgeInsetsDirectional.all(35);
    await tester.pump();
    final summary = comparisonSummary(node.capture())!;
    expect(summary.elementId, 'probe.badge');
    expect(summary.differs, 1);
    expect(
      summary.rows.singleWhere((row) => row.axis == 'padding').status,
      'differs',
    );
  });

  test('problem report keeps only the allowlisted fields', () {
    const device = FrameSettings(size: Size(402, 874));
    final text = problemReport([
      InspectionProblem(
        'overflow',
        'Row overflowed',
        null,
        'home.card',
        device,
      ),
    ]);
    expect(text, 'overflow | home.card | 402×874\nRow overflowed');
  });

  testWidgets('Problems copy button writes the report', (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.pumpWidget(
      InspectorHost(
        appBuilder: (settings, key) => SizedBox.expand(
          key: key,
          child: const ColoredBox(color: Color(0xFF000000)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final host = tester.state<InspectorHostState>(find.byType(InspectorHost));
    host.problems.record(
      InspectionProblem(
        'overflow',
        'Row overflowed',
        null,
        'home.card',
        host.settings,
      ),
    );
    await tester.tap(find.text('Problems'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('copy-problems')));
    await tester.pump();
    expect(copied, contains('overflow | home.card'));
    expect(copied, contains('Row overflowed'));
  });
}
