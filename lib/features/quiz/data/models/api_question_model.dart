import 'dart:math';
import '../../models/quiz_question.dart';

/// Represents a question returned by GET /api/v1/questions
class ApiAnswer {
  final String id;
  final String text;
  final bool isCorrect;

  const ApiAnswer({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  factory ApiAnswer.fromJson(Map<String, dynamic> json) {
    return ApiAnswer(
      id: json['id'] as String,
      text: json['text'] as String,
      isCorrect: json['isCorrect'] as bool,
    );
  }
}

class ApiQuestion {
  final String id;
  final String text;
  final String type;
  final String? explanation;
  final List<ApiAnswer> answers;

  const ApiQuestion({
    required this.id,
    required this.text,
    required this.type,
    required this.explanation,
    required this.answers,
  });

  factory ApiQuestion.fromJson(Map<String, dynamic> json) {
    final answers = (json['answers'] as List)
        .map((a) => ApiAnswer.fromJson(a as Map<String, dynamic>))
        .toList();
    return ApiQuestion(
      id: json['id'] as String,
      text: json['text'] as String,
      type: json['type'] as String,
      explanation: json['explanation'] as String?,
      answers: answers,
    );
  }

  /// Converts to the app's internal [QuizQuestion] model.
  /// Shuffles the answer options so the correct answer is never always first.
  /// Returns null if the question is not MULTIPLE_CHOICE or has no correct answer.
  QuizQuestion? toQuizQuestion() {
    if (type != 'MULTIPLE_CHOICE') return null;
    if (answers.length < 2) return null;

    final correctIndex = answers.indexWhere((a) => a.isCorrect);
    if (correctIndex == -1) return null;

    // Shuffle a copy so the original list is untouched
    final shuffled = List<ApiAnswer>.from(answers)..shuffle(Random());

    // Find where the correct answer landed after the shuffle
    final newCorrectIndex = shuffled.indexWhere((a) => a.isCorrect);

    return QuizQuestion(
      question: text,
      options: shuffled.map((a) => a.text).toList(),
      correctIndex: newCorrectIndex,
    );
  }
}
