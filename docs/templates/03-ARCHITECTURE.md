# 03 - Architecture

> Flutter project structure, state management, and code conventions used by every app.

---

## Monorepo Structure

```
project-root/
├── apps/
│   └── nato_alphabet/
│       ├── lib/
│       │   ├── main.dart                 # App entry point
│       │   ├── app.dart                  # MaterialApp configuration
│       │   ├── screens/                  # One file per screen
│       │   │   ├── reference_screen.dart
│       │   │   ├── letter_quiz_screen.dart
│       │   │   ├── word_quiz_screen.dart
│       │   │   └── about_screen.dart     # Uses shared_app_core AboutPage
│       │   ├── widgets/                  # App-specific reusable widgets
│       │   │   ├── nato_entry_card.dart
│       │   │   ├── quiz_letter_display.dart
│       │   │   └── word_reveal_animation.dart
│       │   ├── providers/                # Riverpod providers (state)
│       │   │   ├── letter_quiz_provider.dart
│       │   │   └── word_quiz_provider.dart
│       │   ├── models/                   # Data models
│       │   │   └── nato_entry.dart
│       │   └── data/                     # Static data
│       │       ├── nato_alphabet.dart
│       │       └── common_words.dart
│       ├── test/
│       │   ├── screens/                  # Widget tests for screens
│       │   └── providers/                # Unit tests for state logic
│       ├── integration_test/             # Full app flow tests (Flutter driver)
│       ├── pubspec.yaml
│       └── analysis_options.yaml
│
├── packages/
│   └── shared_app_core/
│       ├── lib/
│       │   ├── shared_app_core.dart      # Barrel export
│       │   ├── theme/
│       │   │   ├── app_theme.dart        # ThemeData (light + dark)
│       │   │   ├── app_colors.dart       # Color constants
│       │   │   └── app_typography.dart   # Text styles
│       │   ├── widgets/
│       │   │   ├── app_shell.dart        # Scaffold + nav template
│       │   │   ├── about_page.dart       # Shared About page
│       │   │   ├── donation_button.dart  # Donation CTA widget
│       │   │   ├── primary_button.dart   # Styled button
│       │   │   └── secondary_button.dart
│       │   └── constants/
│       │       └── brand.dart            # Mission text, URLs, app-wide constants
│       ├── test/
│       ├── pubspec.yaml
│       └── analysis_options.yaml
│
└── docs/
    ├── templates/                         # These docs
    └── nato_alphabet/                     # App-specific docs
```

---

## State Management: Riverpod

### Why Riverpod
- Compile-time safe (no runtime errors from missing providers)
- Testable (providers can be overridden in tests)
- No BuildContext dependency for logic
- Community standard as of 2025
- Works well with code generation for less boilerplate

### Package
Use `flutter_riverpod` (not hooks_riverpod — keep it simple).

```yaml
dependencies:
  flutter_riverpod: ^3.3.1
```

### Provider Patterns

**For quiz state (mutable, per-session):**
```dart
// Use plain Notifier (no code generation — simpler, no build step required)
class LetterQuizNotifier extends Notifier<LetterQuizState> {
  @override
  LetterQuizState build() => LetterQuizState.initial();

  void reveal() { ... }
  void next() { ... }
  void restart() { ... }
}

final letterQuizProvider = NotifierProvider<LetterQuizNotifier, LetterQuizState>(
  LetterQuizNotifier.new,
);
```

**For static data (immutable):**
```dart
// Simple provider for data that doesn't change
final natoAlphabetProvider = Provider<List<NatoEntry>>(
  (_) => NatoData.entries,
);
```

> **Note:** We do NOT use `riverpod_generator` or `@riverpod` annotations.
> Plain `NotifierProvider` is simpler, has no build step, and works identically.
> This means no `*.g.dart` files and no `build_runner` needed.

