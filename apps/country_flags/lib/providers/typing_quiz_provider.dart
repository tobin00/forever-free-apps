import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/countries.dart';
import '../models/country.dart';
import 'mistakes_provider.dart';

enum TypingAnswerStatus { unanswered, correct, soClose, wrong }

class TypingQuizState {
  final List<Country> countries;
  final int currentIndex;
  final TypingAnswerStatus status;
  final int rightCount;
  final int wrongCount;
  final bool isComplete;

  const TypingQuizState({
    required this.countries,
    this.currentIndex = 0,
    this.status = TypingAnswerStatus.unanswered,
    this.rightCount = 0,
    this.wrongCount = 0,
    this.isComplete = false,
  });

  Country get currentCountry => countries[currentIndex];
  int get total => countries.length;
  bool get isAnswered => status != TypingAnswerStatus.unanswered;

  TypingQuizState copyWith({
    int? currentIndex,
    TypingAnswerStatus? status,
    int? rightCount,
    int? wrongCount,
    bool? isComplete,
  }) {
    return TypingQuizState(
      countries: countries,
      currentIndex: currentIndex ?? this.currentIndex,
      status: status ?? this.status,
      rightCount: rightCount ?? this.rightCount,
      wrongCount: wrongCount ?? this.wrongCount,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

class TypingQuizNotifier extends Notifier<TypingQuizState> {
  @override
  TypingQuizState build() {
    final shuffled = [...CountriesData.all]..shuffle(Random());
    return TypingQuizState(countries: shuffled);
  }

  void submit(String input) {
    if (state.isAnswered) return;
    final correct = state.currentCountry.name;
    final dist = _levenshtein(
      input.trim().toLowerCase(),
      correct.toLowerCase(),
    );
    final status = dist == 0
        ? TypingAnswerStatus.correct
        : dist == 1
            ? TypingAnswerStatus.soClose
            : TypingAnswerStatus.wrong;

    final iso = state.currentCountry.isoCode;
    if (status == TypingAnswerStatus.correct) {
      ref.read(mistakesProvider.notifier).removeMistake(iso);
    } else {
      ref.read(mistakesProvider.notifier).addMistake(iso);
    }

    state = state.copyWith(
      status: status,
      rightCount: status == TypingAnswerStatus.correct
          ? state.rightCount + 1
          : state.rightCount,
      wrongCount: status != TypingAnswerStatus.correct
          ? state.wrongCount + 1
          : state.wrongCount,
    );
  }

  void next() {
    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.countries.length) {
      state = state.copyWith(isComplete: true);
    } else {
      state = state.copyWith(
        currentIndex: nextIndex,
        status: TypingAnswerStatus.unanswered,
      );
    }
  }

  static int _levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final m = a.length;
    final n = b.length;
    final dp = List.generate(m + 1, (i) => List.filled(n + 1, 0));

    for (var i = 0; i <= m; i++) { dp[i][0] = i; }
    for (var j = 0; j <= n; j++) { dp[0][j] = j; }

    for (var i = 1; i <= m; i++) {
      for (var j = 1; j <= n; j++) {
        if (a[i - 1] == b[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 +
              [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]]
                  .reduce((v, e) => v < e ? v : e);
        }
      }
    }

    return dp[m][n];
  }
}

final typingQuizProvider =
    NotifierProvider<TypingQuizNotifier, TypingQuizState>(
  TypingQuizNotifier.new,
);
