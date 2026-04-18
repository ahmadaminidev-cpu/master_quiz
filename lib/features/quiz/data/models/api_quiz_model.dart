/// Represents a quiz returned by GET /api/v1/quizzes
class ApiQuiz {
  final String id;
  final String title;
  final String category;
  final int questionCount;

  const ApiQuiz({
    required this.id,
    required this.title,
    required this.category,
    required this.questionCount,
  });

  factory ApiQuiz.fromJson(Map<String, dynamic> json) {
    return ApiQuiz(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      questionCount: json['questionCount'] as int,
    );
  }
}
