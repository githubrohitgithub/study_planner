import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () {
              // TODO: Date range picker
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Study Time Chart
            _StudyTimeChart(),
            const SizedBox(height: AppTheme.spacingL),
            
            // Performance Stats
            _PerformanceStats(),
            const SizedBox(height: AppTheme.spacingL),
            
            // Subject Progress
            _SubjectProgress(),
            const SizedBox(height: AppTheme.spacingL),
            
            // Review Accuracy
            _ReviewAccuracyChart(),
          ],
        ),
      ),
    );
  }
}

class _StudyTimeChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Study Time This Week',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}h',
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          return Text(
                            days[value.toInt()],
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1.5),
                        FlSpot(1, 2.2),
                        FlSpot(2, 1.8),
                        FlSpot(3, 3.1),
                        FlSpot(4, 2.5),
                        FlSpot(5, 1.9),
                        FlSpot(6, 2.8),
                      ],
                      isCurved: true,
                      color: AppTheme.subjectColors[0],
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.subjectColors[0].withOpacity(0.1),
                      ),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppTheme.subjectColors[0],
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
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

class _PerformanceStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Week\'s Performance',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Study Sessions',
                value: '12',
                subtitle: '+3 from last week',
                icon: Icons.play_circle_outline,
                color: AppTheme.subjectColors[1],
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: _StatCard(
                title: 'Cards Reviewed',
                value: '156',
                subtitle: '+23 from last week',
                icon: Icons.quiz_outlined,
                color: AppTheme.subjectColors[2],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingM),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Accuracy Rate',
                value: '87%',
                subtitle: '+5% from last week',
                icon: Icons.trending_up,
                color: AppTheme.successColor,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: _StatCard(
                title: 'Focus Score',
                value: '4.2/5',
                subtitle: 'Excellent focus',
                icon: Icons.psychology_outlined,
                color: AppTheme.subjectColors[5],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingS,
                    vertical: AppTheme.spacingXS,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  ),
                  child: Icon(Icons.trending_up, color: color, size: 12),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Get actual subject data
    final subjects = [
      {'name': 'Mathematics', 'progress': 0.85, 'color': AppTheme.subjectColors[0]},
      {'name': 'Physics', 'progress': 0.72, 'color': AppTheme.subjectColors[1]},
      {'name': 'Chemistry', 'progress': 0.94, 'color': AppTheme.subjectColors[2]},
      {'name': 'Biology', 'progress': 0.63, 'color': AppTheme.subjectColors[3]},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subject Progress',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            ...subjects.map((subject) => Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
              child: _ProgressItem(
                name: subject['name'] as String,
                progress: subject['progress'] as double,
                color: subject['color'] as Color,
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final String name;
  final double progress;
  final Color color;

  const _ProgressItem({
    required this.name,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingS),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
        ),
      ],
    );
  }
}

class _ReviewAccuracyChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review Accuracy Trend',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          return Text(
                            days[value.toInt()],
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 85, color: AppTheme.subjectColors[1])]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 88, color: AppTheme.subjectColors[1])]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 82, color: AppTheme.subjectColors[1])]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 91, color: AppTheme.subjectColors[1])]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 87, color: AppTheme.subjectColors[1])]),
                    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 84, color: AppTheme.subjectColors[1])]),
                    BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 89, color: AppTheme.subjectColors[1])]),
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