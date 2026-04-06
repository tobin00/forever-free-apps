import 'package:flutter/material.dart';

class MultipleChoiceQuizScreen extends StatelessWidget {
  const MultipleChoiceQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(Phase 3): Implement multiple choice quiz — random flag/name mode per question,
    // 4 answer cards (light blue), progress bar, Right/Wrong counter, X quit button,
    // green/red/amber card feedback, results screen on completion.
    return Scaffold(
      appBar: AppBar(title: const Text('Multiple Choice')),
      body: const Center(child: Text('Multiple Choice Quiz — coming in Phase 3')),
    );
  }
}
