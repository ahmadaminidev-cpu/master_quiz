import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/quiz_mode.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

export 'quiz_event.dart';
export 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
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

  void _startTimer(QuizMode mode) {
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
    final duration = event.mode.questionDuration;
    emit(QuizInProgress(
      category: event.category,
      questions: event.questions,
      mode: event.mode,
      currentIndex: 0,
      selectedAnswer: null,
      answered: false,
      timeRemaining: duration,
      score: 0,
      answerResults: List.filled(event.questions.length, null),
      halfAnswersUsed: List.filled(event.questions.length, false),
    ));
    _startTimer(event.mode);
  }

  void _onSelectAnswer(SelectAnswer event, Emitter<QuizState> emit) {
    final current = state;
    if (current is! QuizInProgress || current.answered) return;

    _timer?.cancel();

    final isCorrect =
        event.selectedIndex == current.currentQuestion.correctIndex;
    final newResults = List<bool?>.from(current.answerResults);
    newResults[current.currentIndex] = isCorrect;

    // Daily Challenge: 10 credits per question
    // Quiz Category: 5 credits per question
    final creditsPerQuestion = current.category == 'Daily Challenge' ? 10 : 5;

    emit(current.copyWith(
      selectedAnswer: event.selectedIndex,
      answered: true,
      score: isCorrect ? current.score + creditsPerQuestion : current.score,
      answerResults: newResults,
    ));

    // In fast mode, auto-advance after a brief feedback pause.
    if (current.mode.autoAdvance) {
      _timer = Timer(const Duration(milliseconds: 1200), () {
        add(NextQuestion());
      });
    }
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
        questions: current.questions,
        mode: current.mode,
      ));
      return;
    }

    final duration = current.mode.questionDuration;
    emit(current.copyWith(
      currentIndex: current.currentIndex + 1,
      answered: false,
      timeRemaining: duration,
      clearSelectedAnswer: true,
    ));
    _startTimer(current.mode);
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
        questions: current.questions,
        mode: current.mode,
      ));
      return;
    }

    final duration = current.mode.questionDuration;
    emit(current.copyWith(
      currentIndex: current.currentIndex + 1,
      answered: false,
      timeRemaining: duration,
      clearSelectedAnswer: true,
    ));
    _startTimer(current.mode);
  }

  void _onTimerTick(TimerTick event, Emitter<QuizState> emit) {
    final current = state;
    if (current is! QuizInProgress) return;
    emit(current.copyWith(timeRemaining: event.remaining));
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
