import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ff_country_flags/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launches without error', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Country Flags'), findsOneWidget);
  });
}
