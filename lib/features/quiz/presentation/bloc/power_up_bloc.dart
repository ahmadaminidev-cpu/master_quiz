import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/quiz_question.dart';

// ── Constants ─────────────────────────────────────────────────────────────────

const int kPowerUpQuestionDuration = 10;
const int kAddTimeBonus = 5;
const int kMaxAddTimeUses = 2;

// ── Events ────────────────────────────────────────────────────────────────────

abstract class PowerUpEvent extends Equatable {
  const PowerUpEvent();
  @override
  List<Object?> get props => [];
}

class StartPowerUp extends PowerUpEvent {}

class PowerUpAnswerSelected extends PowerUpEvent {
  final int selectedIndex;
  const PowerUpAnswerSelected(this.selectedIndex);
  @override
  List<Object?> get props => [selectedIndex];
}

class PowerUpNextQuestion extends PowerUpEvent {}

class PowerUpTick extends PowerUpEvent {
  final int remaining;
  const PowerUpTick(this.remaining);
  @override
  List<Object?> get props => [remaining];
}

class UseEliminate extends PowerUpEvent {}   // remove 2 wrong — 1 use total
class UseAddTime extends PowerUpEvent {}     // +5s — 2 uses total

class PowerUpRestart extends PowerUpEvent {}

// Internal
class _PowerUpTimerExpired extends PowerUpEvent {}

// ── States ────────────────────────────────────────────────────────────────────

abstract class PowerUpState extends Equatable {
  const PowerUpState();
  @override
  List<Object?> get props => [];
}

class PowerUpInitial extends PowerUpState {}

class PowerUpInProgress extends PowerUpState {
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int? selectedAnswer;
  final bool answered;
  final int timeRemaining;
  final int score;
  final List<bool?> answerResults;

  // Power-up usage tracking
  final bool eliminateUsed;       // 50/50 — only once
  final int addTimeUsesLeft;      // starts at 2
  final Set<int> hiddenOptions;   // indices hidden by eliminate

  const PowerUpInProgress({
    required this.questions,
    required this.currentIndex,
    required this.selectedAnswer,
    required this.answered,
    required this.timeRemaining,
    required this.score,
    required this.answerResults,
    required this.eliminateUsed,
    required this.addTimeUsesLeft,
    required this.hiddenOptions,
  });

  QuizQuestion get currentQuestion => questions[currentIndex];
  int get totalQuestions => questions.length;
  bool get isLastQuestion => currentIndex == questions.length - 1;

  PowerUpInProgress copyWith({
    int? currentIndex,
    int? selectedAnswer,
    bool? answered,
    int? timeRemaining,
    int? score,
    List<bool?>? answerResults,
    bool? eliminateUsed,
    int? addTimeUsesLeft,
    Set<int>? hiddenOptions,
    bool clearSelectedAnswer = false,
    bool clearHidden = false,
  }) {
    return PowerUpInProgress(
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswer:
          clearSelectedAnswer ? null : (selectedAnswer ?? this.selectedAnswer),
      answered: answered ?? this.answered,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      score: score ?? this.score,
      answerResults: answerResults ?? this.answerResults,
      eliminateUsed: eliminateUsed ?? this.eliminateUsed,
      addTimeUsesLeft: addTimeUsesLeft ?? this.addTimeUsesLeft,
      hiddenOptions: clearHidden ? {} : (hiddenOptions ?? this.hiddenOptions),
    );
  }

  @override
  List<Object?> get props => [
        questions, currentIndex, selectedAnswer, answered,
        timeRemaining, score, answerResults,
        eliminateUsed, addTimeUsesLeft, hiddenOptions,
      ];
}

class PowerUpFinished extends PowerUpState {
  final int score;
  final int totalQuestions;
  final List<bool?> answerResults;

  const PowerUpFinished({
    required this.score,
    required this.totalQuestions,
    required this.answerResults,
  });

  @override
  List<Object?> get props => [score, totalQuestions, answerResults];
}

// ── Bloc ──────────────────────────────────────────────────────────────────────

class PowerUpBloc extends Bloc<PowerUpEvent, PowerUpState> {
  final List<QuizQuestion> questions;
  Timer? _timer;

