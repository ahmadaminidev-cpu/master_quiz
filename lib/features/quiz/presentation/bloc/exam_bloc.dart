import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/exam_question.dart';

// ── Constants ─────────────────────────────────────────────────────────────────

const int kExamQuestionDuration = 15;

// ── Events ────────────────────────────────────────────────────────────────────

abstract class ExamEvent extends Equatable {
  const ExamEvent();
  @override
  List<Object?> get props => [];
}

class StartExam extends ExamEvent {}

class ExamAnswerSelected extends ExamEvent {
  final int selectedIndex;
  const ExamAnswerSelected(this.selectedIndex);
  @override
  List<Object?> get props => [selectedIndex];
}

class ExamNextQuestion extends ExamEvent {}

class ExamTick extends ExamEvent {
  final int remaining;
  const ExamTick(this.remaining);
  @override
  List<Object?> get props => [remaining];
}

class ExamRestart extends ExamEvent {}

class _ExamTimerExpired extends ExamEvent {}

// ── States ────────────────────────────────────────────────────────────────────

abstract class ExamState extends Equatable {
  const ExamState();
  @override
  List<Object?> get props => [];
}

class ExamInitial extends ExamState {}

class ExamInProgress extends ExamState {
  final List<ExamQuestion> questions;
  final int currentIndex;
  final int? selectedAnswer;
  final bool answered;
  final bool timedOut; // true when timer expired without an answer
  final int timeRemaining;
  final int score;
  final List<bool?> answerResults;

  const ExamInProgress({
    required this.questions,
    required this.currentIndex,
    required this.selectedAnswer,
    required this.answered,
    required this.timedOut,
    required this.timeRemaining,
    required this.score,
    required this.answerResults,
  });

  ExamQuestion get currentQuestion => questions[currentIndex];
  int get totalQuestions => questions.length;
  bool get isLastQuestion => currentIndex == questions.length - 1;

  /// Whether to show the explanation panel (wrong answer or timed out)
  bool get showExplanation {
    if (!answered && !timedOut) return false;
    if (timedOut) return true;
    return selectedAnswer != currentQuestion.correctIndex;
  }

  ExamInProgress copyWith({
    int? currentIndex,
    int? selectedAnswer,
    bool? answered,
    bool? timedOut,
    int? timeRemaining,
    int? score,
    List<bool?>? answerResults,
    bool clearSelectedAnswer = false,
  }) {
    return ExamInProgress(
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswer:
          clearSelectedAnswer ? null : (selectedAnswer ?? this.selectedAnswer),
      answered: answered ?? this.answered,
      timedOut: timedOut ?? this.timedOut,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      score: score ?? this.score,
      answerResults: answerResults ?? this.answerResults,
    );
  }

  @override
  List<Object?> get props => [
        questions, currentIndex, selectedAnswer, answered,
        timedOut, timeRemaining, score, answerResults,
      ];
}

class ExamFinished extends ExamState {
  final int score;
  final int totalQuestions;
  final List<bool?> answerResults;
  final List<ExamQuestion> questions;

  const ExamFinished({
    required this.score,
    required this.totalQuestions,
    required this.answerResults,
    required this.questions,
  });

  @override
  List<Object?> get props => [score, totalQuestions, answerResults, questions];
}

// ── Bloc ──────────────────────────────────────────────────────────────────────

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final List<ExamQuestion> questions;
  Timer? _timer;

  ExamBloc({required this.questions}) : super(ExamInitial()) {
    on<StartExam>(_onStart);
    on<ExamAnswerSelected>(_onAnswerSelected);
    on<ExamNextQuestion>(_onNextQuestion);
    on<ExamTick>(_onTick);
    on<ExamRestart>(_onRestart);
    on<_ExamTimerExpired>(_onTimerExpired);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state;
      if (current is ExamInProgress) {
        if (current.timeRemaining > 0) {
          add(ExamTick(current.timeRemaining - 1));
        } else {
          add(_ExamTimerExpired());
        }
      }
    });
  }

  void _onStart(StartExam event, Emitter<ExamState> emit) {
    _timer?.cancel();
    emit(ExamInProgress(
      questions: questions,
      currentIndex: 0,
      selectedAnswer: null,
      answered: false,
      timedOut: false,
      timeRemaining: kExamQuestionDuration,
      score: 0,
      answerResults: List.filled(questions.length, null),
    ));
    _startTimer();
  }

  void _onAnswerSelected(
      ExamAnswerSelected event, Emitter<ExamState> emit) {
    final current = state;
    if (current is! ExamInProgress || current.answered || current.timedOut) {
      return;
    }
    _timer?.cancel();

    final isCorrect =
        event.selectedIndex == current.currentQuestion.correctIndex;
    final newResults = List<bool?>.from(current.answerResults);
    newResults[current.currentIndex] = isCorrect;

    emit(current.copyWith(
      selectedAnswer: event.selectedIndex,
      answered: true,
      score: isCorrect ? current.score + 10 : current.score,
      answerResults: newResults,
    ));
  }

  void _onNextQuestion(ExamNextQuestion event, Emitter<ExamState> emit) {
    final current = state;
    if (current is! ExamInProgress) return;

    if (current.isLastQuestion) {
      _timer?.cancel();
      emit(ExamFinished(
        score: current.score,
        totalQuestions: current.totalQuestions,
        answerResults: current.answerResults,
        questions: current.questions,
      ));
      return;
    }

    emit(current.copyWith(
      currentIndex: current.currentIndex + 1,
      answered: false,
      timedOut: false,
      timeRemaining: kExamQuestionDuration,
      clearSelectedAnswer: true,
    ));
    _startTimer();
  }

  void _onTick(ExamTick event, Emitter<ExamState> emit) {
    final current = state;
    if (current is ExamInProgress) {
      emit(current.copyWith(timeRemaining: event.remaining));
    }
  }

  void _onTimerExpired(_ExamTimerExpired event, Emitter<ExamState> emit) {
    final current = state;
    if (current is! ExamInProgress || current.answered) return;
    _timer?.cancel();

    // Mark as timed out — show explanation, wait for user to tap Next
    emit(current.copyWith(timedOut: true));
  }

  void _onRestart(ExamRestart event, Emitter<ExamState> emit) {
    _timer?.cancel();
    emit(ExamInitial());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
