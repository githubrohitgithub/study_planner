import 'package:equatable/equatable.dart';
import '../../../domain/entities/subject.dart';

abstract class SubjectEvent extends Equatable {
  const SubjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadSubjects extends SubjectEvent {
  const LoadSubjects();
}

class CreateSubject extends SubjectEvent {
  final Subject subject;

  const CreateSubject(this.subject);

  @override
  List<Object> get props => [subject];
}

class UpdateSubject extends SubjectEvent {
  final Subject subject;

  const UpdateSubject(this.subject);

  @override
  List<Object> get props => [subject];
}

class DeleteSubject extends SubjectEvent {
  final String subjectId;

  const DeleteSubject(this.subjectId);

  @override
  List<Object> get props => [subjectId];
}

class SearchSubjects extends SubjectEvent {
  final String query;

  const SearchSubjects(this.query);

  @override
  List<Object> get props => [query];
}

class UpdateSubjectProgress extends SubjectEvent {
  final String subjectId;
  final double progress;

  const UpdateSubjectProgress(this.subjectId, this.progress);

  @override
  List<Object> get props => [subjectId, progress];
}

class RecordStudyTime extends SubjectEvent {
  final String subjectId;
  final int minutes;

  const RecordStudyTime(this.subjectId, this.minutes);

  @override
  List<Object> get props => [subjectId, minutes];
}

class ClearSearch extends SubjectEvent {
  const ClearSearch();
} 