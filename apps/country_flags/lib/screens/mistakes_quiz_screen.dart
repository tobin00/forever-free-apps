import 'package:flutter/material.dart';

class MistakesQuizScreen extends StatelessWidget {
  const MistakesQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(Phase 3): Implement mistakes quiz — same UI as Multiple Choice but
    // question pool comes from the persisted mistakes list. Correct answers are
    // removed from the list in real time.
    return Scaffold(
      appBar: AppBar(title: const Text('Mistakes Quiz')),
      body: const Center(child: Text('Mistakes Quiz — coming in Phase 3')),
    );
  }
}
