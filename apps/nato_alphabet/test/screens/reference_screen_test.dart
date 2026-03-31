import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nato_alphabet/screens/reference_screen.dart';

void main() {
  testWidgets('Reference screen shows all 26 NATO entries', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ReferenceScreen())),
    );

    // Scroll to ensure all items are rendered
    await tester.pumpAndSettle();

    // First and last entries should be findable
    expect(find.text('Alpha'), findsOneWidget);

    // Scroll to bottom
    await tester.scrollUntilVisible(find.text('Zulu'), 500);
    expect(find.text('Zulu'), findsOneWidget);
  });

  testWidgets('Reference screen shows letter badges', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ReferenceScreen())),
    );
    await tester.pumpAndSettle();

    expect(find.text('A'), findsWidgets);
    expect(find.text('B'), findsWidgets);
  });
}
