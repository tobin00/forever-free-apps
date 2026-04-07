import 'package:flutter/material.dart';
import 'package:shared_app_core/shared_app_core.dart';

import '../models/country.dart';
import '../models/mc_quiz_state.dart';
import '../models/quiz_question.dart';
import 'answer_card.dart';
import 'flag_widget.dart';
import 'quiz_progress_header.dart';

/// Shared body widget for all multiple-choice quiz modes
/// (Multiple Choice, Mistakes, Tricky Flags, Custom).
///
/// Callers supply the state and callbacks; this widget owns no state.
class MCQuizBody extends StatelessWidget {
  final MCQuizState state;
  final void Function(String isoCode) onAnswer;
  final VoidCallback onNext;
  final VoidCallback onQuit;

  const MCQuizBody({
    super.key,
    required this.state,
    required this.onAnswer,
    required this.onNext,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    final question = state.currentQuestion;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Progress header ────────────────────────────────────────────
            QuizProgressHeader(
              currentIndex: state.currentIndex,
              total: state.total,
              rightCount: state.rightCount,
              wrongCount: state.wrongCount,
              onQuit: onQuit,
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: Column(
                  children: [
                    // ── Question (flag or name) ───────────────────────────
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: question.isFlagToName
                            ? _FlagQuestion(question: question)
                            : _NameQuestion(
                                question: question,
                                isDark: isDark,
                              ),
                      ),
                    ),

                    // ── Answer grid (2 × 2) ──────────────────────────────
                    Expanded(
                      flex: 7,
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        children: question.options.map((country) {
                          return AnswerCard(
                            country: country,
                            showFlag: !question.isFlagToName,
                            revealName:
                                state.isAnswered && !question.isFlagToName,
                            status: _cardStatus(state, country),
                            onTap: state.isAnswered
                                ? null
                                : () => onAnswer(country.isoCode),
                          );
                        }).toList(),
                      ),
                    ),

                    // ── Next button ────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24, top: 4),
                      child: FilledButton(
                        onPressed: state.isAnswered ? onNext : null,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          backgroundColor: isDark
                              ? AppColors.primaryDark
                              : AppColors.primary,
                        ),
                        child: const Text('Next'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnswerCardStatus _cardStatus(MCQuizState state, Country country) {
    if (!state.isAnswered) return AnswerCardStatus.idle;
    final isCorrect =
        country.isoCode == state.currentQuestion.correct.isoCode;
    final isSelected = country.isoCode == state.selectedIsoCode;
    if (isSelected && isCorrect) return AnswerCardStatus.selectedCorrect;
    if (isSelected && !isCorrect) return AnswerCardStatus.selectedWrong;
    if (!isSelected && isCorrect) return AnswerCardStatus.revealedCorrect;
    return AnswerCardStatus.idle;
  }
}

// ── Question sub-widgets ──────────────────────────────────────────────────────

class _FlagQuestion extends StatelessWidget {
  final QuizQuestion question;
  const _FlagQuestion({required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FlagWidget(
        isoCode: question.correct.isoCode,
        height: 160,
        borderRadius: 12,
      ),
    );
  }
}

class _NameQuestion extends StatelessWidget {
  final QuizQuestion question;
  final bool isDark;
  const _NameQuestion({required this.question, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Which flag belongs to',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.onBackgroundSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question.correct.name,
            textAlign: TextAlign.center,
            style: theme.textTheme.displaySmall?.copyWith(
              color: isDark
                  ? AppColors.onBackgroundDark
                  : AppColors.onBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
