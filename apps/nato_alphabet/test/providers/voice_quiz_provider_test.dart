import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nato_alphabet/providers/voice_quiz_provider.dart';

void main() {
  ProviderContainer makeContainer() => ProviderContainer();

  test('initial state: initializing, index 0, not complete, no heardWord', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final state = container.read(voiceQuizProvider);

    expect(state.status, VoiceQuizStatus.initializing);
    expect(state.currentIndex, 0);
    expect(state.isComplete, false);
    expect(state.heardWord, isNull);
    expect(state.currentLetter, isNotNull);
    expect(state.total, 26);
  });

  test('progress starts at 1', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    expect(container.read(voiceQuizProvider).progress, 1);
  });

  test('next advances index, sets status to idle, clears heardWord', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    container.read(voiceQuizProvider.notifier).next();
    final state = container.read(voiceQuizProvider);
    expect(state.currentIndex, 1);
    expect(state.status, VoiceQuizStatus.idle);
    expect(state.heardWord, isNull);
  });

  test('next is a no-op when complete', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final notifier = container.read(voiceQuizProvider.notifier);
    for (int i = 0; i < 26; i++) { notifier.next(); }
    expect(container.read(voiceQuizProvider).isComplete, true);
    notifier.next(); // should not throw or advance
    expect(container.read(voiceQuizProvider).currentIndex, 26);
  });

  test('cycles through all 26 unique letters', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final notifier = container.read(voiceQuizProvider.notifier);
    final seen = <String>{};

    for (int i = 0; i < 26; i++) {
      final letter = container.read(voiceQuizProvider).currentLetter;
      expect(letter, isNotNull);
      seen.add(letter!);
      notifier.next();
    }

    expect(seen.length, 26);
    expect(container.read(voiceQuizProvider).isComplete, true);
  });

  test('restart resets index to 0, status to idle, clears heardWord', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final notifier = container.read(voiceQuizProvider.notifier);
    notifier.next();
    notifier.next();
    notifier.restart();

    final state = container.read(voiceQuizProvider);
    expect(state.currentIndex, 0);
    expect(state.status, VoiceQuizStatus.idle);
    expect(state.heardWord, isNull);
    expect(state.isComplete, false);
  });

  test('restart reshuffles — new run has all 26 unique letters', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final notifier = container.read(voiceQuizProvider.notifier);
    notifier.restart();

    final seen = <String>{};
    for (int i = 0; i < 26; i++) {
      seen.add(container.read(voiceQuizProvider).currentLetter!);
      notifier.next();
    }
    expect(seen.length, 26);
  });
}
