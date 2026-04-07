import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/countries.dart';
import '../data/tricky_flag_groups.dart';
import '../models/country.dart';
import '../models/custom_quiz_config.dart';
import '../models/mc_quiz_state.dart';
import '../models/quiz_question.dart';
import 'mistakes_provider.dart';

// ── Custom quiz config ────────────────────────────────────────────────────────

class CustomQuizConfigNotifier extends Notifier<CustomQuizConfig> {
  @override
  CustomQuizConfig build() => const CustomQuizConfig();

  void update(CustomQuizConfig config) => state = config;
}

final customQuizConfigProvider =
    NotifierProvider<CustomQuizConfigNotifier, CustomQuizConfig>(
  CustomQuizConfigNotifier.new,
);

// ── Shared base notifier ──────────────────────────────────────────────────────

abstract class _MCQuizNotifier extends Notifier<MCQuizState> {
  final _rng = Random();

  List<QuizQuestion> buildQuestions();
  bool get loopForever => false;

  @override
  MCQuizState build() => MCQuizState(questions: buildQuestions());

  /// Generates questions from [pool] with the given [direction].
  /// [distractorPool] defaults to all countries.
  List<QuizQuestion> _makeQuestions(
    List<Country> pool, {
    QuizDirection direction = QuizDirection.random,
    List<Country>? distractorPool,
  }) {
    final allCountries = distractorPool ?? CountriesData.all;
    return pool.map((correct) {
      final distractors = [...allCountries]
        ..remove(correct)
        ..shuffle(_rng);
      final options = [correct, ...distractors.take(3)]..shuffle(_rng);
      final isFlagToName = switch (direction) {
        QuizDirection.flagToName => true,
        QuizDirection.nameToFlag => false,
        QuizDirection.random => _rng.nextBool(),
      };
      return QuizQuestion(
        correct: correct,
        options: options,
        isFlagToName: isFlagToName,
      );
    }).toList();
  }

  void answer(String isoCode) {
    if (state.isAnswered) return;
    final correctIso = state.currentQuestion.correct.isoCode;
    final isRight = isoCode == correctIso;
    if (isRight) {
      ref.read(mistakesProvider.notifier).removeMistake(correctIso);
    } else {
      ref.read(mistakesProvider.notifier).addMistake(correctIso);
    }
    state = state.copyWith(
      selectedIsoCode: isoCode,
      rightCount: isRight ? state.rightCount + 1 : state.rightCount,
      wrongCount: isRight ? state.wrongCount : state.wrongCount + 1,
    );
  }

  void next() {
    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.questions.length) {
      if (loopForever) {
        final reshuffled = [...state.questions]..shuffle(_rng);
        state = MCQuizState(
          questions: reshuffled,
          rightCount: state.rightCount,
          wrongCount: state.wrongCount,
        );
      } else {
        state = state.copyWith(isComplete: true);
      }
    } else {
      state = state.copyWith(currentIndex: nextIndex, clearSelected: true);
    }
  }
}

// ── Multiple Choice Quiz ──────────────────────────────────────────────────────

class MultipleChoiceQuizNotifier extends _MCQuizNotifier {
  @override
  List<QuizQuestion> buildQuestions() {
    final pool = [...CountriesData.all]..shuffle(_rng);
    return _makeQuestions(pool);
  }
}

final multipleChoiceQuizProvider =
    NotifierProvider<MultipleChoiceQuizNotifier, MCQuizState>(
  MultipleChoiceQuizNotifier.new,
);

// ── Mistakes Quiz ─────────────────────────────────────────────────────────────

class MistakesQuizNotifier extends _MCQuizNotifier {
  @override
  List<QuizQuestion> buildQuestions() {
    final mistakeIsoCodes = ref.read(mistakesProvider);
    final pool = CountriesData.all
        .where((c) => mistakeIsoCodes.contains(c.isoCode))
        .toList()
      ..shuffle(_rng);
    return _makeQuestions(pool);
  }
}

final mistakesQuizProvider =
    NotifierProvider<MistakesQuizNotifier, MCQuizState>(
  MistakesQuizNotifier.new,
);

// ── Tricky Flags Quiz ─────────────────────────────────────────────────────────

class TrickyFlagsQuizNotifier extends _MCQuizNotifier {
  @override
  List<QuizQuestion> buildQuestions() {
    final questions = <QuizQuestion>[];

    for (final group in TrickyFlagGroupsData.all) {
      final groupCountries = CountriesData.all
          .where((c) => group.isoCodes.contains(c.isoCode))
          .toList();
      if (groupCountries.length < 2) continue;

      // Prefer group members as distractors; fill with random if < 4.
      final optionPool = [...groupCountries];
      if (optionPool.length < 4) {
        final fillers = [...CountriesData.all]
          ..removeWhere((c) => group.isoCodes.contains(c.isoCode))
          ..shuffle(_rng);
        optionPool.addAll(fillers.take(4 - optionPool.length));
      }

      for (final correct in [...groupCountries]..shuffle(_rng)) {
        final others = [...optionPool]
          ..remove(correct)
          ..shuffle(_rng);
        final options = [correct, ...others.take(3)]..shuffle(_rng);
        questions.add(QuizQuestion(
          correct: correct,
          options: options,
          isFlagToName: true, // Always flag → name for tricky flags
        ));
      }
    }

    return questions..shuffle(_rng);
  }
}

final trickyFlagsQuizProvider =
    NotifierProvider<TrickyFlagsQuizNotifier, MCQuizState>(
  TrickyFlagsQuizNotifier.new,
);

// ── Custom Quiz ───────────────────────────────────────────────────────────────

class CustomQuizNotifier extends _MCQuizNotifier {
  @override
  bool get loopForever => ref.read(customQuizConfigProvider).loopForever;

  @override
  List<QuizQuestion> buildQuestions() {
    final config = ref.read(customQuizConfigProvider);

    var pool = config.region != null
        ? CountriesData.byRegion(config.region!)
        : CountriesData.all.toList();

    pool = [...pool]..shuffle(_rng);

    if (config.countryCount != null && config.countryCount! < pool.length) {
      pool = pool.take(config.countryCount!).toList();
    }

    return _makeQuestions(pool, direction: config.direction);
  }
}

final customQuizProvider =
    NotifierProvider<CustomQuizNotifier, MCQuizState>(
  CustomQuizNotifier.new,
);