  PowerUpBloc({required this.questions}) : super(PowerUpInitial()) {
    on<StartPowerUp>(_onStart);
    on<PowerUpAnswerSelected>(_onAnswerSelected);
    on<PowerUpNextQuestion>(_onNextQuestion);
    on<PowerUpTick>(_onTick);
    on<UseEliminate>(_onUseEliminate);
    on<UseAddTime>(_onUseAddTime);
    on<PowerUpRestart>(_onRestart);
    on<_PowerUpTimerExpired>(_onTimerExpired);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state;
      if (current is PowerUpInProgress) {
        if (current.timeRemaining > 0) {
          add(PowerUpTick(current.timeRemaining - 1));
        } else {
          add(_PowerUpTimerExpired());
        }
      }
    });
  }

  void _onStart(StartPowerUp event, Emitter<PowerUpState> emit) {
    _timer?.cancel();
    emit(PowerUpInProgress(
      questions: questions,
      currentIndex: 0,
      selectedAnswer: null,
      answered: false,
      timeRemaining: kPowerUpQuestionDuration,
      score: 0,
      answerResults: List.filled(questions.length, null),
      eliminateUsed: false,
      addTimeUsesLeft: kMaxAddTimeUses,
      hiddenOptions: {},
    ));
    _startTimer();
  }

  void _onAnswerSelected(
      PowerUpAnswerSelected event, Emitter<PowerUpState> emit) {
    final current = state;
    if (current is! PowerUpInProgress || current.answered) return;
    _timer?.cancel();

    final isCorrect =
        event.selectedIndex == current.currentQuestion.correctIndex;
    final newResults = List<bool?>.from(current.answerResults);
    newResults[current.currentIndex] = isCorrect;

    emit(current.copyWith(
      selectedAnswer: event.selectedIndex,
      answered: true,
      score: isCorrect ? current.score + 5 : current.score,
      answerResults: newResults,
    ));
  }

  void _onNextQuestion(PowerUpNextQuestion event, Emitter<PowerUpState> emit) {
    final current = state;
    if (current is! PowerUpInProgress) return;

    if (current.isLastQuestion) {
      _timer?.cancel();
      emit(PowerUpFinished(
        score: current.score,
        totalQuestions: current.totalQuestions,
        answerResults: current.answerResults,
      ));
      return;
    }

    emit(current.copyWith(
      currentIndex: current.currentIndex + 1,
      answered: false,
      timeRemaining: kPowerUpQuestionDuration,
      clearSelectedAnswer: true,
      clearHidden: true,
    ));
    _startTimer();
  }

  void _onTick(PowerUpTick event, Emitter<PowerUpState> emit) {
    final current = state;
    if (current is PowerUpInProgress) {
      emit(current.copyWith(timeRemaining: event.remaining));
    }
  }

  void _onTimerExpired(
      _PowerUpTimerExpired event, Emitter<PowerUpState> emit) {
    final current = state;
    if (current is! PowerUpInProgress) return;
    _timer?.cancel();

    // Mark as skipped (null) and move on
    if (current.isLastQuestion) {
      emit(PowerUpFinished(
        score: current.score,
        totalQuestions: current.totalQuestions,
        answerResults: current.answerResults,
      ));
      return;
    }

    emit(current.copyWith(
      currentIndex: current.currentIndex + 1,
      answered: false,
      timeRemaining: kPowerUpQuestionDuration,
      clearSelectedAnswer: true,
      clearHidden: true,
    ));
    _startTimer();
  }

  void _onUseEliminate(UseEliminate event, Emitter<PowerUpState> emit) {
    final current = state;
    if (current is! PowerUpInProgress) return;
    if (current.eliminateUsed || current.answered) return;

    // Pick 2 wrong answers to hide
    final hidden = <int>{};
    for (int i = 0; i < current.currentQuestion.options.length; i++) {
      if (i != current.currentQuestion.correctIndex && hidden.length < 2) {
        hidden.add(i);
      }
    }

    emit(current.copyWith(
      eliminateUsed: true,
      hiddenOptions: hidden,
    ));
  }

  void _onUseAddTime(UseAddTime event, Emitter<PowerUpState> emit) {
    final current = state;
    if (current is! PowerUpInProgress) return;
    if (current.addTimeUsesLeft <= 0 || current.answered) return;

    emit(current.copyWith(
      addTimeUsesLeft: current.addTimeUsesLeft - 1,
      timeRemaining: current.timeRemaining + kAddTimeBonus,
    ));
  }

  void _onRestart(PowerUpRestart event, Emitter<PowerUpState> emit) {
    _timer?.cancel();
    emit(PowerUpInitial());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
