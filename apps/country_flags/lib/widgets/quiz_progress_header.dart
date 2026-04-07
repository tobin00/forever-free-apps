import 'package:flutter/material.dart';
import 'package:shared_app_core/shared_app_core.dart';

/// Top bar used by all quiz screens: quit button, progress bar, score counters.
class QuizProgressHeader extends StatelessWidget {
  final int currentIndex;
  final int total;
  final int rightCount;
  final int wrongCount;
  final VoidCallback onQuit;

  const QuizProgressHeader({
    super.key,
    required this.currentIndex,
    required this.total,
    required this.rightCount,
    required this.wrongCount,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = total > 0 ? (currentIndex / total).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.close,
              color:
                  isDark ? AppColors.onBackgroundDark : AppColors.onBackground,
            ),
            tooltip: 'Return to menu',
            onPressed: onQuit,
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor:
                    isDark ? AppColors.dividerDark : AppColors.divider,
                color: isDark ? AppColors.primaryDark : AppColors.primary,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _ScoreBadge(
            count: rightCount,
            color: AppColors.success,
            icon: Icons.check,
          ),
          const SizedBox(width: 8),
          _ScoreBadge(
            count: wrongCount,
            color: AppColors.error,
            icon: Icons.close,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final int count;
  final Color color;
  final IconData icon;

  const _ScoreBadge({
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 2),
        Text(
          '$count',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
