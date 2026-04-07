import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_app_core/shared_app_core.dart';

import '../data/countries.dart';
import '../models/custom_quiz_config.dart';
import '../providers/multiple_choice_quiz_provider.dart';

class CustomQuizConfigScreen extends ConsumerStatefulWidget {
  const CustomQuizConfigScreen({super.key});

  @override
  ConsumerState<CustomQuizConfigScreen> createState() =>
      _CustomQuizConfigScreenState();
}

class _CustomQuizConfigScreenState
    extends ConsumerState<CustomQuizConfigScreen> {
  late CustomQuizConfig _config;

  static const _regions = [
    'Africa',
    'Americas',
    'Asia',
    'Europe',
    'Oceania',
  ];

  @override
  void initState() {
    super.initState();
    _config = ref.read(customQuizConfigProvider);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Effective pool size for showing question count options
    final poolSize = _config.region != null
        ? CountriesData.byRegion(_config.region!).length
        : CountriesData.all.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Custom Quiz')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Loop Forever ────────────────────────────────────────────────
          _SectionCard(
            title: 'Loop Forever',
            child: SwitchListTile.adaptive(
              value: _config.loopForever,
              onChanged: (v) =>
                  setState(() => _config = _config.copyWith(loopForever: v)),
              title: const Text('Never-ending quiz'),
              subtitle:
                  const Text('Reshuffles after each round — use X to stop'),
              activeThumbColor:
                  isDark ? AppColors.primaryDark : AppColors.primary,
              activeTrackColor: (isDark
                      ? AppColors.primaryDark
                      : AppColors.primary)
                  .withValues(alpha: 0.4),
              contentPadding: EdgeInsets.zero,
            ),
          ),

          const SizedBox(height: 12),

          // ── Quiz Direction ───────────────────────────────────────────────
          _SectionCard(
            title: 'Quiz Direction',
            child: SegmentedButton<QuizDirection>(
              segments: const [
                ButtonSegment(
                  value: QuizDirection.flagToName,
                  icon: Icon(Icons.flag_outlined, size: 18),
                  label: Text('Flag→Name'),
                ),
                ButtonSegment(
                  value: QuizDirection.nameToFlag,
                  icon: Icon(Icons.abc, size: 18),
                  label: Text('Name→Flag'),
                ),
                ButtonSegment(
                  value: QuizDirection.random,
                  icon: Icon(Icons.shuffle, size: 18),
                  label: Text('Mixed'),
                ),
              ],
              selected: {_config.direction},
              onSelectionChanged: (s) =>
                  setState(() => _config = _config.copyWith(direction: s.first)),
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor:
                    isDark ? AppColors.primaryDark : AppColors.primary,
                selectedForegroundColor: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── Question Count ───────────────────────────────────────────────
          _SectionCard(
            title: 'Number of Questions',
            child: Wrap(
              spacing: 8,
              children: [20, 50, 100, null].map((count) {
                // Clamp label: show "All (N)" for null
                final label = count == null ? 'All ($poolSize)' : '$count';
                final effectiveCount = count;
                final selected = _config.countryCount == effectiveCount;
                return FilterChip(
                  label: Text(label),
                  selected: selected,
                  onSelected: (_) => setState(() => _config = _config.copyWith(
                        countryCount: effectiveCount,
                        clearCountryCount: effectiveCount == null,
                      )),
                  selectedColor: (isDark
                          ? AppColors.primaryDark
                          : AppColors.primary)
                      .withValues(alpha: 0.15),
                  checkmarkColor:
                      isDark ? AppColors.primaryDark : AppColors.primary,
                  labelStyle: TextStyle(
                    color: selected
                        ? (isDark ? AppColors.primaryDark : AppColors.primary)
                        : null,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  showCheckmark: true,
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // ── Region Filter ─────────────────────────────────────────────────
          _SectionCard(
            title: 'Region',
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [null, ..._regions].map((region) {
                final count = region == null
                    ? CountriesData.all.length
                    : CountriesData.byRegion(region).length;
                final label = region ?? 'All Regions';
                final selected = _config.region == region;
                return FilterChip(
                  label: Text('$label ($count)'),
                  selected: selected,
                  onSelected: (_) => setState(() => _config = _config.copyWith(
                        region: region,
                        clearRegion: region == null,
                      )),
                  selectedColor: (isDark
                          ? AppColors.primaryDark
                          : AppColors.primary)
                      .withValues(alpha: 0.15),
                  checkmarkColor:
                      isDark ? AppColors.primaryDark : AppColors.primary,
                  labelStyle: TextStyle(
                    color: selected
                        ? (isDark ? AppColors.primaryDark : AppColors.primary)
                        : null,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  showCheckmark: true,
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 32),

          // ── Start button ──────────────────────────────────────────────────
          FilledButton(
            onPressed: _startQuiz,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              backgroundColor:
                  isDark ? AppColors.primaryDark : AppColors.primary,
            ),
            child: const Text('Start Quiz'),
          ),
        ],
      ),
    );
  }

  void _startQuiz() {
    ref.read(customQuizConfigProvider.notifier).update(_config);
    ref.invalidate(customQuizProvider);
    context.go('/custom-quiz', extra: _config);
  }
}

// ── Section card ──────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: isDark ? Border.all(color: AppColors.dividerDark) : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.onBackgroundSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
