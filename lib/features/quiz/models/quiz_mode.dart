enum QuizMode {
  standard, // 30s per question, lifelines, manual next
  fast,     // 5s per question, no lifelines, auto-advance
  timeAttack, // 60s global timer, answer as many as possible
  daily,    // Daily challenge mode (similar to standard)
}

extension QuizModeX on QuizMode {
  int get questionDuration {
    switch (this) {
      case QuizMode.fast:
        return 7;
      case QuizMode.standard:
      case QuizMode.daily:
        return 30;
      case QuizMode.timeAttack:
        return 40; // global, not per-question
    }
  }

  bool get hasLifelines => this == QuizMode.standard || this == QuizMode.daily;
  bool get autoAdvance => this == QuizMode.fast;
}
