import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Subject extends Equatable {
  final String id;
  final String name;
  final String description;
  final Color color;
  final DateTime createdAt;
  final DateTime? lastStudied;
  final int totalStudyTime; // in minutes
  final int studyStreak;
  final double progress; // 0.0 to 1.0

  const Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.createdAt,
    this.lastStudied,
    this.totalStudyTime = 0,
    this.studyStreak = 0,
    this.progress = 0.0,
  });

  Subject copyWith({
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
    return Subject(
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

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        color,
        createdAt,
        lastStudied,
        totalStudyTime,
        studyStreak,
        progress,
      ];
} 