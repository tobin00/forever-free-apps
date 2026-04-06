import 'package:flutter/material.dart';

import '../models/custom_quiz_config.dart';

class CustomQuizScreen extends StatelessWidget {
  final CustomQuizConfig config;

  const CustomQuizScreen({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    // TODO(Phase 3): Implement custom quiz — same UI as Multiple Choice but
    // uses config.countryCount, config.region, config.direction, config.loopForever.
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Quiz')),
      body: const Center(child: Text('Custom Quiz — coming in Phase 3')),
    );
  }
}
