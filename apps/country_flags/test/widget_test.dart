import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ff_country_flags/app.dart';

void main() {
  setUp(() {
    // Provide empty SharedPreferences so providers don't throw during tests.
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App launches without error', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CountryFlagsApp()));
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
