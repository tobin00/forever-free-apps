import 'country.dart';

/// One question in a multiple-choice quiz round.
class QuizQuestion {
  /// The country the user must identify.
  final Country correct;

  /// Exactly 4 answer options (includes correct), already shuffled.
  final List<Country> options;

  /// true  → show a flag, pick the country name.
  /// false → show a country name, pick the flag.
  final bool isFlagToName;

  const QuizQuestion({
    required this.correct,
    required this.options,
    required this.isFlagToName,
  });
}
