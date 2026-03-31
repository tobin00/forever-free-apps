import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nato_alphabet/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full flow: launch, navigate tabs, quiz', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Lands on Reference tab
    expect(find.text('Alpha'), findsOneWidget);

    // Navigate to Letter Quiz
    await tester.tap(find.text('Letter Quiz'));
    await tester.pumpAndSettle();
    expect(find.text('Reveal'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Reveal then next
    await tester.tap(find.text('Reveal'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.textContaining('2 of 26'), findsOneWidget);

    // Navigate to Word Quiz
    await tester.tap(find.text('Word Quiz'));
    await tester.pumpAndSettle();
    expect(find.text('Show Me'), findsOneWidget);

    // Reveal and next
    await tester.tap(find.text('Show Me'));
    await tester.pumpAndSettle();
    expect(find.textContaining('—'), findsWidgets);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.textContaining('—'), findsNothing);

    // Navigate back to Reference
    await tester.tap(find.text('Reference'));
    await tester.pumpAndSettle();
    expect(find.text('Alpha'), findsOneWidget);
  });
}
