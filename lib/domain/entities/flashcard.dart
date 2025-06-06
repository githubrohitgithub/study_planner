import 'package:equatable/equatable.dart';

enum DifficultyLevel {
  easy(2.5),
  medium(2.0),
  hard(1.0);

  const DifficultyLevel(this.multiplier);
  final double multiplier;
}

class Flashcard extends Equatable {
  final String id;
  final String subjectId;
  final String question;
  final String answer;
  final String? hint;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? lastReviewed;
  final DateTime? nextReview;
  final int reviewCount;
  final int correctCount;
  final int incorrectCount;
  final DifficultyLevel difficulty;
  final double easeFactor; // for spaced repetition algorithm
  final int interval; // days until next review

  const Flashcard({
    required this.id,
    required this.subjectId,
    required this.question,
    required this.answer,
    this.hint,
    this.tags = const [],
    required this.createdAt,
    this.lastReviewed,
    this.nextReview,
    this.reviewCount = 0,
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.difficulty = DifficultyLevel.medium,
    this.easeFactor = 2.5,
    this.interval = 1,
  });

  Flashcard copyWith({
    String? id,
    String? subjectId,
    String? question,
    String? answer,
    String? hint,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? lastReviewed,
    DateTime? nextReview,
    int? reviewCount,
    int? correctCount,
    int? incorrectCount,
    DifficultyLevel? difficulty,
    double? easeFactor,
    int? interval,
  }) {
    return Flashcard(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      hint: hint ?? this.hint,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      nextReview: nextReview ?? this.nextReview,
      reviewCount: reviewCount ?? this.reviewCount,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      difficulty: difficulty ?? this.difficulty,
      easeFactor: easeFactor ?? this.easeFactor,
      interval: interval ?? this.interval,
    );
  }

  double get accuracyRate {
    if (reviewCount == 0) return 0.0;
    return correctCount / reviewCount;
  }

  bool get isDueForReview {
    if (nextReview == null) return true;
    return DateTime.now().isAfter(nextReview!);
  }

  @override
  List<Object?> get props => [
        id,
        subjectId,
        question,
        answer,
        hint,
        tags,
        createdAt,
        lastReviewed,
        nextReview,
        reviewCount,
        correctCount,
        incorrectCount,
        difficulty,
        easeFactor,
        interval,
      ];
} 