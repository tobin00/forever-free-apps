import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_app_core/shared_app_core.dart';

import '../providers/typing_quiz_provider.dart';
import '../widgets/flag_widget.dart';
import '../widgets/quiz_progress_header.dart';

class TypingQuizScreen extends ConsumerStatefulWidget {
  const TypingQuizScreen({super.key});

  @override
  ConsumerState<TypingQuizScreen> createState() => _TypingQuizScreenState();
}

class _TypingQuizScreenState extends ConsumerState<TypingQuizScreen>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _submit() {
    final input = _controller.text;
    if (input.trim().isEmpty) return;
    ref.read(typingQuizProvider.notifier).submit(input);
    final status = ref.read(typingQuizProvider).status;
    if (status == TypingAnswerStatus.soClose ||
        status == TypingAnswerStatus.wrong) {
      _shakeController.forward(from: 0);
    }
  }

  void _next() {
    _controller.clear();
    ref.read(typingQuizProvider.notifier).next();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(typingQuizProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ref.listen<TypingQuizState>(typingQuizProvider, (_, next) {
      if (next.isComplete) {
        context.go('/quiz-results', extra: {
          'right': next.rightCount,
          'wrong': next.wrongCount,
        });
      }
    });

    if (state.isComplete) return const SizedBox.shrink();

    final country = state.currentCountry;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            QuizProgressHeader(
              currentIndex: state.currentIndex,
              total: state.total,
              rightCount: state.rightCount,
              wrongCount: state.wrongCount,
              onQuit: () => context.go('/'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Column(
                  children: [
                    // ── Flag (with shake animation on wrong) ──────────────
                    AnimatedBuilder(
                      animation: _shakeAnim,
                      builder: (context, child) {
                        final t = _shakeAnim.value;
                        final offset = 12 *
                            math.sin(t * math.pi * 6) *
                            math.max(0, 1 - t);
                        return Transform.translate(
                          offset: Offset(offset, 0),
                          child: child,
                        );
                      },
                      child: Container(
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
                          isoCode: country.isoCode,
                          height: 160,
                          borderRadius: 12,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Text input ────────────────────────────────────────
                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      enabled: !state.isAnswered,
                      onSubmitted: (_) {
                        if (!state.isAnswered) _submit();
                      },
                      decoration: InputDecoration(
                        hintText: 'Type the country name…',
                        filled: true,
                        fillColor:
                            isDark ? AppColors.surfaceDark : AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark
                                ? AppColors.dividerDark
                                : AppColors.divider,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark
                                ? AppColors.primaryDark
                                : AppColors.primary,
                            width: 2,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark
                                ? AppColors.dividerDark
                                : AppColors.divider,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Feedback banner ───────────────────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: state.isAnswered
                          ? _FeedbackBanner(
                              key: ValueKey(state.currentIndex),
                              status: state.status,
                              countryName: country.name,
                              isDark: isDark,
                            )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 16),

                    // ── Action button ─────────────────────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: state.isAnswered
                          ? FilledButton(
                              key: const ValueKey('next'),
                              onPressed: _next,
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
                            )
                          : FilledButton(
                              key: const ValueKey('submit'),
                              onPressed: _submit,
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                backgroundColor: isDark
                                    ? AppColors.primaryDark
                                    : AppColors.primary,
                              ),
                              child: const Text('Submit'),
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
}

// ── Feedback banner ───────────────────────────────────────────────────────────

class _FeedbackBanner extends StatelessWidget {
  final TypingAnswerStatus status;
  final String countryName;
  final bool isDark;

  const _FeedbackBanner({
    super.key,
    required this.status,
    required this.countryName,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return switch (status) {
      TypingAnswerStatus.correct => _banner(
          context: context,
          icon: Icons.check_circle_outline,
          iconColor: AppColors.success,
          bg: isDark ? const Color(0xFF1B5E20) : const Color(0xFFE8F5E9),
          title: 'Correct!',
          titleColor: AppColors.success,
          theme: theme,
        ),
      TypingAnswerStatus.soClose => _banner(
          context: context,
          icon: Icons.tips_and_updates_outlined,
          iconColor: const Color(0xFFF57C00),
          bg: isDark ? const Color(0xFF7E3500) : const Color(0xFFFFF3E0),
          title: 'So Close!',
          titleColor: const Color(0xFFF57C00),
          subtitle: 'The answer is: $countryName',
          theme: theme,
        ),
      TypingAnswerStatus.wrong => _banner(
          context: context,
          icon: Icons.cancel_outlined,
          iconColor: AppColors.error,
          bg: isDark ? const Color(0xFF7F0000) : const Color(0xFFFFEBEE),
          title: 'Not quite',
          titleColor: AppColors.error,
          subtitle: 'The answer is: $countryName',
          theme: theme,
        ),
      TypingAnswerStatus.unanswered => const SizedBox.shrink(),
    };
  }

  Widget _banner({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color bg,
    required String title,
    required Color titleColor,
    String? subtitle,
    required ThemeData theme,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.onBackgroundDark
                          : AppColors.onBackground,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
