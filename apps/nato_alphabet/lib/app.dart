import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_app_core/shared_app_core.dart';

import 'providers/theme_mode_provider.dart';
import 'screens/about_screen.dart';
import 'screens/letter_quiz_screen.dart';
import 'screens/reference_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/word_quiz_screen.dart';

class NatoAlphabetApp extends ConsumerWidget {
  const NatoAlphabetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'Forever Free: NATO Alphabet',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/reference',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        final location = state.matchedLocation;
        int selectedIndex = 0;
        if (location.startsWith('/letter-quiz')) selectedIndex = 1;
        if (location.startsWith('/word-quiz')) selectedIndex = 2;

        return AppShell(
          title: 'Forever Free: NATO Alphabet',
          selectedIndex: selectedIndex,
          destinations: const [
            AppShellDestination(
              icon: Icon(Icons.list_outlined),
              selectedIcon: Icon(Icons.list),
              label: 'Reference',
            ),
            AppShellDestination(
              icon: Icon(Icons.quiz_outlined),
              selectedIcon: Icon(Icons.quiz),
              label: 'Letter Quiz',
            ),
            AppShellDestination(
              icon: Icon(Icons.spellcheck_outlined),
              selectedIcon: Icon(Icons.spellcheck),
              label: 'Word Quiz',
            ),
          ],
          extraActions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Settings',
              onPressed: () => context.push('/settings'),
            ),
          ],
          onDestinationSelected: (index) {
            const routes = ['/reference', '/letter-quiz', '/word-quiz'];
            context.go(routes[index]);
          },
          onAboutTap: () => context.push('/about'),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/reference',
          builder: (_, __) => const ReferenceScreen(),
        ),
        GoRoute(
          path: '/letter-quiz',
          builder: (_, __) => const LetterQuizScreen(),
        ),
        GoRoute(
          path: '/word-quiz',
          builder: (_, __) => const WordQuizScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/about',
      builder: (_, __) => const AboutScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (_, __) => const SettingsScreen(),
    ),
  ],
);
