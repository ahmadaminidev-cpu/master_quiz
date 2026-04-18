import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../quiz/data/quiz_repository.dart';
import '../../../quiz/models/quiz_question.dart';

// ── Events ────────────────────────────────────────────────────────────────────

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {}

class RetryLoadCategories extends CategoryEvent {}

// ── States ────────────────────────────────────────────────────────────────────

abstract class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final Map<String, List<QuizQuestion>> questionsByCategory;

  const CategoryLoaded(this.questionsByCategory);

  @override
  List<Object?> get props => [questionsByCategory];
}

class CategoryError extends CategoryState {
  final String message;
  const CategoryError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Bloc ──────────────────────────────────────────────────────────────────────

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final QuizRepository _repository;

  CategoryBloc({QuizRepository? repository})
      : _repository = repository ?? QuizRepository(),
        super(CategoryInitial()) {
    on<LoadCategories>(_onLoad);
    on<RetryLoadCategories>((_, emit) => _onLoad(LoadCategories(), emit));
  }

  Future<void> _onLoad(
      CategoryEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final data = await _repository.fetchAllCategories();
      emit(CategoryLoaded(data));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
