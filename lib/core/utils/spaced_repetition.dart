import '../../domain/entities/flashcard.dart';

class SpacedRepetitionAlgorithm {
  /// Calculate the next review parameters based on the SM-2 algorithm
  /// 
  /// [flashcard] - The current flashcard
  /// [quality] - User response quality (0-5)
  ///   0: complete blackout
  ///   1: incorrect response, but remembered on seeing answer
  ///   2: incorrect response, but it seemed easy on seeing answer
  ///   3: correct response, but required significant effort
  ///   4: correct response, after some hesitation
  ///   5: correct response with perfect recall
  static FlashcardUpdateResult calculateNextReview(
    Flashcard flashcard,
    int quality,
  ) {
    assert(quality >= 0 && quality <= 5, 'Quality must be between 0 and 5');

    double easeFactor = flashcard.easeFactor;
    int interval = flashcard.interval;
    int repetitions = flashcard.reviewCount;

    // Update ease factor based on quality
    if (quality >= 3) {
      // Correct response
      easeFactor = easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    } else {
      // Incorrect response - reset repetitions and interval
      repetitions = 0;
      interval = 1;
    }

    // Ensure ease factor doesn't go below 1.3
    if (easeFactor < 1.3) {
      easeFactor = 1.3;
    }

    // Calculate new interval
    if (repetitions == 0) {
      interval = 1;
    } else if (repetitions == 1) {
      interval = 6;
    } else {
      interval = (interval * easeFactor).round();
    }

    // Calculate next review date
    final nextReview = DateTime.now().add(Duration(days: interval));

    return FlashcardUpdateResult(
      easeFactor: easeFactor,
      interval: interval,
      nextReview: nextReview,
      repetitions: repetitions + 1,
    );
  }

  /// Convert user response to quality score
  static int responseToQuality(bool isCorrect, DifficultyLevel difficulty) {
    if (!isCorrect) {
      return 1; // Incorrect but remembered on seeing answer
    }

    // Correct responses mapped to quality based on difficulty
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 5; // Perfect recall
      case DifficultyLevel.medium:
        return 4; // Some hesitation
      case DifficultyLevel.hard:
        return 3; // Required significant effort
    }
  }

  /// Get recommended study intervals for different difficulty levels
  static List<int> getRecommendedIntervals() {
    return [1, 3, 7, 14, 30, 60, 120]; // Days
  }

  /// Calculate retention rate based on review history
  static double calculateRetentionRate(List<bool> recentReviews) {
    if (recentReviews.isEmpty) return 0.0;
    
    final correctCount = recentReviews.where((correct) => correct).length;
    return correctCount / recentReviews.length;
  }
}

class FlashcardUpdateResult {
  final double easeFactor;
  final int interval;
  final DateTime nextReview;
  final int repetitions;

  const FlashcardUpdateResult({
    required this.easeFactor,
    required this.interval,
    required this.nextReview,
    required this.repetitions,
  });
} 