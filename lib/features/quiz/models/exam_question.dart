class ExamQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation; // shown after a wrong answer or timeout

  const ExamQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}
