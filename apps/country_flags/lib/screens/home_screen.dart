import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/mistakes_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasMistakes = ref.watch(mistakesProvider).isNotEmpty;

    // TODO(Phase 3): Replace with full designed Home screen — app title/banner,
    // styled menu buttons with icons, proper spacing per design language.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flags of the World'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.info_outlined),
            tooltip: 'About',
            onPressed: () => context.push('/about'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MenuButton(
            label: 'Flashcards',
            onTap: () => context.push('/flashcards'),
          ),
          _MenuButton(
            label: 'Quiz — Multiple Choice',
            onTap: () => context.push('/multiple-choice'),
          ),
          _MenuButton(
            label: 'Quiz — Mistakes',
            enabled: hasMistakes,
            onTap: hasMistakes ? () => context.push('/mistakes') : null,
          ),
          _MenuButton(
            label: 'Quiz — Tricky Flags',
            onTap: () => context.push('/tricky-flags'),
          ),
          _MenuButton(
            label: 'Quiz — Typing',
            onTap: () => context.push('/typing'),
          ),
          _MenuButton(
            label: 'Quiz — Custom',
            onTap: () => context.push('/custom-config'),
          ),
          _MenuButton(
            label: 'List of All Flags',
            onTap: () => context.push('/reference'),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool enabled;

  const _MenuButton({
    required this.label,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FilledButton(
        onPressed: enabled ? onTap : null,
        child: Text(label),
      ),
    );
  }
}
