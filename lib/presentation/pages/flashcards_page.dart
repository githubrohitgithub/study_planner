import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../bloc/subject/subject_bloc.dart';
import '../bloc/subject/subject_event.dart';
import '../bloc/subject/subject_state.dart';
import '../widgets/create_flashcard_dialog.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  @override
  void initState() {
    super.initState();
    // Load subjects for flashcard creation
    context.read<SubjectBloc>().add(const LoadSubjects());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filters
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
                    Icons.quiz_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: AppTheme.spacingM),
                  Text(
                    'No flashcards yet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Create a subject first, then add flashcards',
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
                  Icons.quiz_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: AppTheme.spacingM),
                Text(
                  'Flashcards Page',
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
                builder: (context) => const CreateFlashcardDialog(),
              );
            } : () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please create a subject first before adding flashcards'),
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