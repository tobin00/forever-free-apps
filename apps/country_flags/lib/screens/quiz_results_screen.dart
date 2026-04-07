import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_app_core/shared_app_core.dart';

class QuizResultsScreen extends StatelessWidget {
  final int rightCount;
  final int wrongCount;

  const QuizResultsScreen({
    super.key,
    required this.rightCount,
    required this.wrongCount,
  });

  @override
  Widget build(BuildContext context) {
    final total = rightCount + wrongCount;
    final pct = total > 0 ? (rightCount / total * 100).round() : 0;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final emoji = pct >= 90
        ? '🎉'
        : pct >= 70
            ? '😊'
            : pct >= 50
                ? '😐'
                : '😅';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 72)),
                const SizedBox(height: 16),
                Text(
                  '$pct%',
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: isDark ? AppColors.primaryDark : AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  total == 1 ? '1 question' : '$total questions',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.onBackgroundSecondary,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StatBox(
                      icon: Icons.check_circle_outline,
                      count: rightCount,
                      label: 'Correct',
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 32),
                    _StatBox(
                      icon: Icons.cancel_outlined,
                      count: wrongCount,
                      label: 'Wrong',
                      color: AppColors.error,
                    ),
                  ],
                ),
                const SizedBox(height: 56),
                FilledButton(
                  onPressed: () => context.go('/'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(240, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    backgroundColor:
                        isDark ? AppColors.primaryDark : AppColors.primary,
                  ),
                  child: const Text('Back to Main Menu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  final Color color;

  const _StatBox({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: color, size: 36),
        ),
        const SizedBox(height: 10),
        Text(
          '$count',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.onBackgroundSecondary,
          ),
        ),
      ],
    );
  }
}
