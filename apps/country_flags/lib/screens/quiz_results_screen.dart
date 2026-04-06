import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuizResultsScreen extends StatelessWidget {
  final int rightCount;
  final int wrongCount;

  const QuizResultsScreen({
    super.key,
    required this.rightCount,
    required this.wrongCount,
  });

  @override
  Widget build(BuildContext context) {
    // TODO(Phase 3): Implement full results UI with score display and animation.
    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Right: $rightCount'),
            Text('Wrong: $wrongCount'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Return to Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
