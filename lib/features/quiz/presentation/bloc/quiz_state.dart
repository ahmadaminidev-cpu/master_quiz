import 'package:equatable/equatable.dart';
import '../../models/quiz_question.dart';
import '../../models/quiz_mode.dart';

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
  final QuizMode mode;

  /// null = skipped, true = correct, false = wrong
  final List<bool?> answerResults;
  final List<bool> halfAnswersUsed;

  const QuizInProgress({
    required this.category,
    required this.questions,
    required this.currentIndex,
    required this.selectedAnswer,
    required this.answered,
    required this.timeRemaining,
    required this.score,
    required this.mode,
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
      mode: mode,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswer:
          clearSelectedAnswer ? null : (selectedAnswer ?? this.selectedAnswer),
      answered: answered ?? this.answered,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      score: score ?? this.score,
      answerResults: answerResults ?? this.answerResults,
      halfAnswersUsed: halfAnswersUsed ?? this.halfAnswersUsed,
    );
  }

  @override
  List<Object?> get props => [
        category,
        questions,
        currentIndex,
        selectedAnswer,
        answered,
        timeRemaining,
        score,
        mode,
        answerResults,
        halfAnswersUsed,
      ];
}

class QuizFinished extends QuizState {
  final String category;
  final int score;
  final int totalQuestions;
  final List<bool?> answerResults;
  final QuizMode mode;

  const QuizFinished({
    required this.category,
    required this.score,
    required this.totalQuestions,
    required this.answerResults,
    this.mode = QuizMode.standard,
  });

  @override
  List<Object?> get props => [category, score, totalQuestions, answerResults, mode];
}
