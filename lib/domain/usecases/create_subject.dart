import '../entities/subject.dart';
import '../repositories/subject_repository.dart';

class CreateSubject {
  final SubjectRepository repository;

  CreateSubject(this.repository);

  Future<String> call(Subject subject) async {
    // Validate subject data
    if (subject.name.trim().isEmpty) {
      throw ArgumentError('Subject name cannot be empty');
    }

    if (subject.description.trim().isEmpty) {
      throw ArgumentError('Subject description cannot be empty');
    }

    return await repository.createSubject(subject);
  }
} 