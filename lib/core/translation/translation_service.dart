import 'dart:convert';
import 'package:http/http.dart' as http;

/// Translates text using the MyMemory free API (no key required).
/// Caches results in memory to avoid redundant network calls.
class TranslationService {
  TranslationService._();
  static final TranslationService instance = TranslationService._();

  // In-memory cache: "text|langpair" → translated text
  final Map<String, String> _cache = {};

  /// Translates a single string. Returns the original on failure.
  Future<String> translate(String text, {required String to}) async {
    if (text.trim().isEmpty) return text;

    final cacheKey = '$text|en|$to';
    if (_cache.containsKey(cacheKey)) return _cache[cacheKey]!;

    try {
      final uri = Uri.parse(
        'https://api.mymemory.translated.net/get'
        '?q=${Uri.encodeComponent(text)}&langpair=en|$to',
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final translated =
            body['responseData']['translatedText'] as String? ?? text;
        _cache[cacheKey] = translated;
        return translated;
      }
    } catch (_) {
      // Fall through and return original
    }
    return text;
  }

  /// Translates a list of strings in parallel.
  Future<List<String>> translateAll(List<String> texts,
      {required String to}) async {
    return Future.wait(texts.map((t) => translate(t, to: to)));
  }

  void clearCache() => _cache.clear();
}
