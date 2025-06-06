import 'package:equatable/equatable.dart';

enum StudyPlanStatus {
  active,
  completed,
  paused,
  overdue,
}

enum StudyPlanPriority {
  low,
  medium,
  high,
  urgent,
}

class StudyPlan extends Equatable {
  final String id;
  final String subjectId;
  final String title;
  final String? description;
  final DateTime startDate;
  final DateTime dueDate;
  final StudyPlanStatus status;
  final StudyPlanPriority priority;
  final int estimatedDuration; // in minutes
  final int actualDuration; // in minutes
  final List<String> tasks;
  final List<String> completedTasks;
  final DateTime createdAt;
  final DateTime? completedAt;

  const StudyPlan({
    required this.id,
    required this.subjectId,
    required this.title,
    this.description,
    required this.startDate,
    required this.dueDate,
    this.status = StudyPlanStatus.active,
    this.priority = StudyPlanPriority.medium,
    this.estimatedDuration = 60,
    this.actualDuration = 0,
    this.tasks = const [],
    this.completedTasks = const [],
    required this.createdAt,
    this.completedAt,
  });

  StudyPlan copyWith({
    String? id,
    String? subjectId,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? dueDate,
    StudyPlanStatus? status,
    StudyPlanPriority? priority,
    int? estimatedDuration,
    int? actualDuration,
    List<String>? tasks,
    List<String>? completedTasks,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return StudyPlan(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      tasks: tasks ?? this.tasks,
      completedTasks: completedTasks ?? this.completedTasks,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  double get progressPercentage {
    if (tasks.isEmpty) return 0.0;
    return completedTasks.length / tasks.length;
  }

  bool get isOverdue {
    return DateTime.now().isAfter(dueDate) && status != StudyPlanStatus.completed;
  }

  bool get isDueToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return today.isAtSameMomentAs(due);
  }

  int get remainingTasks => tasks.length - completedTasks.length;

  @override
  List<Object?> get props => [
        id,
        subjectId,
        title,
        description,
        startDate,
        dueDate,
        status,
        priority,
        estimatedDuration,
        actualDuration,
        tasks,
        completedTasks,
        createdAt,
        completedAt,
      ];
} 