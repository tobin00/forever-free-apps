import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_app_core/shared_app_core.dart';

import 'models/custom_quiz_config.dart';
import 'providers/settings_provider.dart';
import 'screens/about_screen.dart';
import 'screens/custom_quiz_config_screen.dart';
import 'screens/custom_quiz_screen.dart';
import 'screens/flashcard_screen.dart';
import 'screens/home_screen.dart';
import 'screens/mistakes_quiz_screen.dart';
import 'screens/multiple_choice_quiz_screen.dart';
import 'screens/quiz_results_screen.dart';
import 'screens/reference_list_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/tricky_flags_quiz_screen.dart';
import 'screens/typing_quiz_screen.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/flashcards',
      builder: (context, state) => const FlashcardScreen(),
    ),
    GoRoute(
      path: '/multiple-choice',
      builder: (context, state) => const MultipleChoiceQuizScreen(),
    ),
    GoRoute(
      path: '/mistakes',
      builder: (context, state) => const MistakesQuizScreen(),
    ),
    GoRoute(
      path: '/tricky-flags',
      builder: (context, state) => const TrickyFlagsQuizScreen(),
    ),
    GoRoute(
      path: '/typing',
      builder: (context, state) => const TypingQuizScreen(),
    ),
    GoRoute(
      path: '/custom-config',
      builder: (context, state) => const CustomQuizConfigScreen(),
    ),
    GoRoute(
      path: '/custom-quiz',
      builder: (context, state) {
        final config =
            state.extra as CustomQuizConfig? ?? const CustomQuizConfig();
        return CustomQuizScreen(config: config);
      },
    ),
    GoRoute(
      path: '/quiz-results',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return QuizResultsScreen(
          rightCount: (extra?['right'] as int?) ?? 0,
          wrongCount: (extra?['wrong'] as int?) ?? 0,
        );
      },
    ),
    GoRoute(
      path: '/reference',
      builder: (context, state) => const ReferenceListScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutScreen(),
    ),
  ],
);

class CountryFlagsApp extends ConsumerWidget {
  const CountryFlagsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsProvider);

    return MaterialApp.router(
      title: 'Forever Free: Flags of the World',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
