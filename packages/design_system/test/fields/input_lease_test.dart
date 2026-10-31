import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_design_system/design_system.dart';

const _locator = UiRuntimeLocator(
  routeName: 'test-lease',
  routeInstanceId: 't',
);

class _Host extends StatelessWidget {
  const _Host({this.controller, this.focus});
  final TextEditingController? controller;
  final FocusNode? focus;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: AppThemeFactory.build(brightness: Brightness.dark),
    home: Scaffold(
      body: SizedBox(
        width: 370,
        child: AppTextField(
          elementId: 'test.lease.swap',
          runtimeLocator: _locator,
          label: 'Input',
          options: FieldInputOptions(controller: controller, focusNode: focus),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'swapping controllers and focus nodes never disposes a live object',
    (tester) async {
      final first = TextEditingController(text: 'one');
      final firstFocus = FocusNode();
      await tester.pumpWidget(_Host(controller: first, focus: firstFocus));

      // Swap to a new external pair: the lease retires its internal objects
      // (none here) and re-leases; the editable rebuilds with the new pair.
      final second = TextEditingController(text: 'two');
      final secondFocus = FocusNode();
      await tester.pumpWidget(_Host(controller: second, focus: secondFocus));
      await tester.pump();
      expect(tester.takeException(), isNull);

      // Swap to nothing: the lease creates internal replacements; the
      // replaced external objects stay alive and usable (consumer-owned).
      await tester.pumpWidget(const _Host());
      await tester.pump();
      expect(tester.takeException(), isNull);
      second.text = 'still-owned';
      expect(second.text, 'still-owned');
      secondFocus.unfocus();

      // Swap from internal ownership to an external controller: the retired
      // internal controller is disposed after the frame, not mid-update.
      final third = TextEditingController(text: 'three');
      await tester.pumpWidget(_Host(controller: third));
      await tester.pump();
      await tester.pump();
      expect(tester.takeException(), isNull);

      first.dispose();
      firstFocus.dispose();
      second.dispose();
      secondFocus.dispose();
      third.dispose();
    },
  );
}
