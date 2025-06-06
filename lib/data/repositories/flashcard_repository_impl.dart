import 'package:uuid/uuid.dart';

import '../../core/utils/spaced_repetition.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../datasources/database_helper.dart';
import '../models/flashcard_model.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  final DatabaseHelper _databaseHelper;
  final Uuid _uuid = const Uuid();

  FlashcardRepositoryImpl(this._databaseHelper);

  @override
  Future<List<Flashcard>> getAllFlashcards() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'flashcards',
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => FlashcardModel.fromJson(map)).toList();
  }

  @override
  Future<List<Flashcard>> getFlashcardsBySubject(String subjectId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'flashcards',
      where: 'subject_id = ?',
      whereArgs: [subjectId],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => FlashcardModel.fromJson(map)).toList();
  }

  @override
  Future<Flashcard?> getFlashcardById(String id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'flashcards',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return FlashcardModel.fromJson(maps.first);
  }

  @override
  Future<String> createFlashcard(Flashcard flashcard) async {
    final db = await _databaseHelper.database;
    final id = _uuid.v4();
    
    final flashcardModel = FlashcardModel(
      id: id,
      subjectId: flashcard.subjectId,
      question: flashcard.question,
      answer: flashcard.answer,
      hint: flashcard.hint,
      tags: flashcard.tags,
      createdAt: DateTime.now(),
      lastReviewed: flashcard.lastReviewed,
      nextReview: flashcard.nextReview ?? DateTime.now().add(const Duration(days: 1)),
      reviewCount: flashcard.reviewCount,
      correctCount: flashcard.correctCount,
      incorrectCount: flashcard.incorrectCount,
      difficulty: flashcard.difficulty,
      easeFactor: flashcard.easeFactor,
      interval: flashcard.interval,
    );

    await db.insert('flashcards', flashcardModel.toJson());
    return id;
  }

  @override
  Future<void> updateFlashcard(Flashcard flashcard) async {
    final db = await _databaseHelper.database;
    final flashcardModel = FlashcardModel.fromEntity(flashcard);

    await db.update(
      'flashcards',
      flashcardModel.toJson(),
      where: 'id = ?',
      whereArgs: [flashcard.id],
    );
  }

  @override
  Future<void> deleteFlashcard(String id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'flashcards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Flashcard>> getFlashcardsForReview() async {
    final db = await _databaseHelper.database;
    final now = DateTime.now().toIso8601String();
    
    final List<Map<String, dynamic>> maps = await db.query(
      'flashcards',
      where: 'next_review <= ? OR next_review IS NULL',
      whereArgs: [now],
      orderBy: 'next_review ASC',
    );

    return maps.map((map) => FlashcardModel.fromJson(map)).toList();
  }

  @override
  Future<List<Flashcard>> getFlashcardsDueToday() async {
    final db = await _databaseHelper.database;
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    
    final List<Map<String, dynamic>> maps = await db.query(
      'flashcards',
      where: 'next_review <= ?',
      whereArgs: [endOfDay.toIso8601String()],
      orderBy: 'next_review ASC',
    );

    return maps.map((map) => FlashcardModel.fromJson(map)).toList();
  }

  @override
  Future<List<Flashcard>> searchFlashcards(String query) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'flashcards',
      where: 'question LIKE ? OR answer LIKE ? OR tags LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => FlashcardModel.fromJson(map)).toList();
  }

  @override
  Future<void> recordFlashcardReview(String flashcardId, bool isCorrect) async {
    final flashcard = await getFlashcardById(flashcardId);
    if (flashcard == null) return;

    // Calculate quality score based on correctness and difficulty
    final quality = SpacedRepetitionAlgorithm.responseToQuality(
      isCorrect,
      flashcard.difficulty,
    );

    // Calculate next review parameters using SM-2 algorithm
    final updateResult = SpacedRepetitionAlgorithm.calculateNextReview(
      flashcard,
      quality,
    );

    // Update flashcard with new review data
    final updatedFlashcard = flashcard.copyWith(
      lastReviewed: DateTime.now(),
      nextReview: updateResult.nextReview,
      reviewCount: updateResult.repetitions,
      correctCount: isCorrect ? flashcard.correctCount + 1 : flashcard.correctCount,
      incorrectCount: !isCorrect ? flashcard.incorrectCount + 1 : flashcard.incorrectCount,
      easeFactor: updateResult.easeFactor,
      interval: updateResult.interval,
    );

    await updateFlashcard(updatedFlashcard);
  }

  @override
  Future<List<Flashcard>> getFlashcardsByTags(List<String> tags) async {
    final db = await _databaseHelper.database;
    
    // Create WHERE clause for tags
    final tagConditions = tags.map((_) => 'tags LIKE ?').join(' OR ');
    final tagArgs = tags.map((tag) => '%$tag%').toList();
    
    final List<Map<String, dynamic>> maps = await db.query(
      'flashcards',
      where: tagConditions,
      whereArgs: tagArgs,
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => FlashcardModel.fromJson(map)).toList();
  }

  @override
  Future<Map<String, int>> getFlashcardStats(String subjectId) async {
    final db = await _databaseHelper.database;
    
    // Get total count
    final totalResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM flashcards WHERE subject_id = ?',
      [subjectId],
    );
    final totalCount = totalResult.first['count'] as int;

    // Get due today count
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final dueResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM flashcards WHERE subject_id = ? AND next_review <= ?',
      [subjectId, endOfDay.toIso8601String()],
    );
    final dueCount = dueResult.first['count'] as int;

    // Get overdue count
    final overdueResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM flashcards WHERE subject_id = ? AND next_review < ?',
      [subjectId, now.toIso8601String()],
    );
    final overdueCount = overdueResult.first['count'] as int;

    // Get mastered count (cards with interval > 30 days)
    final masteredResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM flashcards WHERE subject_id = ? AND interval > 30',
      [subjectId],
    );
    final masteredCount = masteredResult.first['count'] as int;

    // Calculate average accuracy
    final accuracyResult = await db.rawQuery(
      'SELECT AVG(CASE WHEN review_count > 0 THEN CAST(correct_count AS FLOAT) / review_count ELSE 0 END) as avg_accuracy FROM flashcards WHERE subject_id = ?',
      [subjectId],
    );
    final avgAccuracy = (accuracyResult.first['avg_accuracy'] as double? ?? 0.0) * 100;

    return {
      'total': totalCount,
      'due_today': dueCount,
      'overdue': overdueCount,
      'mastered': masteredCount,
      'accuracy': avgAccuracy.round(),
    };
  }
} 