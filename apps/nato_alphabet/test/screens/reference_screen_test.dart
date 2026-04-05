import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nato_alphabet/screens/reference_screen.dart';

void main() {
  testWidgets('Reference screen shows all 26 NATO entries', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: ReferenceScreen())),
      ),
    );

    await tester.pumpAndSettle();

    // First entry — ICAO spelling is Alfa (not Alpha)
    expect(find.text('Alfa'), findsOneWidget);

    // Scroll to bottom
    await tester.scrollUntilVisible(find.text('Zulu'), 500);
    expect(find.text('Zulu'), findsOneWidget);
  });

  testWidgets('Reference screen shows letter badges', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: ReferenceScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('A'), findsWidgets);
    expect(find.text('B'), findsWidgets);
  });
}
