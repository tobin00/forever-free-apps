import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nato_alphabet/screens/word_quiz_screen.dart';

Widget makeApp() => const ProviderScope(
      child: MaterialApp(home: Scaffold(body: WordQuizScreen())),
    );

void main() {
  testWidgets('Both Show Me and Next buttons are always visible', (tester) async {
    await tester.pumpWidget(makeApp());
    await tester.pumpAndSettle();

    expect(find.text('Show Me'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('A word is displayed on load', (tester) async {
    await tester.pumpWidget(makeApp());
    await tester.pumpAndSettle();

    // The word display should have at least one alphabetic character
    final textWidgets = tester.widgetList<Text>(find.byType(Text)).toList();
    final hasWord = textWidgets.any((t) =>
        t.data != null &&
        RegExp(r'^[A-Z]+$').hasMatch(t.data!) &&
        t.data!.length > 1);
    expect(hasWord, true);
  });

  testWidgets('Tapping Show Me reveals NATO letters', (tester) async {
    await tester.pumpWidget(makeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Show Me'));
    await tester.pumpAndSettle();

    // After reveal, Show Me should be disabled and the em-dash reveal rows visible
    expect(find.textContaining('—'), findsWidgets);
  });

  testWidgets('Tapping Next clears reveal and shows new word', (tester) async {
    await tester.pumpWidget(makeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Show Me'));
    await tester.pumpAndSettle();

    // Reveal rows visible
    expect(find.textContaining('—'), findsWidgets);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Reveal rows gone
    expect(find.textContaining('—'), findsNothing);
  });
}
