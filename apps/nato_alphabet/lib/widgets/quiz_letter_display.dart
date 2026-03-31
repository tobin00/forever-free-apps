import 'package:flutter/material.dart';

/// Shows the quiz letter prominently. Reveals the NATO word with a fade+slide animation.
class QuizLetterDisplay extends StatefulWidget {
  final String letter;
  final String? natoWord;
  final bool isRevealed;

  const QuizLetterDisplay({
    super.key,
    required this.letter,
    required this.natoWord,
    required this.isRevealed,
  });

  @override
  State<QuizLetterDisplay> createState() => _QuizLetterDisplayState();
}

class _QuizLetterDisplayState extends State<QuizLetterDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.isRevealed) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(QuizLetterDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (widget.isRevealed && !oldWidget.isRevealed) {
      if (reduceMotion) {
        _controller.value = 1.0;
      } else {
        _controller.forward();
      }
    }
    if (!widget.isRevealed) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Large letter
        Semantics(
          label: 'Letter: ${widget.letter}',
          child: Text(
            widget.letter,
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: 96,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Revealed NATO word
        SizedBox(
          height: 56,
          child: widget.isRevealed
              ? FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Text(
                      widget.natoWord ?? '',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 33,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
