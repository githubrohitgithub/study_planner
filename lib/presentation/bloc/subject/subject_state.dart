import 'package:equatable/equatable.dart';
import '../../../domain/entities/subject.dart';

abstract class SubjectState extends Equatable {
  const SubjectState();

  @override
  List<Object?> get props => [];
}

class SubjectInitial extends SubjectState {
  const SubjectInitial();
}

class SubjectLoading extends SubjectState {
  const SubjectLoading();
}

class SubjectLoaded extends SubjectState {
  final List<Subject> subjects;
  final bool isSearching;
  final String? searchQuery;

  const SubjectLoaded({
    required this.subjects,
    this.isSearching = false,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [subjects, isSearching, searchQuery];

  SubjectLoaded copyWith({
    List<Subject>? subjects,
    bool? isSearching,
    String? searchQuery,
  }) {
    return SubjectLoaded(
      subjects: subjects ?? this.subjects,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class SubjectOperationInProgress extends SubjectState {
  final List<Subject> subjects;
  final String operation;

  const SubjectOperationInProgress({
    required this.subjects,
    required this.operation,
  });

  @override
  List<Object> get props => [subjects, operation];
}

class SubjectOperationSuccess extends SubjectState {
  final List<Subject> subjects;
  final String message;

  const SubjectOperationSuccess({
    required this.subjects,
    required this.message,
  });

  @override
  List<Object> get props => [subjects, message];
}

class SubjectError extends SubjectState {
  final String message;
  final List<Subject>? subjects;

  const SubjectError({
    required this.message,
    this.subjects,
  });

  @override
  List<Object?> get props => [message, subjects];
} 