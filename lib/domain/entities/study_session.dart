import 'package:equatable/equatable.dart';

enum StudySessionType {
  flashcards,
  freeStudy,
  review,
  practice,
}

class StudySession extends Equatable {
  final String id;
  final String subjectId;
  final StudySessionType type;
  final DateTime startTime;
  final DateTime? endTime;
  final int duration; // in minutes
  final int cardsReviewed;
  final int correctAnswers;
  final int incorrectAnswers;
  final double focusScore; // 0.0 to 1.0
  final List<String> topicsStudied;
  final String? notes;

  const StudySession({
    required this.id,
    required this.subjectId,
    required this.type,
    required this.startTime,
    this.endTime,
    this.duration = 0,
    this.cardsReviewed = 0,
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
    this.focusScore = 1.0,
    this.topicsStudied = const [],
    this.notes,
  });

  StudySession copyWith({
    String? id,
    String? subjectId,
    StudySessionType? type,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    int? cardsReviewed,
    int? correctAnswers,
    int? incorrectAnswers,
    double? focusScore,
    List<String>? topicsStudied,
    String? notes,
  }) {
    return StudySession(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      cardsReviewed: cardsReviewed ?? this.cardsReviewed,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      focusScore: focusScore ?? this.focusScore,
      topicsStudied: topicsStudied ?? this.topicsStudied,
      notes: notes ?? this.notes,
    );
  }

  double get accuracyRate {
    if (cardsReviewed == 0) return 0.0;
    return correctAnswers / cardsReviewed;
  }

  bool get isActive => endTime == null;

  @override
  List<Object?> get props => [
        id,
        subjectId,
        type,
        startTime,
        endTime,
        duration,
        cardsReviewed,
        correctAnswers,
        incorrectAnswers,
        focusScore,
        topicsStudied,
        notes,
      ];
} 