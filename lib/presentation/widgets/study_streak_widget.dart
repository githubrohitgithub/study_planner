import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class StudyStreakWidget extends StatelessWidget {
  const StudyStreakWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Get actual streak data from BLoC
    const currentStreak = 7;
    const longestStreak = 23;

    return Card(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.subjectColors[0].withOpacity(0.1),
              AppTheme.subjectColors[1].withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingS),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    color: AppTheme.successColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Study Streak',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Keep the momentum going! 🔥',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingL),
            Row(
              children: [
                Expanded(
                  child: _StreakStat(
                    label: 'Current Streak',
                    value: '$currentStreak days',
                    color: AppTheme.successColor,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: _StreakStat(
                    label: 'Longest Streak',
                    value: '$longestStreak days',
                    color: AppTheme.subjectColors[3],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            _StreakCalendar(),
          ],
        ),
      ),
    );
  }
}

class _StreakStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StreakStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StreakCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual study history data
    final studyDays = [true, true, false, true, true, true, true];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Week',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (index) {
            final dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
            final hasStudied = studyDays[index];
            
            return Column(
              children: [
                Text(
                  dayLabels[index],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: hasStudied 
                        ? AppTheme.successColor 
                        : Theme.of(context).colorScheme.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: hasStudied
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        )
                      : null,
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
} 