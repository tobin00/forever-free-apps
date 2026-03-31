import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_app_core/shared_app_core.dart';

import '../data/nato_alphabet.dart';
import '../providers/word_quiz_provider.dart';
import '../widgets/word_reveal_animation.dart';

class WordQuizScreen extends ConsumerWidget {
  const WordQuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wordQuizProvider);
    final notifier = ref.read(wordQuizProvider.notifier);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Instruction hint
          Text(
            'Spell this word using NATO alphabet names:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Word display
          Semantics(
            label: 'Word to spell: ${state.currentWord}',
            child: Text(
              state.currentWord,
              style: theme.textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 32),

          // Animated reveal area
          Expanded(
            child: SingleChildScrollView(
              child: WordRevealAnimation(
                key: ValueKey(state.currentWord),
                word: state.currentWord,
                isRevealed: state.isRevealed,
                natoLookup: NatoData.lookup,
              ),
            ),
          ),

          // Buttons — always both visible
          Row(
            children: [
              Expanded(
                child: Semantics(
                  label: state.isRevealed ? 'Answer already shown' : 'Show NATO spelling',
                  child: PrimaryButton(
                    label: 'Show Me',
                    onPressed: state.isRevealed ? null : notifier.reveal,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Semantics(
                  label: 'Next word',
                  child: SecondaryButton(
                    label: 'Next',
                    onPressed: notifier.next,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
