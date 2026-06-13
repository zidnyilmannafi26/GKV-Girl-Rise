import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:girls_rise/main.dart';

void main() {
  testWidgets('Homepage smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GirlRiseApp());

    // Verify that our title is present.
    expect(find.text('Girl Rise'), findsOneWidget);
    expect(find.text('TAP TO START'), findsOneWidget);
  });
}
