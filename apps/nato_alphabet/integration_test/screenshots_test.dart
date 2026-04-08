// Runs ON the iOS simulator. Navigates through the app and calls
// takeScreenshot() at each screen. The bytes are forwarded to the host-side
// driver (test_driver/screenshots_driver.dart) which saves them as PNG files.
//
// Run via the Codemagic nato-alphabet-screenshots workflow, or locally:
//   cd apps/nato_alphabet
//   flutter drive \
//     --driver integration_test/test_driver/screenshots_driver.dart \
//     --target  integration_test/screenshots_test.dart \
//     -d "iPhone 16 Pro Max"

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nato_alphabet/app.dart';
import 'package:nato_alphabet/providers/theme_mode_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('capture App Store screenshots', (WidgetTester tester) async {
    // ── App setup ────────────────────────────────────────────────────────────
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const NatoAlphabetApp(),
      ),
    );
    await tester.pumpAndSettle();

    // On iOS the Flutter surface is a Metal layer by default, which produces
    // blank screenshots. convertFlutterSurfaceToImage() switches to a
    // UIImage-based renderer that the screenshot mechanism can capture.
    await binding.convertFlutterSurfaceToImage();
    await tester.pump();

    // ── 1. Reference screen ───────────────────────────────────────────────
    // App starts here — scroll up to ensure we're at the top.
    await tester.pumpAndSettle();
    await binding.takeScreenshot('01_reference');

    // ── 2. Letter Quiz — question visible ─────────────────────────────────
    await tester.tap(find.text('Letter Quiz'));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('02_letter_quiz_question');

    // ── 3. Letter Quiz — answer revealed ──────────────────────────────────
    await tester.tap(find.text('Reveal'));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('03_letter_quiz_revealed');

    // ── 4. Word Quiz — word visible ────────────────────────────────────────
    await tester.tap(find.text('Word Quiz'));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('04_word_quiz_question');

    // ── 5. Word Quiz — NATO spelling revealed ─────────────────────────────
    await tester.tap(find.text('Show Me'));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('05_word_quiz_revealed');

    // ── 6. About page ─────────────────────────────────────────────────────
    // The About button is an IconButton with tooltip 'About' in the AppBar.
    await tester.tap(find.byTooltip('About'));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('06_about');
  },
  // Screenshots take longer than the default 10-second timeout.
  timeout: const Timeout(Duration(minutes: 3)));
}
