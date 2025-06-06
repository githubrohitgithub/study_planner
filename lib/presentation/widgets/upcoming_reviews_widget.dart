import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class UpcomingReviewsWidget extends StatelessWidget {
  const UpcomingReviewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Get actual review data from BLoC
    const dueToday = 5;
    const dueTomorrow = 8;
    const overdueCards = 2;

    return Card(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.subjectColors[8].withOpacity(0.1),
              AppTheme.subjectColors[9].withOpacity(0.1),
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
                    color: AppTheme.subjectColors[8].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  child: Icon(
                    Icons.schedule_outlined,
                    color: AppTheme.subjectColors[8],
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: Text(
                    'Upcoming Reviews',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            if (overdueCards > 0) ...[
              _ReviewItem(
                label: 'Overdue',
                count: overdueCards,
                color: AppTheme.warningColor,
                isUrgent: true,
              ),
              const SizedBox(height: AppTheme.spacingS),
            ],
            _ReviewItem(
              label: 'Due Today',
              count: dueToday,
              color: AppTheme.subjectColors[1],
            ),
            const SizedBox(height: AppTheme.spacingS),
            _ReviewItem(
              label: 'Due Tomorrow',
              count: dueTomorrow,
              color: AppTheme.subjectColors[5],
            ),
            const SizedBox(height: AppTheme.spacingM),
            if (dueToday > 0 || overdueCards > 0)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to review session
                  },
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: Text(
                    overdueCards > 0 ? 'Review Overdue Cards' : 'Start Review',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: overdueCards > 0 
                        ? AppTheme.warningColor 
                        : AppTheme.subjectColors[1],
                    foregroundColor: Colors.white,
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  border: Border.all(
                    color: AppTheme.successColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppTheme.successColor,
                      size: 20,
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Expanded(
                      child: Text(
                        'All caught up! 🎉',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final bool isUrgent;

  const _ReviewItem({
    required this.label,
    required this.count,
    required this.color,
    this.isUrgent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppTheme.spacingS),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: isUrgent ? color : null,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingS,
            vertical: AppTheme.spacingXS,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
          ),
          child: Text(
            count.toString(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
} 