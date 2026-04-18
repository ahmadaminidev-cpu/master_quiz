import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_question.dart';
import 'models/api_question_model.dart';
import 'models/api_quiz_model.dart';

class QuizRepository {
  static const String _baseUrl = 'https://quizapi.io/api/v1';
  static const String _apiKey =
      'Bearer qa_sk_63e8906e3a920eaf99c3d83afea1688a245453ba';

  static const Map<String, String> _headers = {
    'Authorization': _apiKey,
  };

  // ── Quiz IDs grouped by our 5 app categories ──────────────────────────────
  // Chosen as the top 5 categories by total question count from the API.
  static const Map<String, List<String>> _categoryQuizIds = {
    'Science': [
      'cmmdjge1c008yutgrpwpe6ykd', // Physics Fundamentals      (10q)
      'cmmdjge4g00j8utgrz2bazgdi', // Biology Essentials         (8q)
      'cmmdjge2k00cuutgr36hxib8u', // Chemistry Basics           (8q)
    ],
    'History': [
      'cmmdjge1s00acutgrtsjp7coa', // World History Essentials  (10q)
      'cmmdjge4r00kcutgri4keqjkx', // US History Highlights      (8q)
    ],
    'Programming': [
      'cmmdjgdzb004autgrtn29hcbk', // Python Data Structures     (8q)
    ],
    'DevOps': [
      'cmmdjge6h00qgutgrfkhlvdqz', // Linux Command Line         (8q)
      'cmmdjge4400i4utgrb2gfwxi5', // DevOps & Cloud Essentials  (8q)
    ],
    'General Knowledge': [
      'cmmdjge5e00mkutgrn2025lta', // General Knowledge Trivia  (10q)
    ],
  };

  /// Fetches all quizzes from the API (used for discovery / future use).
  Future<List<ApiQuiz>> fetchQuizzes({int limit = 20}) async {
    final uri = Uri.parse('$_baseUrl/quizzes?limit=$limit');
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch quizzes: ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List;
    return data
        .map((q) => ApiQuiz.fromJson(q as Map<String, dynamic>))
        .toList();
  }

  /// Fetches questions for a single quiz ID.
  Future<List<ApiQuestion>> fetchQuestionsForQuiz(String quizId) async {
    final uri = Uri.parse(
        '$_baseUrl/questions?quiz_id=$quizId&include_answers=true');
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to fetch questions for $quizId: ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List;
    return data
        .map((q) => ApiQuestion.fromJson(q as Map<String, dynamic>))
        .toList();
  }

  /// Fetches and merges all questions for a given app category.
  /// Returns only MULTIPLE_CHOICE questions with a valid correct answer.
  Future<List<QuizQuestion>> fetchQuestionsForCategory(
      String category) async {
    final quizIds = _categoryQuizIds[category];
    if (quizIds == null || quizIds.isEmpty) return [];

    final allQuestions = <QuizQuestion>[];

    for (final quizId in quizIds) {
      final apiQuestions = await fetchQuestionsForQuiz(quizId);
      for (final q in apiQuestions) {
        final converted = q.toQuizQuestion();
        if (converted != null) allQuestions.add(converted);
      }
    }

    return allQuestions;
  }

  /// Fetches questions for all 5 app categories in parallel.
  Future<Map<String, List<QuizQuestion>>> fetchAllCategories() async {
    final futures = _categoryQuizIds.keys.map((category) async {
      final questions = await fetchQuestionsForCategory(category);
      return MapEntry(category, questions);
    });

    final entries = await Future.wait(futures);
    return Map.fromEntries(entries);
  }

  /// The 5 category names used in the app.
  static List<String> get categoryNames =>
      _categoryQuizIds.keys.toList();
}
