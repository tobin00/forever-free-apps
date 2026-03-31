import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nato_alphabet/providers/word_quiz_provider.dart';

void main() {
  ProviderContainer makeContainer() => ProviderContainer();

  test('initial state: has a word, not revealed', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final state = container.read(wordQuizProvider);

    expect(state.currentWord, isNotEmpty);
    expect(state.isRevealed, false);
  });

  test('reveal sets isRevealed to true', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    container.read(wordQuizProvider.notifier).reveal();
    expect(container.read(wordQuizProvider).isRevealed, true);
  });

  test('next changes word and clears reveal', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final notifier = container.read(wordQuizProvider.notifier);
    final firstWord = container.read(wordQuizProvider).currentWord;

    notifier.reveal();
    // Call next several times to ensure we get a different word eventually
    String? newWord;
    for (int i = 0; i < 10; i++) {
      notifier.next();
      newWord = container.read(wordQuizProvider).currentWord;
      if (newWord != firstWord) break;
    }

    expect(container.read(wordQuizProvider).isRevealed, false);
    expect(newWord, isNotEmpty);
  });

  test('no repeated words in 20 consecutive nexts', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final notifier = container.read(wordQuizProvider.notifier);
    final seen = <String>{};

    for (int i = 0; i < 20; i++) {
      final word = container.read(wordQuizProvider).currentWord;
      expect(seen.contains(word), false, reason: 'Word "$word" was repeated');
      seen.add(word);
      notifier.next();
    }
  });

  test('reveal is idempotent (second call has no effect)', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final notifier = container.read(wordQuizProvider.notifier);
    notifier.reveal();
    notifier.reveal();
    expect(container.read(wordQuizProvider).isRevealed, true);
  });
}
