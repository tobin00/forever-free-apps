import 'package:flutter/material.dart';

class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(Phase 3): Implement flashcard screen — show flag, Reveal button, Next button,
    // progress counter (e.g. "34 / 195"), X quit button (no confirmation).
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards')),
      body: const Center(child: Text('Flashcards — coming in Phase 3')),
    );
  }
}
