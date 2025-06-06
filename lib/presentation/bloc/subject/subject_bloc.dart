import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/subject.dart';
import '../../../domain/repositories/subject_repository.dart';
import 'subject_event.dart';
import 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final SubjectRepository _subjectRepository;

  SubjectBloc(this._subjectRepository) : super(const SubjectInitial()) {
    on<LoadSubjects>(_onLoadSubjects);
    on<CreateSubject>(_onCreateSubject);
    on<UpdateSubject>(_onUpdateSubject);
    on<DeleteSubject>(_onDeleteSubject);
    on<SearchSubjects>(_onSearchSubjects);
    on<UpdateSubjectProgress>(_onUpdateSubjectProgress);
    on<RecordStudyTime>(_onRecordStudyTime);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadSubjects(
    LoadSubjects event,
    Emitter<SubjectState> emit,
  ) async {
    try {
      emit(const SubjectLoading());
      final subjects = await _subjectRepository.getAllSubjects();
      emit(SubjectLoaded(subjects: subjects));
    } catch (e) {
      emit(SubjectError(message: 'Failed to load subjects: ${e.toString()}'));
    }
  }

  Future<void> _onCreateSubject(
    CreateSubject event,
    Emitter<SubjectState> emit,
  ) async {
    try {
      final currentState = state;
      final currentSubjects = currentState is SubjectLoaded 
          ? currentState.subjects 
          : <Subject>[];

      emit(SubjectOperationInProgress(
        subjects: currentSubjects,
        operation: 'Creating subject...',
      ));

      await _subjectRepository.createSubject(event.subject);
      final subjects = await _subjectRepository.getAllSubjects();
      
      emit(SubjectOperationSuccess(
        subjects: subjects,
        message: 'Subject created successfully',
      ));
      
      // Auto transition to loaded state
      await Future.delayed(const Duration(milliseconds: 500));
      emit(SubjectLoaded(subjects: subjects));
    } catch (e) {
      final currentState = state;
      final currentSubjects = currentState is SubjectLoaded 
          ? currentState.subjects 
          : <Subject>[];
      
      emit(SubjectError(
        message: 'Failed to create subject: ${e.toString()}',
        subjects: currentSubjects,
      ));
    }
  }

  Future<void> _onUpdateSubject(
    UpdateSubject event,
    Emitter<SubjectState> emit,
  ) async {
    try {
      final currentState = state;
      final currentSubjects = currentState is SubjectLoaded 
          ? currentState.subjects 
          : <Subject>[];

      emit(SubjectOperationInProgress(
        subjects: currentSubjects,
        operation: 'Updating subject...',
      ));

      await _subjectRepository.updateSubject(event.subject);
      final subjects = await _subjectRepository.getAllSubjects();
      
      emit(SubjectOperationSuccess(
        subjects: subjects,
        message: 'Subject updated successfully',
      ));
      
      // Auto transition to loaded state
      await Future.delayed(const Duration(milliseconds: 500));
      emit(SubjectLoaded(subjects: subjects));
    } catch (e) {
      final currentState = state;
      final currentSubjects = currentState is SubjectLoaded 
          ? currentState.subjects 
          : <Subject>[];
      
      emit(SubjectError(
        message: 'Failed to update subject: ${e.toString()}',
        subjects: currentSubjects,
      ));
    }
  }

  Future<void> _onDeleteSubject(
    DeleteSubject event,
    Emitter<SubjectState> emit,
  ) async {
    try {
      final currentState = state;
      final currentSubjects = currentState is SubjectLoaded 
          ? currentState.subjects 
          : <Subject>[];

      emit(SubjectOperationInProgress(
        subjects: currentSubjects,
        operation: 'Deleting subject...',
      ));

      await _subjectRepository.deleteSubject(event.subjectId);
      final subjects = await _subjectRepository.getAllSubjects();
      
      emit(SubjectOperationSuccess(
        subjects: subjects,
        message: 'Subject deleted successfully',
      ));
      
      // Auto transition to loaded state
      await Future.delayed(const Duration(milliseconds: 500));
      emit(SubjectLoaded(subjects: subjects));
    } catch (e) {
      final currentState = state;
      final currentSubjects = currentState is SubjectLoaded 
          ? currentState.subjects 
          : <Subject>[];
      
      emit(SubjectError(
        message: 'Failed to delete subject: ${e.toString()}',
        subjects: currentSubjects,
      ));
    }
  }

  Future<void> _onSearchSubjects(
    SearchSubjects event,
    Emitter<SubjectState> emit,
  ) async {
    try {
      final subjects = event.query.isEmpty
          ? await _subjectRepository.getAllSubjects()
          : await _subjectRepository.searchSubjects(event.query);
      
      emit(SubjectLoaded(
        subjects: subjects,
        isSearching: event.query.isNotEmpty,
        searchQuery: event.query.isEmpty ? null : event.query,
      ));
    } catch (e) {
      emit(SubjectError(message: 'Failed to search subjects: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateSubjectProgress(
    UpdateSubjectProgress event,
    Emitter<SubjectState> emit,
  ) async {
    try {
      await _subjectRepository.updateSubjectProgress(
        event.subjectId,
        event.progress,
      );
      
      // Refresh subjects list
      final subjects = await _subjectRepository.getAllSubjects();
      
      final currentState = state;
      if (currentState is SubjectLoaded) {
        emit(currentState.copyWith(subjects: subjects));
      } else {
        emit(SubjectLoaded(subjects: subjects));
      }
    } catch (e) {
      emit(SubjectError(
        message: 'Failed to update progress: ${e.toString()}',
      ));
    }
  }

  Future<void> _onRecordStudyTime(
    RecordStudyTime event,
    Emitter<SubjectState> emit,
  ) async {
    try {
      await _subjectRepository.recordStudyTime(
        event.subjectId,
        event.minutes,
      );
      
      // Refresh subjects list to show updated study time and streak
      final subjects = await _subjectRepository.getAllSubjects();
      
      final currentState = state;
      if (currentState is SubjectLoaded) {
        emit(currentState.copyWith(subjects: subjects));
      } else {
        emit(SubjectLoaded(subjects: subjects));
      }
    } catch (e) {
      emit(SubjectError(
        message: 'Failed to record study time: ${e.toString()}',
      ));
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<SubjectState> emit,
  ) async {
    try {
      final subjects = await _subjectRepository.getAllSubjects();
      emit(SubjectLoaded(
        subjects: subjects,
        isSearching: false,
        searchQuery: null,
      ));
    } catch (e) {
      emit(SubjectError(message: 'Failed to clear search: ${e.toString()}'));
    }
  }
} 