import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/study_plan.dart';
import '../../domain/entities/subject.dart';
import '../bloc/subject/subject_bloc.dart';
import '../bloc/subject/subject_state.dart';

class CreateStudyPlanDialog extends StatefulWidget {
  const CreateStudyPlanDialog({super.key});

  @override
  State<CreateStudyPlanDialog> createState() => _CreateStudyPlanDialogState();
}

class _CreateStudyPlanDialogState extends State<CreateStudyPlanDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _studyTimeController = TextEditingController();
  
  List<String> _selectedSubjectIds = [];
  List<Subject> _subjects = [];
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  StudyPlanPriority _priority = StudyPlanPriority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _studyTimeController.dispose();
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
          title: const Text('Create Study Plan'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Plan Title',
                      hintText: 'e.g., Final Exam Preparation',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a plan title';
                      }
                      if (value.trim().length < 2) {
                        return 'Title must be at least 2 characters';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      hintText: 'Brief description of your study plan',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  if (_subjects.isNotEmpty) ...[
                    Text(
                      'Select Subjects',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _subjects.map((subject) {
                          final isSelected = _selectedSubjectIds.contains(subject.id);
                          return CheckboxListTile(
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _selectedSubjectIds.add(subject.id);
                                } else {
                                  _selectedSubjectIds.remove(subject.id);
                                }
                              });
                            },
                            title: Row(
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
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _studyTimeController,
                          decoration: const InputDecoration(
                            labelText: 'Daily Study Time',
                            hintText: '60',
                            suffixText: 'minutes',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter study time';
                            }
                            final minutes = int.tryParse(value);
                            if (minutes == null || minutes <= 0) {
                              return 'Please enter a valid number';
                            }
                            if (minutes > 480) {
                              return 'Maximum 8 hours (480 minutes)';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: DropdownButtonFormField<StudyPlanPriority>(
                          value: _priority,
                          decoration: const InputDecoration(
                            labelText: 'Priority',
                            border: OutlineInputBorder(),
                          ),
                          items: StudyPlanPriority.values.map((priority) {
                            return DropdownMenuItem<StudyPlanPriority>(
                              value: priority,
                              child: Text(_priorityName(priority)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _priority = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: AppTheme.spacingS),
                            OutlinedButton.icon(
                              onPressed: () => _selectDate(context, true),
                              icon: const Icon(Icons.calendar_today),
                              label: Text(
                                '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End Date',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: AppTheme.spacingS),
                            OutlinedButton.icon(
                              onPressed: () => _selectDate(context, false),
                              icon: const Icon(Icons.calendar_today),
                              label: Text(
                                '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
              onPressed: _createStudyPlan,
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  String _priorityName(StudyPlanPriority priority) {
    switch (priority) {
      case StudyPlanPriority.low:
        return 'Low';
      case StudyPlanPriority.medium:
        return 'Medium';
      case StudyPlanPriority.high:
        return 'High';
      case StudyPlanPriority.urgent:
        return 'Urgent';
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        if (isStartDate) {
          _startDate = date;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 30));
          }
        } else {
          _endDate = date;
        }
      });
    }
  }

  void _createStudyPlan() {
    if (_formKey.currentState!.validate()) {
      if (_selectedSubjectIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one subject'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      if (_endDate.isBefore(_startDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End date must be after start date'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Create a study plan for the first selected subject
      // TODO: Support multiple subjects in future versions
      final studyPlan = StudyPlan(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        subjectId: _selectedSubjectIds.first,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        startDate: _startDate,
        dueDate: _endDate,
        estimatedDuration: int.parse(_studyTimeController.text),
        priority: _priority,
        createdAt: DateTime.now(),
      );

      // TODO: Add study plan creation logic through BLoC
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Study plan created successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  int _calculateTotalSessions() {
    final daysDifference = _endDate.difference(_startDate).inDays + 1;
    return daysDifference;
  }
} 