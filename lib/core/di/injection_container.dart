import 'package:flutter/foundation.dart';

import '../../data/datasources/database_helper.dart';
import '../../data/repositories/flashcard_repository_impl.dart';
import '../../data/repositories/subject_repository_impl.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../../domain/repositories/subject_repository.dart';
import '../../domain/usecases/create_subject.dart';
import '../../domain/usecases/get_subjects.dart';
import '../../presentation/bloc/subject/subject_bloc.dart';

class InjectionContainer {
  static final InjectionContainer _instance = InjectionContainer._internal();
  
  factory InjectionContainer() => _instance;
  
  InjectionContainer._internal();

  // Singletons
  late DatabaseHelper _databaseHelper;
  late SubjectRepository _subjectRepository;
  late FlashcardRepository _flashcardRepository;
  
  // Use cases
  late GetSubjects _getSubjects;
  late CreateSubject _createSubject;
  
  // BLoCs
  SubjectBloc? _subjectBloc;

  Future<void> init() async {
    // Core
    _databaseHelper = DatabaseHelper();
    
    // Repositories
    _subjectRepository = SubjectRepositoryImpl(_databaseHelper);
    _flashcardRepository = FlashcardRepositoryImpl(_databaseHelper);
    
    // Use cases
    _getSubjects = GetSubjects(_subjectRepository);
    _createSubject = CreateSubject(_subjectRepository);
    
    if (kDebugMode) {
      print('✅ Dependency injection initialized');
    }
  }

  // Getters for repositories
  SubjectRepository get subjectRepository => _subjectRepository;
  FlashcardRepository get flashcardRepository => _flashcardRepository;
  
  // Getters for use cases
  GetSubjects get getSubjects => _getSubjects;
  CreateSubject get createSubject => _createSubject;
  
  // BLoC getters with lazy initialization
  SubjectBloc get subjectBloc {
    _subjectBloc ??= SubjectBloc(_subjectRepository);
    return _subjectBloc!;
  }
  
  // Dispose method for cleanup
  void dispose() {
    _subjectBloc?.close();
    _subjectBloc = null;
  }
} 