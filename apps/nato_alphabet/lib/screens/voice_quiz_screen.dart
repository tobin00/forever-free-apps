import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_app_core/shared_app_core.dart';

import '../providers/voice_quiz_provider.dart';
import '../providers/voice_quiz_settings_provider.dart';
import '../widgets/quiz_letter_display.dart';

// ---------------------------------------------------------------------------
// Entry point — gates on whether voice quiz is enabled.
// Splits into two separate ConsumerWidgets so voiceQuizProvider is only
// watched (and thus initialised) after the user has opted in.
// ---------------------------------------------------------------------------

class VoiceQuizScreen extends ConsumerWidget {
  const VoiceQuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(voiceQuizEnabledProvider);
    if (!enabled) {
      return _EnablePromptView(
        onEnable: () => ref.read(voiceQuizEnabledProvider.notifier).setEnabled(true),
      );
    }
    return const _VoiceQuizContent();
  }
}

// ---------------------------------------------------------------------------
// Enable prompt — shown when the feature is off.
// ---------------------------------------------------------------------------

class _EnablePromptView extends StatelessWidget {
  final VoidCallback onEnable;

  const _EnablePromptView({required this.onEnable});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mic_outlined,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Voice Quiz',
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Speak the NATO word for each letter and the app will check your answer.\n\nThis feature uses your microphone.',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              label: 'Enable Voice Quiz',
              onPressed: onEnable,
              fullWidth: true,
            ),
            const SizedBox(height: 12),
            Text(
              'You can turn this off in Settings at any time.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Active quiz content — only mounted when enabled.
// ---------------------------------------------------------------------------

class _VoiceQuizContent extends ConsumerWidget {
  const _VoiceQuizContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(voiceQuizProvider);
    final notifier = ref.read(voiceQuizProvider.notifier);

    if (state.status == VoiceQuizStatus.permissionDenied) {
      return const _PermissionDeniedView();
    }

    if (state.isComplete) {
      return _CompletionView(onRestart: notifier.restart);
    }

    return _QuizView(state: state, notifier: notifier);
  }
}

// ---------------------------------------------------------------------------
// Permission denied view.
// ---------------------------------------------------------------------------

class _PermissionDeniedView extends StatelessWidget {
  const _PermissionDeniedView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mic_off_outlined, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 24),
            Text(
              'Microphone access denied',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Please grant microphone and speech recognition access in your device Settings, then come back.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Completion view.
// ---------------------------------------------------------------------------

class _CompletionView extends StatelessWidget {
  final VoidCallback onRestart;

  const _CompletionView({required this.onRestart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, size: 72, color: theme.colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              'Done!',
              style: theme.textTheme.displayMedium?.copyWith(fontSize: 48),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "You've said all 26 NATO words!",
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            PrimaryButton(label: 'Go Again', onPressed: onRestart, fullWidth: true),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main quiz view.
// ---------------------------------------------------------------------------

class _QuizView extends StatelessWidget {
  final VoiceQuizState state;
  final VoiceQuizNotifier notifier;

  const _QuizView({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRevealState = state.status == VoiceQuizStatus.correct ||
        state.status == VoiceQuizStatus.incorrect;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          // Progress indicator
          Semantics(
            label: 'Progress: ${state.progress} of ${state.total} letters',
            child: Text(
              '${state.progress} of ${state.total}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: state.progress / state.total,
            backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 40),

          // Letter + word display
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QuizLetterDisplay(
                    letter: state.currentLetter!,
                    natoWord: state.currentNatoWord,
                    isRevealed: isRevealState,
                  ),
                  const SizedBox(height: 24),
                  _FeedbackArea(state: state),
                ],
              ),
            ),
          ),

          // Action buttons
          _ActionArea(state: state, notifier: notifier),
          const SizedBox(height: 16),

          // Restart link
          TextButton(
            onPressed: notifier.restart,
            child: Text('Restart', style: theme.textTheme.bodySmall),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Feedback area — correct / incorrect / no-speech messaging.
// ---------------------------------------------------------------------------

class _FeedbackArea extends StatelessWidget {
  final VoiceQuizState state;

  const _FeedbackArea({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Fixed height to prevent layout shift when status changes.
    return SizedBox(
      height: 64,
      child: switch (state.status) {
        VoiceQuizStatus.correct => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 28),
              const SizedBox(width: 8),
              Semantics(
                label: 'Correct',
                child: Text(
                  'Correct!',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        VoiceQuizStatus.incorrect => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cancel, color: theme.colorScheme.error, size: 22),
                  const SizedBox(width: 6),
                  Semantics(
                    label: 'You said ${state.heardWord ?? "unknown"}',
                    child: Text(
                      'You said: "${state.heardWord ?? "?"}"',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Correct: ${state.currentNatoWord ?? ""}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        VoiceQuizStatus.noSpeech => Semantics(
            label: "Didn't catch that, try again",
            child: Text(
              "Didn't catch that",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        VoiceQuizStatus.listening => Semantics(
            label: 'Listening',
            child: Text(
              'Listening…',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Action area — mic button, cancel, or next button.
// ---------------------------------------------------------------------------

class _ActionArea extends StatelessWidget {
  final VoiceQuizState state;
  final VoiceQuizNotifier notifier;

  const _ActionArea({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return switch (state.status) {
      VoiceQuizStatus.listening => _CancelButton(onCancel: notifier.cancelListening),
      VoiceQuizStatus.correct || VoiceQuizStatus.incorrect => Semantics(
          label: 'Next letter',
          child: PrimaryButton(label: 'Next', onPressed: notifier.next, fullWidth: true),
        ),
      VoiceQuizStatus.initializing => Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      _ => _MicButton(
          onTap: notifier.startListening,
          isRetry: state.status == VoiceQuizStatus.noSpeech,
        ),
    };
  }
}

class _MicButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isRetry;

  const _MicButton({required this.onTap, required this.isRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = isRetry ? 'Try Again' : 'Tap to Speak';

    return Semantics(
      label: label,
      button: true,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: theme.colorScheme.primaryContainer,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onTap,
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Icon(
                    Icons.mic,
                    size: 40,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  final VoidCallback onCancel;

  const _CancelButton({required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: theme.colorScheme.surfaceContainerHighest,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onCancel,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Icon(
                Icons.mic,
                size: 40,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
