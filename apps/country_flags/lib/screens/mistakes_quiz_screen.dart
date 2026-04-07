import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/mc_quiz_state.dart';
import '../providers/multiple_choice_quiz_provider.dart';
import '../widgets/mc_quiz_body.dart';

class MistakesQuizScreen extends ConsumerWidget {
  const MistakesQuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mistakesQuizProvider);

    ref.listen<MCQuizState>(mistakesQuizProvider, (_, next) {
      if (next.isComplete) {
        context.go('/quiz-results', extra: {
          'right': next.rightCount,
          'wrong': next.wrongCount,
        });
      }
    });

    if (state.isComplete) return const SizedBox.shrink();

    return MCQuizBody(
      state: state,
      onAnswer: (iso) => ref.read(mistakesQuizProvider.notifier).answer(iso),
      onNext: () => ref.read(mistakesQuizProvider.notifier).next(),
      onQuit: () => context.go('/'),
    );
  }
}
