import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_dev_inspector/inspector.dart';

void main() {
  testWidgets(
    'audit reports missing, duplicate and small targets without label text',
    (tester) async {
      tester.view.physicalSize = const Size(1600, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        InspectorHost(
          appBuilder: (settings, key) => MediaQuery(
            data: settings.media,
            child: SizedBox.expand(
              key: key,
              child: MaterialApp(
                home: Column(
                  children: [
                    Semantics(
                      button: true,
                      container: true,
                      onTap: () {},
                      child: const SizedBox(width: 10, height: 10),
                    ),
                    Semantics(
                      button: true,
                      container: true,
                      explicitChildNodes: true,
                      label: 'Go',
                      onTap: () {},
                      child: const SizedBox(width: 48, height: 48),
                    ),
                    Semantics(
                      button: true,
                      container: true,
                      explicitChildNodes: true,
                      label: 'Go',
                      onTap: () {},
                      child: const SizedBox(width: 48, height: 48),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      final host = tester.state<InspectorHostState>(find.byType(InspectorHost));
      await host.auditCurrent();
      final kinds = host.accessibility.findings
          .map((finding) => finding.kind)
          .toSet();
      expect(kinds, contains('a11y-missing-name'));
      expect(kinds, contains('a11y-touch-target'));
      expect(kinds, contains('a11y-duplicate-name'));
      final encoded = jsonEncode(host.accessibility.toJson());
      expect(encoded, isNot(contains('Go')));
      expect(encoded, contains('p2e-a11y-audit-v1'));
      expect(encoded, contains('Not a TalkBack'));
    },
  );

  test('sibling traversal flags upward focus and RTL rows', () {
    final kinds = siblingOrderKinds(const [
      SiblingProbe(Rect.fromLTWH(0, 80, 48, 48)),
      SiblingProbe(Rect.fromLTWH(0, 0, 48, 48)),
      SiblingProbe(Rect.fromLTWH(0, 200, 48, 48), direction: TextDirection.rtl),
      SiblingProbe(
        Rect.fromLTWH(80, 200, 48, 48),
        direction: TextDirection.rtl,
      ),
    ]).map((hit) => hit.kind);
    expect(kinds, containsAll(['a11y-focus-order', 'a11y-rtl-order']));
  });
}
