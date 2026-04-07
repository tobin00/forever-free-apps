import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_app_core/shared_app_core.dart';

import '../providers/flashcard_provider.dart';
import '../providers/mistakes_provider.dart';
import '../providers/multiple_choice_quiz_provider.dart';
import '../providers/typing_quiz_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasMistakes = ref.watch(mistakesProvider).isNotEmpty;
    final mistakeCount = ref.watch(mistakesProvider).length;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.info_outlined),
            tooltip: 'About',
            onPressed: () => context.push('/about'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          // ── Header ────────────────────────────────────────────────────────
          const SizedBox(height: 8),
          Center(
            child: Column(
              children: [
                Text(
                  'Forever Free',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onBackgroundSecondary,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Flags of the World',
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: isDark ? AppColors.primaryDark : AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Learn every flag, offline & free',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onBackgroundSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ── Menu cards ────────────────────────────────────────────────────
          _MenuCard(
            icon: Icons.style_outlined,
            label: 'Flashcards',
            subtitle: 'Flip through all flags at your pace',
            onTap: () {
              ref.invalidate(flashcardProvider);
              context.push('/flashcards');
            },
          ),
          _MenuCard(
            icon: Icons.quiz_outlined,
            label: 'Quiz — Multiple Choice',
            subtitle: 'Pick the right flag or country name',
            onTap: () {
              ref.invalidate(multipleChoiceQuizProvider);
              context.push('/multiple-choice');
            },
          ),
          _MenuCard(
            icon: Icons.highlight_off,
            label: 'Quiz — Mistakes',
            subtitle: hasMistakes
                ? '$mistakeCount flag${mistakeCount == 1 ? '' : 's'} to review'
                : 'No mistakes yet — keep quizzing!',
            enabled: hasMistakes,
            onTap: hasMistakes
                ? () {
                    ref.invalidate(mistakesQuizProvider);
                    context.push('/mistakes');
                  }
                : null,
          ),
          _MenuCard(
            icon: Icons.flag_outlined,
            label: 'Quiz — Tricky Flags',
            subtitle: 'Flags that look surprisingly similar',
            onTap: () {
              ref.invalidate(trickyFlagsQuizProvider);
              context.push('/tricky-flags');
            },
          ),
          _MenuCard(
            icon: Icons.keyboard_outlined,
            label: 'Quiz — Typing',
            subtitle: 'Type the country name from memory',
            onTap: () {
              ref.invalidate(typingQuizProvider);
              context.push('/typing');
            },
          ),
          _MenuCard(
            icon: Icons.tune_outlined,
            label: 'Quiz — Custom',
            subtitle: 'Set your own rules and region',
            onTap: () => context.push('/custom-config'),
          ),
          _MenuCard(
            icon: Icons.public_outlined,
            label: 'List of All Flags',
            subtitle: 'Browse all 197 flags alphabetically',
            onTap: () => context.push('/reference'),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback? onTap;
  final bool enabled;

  const _MenuCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final iconColor = enabled
        ? (isDark ? AppColors.primaryDark : AppColors.primary)
        : theme.disabledColor;
    final labelColor =
        enabled ? theme.textTheme.titleMedium?.color : theme.disabledColor;
    final subtitleColor =
        enabled ? AppColors.onBackgroundSecondary : theme.disabledColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        elevation: isDark ? 0 : 1,
        shadowColor: Colors.black12,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: isDark
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.dividerDark,
                      width: 1,
                    ),
                  )
                : null,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 26),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: labelColor),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: subtitleColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: enabled
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                      : theme.disabledColor.withValues(alpha: 0.3),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
