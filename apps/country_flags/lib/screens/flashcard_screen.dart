import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_app_core/shared_app_core.dart';

import '../providers/flashcard_provider.dart';
import '../widgets/flag_widget.dart';

class FlashcardScreen extends ConsumerWidget {
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(flashcardProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Auto-return to home when all cards are done.
    ref.listen<FlashcardState>(flashcardProvider, (_, next) {
      if (next.isComplete) context.go('/');
    });

    if (state.isComplete) return const SizedBox.shrink();

    final country = state.currentCountry;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar: X button + progress counter ────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark
                          ? AppColors.onBackgroundDark
                          : AppColors.onBackground,
                    ),
                    tooltip: 'Return to menu',
                    onPressed: () => context.go('/'),
                  ),
                  const Spacer(),
                  Text(
                    '${state.currentIndex + 1} / ${state.total}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.onBackgroundSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),

            // ── Flag ─────────────────────────────────────────────────────
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Flag card
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: FlagWidget(
                          isoCode: country.isoCode,
                          height: 180,
                          borderRadius: 12,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Country name reveal area
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: state.isRevealed
                            ? Text(
                                country.name,
                                key: const ValueKey('revealed'),
                                style: theme.textTheme.displayMedium?.copyWith(
                                  color: isDark
                                      ? AppColors.onBackgroundDark
                                      : AppColors.onBackground,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : SizedBox(
                                key: const ValueKey('hidden'),
                                height:
                                    (theme.textTheme.displayMedium?.fontSize ??
                                            28) *
                                        1.25,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Buttons ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Row(
                children: [
                  // Reveal button (hidden after reveal)
                  Expanded(
                    child: AnimatedOpacity(
                      opacity: state.isRevealed ? 0 : 1,
                      duration: const Duration(milliseconds: 150),
                      child: OutlinedButton(
                        onPressed: state.isRevealed
                            ? null
                            : () => ref
                                .read(flashcardProvider.notifier)
                                .reveal(),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          side: BorderSide(
                            color: isDark
                                ? AppColors.primaryDark
                                : AppColors.primary,
                            width: 1.5,
                          ),
                          foregroundColor:
                              isDark ? AppColors.primaryDark : AppColors.primary,
                        ),
                        child: const Text('Reveal'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Next button
                  Expanded(
                    child: FilledButton(
                      onPressed: () =>
                          ref.read(flashcardProvider.notifier).next(),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        backgroundColor:
                            isDark ? AppColors.primaryDark : AppColors.primary,
                      ),
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
