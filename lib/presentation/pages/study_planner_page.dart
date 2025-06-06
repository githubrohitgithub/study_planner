import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../bloc/subject/subject_bloc.dart';
import '../bloc/subject/subject_event.dart';
import '../bloc/subject/subject_state.dart';
import '../widgets/create_study_plan_dialog.dart';

class StudyPlannerPage extends StatefulWidget {
  const StudyPlannerPage({super.key});

  @override
  State<StudyPlannerPage> createState() => _StudyPlannerPageState();
}

class _StudyPlannerPageState extends State<StudyPlannerPage> {
  @override
  void initState() {
    super.initState();
    // Load subjects for study plan creation
    context.read<SubjectBloc>().add(const LoadSubjects());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              // TODO: Calendar view
            },
          ),
        ],
      ),
      body: BlocBuilder<SubjectBloc, SubjectState>(
        builder: (context, state) {
          if (state is SubjectLoaded && state.subjects.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: AppTheme.spacingM),
                  Text(
                    'No study plans yet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Create subjects first, then build study plans',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: AppTheme.spacingM),
                Text(
                  'Study Planner Page',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: AppTheme.spacingS),
                Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: BlocBuilder<SubjectBloc, SubjectState>(
        builder: (context, state) {
          final hasSubjects = state is SubjectLoaded && state.subjects.isNotEmpty;
          
          return FloatingActionButton(
            onPressed: hasSubjects ? () {
              showDialog(
                context: context,
                builder: (context) => const CreateStudyPlanDialog(),
              );
            } : () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please create subjects first before creating study plans'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            backgroundColor: hasSubjects ? null : Colors.grey,
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
} 