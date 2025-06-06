import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../bloc/subject/subject_bloc.dart';
import '../bloc/subject/subject_event.dart';
import '../bloc/subject/subject_state.dart';
import '../widgets/create_subject_dialog.dart';
import '../widgets/create_flashcard_dialog.dart';
import '../widgets/create_study_plan_dialog.dart';
import '../widgets/study_streak_widget.dart';
import '../widgets/upcoming_reviews_widget.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/dashboard_card.dart';
import 'analytics_page.dart';
import 'subjects_page.dart';
import 'flashcards_page.dart';
import 'study_planner_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _DashboardView(),
    const SubjectsPage(),
    const FlashcardsPage(),
    const StudyPlannerPage(),
    const AnalyticsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.subject_outlined),
            selectedIcon: Icon(Icons.subject),
            label: 'Subjects',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz),
            label: 'Flashcards',
          ),
          NavigationDestination(
            icon: Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.schedule),
            label: 'Planner',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView({super.key});

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  @override
  void initState() {
    super.initState();
    // Load subjects when dashboard initializes
    context.read<SubjectBloc>().add(const LoadSubjects());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning! 👋',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Ready to learn something new?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Study Streak Section
            const StudyStreakWidget(),
            const SizedBox(height: AppTheme.spacingL),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  QuickActionButton(
                    icon: Icons.add_circle_outline,
                    label: 'New Subject',
                    color: AppTheme.subjectColors[0],
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const CreateSubjectDialog(),
                      );
                    },
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  QuickActionButton(
                    icon: Icons.quiz_outlined,
                    label: 'Study Now',
                    color: AppTheme.subjectColors[1],
                    onTap: () {
                      // TODO: Start study session
                    },
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  QuickActionButton(
                    icon: Icons.add_card_outlined,
                    label: 'Add Cards',
                    color: AppTheme.subjectColors[2],
                    onTap: () {
                      // Check if subjects exist before showing flashcard dialog
                      final subjectBloc = context.read<SubjectBloc>();
                      final state = subjectBloc.state;
                      
                      if (state is SubjectLoaded && state.subjects.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => const CreateFlashcardDialog(),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please create a subject first before adding flashcards'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  QuickActionButton(
                    icon: Icons.schedule_outlined,
                    label: 'Plan Study',
                    color: AppTheme.subjectColors[3],
                    onTap: () {
                      // Check if subjects exist before showing study plan dialog
                      final subjectBloc = context.read<SubjectBloc>();
                      final state = subjectBloc.state;
                      
                      if (state is SubjectLoaded && state.subjects.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => const CreateStudyPlanDialog(),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please create subjects first before creating study plans'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            
            // Dashboard Cards
            StaggeredGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: AppTheme.spacingM,
              crossAxisSpacing: AppTheme.spacingM,
              children: [
                StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 1,
                  child: DashboardCard(
                    title: 'Today\'s Reviews',
                    subtitle: '5 cards due',
                    icon: Icons.today_outlined,
                    color: AppTheme.subjectColors[4],
                    onTap: () {
                      // TODO: Navigate to today's reviews
                    },
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: DashboardCard(
                    title: 'Total Cards',
                    subtitle: '124',
                    icon: Icons.quiz_outlined,
                    color: AppTheme.subjectColors[5],
                    onTap: () {
                      // TODO: Navigate to all flashcards
                    },
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: DashboardCard(
                    title: 'Study Time',
                    subtitle: '2.5h today',
                    icon: Icons.timer_outlined,
                    color: AppTheme.subjectColors[6],
                    onTap: () {
                      // TODO: Navigate to study analytics
                    },
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 1,
                  child: const UpcomingReviewsWidget(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 