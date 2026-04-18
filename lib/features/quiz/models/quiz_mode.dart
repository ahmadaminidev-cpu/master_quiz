enum QuizMode {
  standard, // 30s per question, lifelines, manual next
  fast,     // 5s per question, no lifelines, auto-advance
  timeAttack, // 60s global timer, answer as many as possible
}

extension QuizModeX on QuizMode {
  int get questionDuration {
    switch (this) {
      case QuizMode.fast:
        return 5;
      case QuizMode.standard:
        return 30;
      case QuizMode.timeAttack:
        return 60; // global, not per-question
    }
  }

  bool get hasLifelines => this == QuizMode.standard;
  bool get autoAdvance => this == QuizMode.fast;
}
