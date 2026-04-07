import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/custom_quiz_config.dart';
import '../models/mc_quiz_state.dart';
import '../providers/multiple_choice_quiz_provider.dart';
import '../widgets/mc_quiz_body.dart';

class CustomQuizScreen extends ConsumerWidget {
  final CustomQuizConfig config;

  const CustomQuizScreen({super.key, required this.config});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customQuizProvider);
    final loopForever = ref.watch(customQuizConfigProvider).loopForever;

    ref.listen<MCQuizState>(customQuizProvider, (_, next) {
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
      onAnswer: (iso) => ref.read(customQuizProvider.notifier).answer(iso),
      onNext: () => ref.read(customQuizProvider.notifier).next(),
      // Loop-forever quizzes go straight home on X (no results).
      onQuit: loopForever
          ? () => context.go('/')
          : () => context.go('/quiz-results', extra: {
                'right': state.rightCount,
                'wrong': state.wrongCount,
              }),
    );
  }
}
