import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/quiz_question.dart';

// ── Events ──────────────────────────────────────────────────────────────────

abstract class QuizEvent extends Equatable {
  const QuizEvent();
  @override
  List<Object?> get props => [];
}

class StartQuiz extends QuizEvent {
  final String category;
  final List<QuizQuestion> questions;
  const StartQuiz({required this.category, required this.questions});
  @override
  List<Object?> get props => [category, questions];
}

class SelectAnswer extends QuizEvent {
  final int selectedIndex;
  const SelectAnswer(this.selectedIndex);
  @override
  List<Object?> get props => [selectedIndex];
}

class NextQuestion extends QuizEvent {}

class SkipQuestion extends QuizEvent {}

class TimerTick extends QuizEvent {
  final int remaining;
  const TimerTick(this.remaining);
  @override
  List<Object?> get props => [remaining];
}

class UseHalfAnswers extends QuizEvent {}

class RestartQuiz extends QuizEvent {}

// ── States ───────────────────────────────────────────────────────────────────

abstract class QuizState extends Equatable {
  const QuizState();
  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizInProgress extends QuizState {
  final String category;
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int? selectedAnswer;
  final bool answered;
  final int timeRemaining;
  final int score;
  final List<bool?> answerResults; // null = skipped, true = correct, false = wrong
  final List<bool> halfAnswersUsed;

  const QuizInProgress({
    required this.category,
    required this.questions,
    required this.currentIndex,
    required this.selectedAnswer,
    required this.answered,
    required this.timeRemaining,
    required this.score,
    required this.answerResults,
    required this.halfAnswersUsed,
  });

  QuizQuestion get currentQuestion => questions[currentIndex];
  int get totalQuestions => questions.length;
  bool get isLastQuestion => currentIndex == questions.length - 1;

  QuizInProgress copyWith({
    int? currentIndex,
    int? selectedAnswer,
    bool? answered,
    int? timeRemaining,
    int? score,
    List<bool?>? answerResults,
    List<bool>? halfAnswersUsed,
    bool clearSelectedAnswer = false,
  }) {
    return QuizInProgress(
      category: category,
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswer: clearSelectedAnswer ? null : (selectedAnswer ?? this.selectedAnswer),
      answered: answered ?? this.answered,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      score: score ?? this.score,
      answerResults: answerResults ?? this.answerResults,
      halfAnswersUsed: halfAnswersUsed ?? this.halfAnswersUsed,
    );
  }

  @override
  List<Object?> get props => [
        category, questions, currentIndex, selectedAnswer,
        answered, timeRemaining, score, answerResults, halfAnswersUsed,
      ];
}

class QuizFinished extends QuizState {
  final String category;
  final int score;
  final int totalQuestions;
  final List<bool?> answerResults;

  const QuizFinished({
    required this.category,
    required this.score,
    required this.totalQuestions,
    required this.answerResults,
  });

  @override
  List<Object?> get props => [category, score, totalQuestions, answerResults];
}

// ── Bloc ─────────────────────────────────────────────────────────────────────

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  static const int questionDuration = 30;
  Timer? _timer;

  QuizBloc() : super(QuizInitial()) {
    on<StartQuiz>(_onStartQuiz);
    on<SelectAnswer>(_onSelectAnswer);
    on<NextQuestion>(_onNextQuestion);
    on<SkipQuestion>(_onSkipQuestion);
    on<TimerTick>(_onTimerTick);
    on<UseHalfAnswers>(_onUseHalfAnswers);
    on<RestartQuiz>(_onRestartQuiz);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final state = this.state;
      if (state is QuizInProgress) {
        if (state.timeRemaining > 0) {
          add(TimerTick(state.timeRemaining - 1));
        } else {
          add(SkipQuestion());
        }
      }
    });
  }

  void _onStartQuiz(StartQuiz event, Emitter<QuizState> emit) {
    _timer?.cancel();
    emit(QuizInProgress(
      category: event.category,
      questions: event.questions,
      currentIndex: 0,
      selectedAnswer: null,
      answered: false,
      timeRemaining: questionDuration,
      score: 0,
      answerResults: List.filled(event.questions.length, null),
      halfAnswersUsed: List.filled(event.questions.length, false),
    ));
    _startTimer();
  }

  void _onSelectAnswer(SelectAnswer event, Emitter<QuizState> emit) {
    final state = this.state;
    if (state is! QuizInProgress || state.answered) return;
    _timer?.cancel();

    final isCorrect = event.selectedIndex == state.currentQuestion.correctIndex;
    final newResults = List<bool?>.from(state.answerResults);
    newResults[state.currentIndex] = isCorrect;

    emit(state.copyWith(
      selectedAnswer: event.selectedIndex,
      answered: true,
      score: isCorrect ? state.score + 10 : state.score,
      answerResults: newResults,
    ));
  }

  void _onNextQuestion(NextQuestion event, Emitter<QuizState> emit) {
    final state = this.state;
    if (state is! QuizInProgress) return;

    if (state.isLastQuestion) {
      _timer?.cancel();
      emit(QuizFinished(
        category: state.category,
        score: state.score,
        totalQuestions: state.totalQuestions,
        answerResults: state.answerResults,
      ));
      return;
    }

    emit(state.copyWith(
      currentIndex: state.currentIndex + 1,
      answered: false,
      timeRemaining: questionDuration,
      clearSelectedAnswer: true,
    ));
    _startTimer();
  }

  void _onSkipQuestion(SkipQuestion event, Emitter<QuizState> emit) {
    final state = this.state;
    if (state is! QuizInProgress) return;
    _timer?.cancel();

    if (state.isLastQuestion) {
      emit(QuizFinished(
        category: state.category,
        score: state.score,
        totalQuestions: state.totalQuestions,
        answerResults: state.answerResults,
      ));
      return;
    }

    emit(state.copyWith(
      currentIndex: state.currentIndex + 1,
      answered: false,
      timeRemaining: questionDuration,
      clearSelectedAnswer: true,
    ));
    _startTimer();
  }

  void _onTimerTick(TimerTick event, Emitter<QuizState> emit) {
    final state = this.state;
    if (state is QuizInProgress) {
      emit(state.copyWith(timeRemaining: event.remaining));
    }
  }

  void _onUseHalfAnswers(UseHalfAnswers event, Emitter<QuizState> emit) {
    final state = this.state;
    if (state is! QuizInProgress || state.answered) return;
    if (state.halfAnswersUsed[state.currentIndex]) return;

    final newUsed = List<bool>.from(state.halfAnswersUsed);
    newUsed[state.currentIndex] = true;
    emit(state.copyWith(halfAnswersUsed: newUsed));
  }

  void _onRestartQuiz(RestartQuiz event, Emitter<QuizState> emit) {
    _timer?.cancel();
    emit(QuizInitial());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
