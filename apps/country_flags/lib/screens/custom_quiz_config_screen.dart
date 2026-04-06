import 'package:flutter/material.dart';

class CustomQuizConfigScreen extends StatelessWidget {
  const CustomQuizConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(Phase 3): Implement custom quiz config — loop forever toggle,
    // quiz direction picker, country count slider, region filter picker,
    // "Start Quiz" button that pushes /custom-quiz with the config as extra.
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Quiz')),
      body: const Center(child: Text('Custom Quiz Config — coming in Phase 3')),
    );
  }
}
