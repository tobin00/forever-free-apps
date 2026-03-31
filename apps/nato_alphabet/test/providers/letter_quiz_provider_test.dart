import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nato_alphabet/providers/letter_quiz_provider.dart';

void main() {
  ProviderContainer makeContainer() => ProviderContainer();

  test('initial state: not complete, index 0, not revealed', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final state = container.read(letterQuizProvider);

    expect(state.isComplete, false);
    expect(state.currentIndex, 0);
    expect(state.isRevealed, false);
    expect(state.currentLetter, isNotNull);
    expect(state.total, 26);
  });

  test('reveal sets isRevealed to true', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    container.read(letterQuizProvider.notifier).reveal();
    expect(container.read(letterQuizProvider).isRevealed, true);
  });

  test('next advances index and clears reveal', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    container.read(letterQuizProvider.notifier).reveal();
    container.read(letterQuizProvider.notifier).next();
    final state = container.read(letterQuizProvider);
    expect(state.currentIndex, 1);
    expect(state.isRevealed, false);
  });

  test('cycles through all 26 unique letters', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final notifier = container.read(letterQuizProvider.notifier);
    final seen = <String>{};

    for (int i = 0; i < 26; i++) {
      final letter = container.read(letterQuizProvider).currentLetter;
      expect(letter, isNotNull);
      seen.add(letter!);
      notifier.next();
    }

    expect(seen.length, 26);
    expect(container.read(letterQuizProvider).isComplete, true);
  });

  test('progress goes from 1 to 26 then completes', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final notifier = container.read(letterQuizProvider.notifier);

    expect(container.read(letterQuizProvider).progress, 1);
    notifier.next();
    expect(container.read(letterQuizProvider).progress, 2);

    for (int i = 2; i <= 26; i++) {
      notifier.next();
    }
    expect(container.read(letterQuizProvider).isComplete, true);
  });

  test('restart resets to index 0 and not revealed', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final notifier = container.read(letterQuizProvider.notifier);
    notifier.next();
    notifier.next();
    notifier.reveal();
    notifier.restart();

    final state = container.read(letterQuizProvider);
    expect(state.currentIndex, 0);
    expect(state.isRevealed, false);
    expect(state.isComplete, false);
  });

  test('reveal does nothing when already complete', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final notifier = container.read(letterQuizProvider.notifier);
    for (int i = 0; i < 26; i++) { notifier.next(); }
    notifier.reveal(); // should be a no-op
    expect(container.read(letterQuizProvider).isComplete, true);
  });
}
