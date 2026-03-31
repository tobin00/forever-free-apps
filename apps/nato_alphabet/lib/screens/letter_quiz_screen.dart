import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_app_core/shared_app_core.dart';

import '../providers/letter_quiz_provider.dart';
import '../widgets/quiz_letter_display.dart';

class LetterQuizScreen extends ConsumerWidget {
  const LetterQuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(letterQuizProvider);
    final notifier = ref.read(letterQuizProvider.notifier);
    final theme = Theme.of(context);

    if (state.isComplete) {
      return _CompletionView(onRestart: notifier.restart);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          // Progress indicator
          Semantics(
            label: 'Progress: ${state.progress} of ${state.total} letters',
            child: Text(
              '${state.progress} of ${state.total}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: state.progress / state.total,
            backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 40),

          // Letter display (always visible)
          Expanded(
            child: Center(
              child: QuizLetterDisplay(
                letter: state.currentLetter!,
                natoWord: state.currentNatoWord,
                isRevealed: state.isRevealed,
              ),
            ),
          ),

          // Buttons — always both visible
          Row(
            children: [
              Expanded(
                child: Semantics(
                  label: state.isRevealed ? 'Answer revealed' : 'Reveal NATO word',
                  child: PrimaryButton(
                    label: 'Reveal',
                    onPressed: state.isRevealed ? null : notifier.reveal,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Semantics(
                  label: 'Next letter',
                  child: SecondaryButton(
                    label: 'Next',
                    onPressed: notifier.next,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Restart link
          TextButton(
            onPressed: notifier.restart,
            child: Text(
              'Restart',
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _CompletionView extends StatelessWidget {
  final VoidCallback onRestart;

  const _CompletionView({required this.onRestart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, size: 72, color: theme.colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              'Done!',
              style: theme.textTheme.displayMedium?.copyWith(fontSize: 48),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Congratulations, you're all out of letters.",
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            PrimaryButton(label: 'Go Again', onPressed: onRestart, fullWidth: true),
          ],
        ),
      ),
    );
  }
}
