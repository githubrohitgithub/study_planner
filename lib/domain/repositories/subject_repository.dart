import '../entities/subject.dart';

abstract class SubjectRepository {
  Future<List<Subject>> getAllSubjects();
  Future<Subject?> getSubjectById(String id);
  Future<String> createSubject(Subject subject);
  Future<void> updateSubject(Subject subject);
  Future<void> deleteSubject(String id);
  Future<List<Subject>> searchSubjects(String query);
  Future<void> updateSubjectProgress(String subjectId, double progress);
  Future<void> recordStudyTime(String subjectId, int minutes);
} 