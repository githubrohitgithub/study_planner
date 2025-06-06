import '../../domain/entities/flashcard.dart';

class FlashcardModel extends Flashcard {
  const FlashcardModel({
    required super.id,
    required super.subjectId,
    required super.question,
    required super.answer,
    super.hint,
    super.tags,
    required super.createdAt,
    super.lastReviewed,
    super.nextReview,
    super.reviewCount,
    super.correctCount,
    super.incorrectCount,
    super.difficulty,
    super.easeFactor,
    super.interval,
  });

  factory FlashcardModel.fromEntity(Flashcard flashcard) {
    return FlashcardModel(
      id: flashcard.id,
      subjectId: flashcard.subjectId,
      question: flashcard.question,
      answer: flashcard.answer,
      hint: flashcard.hint,
      tags: flashcard.tags,
      createdAt: flashcard.createdAt,
      lastReviewed: flashcard.lastReviewed,
      nextReview: flashcard.nextReview,
      reviewCount: flashcard.reviewCount,
      correctCount: flashcard.correctCount,
      incorrectCount: flashcard.incorrectCount,
      difficulty: flashcard.difficulty,
      easeFactor: flashcard.easeFactor,
      interval: flashcard.interval,
    );
  }

  factory FlashcardModel.fromJson(Map<String, dynamic> json) {
    return FlashcardModel(
      id: json['id'] as String,
      subjectId: json['subject_id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      hint: json['hint'] as String?,
      tags: (json['tags'] as String?)?.split(',') ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
      lastReviewed: json['last_reviewed'] != null
          ? DateTime.parse(json['last_reviewed'] as String)
          : null,
      nextReview: json['next_review'] != null
          ? DateTime.parse(json['next_review'] as String)
          : null,
      reviewCount: json['review_count'] as int? ?? 0,
      correctCount: json['correct_count'] as int? ?? 0,
      incorrectCount: json['incorrect_count'] as int? ?? 0,
      difficulty: DifficultyLevel.values.firstWhere(
        (e) => e.name == (json['difficulty'] as String? ?? 'medium'),
        orElse: () => DifficultyLevel.medium,
      ),
      easeFactor: (json['ease_factor'] as num?)?.toDouble() ?? 2.5,
      interval: json['interval'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject_id': subjectId,
      'question': question,
      'answer': answer,
      'hint': hint,
      'tags': tags.join(','),
      'created_at': createdAt.toIso8601String(),
      'last_reviewed': lastReviewed?.toIso8601String(),
      'next_review': nextReview?.toIso8601String(),
      'review_count': reviewCount,
      'correct_count': correctCount,
      'incorrect_count': incorrectCount,
      'difficulty': difficulty.name,
      'ease_factor': easeFactor,
      'interval': interval,
    };
  }

  @override
  FlashcardModel copyWith({
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
    return FlashcardModel(
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
} 