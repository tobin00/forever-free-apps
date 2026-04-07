import 'quiz_question.dart';

/// Shared state for all multiple-choice-style quiz modes
/// (Multiple Choice, Mistakes, Tricky Flags, Custom).
class MCQuizState {
  final List<QuizQuestion> questions;
  final int currentIndex;

  /// ISO code the user tapped; null = not yet answered.
  final String? selectedIsoCode;

  final int rightCount;
  final int wrongCount;
  final bool isComplete;

  const MCQuizState({
    required this.questions,
    this.currentIndex = 0,
    this.selectedIsoCode,
    this.rightCount = 0,
    this.wrongCount = 0,
    this.isComplete = false,
  });

  QuizQuestion get currentQuestion => questions[currentIndex];
  int get total => questions.length;
  bool get isAnswered => selectedIsoCode != null;

  MCQuizState copyWith({
    int? currentIndex,
    String? selectedIsoCode,
    int? rightCount,
    int? wrongCount,
    bool? isComplete,
    bool clearSelected = false,
  }) {
    return MCQuizState(
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedIsoCode:
          clearSelected ? null : (selectedIsoCode ?? this.selectedIsoCode),
      rightCount: rightCount ?? this.rightCount,
      wrongCount: wrongCount ?? this.wrongCount,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
