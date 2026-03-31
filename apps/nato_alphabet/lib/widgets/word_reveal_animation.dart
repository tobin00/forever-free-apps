import 'package:flutter/material.dart';

/// Vertically stacked letter rows that animate in one-by-one when [isRevealed] becomes true.
/// Use [key: ValueKey(word)] in the parent so state resets when the word changes.
class WordRevealAnimation extends StatefulWidget {
  final String word;
  final bool isRevealed;
  final Map<String, String> natoLookup;

  const WordRevealAnimation({
    super.key,
    required this.word,
    required this.isRevealed,
    required this.natoLookup,
  });

  @override
  State<WordRevealAnimation> createState() => _WordRevealAnimationState();
}

class _WordRevealAnimationState extends State<WordRevealAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fades;
  late List<Animation<Offset>> _slides;

  @override
  void initState() {
    super.initState();
    _buildAnimations();
    if (widget.isRevealed) {
      for (final c in _controllers) {
        c.value = 1.0;
      }
    }
  }

  void _buildAnimations() {
    final count = widget.word.length;
    _controllers = List.generate(
      count,
      (_) => AnimationController(
        duration: const Duration(milliseconds: 250),
        vsync: this,
      ),
    );
    _fades = _controllers
        .map((c) => Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: c, curve: Curves.easeOut),
            ))
        .toList();
    _slides = _controllers
        .map((c) => Tween<Offset>(
              begin: const Offset(0.15, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();
  }

  @override
  void didUpdateWidget(WordRevealAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRevealed && !oldWidget.isRevealed) {
      _playReveal();
    }
  }

  void _playReveal() {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    for (int i = 0; i < _controllers.length; i++) {
      if (reduceMotion) {
        _controllers[i].value = 1.0;
      } else {
        Future.delayed(Duration(milliseconds: i * 50), () {
          if (mounted) _controllers[i].forward();
        });
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isRevealed) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final letters = widget.word.split('');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(letters.length, (i) {
        final letter = letters[i];
        final natoWord = widget.natoLookup[letter] ?? letter;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: FadeTransition(
            opacity: _fades[i],
            child: SlideTransition(
              position: _slides[i],
              child: Semantics(
                label: '$letter: $natoWord',
                child: Row(
                  children: [
                    SizedBox(
                      width: 44,
                      child: Text(
                        letter,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 24,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '— $natoWord',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
