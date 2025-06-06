import 'package:flutter/material.dart';
import '../../domain/entities/subject.dart';

class SubjectModel extends Subject {
  const SubjectModel({
    required super.id,
    required super.name,
    required super.description,
    required super.color,
    required super.createdAt,
    super.lastStudied,
    super.totalStudyTime,
    super.studyStreak,
    super.progress,
  });

  factory SubjectModel.fromEntity(Subject subject) {
    return SubjectModel(
      id: subject.id,
      name: subject.name,
      description: subject.description,
      color: subject.color,
      createdAt: subject.createdAt,
      lastStudied: subject.lastStudied,
      totalStudyTime: subject.totalStudyTime,
      studyStreak: subject.studyStreak,
      progress: subject.progress,
    );
  }

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      color: Color(json['color'] as int),
      createdAt: DateTime.parse(json['created_at'] as String),
      lastStudied: json['last_studied'] != null
          ? DateTime.parse(json['last_studied'] as String)
          : null,
      totalStudyTime: json['total_study_time'] as int? ?? 0,
      studyStreak: json['study_streak'] as int? ?? 0,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color.value,
      'created_at': createdAt.toIso8601String(),
      'last_studied': lastStudied?.toIso8601String(),
      'total_study_time': totalStudyTime,
      'study_streak': studyStreak,
      'progress': progress,
    };
  }

  @override
  SubjectModel copyWith({
    String? id,
    String? name,
    String? description,
    Color? color,
    DateTime? createdAt,
    DateTime? lastStudied,
    int? totalStudyTime,
    int? studyStreak,
    double? progress,
  }) {
    return SubjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      lastStudied: lastStudied ?? this.lastStudied,
      totalStudyTime: totalStudyTime ?? this.totalStudyTime,
      studyStreak: studyStreak ?? this.studyStreak,
      progress: progress ?? this.progress,
    );
  }
} 