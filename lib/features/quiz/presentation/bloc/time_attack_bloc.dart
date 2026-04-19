import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/quiz_question.dart';

// ── Constants ─────────────────────────────────────────────────────────────────

const int kTimeAttackDuration = 60;

// ── Events ────────────────────────────────────────────────────────────────────

abstract class TimeAttackEvent extends Equatable {
  const TimeAttackEvent();
  @override
  List<Object?> get props => [];
}

class StartTimeAttack extends TimeAttackEvent {}

class TimeAttackAnswerSelected extends TimeAttackEvent {
  final int selectedIndex;
  const TimeAttackAnswerSelected(this.selectedIndex);
  @override
  List<Object?> get props => [selectedIndex];
}

class TimeAttackTick extends TimeAttackEvent {
  final int remaining;
  const TimeAttackTick(this.remaining);
  @override
  List<Object?> get props => [remaining];
}

class TimeAttackRestart extends TimeAttackEvent {}

// Internal — not exposed to UI
class _TimeAttackAdvance extends TimeAttackEvent {}
class _TimeAttackFinish extends TimeAttackEvent {}

// ── States ────────────────────────────────────────────────────────────────────

abstract class TimeAttackState extends Equatable {
  const TimeAttackState();
  @override
  List<Object?> get props => [];
}

class TimeAttackInitial extends TimeAttackState {}

class TimeAttackInProgress extends TimeAttackState {
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int? selectedAnswer;
  final bool answered;
  final int timeRemaining;
  final int score;
  final int correctCount;
  final List<bool?> answerResults;

  const TimeAttackInProgress({
    required this.questions,
    required this.currentIndex,
    required this.selectedAnswer,
    required this.answered,
    required this.timeRemaining,
    required this.score,
    required this.correctCount,
    required this.answerResults,
  });

  QuizQuestion get currentQuestion => questions[currentIndex];
  int get answeredCount => answerResults.where((r) => r != null).length;

  TimeAttackInProgress copyWith({
    int? currentIndex,
    int? selectedAnswer,
    bool? answered,
    int? timeRemaining,
    int? score,
    int? correctCount,
    List<bool?>? answerResults,
    bool clearSelectedAnswer = false,
  }) {
    return TimeAttackInProgress(
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswer:
          clearSelectedAnswer ? null : (selectedAnswer ?? this.selectedAnswer),
      answered: answered ?? this.answered,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      score: score ?? this.score,
      correctCount: correctCount ?? this.correctCount,
      answerResults: answerResults ?? this.answerResults,
    );
  }

  @override
  List<Object?> get props => [
        questions, currentIndex, selectedAnswer, answered,
        timeRemaining, score, correctCount, answerResults,
      ];
}

class TimeAttackFinished extends TimeAttackState {
  final int score;
  final int correctCount;
  final int totalAnswered;
  final List<bool?> answerResults;
  final List<QuizQuestion> questions;

  const TimeAttackFinished({
    required this.score,
    required this.correctCount,
    required this.totalAnswered,
    required this.answerResults,
    required this.questions,
  });

  @override
  List<Object?> get props =>
      [score, correctCount, totalAnswered, answerResults, questions];
}

// ── Bloc ──────────────────────────────────────────────────────────────────────

class TimeAttackBloc extends Bloc<TimeAttackEvent, TimeAttackState> {
  final List<QuizQuestion> questions;
  Timer? _globalTimer;

  TimeAttackBloc({required this.questions}) : super(TimeAttackInitial()) {
    on<StartTimeAttack>(_onStart);
    on<TimeAttackAnswerSelected>(_onAnswerSelected);
    on<TimeAttackTick>(_onTick);
    on<TimeAttackRestart>(_onRestart);
    on<_TimeAttackAdvance>(_onAdvance);
    on<_TimeAttackFinish>(_onFinish);
  }

  void _startGlobalTimer() {
    _globalTimer?.cancel();
    _globalTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state;
      if (current is TimeAttackInProgress) {
        if (current.timeRemaining > 0) {
          add(TimeAttackTick(current.timeRemaining - 1));
        } else {
          _finish();
        }
      }
    });
  }

  void _finish() {
    _globalTimer?.cancel();
    add(_TimeAttackFinish());
  }

  void _onFinish(_TimeAttackFinish event, Emitter<TimeAttackState> emit) {
    final current = state;
    if (current is! TimeAttackInProgress) return;
    emit(TimeAttackFinished(
      score: current.score,
      correctCount: current.correctCount,
      totalAnswered: current.answeredCount,
      answerResults: current.answerResults,
      questions: current.questions,
    ));
  }

  void _onStart(StartTimeAttack event, Emitter<TimeAttackState> emit) {
    _globalTimer?.cancel();
    emit(TimeAttackInProgress(
      questions: questions,
      currentIndex: 0,
      selectedAnswer: null,
      answered: false,
      timeRemaining: kTimeAttackDuration,
      score: 0,
      correctCount: 0,
      answerResults: List.filled(questions.length, null),
    ));
    _startGlobalTimer();
  }

  void _onAnswerSelected(
      TimeAttackAnswerSelected event, Emitter<TimeAttackState> emit) {
    final current = state;
    if (current is! TimeAttackInProgress || current.answered) return;

    final isCorrect =
        event.selectedIndex == current.currentQuestion.correctIndex;
    final newResults = List<bool?>.from(current.answerResults);
    newResults[current.currentIndex] = isCorrect;

    emit(current.copyWith(
      selectedAnswer: event.selectedIndex,
      answered: true,
      score: isCorrect ? current.score + 5 : current.score,
      correctCount: isCorrect ? current.correctCount + 1 : current.correctCount,
      answerResults: newResults,
    ));

    // Auto-advance after brief feedback via a one-shot timer
    _globalTimer?.cancel();
    _globalTimer = Timer(const Duration(milliseconds: 900), () {
      add(_TimeAttackAdvance());
    });
  }

  void _onTick(TimeAttackTick event, Emitter<TimeAttackState> emit) {
    final current = state;
    if (current is TimeAttackInProgress) {
      emit(current.copyWith(timeRemaining: event.remaining));
    }
  }

  void _onAdvance(_TimeAttackAdvance event, Emitter<TimeAttackState> emit) {
    final current = state;
    if (current is! TimeAttackInProgress) return;

    if (current.currentIndex >= current.questions.length - 1) {
      _finish();
      return;
    }

    // Resume the global countdown from where it left off
    final remaining = current.timeRemaining;
    emit(current.copyWith(
      currentIndex: current.currentIndex + 1,
      answered: false,
      clearSelectedAnswer: true,
    ));

    // Restart the per-second tick from the current remaining time
    _globalTimer?.cancel();
    _globalTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final s = state;
      if (s is TimeAttackInProgress) {
        if (s.timeRemaining > 0) {
          add(TimeAttackTick(s.timeRemaining - 1));
        } else {
          _finish();
        }
      }
    });
    // Emit the preserved remaining time so the bar doesn't jump
    final s = state;
    if (s is TimeAttackInProgress) {
      emit(s.copyWith(timeRemaining: remaining));
    }
  }

  void _onRestart(TimeAttackRestart event, Emitter<TimeAttackState> emit) {
    _globalTimer?.cancel();
    emit(TimeAttackInitial());
  }

  @override
  Future<void> close() {
    _globalTimer?.cancel();
    return super.close();
  }
}
