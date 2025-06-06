import '../entities/flashcard.dart';

abstract class FlashcardRepository {
  Future<List<Flashcard>> getAllFlashcards();
  Future<List<Flashcard>> getFlashcardsBySubject(String subjectId);
  Future<Flashcard?> getFlashcardById(String id);
  Future<String> createFlashcard(Flashcard flashcard);
  Future<void> updateFlashcard(Flashcard flashcard);
  Future<void> deleteFlashcard(String id);
  Future<List<Flashcard>> getFlashcardsForReview();
  Future<List<Flashcard>> getFlashcardsDueToday();
  Future<List<Flashcard>> searchFlashcards(String query);
  Future<void> recordFlashcardReview(String flashcardId, bool isCorrect);
  Future<List<Flashcard>> getFlashcardsByTags(List<String> tags);
  Future<Map<String, int>> getFlashcardStats(String subjectId);
} 