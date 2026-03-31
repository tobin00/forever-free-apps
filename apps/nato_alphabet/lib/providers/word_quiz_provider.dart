import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/common_words.dart';

class WordQuizState {
  final String currentWord;
  final bool isRevealed;
  final List<String> recentWords; // rolling window to avoid repetition

  const WordQuizState({
    required this.currentWord,
    required this.isRevealed,
    required this.recentWords,
  });

  WordQuizState copyWith({
    String? currentWord,
    bool? isRevealed,
    List<String>? recentWords,
  }) {
    return WordQuizState(
      currentWord: currentWord ?? this.currentWord,
      isRevealed: isRevealed ?? this.isRevealed,
      recentWords: recentWords ?? this.recentWords,
    );
  }

  static WordQuizState initial() {
    final word = _pickRandom([], Random());
    return WordQuizState(
      currentWord: word,
      isRevealed: false,
      recentWords: [word],
    );
  }

  static String _pickRandom(List<String> recentWords, Random rng) {
    const all = CommonWords.words;
    // Prefer words not in recent history
    final available = all.where((w) => !recentWords.contains(w)).toList();
    final pool = available.isNotEmpty ? available : all;
    return pool[rng.nextInt(pool.length)];
  }
}

class WordQuizNotifier extends Notifier<WordQuizState> {
  final _rng = Random();

  @override
  WordQuizState build() => WordQuizState.initial();

  void reveal() {
    if (state.isRevealed) return;
    state = state.copyWith(isRevealed: true);
  }

  void next() {
    final recent = List<String>.from(state.recentWords);
    // Keep history to last 50 words to avoid repetition
    if (recent.length >= 50) {
      recent.removeAt(0);
    }

    final pool = CommonWords.words.where((w) => !recent.contains(w)).toList();
    final source = pool.isNotEmpty ? pool : CommonWords.words;
    final newWord = source[_rng.nextInt(source.length)];

    recent.add(newWord);
    state = WordQuizState(
      currentWord: newWord,
      isRevealed: false,
      recentWords: recent,
    );
  }
}

final wordQuizProvider =
    NotifierProvider<WordQuizNotifier, WordQuizState>(WordQuizNotifier.new);
