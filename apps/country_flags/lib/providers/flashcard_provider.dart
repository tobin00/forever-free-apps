import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/countries.dart';
import '../models/country.dart';

class FlashcardState {
  final List<Country> countries;
  final int currentIndex;
  final bool isRevealed;
  final bool isComplete;

  const FlashcardState({
    required this.countries,
    this.currentIndex = 0,
    this.isRevealed = false,
    this.isComplete = false,
  });

  Country get currentCountry => countries[currentIndex];
  int get total => countries.length;

  FlashcardState copyWith({
    int? currentIndex,
    bool? isRevealed,
    bool? isComplete,
  }) {
    return FlashcardState(
      countries: countries,
      currentIndex: currentIndex ?? this.currentIndex,
      isRevealed: isRevealed ?? this.isRevealed,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

class FlashcardNotifier extends Notifier<FlashcardState> {
  @override
  FlashcardState build() {
    final shuffled = [...CountriesData.all]..shuffle(Random());
    return FlashcardState(countries: shuffled);
  }

  void reveal() {
    state = state.copyWith(isRevealed: true);
  }

  void next() {
    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.countries.length) {
      state = state.copyWith(isComplete: true);
    } else {
      state = state.copyWith(currentIndex: nextIndex, isRevealed: false);
    }
  }
}

final flashcardProvider = NotifierProvider<FlashcardNotifier, FlashcardState>(
  FlashcardNotifier.new,
);
