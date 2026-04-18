import 'package:equatable/equatable.dart';
import '../../models/quiz_question.dart';

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
