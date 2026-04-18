import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

export 'quiz_event.dart';
export 'quiz_state.dart';

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

  // ── Timer ──────────────────────────────────────────────────────────────────

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state;
      if (current is QuizInProgress) {
        if (current.timeRemaining > 0) {
          add(TimerTick(current.timeRemaining - 1));
        } else {
          add(SkipQuestion());
        }
      }
    });
  }

  // ── Handlers ───────────────────────────────────────────────────────────────

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
    final current = state;
    if (current is! QuizInProgress || current.answered) return;
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

  void _onNextQuestion(NextQuestion event, Emitter<QuizState> emit) {
    final current = state;
    if (current is! QuizInProgress) return;

    if (current.isLastQuestion) {
      _timer?.cancel();
      emit(QuizFinished(
        category: current.category,
        score: current.score,
        totalQuestions: current.totalQuestions,
        answerResults: current.answerResults,
      ));
      return;
    }

    emit(current.copyWith(
      currentIndex: current.currentIndex + 1,
      answered: false,
      timeRemaining: questionDuration,
      clearSelectedAnswer: true,
    ));
    _startTimer();
  }

  void _onSkipQuestion(SkipQuestion event, Emitter<QuizState> emit) {
    final current = state;
    if (current is! QuizInProgress) return;
    _timer?.cancel();

    if (current.isLastQuestion) {
      emit(QuizFinished(
        category: current.category,
        score: current.score,
        totalQuestions: current.totalQuestions,
        answerResults: current.answerResults,
      ));
      return;
    }

    emit(current.copyWith(
      currentIndex: current.currentIndex + 1,
      answered: false,
      timeRemaining: questionDuration,
      clearSelectedAnswer: true,
    ));
    _startTimer();
  }

  void _onTimerTick(TimerTick event, Emitter<QuizState> emit) {
    final current = state;
    if (current is QuizInProgress) {
      emit(current.copyWith(timeRemaining: event.remaining));
    }
  }

  void _onUseHalfAnswers(UseHalfAnswers event, Emitter<QuizState> emit) {
    final current = state;
    if (current is! QuizInProgress || current.answered) return;
    if (current.halfAnswersUsed[current.currentIndex]) return;

    final newUsed = List<bool>.from(current.halfAnswersUsed);
    newUsed[current.currentIndex] = true;
    emit(current.copyWith(halfAnswersUsed: newUsed));
  }

  void _onRestartQuiz(RestartQuiz event, Emitter<QuizState> emit) {
    _timer?.cancel();
    emit(QuizInitial());
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
