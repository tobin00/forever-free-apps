import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/nato_entry.dart';
import '../providers/audio_provider.dart';

/// A single row in the Reference screen showing letter, NATO word,
/// official pronunciation, and a play button for the audio clip.
class NatoEntryCard extends ConsumerWidget {
  final NatoEntry entry;

  const NatoEntryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final playingWord = ref.watch(audioProvider);
    final isPlaying = playingWord == entry.word;

    return Semantics(
      label: '${entry.letter}: ${entry.word}, pronounced ${entry.pronunciation}',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Letter badge
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  entry.letter,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Word + pronunciation
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      entry.word,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '(${entry.pronunciation})',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              // Play / stop button
              IconButton(
                icon: Icon(isPlaying ? Icons.stop_circle_outlined : Icons.play_circle_outline),
                color: theme.colorScheme.primary,
                tooltip: isPlaying ? 'Stop' : 'Play pronunciation',
                onPressed: () =>
                    ref.read(audioProvider.notifier).toggle(entry.word),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
