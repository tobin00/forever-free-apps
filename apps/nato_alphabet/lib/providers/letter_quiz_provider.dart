import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/nato_alphabet.dart';

class LetterQuizState {
  final List<String> shuffledLetters;
  final int currentIndex;
  final bool isRevealed;

  const LetterQuizState({
    required this.shuffledLetters,
    required this.currentIndex,
    required this.isRevealed,
  });

  bool get isComplete => currentIndex >= shuffledLetters.length;
  String? get currentLetter => isComplete ? null : shuffledLetters[currentIndex];
  String? get currentNatoWord => currentLetter == null ? null : NatoData.lookup[currentLetter];

  /// 1-based progress (1 = showing first card, 26 = showing last card).
  int get progress => min(currentIndex + 1, shuffledLetters.length);
  int get total => shuffledLetters.length;

  LetterQuizState copyWith({
    List<String>? shuffledLetters,
    int? currentIndex,
    bool? isRevealed,
  }) {
    return LetterQuizState(
      shuffledLetters: shuffledLetters ?? this.shuffledLetters,
      currentIndex: currentIndex ?? this.currentIndex,
      isRevealed: isRevealed ?? this.isRevealed,
    );
  }

  static LetterQuizState initial() {
    final letters = NatoData.entries.map((e) => e.letter).toList()..shuffle(Random());
    return LetterQuizState(
      shuffledLetters: letters,
      currentIndex: 0,
      isRevealed: false,
    );
  }
}

class LetterQuizNotifier extends Notifier<LetterQuizState> {
  @override
  LetterQuizState build() => LetterQuizState.initial();

  void reveal() {
    if (state.isComplete) return;
    state = state.copyWith(isRevealed: true);
  }

  void next() {
    if (state.isComplete) return;
    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      isRevealed: false,
    );
  }

  void restart() {
    state = LetterQuizState.initial();
  }
}

final letterQuizProvider =
    NotifierProvider<LetterQuizNotifier, LetterQuizState>(LetterQuizNotifier.new);
