import 'package:uuid/uuid.dart';

import '../../domain/entities/subject.dart';
import '../../domain/repositories/subject_repository.dart';
import '../datasources/database_helper.dart';
import '../models/subject_model.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final DatabaseHelper _databaseHelper;
  final Uuid _uuid = const Uuid();

  SubjectRepositoryImpl(this._databaseHelper);

  @override
  Future<List<Subject>> getAllSubjects() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'subjects',
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => SubjectModel.fromJson(map)).toList();
  }

  @override
  Future<Subject?> getSubjectById(String id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'subjects',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return SubjectModel.fromJson(maps.first);
  }

  @override
  Future<String> createSubject(Subject subject) async {
    final db = await _databaseHelper.database;
    final id = _uuid.v4();
    
    final subjectModel = SubjectModel(
      id: id,
      name: subject.name,
      description: subject.description,
      color: subject.color,
      createdAt: DateTime.now(),
      lastStudied: subject.lastStudied,
      totalStudyTime: subject.totalStudyTime,
      studyStreak: subject.studyStreak,
      progress: subject.progress,
    );

    await db.insert('subjects', subjectModel.toJson());
    return id;
  }

  @override
  Future<void> updateSubject(Subject subject) async {
    final db = await _databaseHelper.database;
    final subjectModel = SubjectModel.fromEntity(subject);

    await db.update(
      'subjects',
      subjectModel.toJson(),
      where: 'id = ?',
      whereArgs: [subject.id],
    );
  }

  @override
  Future<void> deleteSubject(String id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'subjects',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Subject>> searchSubjects(String query) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'subjects',
      where: 'name LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => SubjectModel.fromJson(map)).toList();
  }

  @override
  Future<void> updateSubjectProgress(String subjectId, double progress) async {
    final db = await _databaseHelper.database;
    await db.update(
      'subjects',
      {'progress': progress},
      where: 'id = ?',
      whereArgs: [subjectId],
    );
  }

  @override
  Future<void> recordStudyTime(String subjectId, int minutes) async {
    final db = await _databaseHelper.database;
    
    // Get current subject data
    final subject = await getSubjectById(subjectId);
    if (subject == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastStudiedDay = subject.lastStudied != null
        ? DateTime(subject.lastStudied!.year, subject.lastStudied!.month, subject.lastStudied!.day)
        : null;

    // Calculate new streak
    int newStreak = subject.studyStreak;
    if (lastStudiedDay == null) {
      newStreak = 1;
    } else if (lastStudiedDay.isBefore(today)) {
      final daysDifference = today.difference(lastStudiedDay).inDays;
      if (daysDifference == 1) {
        newStreak = subject.studyStreak + 1;
      } else {
        newStreak = 1; // Reset streak if more than 1 day gap
      }
    }
    // If studied today already, keep current streak

    await db.update(
      'subjects',
      {
        'total_study_time': subject.totalStudyTime + minutes,
        'last_studied': now.toIso8601String(),
        'study_streak': newStreak,
      },
      where: 'id = ?',
      whereArgs: [subjectId],
    );
  }
} 