import 'package:flutter/material.dart';

class TypingQuizScreen extends StatelessWidget {
  const TypingQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(Phase 3): Implement typing quiz — show flag, text input, system keyboard,
    // "So Close!" (Levenshtein distance 1) with shake animation,
    // correct/wrong feedback, results screen on completion.
    return Scaffold(
      appBar: AppBar(title: const Text('Typing Quiz')),
      body: const Center(child: Text('Typing Quiz — coming in Phase 3')),
    );
  }
}
