import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/entities/subject.dart';
import '../bloc/subject/subject_bloc.dart';
import '../bloc/subject/subject_state.dart';

class CreateFlashcardDialog extends StatefulWidget {
  final String? preselectedSubjectId;

  const CreateFlashcardDialog({
    super.key,
    this.preselectedSubjectId,
  });

  @override
  State<CreateFlashcardDialog> createState() => _CreateFlashcardDialogState();
}

class _CreateFlashcardDialogState extends State<CreateFlashcardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _frontController = TextEditingController();
  final _backController = TextEditingController();
  String? _selectedSubjectId;
  List<Subject> _subjects = [];

  @override
  void initState() {
    super.initState();
    _selectedSubjectId = widget.preselectedSubjectId;
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectBloc, SubjectState>(
      builder: (context, state) {
        if (state is SubjectLoaded) {
          _subjects = state.subjects;
        }

        return AlertDialog(
          title: const Text('Create New Flashcard'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_subjects.isNotEmpty) ...[
                    Text(
                      'Subject',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    DropdownButtonFormField<String>(
                      value: _selectedSubjectId,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Select a subject',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a subject';
                        }
                        return null;
                      },
                      items: _subjects.map((subject) {
                        return DropdownMenuItem<String>(
                          value: subject.id,
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: subject.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: AppTheme.spacingS),
                              Expanded(child: Text(subject.name)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSubjectId = value;
                        });
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_outlined,
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Expanded(
                            child: Text(
                              'No subjects found. Please create a subject first.',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                  ],
                  TextFormField(
                    controller: _frontController,
                    decoration: const InputDecoration(
                      labelText: 'Front Side',
                      hintText: 'Enter the question or term',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the front side content';
                      }
                      if (value.trim().length < 2) {
                        return 'Front side must be at least 2 characters';
                      }
                      return null;
                    },
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  TextFormField(
                    controller: _backController,
                    decoration: const InputDecoration(
                      labelText: 'Back Side',
                      hintText: 'Enter the answer or definition',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the back side content';
                      }
                      if (value.trim().length < 2) {
                        return 'Back side must be at least 2 characters';
                      }
                      return null;
                    },
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: _subjects.isEmpty ? null : _createFlashcard,
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _createFlashcard() {
    if (_formKey.currentState!.validate()) {
      final flashcard = Flashcard(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        subjectId: _selectedSubjectId!,
        question: _frontController.text.trim(),
        answer: _backController.text.trim(),
        createdAt: DateTime.now(),
        nextReview: DateTime.now().add(const Duration(days: 1)),
        difficulty: DifficultyLevel.medium,
      );

      // TODO: Add flashcard creation logic through BLoC
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Flashcard created successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
} 