### State Guidelines
- State lives in `providers/` directory
- UI logic (what to show) lives in providers
- Presentation logic (how to show) lives in widgets
- No business logic in widgets — widgets only read state and call provider methods
- State is **not persisted** unless the app specifically requires it (NATO app doesn't)

---

## Navigation: GoRouter

### Why GoRouter
- Declarative routing that integrates with Riverpod
- Supports deep linking (useful if we ever add it)
- Clean URL-like paths
- Type-safe route parameters

### Package
```yaml
dependencies:
  go_router: ^17.1.0
```

### Route Structure (per app)
```dart
final router = GoRouter(
  initialLocation: '/reference',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/reference', builder: (_, __) => const ReferenceScreen()),
        GoRoute(path: '/letter-quiz', builder: (_, __) => const LetterQuizScreen()),
        GoRoute(path: '/word-quiz', builder: (_, __) => const WordQuizScreen()),
      ],
    ),
    GoRoute(path: '/about', builder: (_, __) => const AboutScreen()),
  ],
);
```

**Note:** The About page is outside the ShellRoute so it appears as a full-screen overlay without the bottom nav bar.

---

## Project Conventions

### File Naming
- All Dart files: `snake_case.dart`
- One public class per file (matching filename)
- Private helpers can live in the same file if small

### Class Naming
- Widgets: `PascalCase` (e.g., `NatoEntryCard`)
- State classes: `PascalCaseState` (e.g., `LetterQuizState`)
- Providers: `camelCase` (e.g., `letterQuizProvider`)

### Import Ordering
```dart
// 1. Dart SDK
import 'dart:math';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. External packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 4. Shared packages
import 'package:shared_app_core/shared_app_core.dart';

// 5. App-relative imports
import '../providers/letter_quiz_provider.dart';
```

### Widget Structure
```dart
class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);

    return Scaffold(
      // ... widget tree
    );
  }
}
```

- Use `ConsumerWidget` (not `StatefulWidget` + `Consumer`) unless you need `initState`
- Use `const` constructors wherever possible
- Extract sub-widgets into methods only if the method is reused or the build method exceeds ~80 lines

---

## Dependencies (Shared Across All Apps)

### packages/shared_app_core/pubspec.yaml
```yaml
name: shared_app_core
description: Shared theme, widgets, and components for freeware apps.

environment:
  sdk: '>=3.2.0 <4.0.0'
  flutter: '>=3.16.0'

dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
  url_launcher: ^6.2.0    # For donation link

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
```

### apps/{app_name}/pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^3.3.1
  go_router: ^17.1.0
  shared_app_core:
    path: ../../packages/shared_app_core

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  integration_test:
    sdk: flutter
  flutter_launcher_icons: ^0.14.3

flutter_launcher_icons:
  android: true
  ios: false                        # Deferred until iOS phase
  image_path: assets/icon/icon.png
  min_sdk_android: 21
  adaptive_icon_background: "#1B5E7B"   # Primary color from design language
  adaptive_icon_foreground: assets/icon/icon.png

flutter:
  uses-material-design: true
  assets:
    - assets/icon/
```

> **No code generation needed.** We intentionally omit `riverpod_annotation`,
> `riverpod_generator`, and `build_runner`. Plain `NotifierProvider` is sufficient
> and keeps the build process simple — no `dart run build_runner` step required.

### Dependency Rules
- **Minimize dependencies.** Every package is a maintenance burden.
- No analytics packages (Firebase, etc.)
- No ad packages
- No network packages (these apps are offline)
- Evaluate every new dependency: is it worth the cost?

---

## Testing Strategy

### Test Types

| Type | Location | Runs | Tests |
|------|----------|------|-------|
| **Unit** | `test/providers/` | Every CI build | State logic, data transformations |
| **Widget** | `test/screens/` | Every CI build | Screen rendering, user interactions |
| **Integration** | `integration_test/` | Every CI build | Full user flows across screens |

### Unit Test Example (Provider)
```dart
void main() {
  test('LetterQuiz cycles through all 26 letters', () {
    final container = ProviderContainer();
    final quiz = container.read(letterQuizProvider.notifier);

    final seenLetters = <String>{};
    for (int i = 0; i < 26; i++) {
      final state = container.read(letterQuizProvider);
      seenLetters.add(state.currentLetter!);  // non-null: loop stops before complete
      quiz.next();
    }

    expect(seenLetters.length, 26);
  });
}
```

### Widget Test Example
```dart
void main() {
  testWidgets('Letter Quiz shows Reveal button', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LetterQuizScreen())),
    );

    expect(find.text('Reveal'), findsOneWidget);
  });
}
```

### Coverage Target
- **Providers:** 90%+ (this is where logic lives)
- **Widgets:** Key interactions tested (taps, reveals, navigation)
- **Integration:** At least one test per UX flow from 01-REQUIREMENTS.md

---

## Code Generation

**We do not use Riverpod code generation.** Plain `NotifierProvider` is used instead.

This was a deliberate decision after the first app: code generation adds build steps,
`*.g.dart` files to manage, and complexity that isn't warranted for apps of this size.

If a future app has dramatically more providers and the boilerplate becomes painful,
revisit this decision then. Until then, use plain `NotifierProvider` as shown above.

---

## Platform-Specific Notes

### Android
- `minSdkVersion: 21` (Android 5.0 — covers 99%+ of devices)
- `targetSdkVersion: 34` (latest stable)
- Material 3 / Material You support enabled
- No permissions required (fully offline app)

### iOS (Deferred)
- Minimum deployment target: iOS 13.0
- Will configure when ready for iOS builds
- Same codebase, no platform-specific code expected

---

## Instructions for AI

When setting up a new app (Phase 2 of `00-PROCESS.md`):
1. Run `flutter create --org com.yourorg --project-name {app_name} apps/{app_name}` (confirm org with user on first app)
2. Add `shared_app_core` as a path dependency: `path: ../../packages/shared_app_core`
3. Add all standard dependencies listed in the Dependencies section above
4. Create the directory structure shown at the top of this document
5. Implement the GoRouter route structure — adapt the route pattern above to the app's screens from REQUIREMENTS.md
6. Create Riverpod providers for all app state — use plain `NotifierProvider` (NO code generation)
7. Follow the file naming, class naming, and import ordering conventions exactly
8. Run `flutter pub get` and `flutter analyze` to verify clean setup (no build_runner step needed)
