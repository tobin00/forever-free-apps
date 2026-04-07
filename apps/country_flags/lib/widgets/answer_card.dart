import 'package:flutter/material.dart';
import 'package:shared_app_core/shared_app_core.dart';

import '../models/country.dart';
import 'flag_widget.dart';

enum AnswerCardStatus {
  idle,
  selectedCorrect,
  selectedWrong,
  revealedCorrect,
}

/// One answer option in a multiple-choice quiz question.
///
/// [showFlag] — if true, shows the country's flag; otherwise shows the name.
/// [revealName] — if true and [showFlag] is true, shows the country name below
///   the flag (used after answering a name→flag question so the user can learn).
class AnswerCard extends StatelessWidget {
  final Country country;
  final bool showFlag;
  final bool revealName;
  final AnswerCardStatus status;
  final VoidCallback? onTap;

  const AnswerCard({
    super.key,
    required this.country,
    required this.showFlag,
    this.revealName = false,
    this.status = AnswerCardStatus.idle,
    this.onTap,
  });

  Color _bgColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return switch (status) {
      AnswerCardStatus.idle =>
        isDark ? const Color(0xFF1E3045) : const Color(0xFFE8F4FD),
      AnswerCardStatus.selectedCorrect =>
        isDark ? const Color(0xFF1B5E20) : const Color(0xFF388E3C),
      AnswerCardStatus.selectedWrong =>
        isDark ? const Color(0xFF7F0000) : const Color(0xFFD32F2F),
      AnswerCardStatus.revealedCorrect =>
        isDark ? const Color(0xFF1B5E20) : const Color(0xFF388E3C),
    };
  }

  Color _textColor(BuildContext context) {
    return switch (status) {
      AnswerCardStatus.idle => Theme.of(context).brightness == Brightness.dark
          ? AppColors.onBackgroundDark
          : AppColors.onBackground,
      _ => Colors.white,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _bgColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showFlag)
                  FlagWidget(
                    isoCode: country.isoCode,
                    height: 52,
                    borderRadius: 6,
                  )
                else
                  Text(
                    country.name,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _textColor(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (showFlag && revealName) ...[
                  const SizedBox(height: 4),
                  Text(
                    country.name,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _textColor(context),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
