import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const delegate = _AppLocalizationsDelegate();

  bool get isRtl => locale.languageCode == 'fa';

  static final Map<String, Map<String, String>> _strings = {
    // ── Category names ─────────────────────────────────────────────────────
    'cat_science': {'en': 'Science', 'fa': 'علوم'},
    'cat_history': {'en': 'History', 'fa': 'تاریخ'},
    'cat_programming': {'en': 'Programming', 'fa': 'برنامه‌نویسی'},
    'cat_devops': {'en': 'DevOps & Cloud', 'fa': 'دواپس و ابر'},
    'cat_general': {'en': 'General Knowledge', 'fa': 'دانش عمومی'},
    'daily_challenge_category': {'en': 'Daily Challenge', 'fa': 'چالش روزانه'},
    'nav_home': {'en': 'Home', 'fa': 'خانه'},
    'nav_progress': {'en': 'Progress', 'fa': 'پیشرفت'},

    // ── Home Screen ───────────────────────────────────────────────────────────
    'change_language': {'en': 'Change Language', 'fa': 'تغییر زبان'},
    'save_progress': {'en': 'Save Progress', 'fa': 'ذخیره پیشرفت'},
    'daily_challenge': {'en': 'Daily Challenge', 'fa': 'چالش روزانه'},
    'daily_xp': {'en': 'Questions • 50 XP', 'fa': 'سوال • ۵۰ امتیاز'},
    'done': {'en': 'Done', 'fa': 'انجام شد'},
    'completed': {'en': 'Completed!', 'fa': 'تکمیل شد!'},
    'progress': {'en': 'Progress', 'fa': 'پیشرفت'},
    'quiz_categories': {'en': 'Quiz Categories', 'fa': 'دسته‌بندی‌های کوییز'},
    'more_games': {'en': 'More Games', 'fa': 'بازی‌های بیشتر'},
    'play': {'en': 'Play', 'fa': 'بازی'},
    'could_not_load': {'en': 'Could not load categories', 'fa': 'بارگذاری دسته‌بندی‌ها ناموفق بود'},
    'retry': {'en': 'Retry', 'fa': 'تلاش مجدد'},

    // ── Game Mode Names ───────────────────────────────────────────────────────
    'fast_mode': {'en': 'Fast Mode', 'fa': 'حالت سریع'},
    'fast_mode_sub': {'en': '10 Qs • 5s each', 'fa': '۱۰ سوال • ۵ ثانیه'},
    'time_attack': {'en': 'Time Attack', 'fa': 'حمله زمانی'},
    'time_attack_sub': {'en': '40 Qs • 60s', 'fa': '۴۰ سوال • ۶۰ ثانیه'},
    'power_up': {'en': 'Power Up', 'fa': 'پاور آپ'},
    'power_up_sub': {'en': '12 Qs • 10s each', 'fa': '۱۲ سوال • ۱۰ ثانیه'},
    'exam_mode': {'en': 'Exam Mode', 'fa': 'حالت آزمون'},
    'exam_mode_sub': {'en': '12 Qs • 15s each', 'fa': '۱۲ سوال • ۱۵ ثانیه'},

    // ── Quiz Screen ───────────────────────────────────────────────────────────
    'time': {'en': 'Time', 'fa': 'زمان'},
    'fifty_fifty': {'en': '50/50', 'fa': '۵۰/۵۰'},
    'answers': {'en': 'Answers', 'fa': 'پاسخ‌ها'},
    'audience': {'en': 'Audience', 'fa': 'مخاطبان'},
    'poll': {'en': 'Poll', 'fa': 'نظرسنجی'},
    'add_time': {'en': 'Add time', 'fa': 'افزودن زمان'},
    'plus_15s': {'en': '+15s', 'fa': '+۱۵ ثانیه'},
    'skip': {'en': 'Skip', 'fa': 'رد کردن'},
    'question_label': {'en': 'Question', 'fa': 'سوال'},
    'next_question': {'en': 'Next Question', 'fa': 'سوال بعدی'},
    'see_results': {'en': 'See Results', 'fa': 'مشاهده نتایج'},
    'quit_quiz': {'en': 'Quit Quiz?', 'fa': 'خروج از کوییز؟'},
    'progress_lost': {'en': 'Your progress will be lost.', 'fa': 'پیشرفت شما از دست خواهد رفت.'},
    'cancel': {'en': 'Cancel', 'fa': 'لغو'},
    'quit': {'en': 'Quit', 'fa': 'خروج'},

    // ── Fast Mode ─────────────────────────────────────────────────────────────
    'next_in': {'en': 'Next question in', 'fa': 'سوال بعدی در'},
    'tap_answer': {'en': 'Tap an answer before time runs out!', 'fa': 'قبل از اتمام وقت پاسخ دهید!'},
    'quit_fast': {'en': 'Quit Fast Mode?', 'fa': 'خروج از حالت سریع؟'},

    // ── Time Attack ───────────────────────────────────────────────────────────
    'answered': {'en': 'Answered', 'fa': 'پاسخ داده شده'},
    'correct': {'en': 'Correct', 'fa': 'درست'},
    'wrong': {'en': 'Wrong', 'fa': 'غلط'},
    'answer_fast': {'en': 'Answer fast — the clock is ticking!', 'fa': 'سریع پاسخ دهید — ساعت در حال تیک‌تاک است!'},
    'next_coming': {'en': 'Next question coming up…', 'fa': 'سوال بعدی در راه است…'},
    'quit_time_attack': {'en': 'Quit Time Attack?', 'fa': 'خروج از حمله زمانی؟'},

    // ── Power Up ──────────────────────────────────────────────────────────────
    'eliminate': {'en': 'Eliminate', 'fa': 'حذف'},
    'two_wrong': {'en': '2 wrong answers', 'fa': '۲ پاسخ غلط'},
    'plus_5s': {'en': '+5 Seconds', 'fa': '+۵ ثانیه'},
    'extra_time': {'en': 'Extra time', 'fa': 'زمان اضافه'},
    'quit_power_up': {'en': 'Quit Power Up?', 'fa': 'خروج از پاور آپ؟'},

    // ── Exam ──────────────────────────────────────────────────────────────────
    'times_up': {'en': "Time's up! Here's the answer", 'fa': 'وقت تمام شد! پاسخ صحیح:'},
    'learn_from': {'en': 'Learn from this', 'fa': 'از این یاد بگیر'},
    'quit_exam': {'en': 'Quit Exam?', 'fa': 'خروج از آزمون؟'},

    // ── Results ───────────────────────────────────────────────────────────────
    'excellent': {'en': 'Excellent!', 'fa': 'عالی!'},
    'true_expert': {'en': "You're a true expert!", 'fa': 'شما یک متخصص واقعی هستید!'},
    'good_job': {'en': 'Good Job!', 'fa': 'آفرین!'},
    'keep_practicing': {'en': 'Keep practicing to improve!', 'fa': 'برای پیشرفت تمرین کنید!'},
    'not_bad': {'en': 'Not Bad', 'fa': 'بد نبود'},
    'can_do_better': {'en': 'You can do better next time!', 'fa': 'دفعه بعد بهتر خواهید بود!'},
    'keep_trying': {'en': 'Keep Trying!', 'fa': 'تلاش کنید!'},
    'practice_perfect': {'en': 'Practice makes perfect!', 'fa': 'تمرین کمال می‌آورد!'},
    'skipped': {'en': 'Skipped', 'fa': 'رد شده'},
    'credits_earned': {'en': 'Credits Earned', 'fa': 'امتیاز کسب شده'},
    'play_again': {'en': 'Play Again', 'fa': 'دوباره بازی'},
    'back_to_home': {'en': 'Back to Home', 'fa': 'بازگشت به خانه'},
    'answer_review': {'en': 'Answer Review', 'fa': 'مرور پاسخ‌ها'},

    // ── Time Attack Result ────────────────────────────────────────────────────
    'incredible': {'en': 'Incredible!', 'fa': 'باورنکردنی!'},
    'great_run': {'en': 'Great Run!', 'fa': 'عملکرد عالی!'},
    'not_bad_excl': {'en': 'Not Bad!', 'fa': 'بد نبود!'},
    'keep_going': {'en': 'Keep Going!', 'fa': 'ادامه بده!'},
    'accuracy': {'en': 'Accuracy', 'fa': 'دقت'},
    'timed_out': {'en': 'Timed Out', 'fa': 'زمان تمام شد'},

    // ── Power Up Result ───────────────────────────────────────────────────────
    'powered_up': {'en': 'Powered Up!', 'fa': 'پاور گرفتی!'},
    'good_power': {'en': 'Good Power!', 'fa': 'قدرت خوب!'},
    'keep_charging': {'en': 'Keep Charging!', 'fa': 'به شارژ ادامه بده!'},
    'need_more_power': {'en': 'Need More Power!', 'fa': 'به قدرت بیشتری نیاز داری!'},
    'no_mercy': {'en': '10 seconds per question — no mercy!', 'fa': '۱۰ ثانیه برای هر سوال — بدون رحم!'},

    // ── Exam Result ───────────────────────────────────────────────────────────
    'exam_passed': {'en': 'Exam Passed!', 'fa': 'آزمون قبول شدی!'},
    'outstanding': {'en': 'Outstanding knowledge!', 'fa': 'دانش فوق‌العاده!'},
    'good_score': {'en': 'Good Score!', 'fa': 'نمره خوب!'},
    'keep_studying': {'en': 'Keep studying to improve.', 'fa': 'برای پیشرفت مطالعه کنید.'},
    'almost_there': {'en': 'Almost There', 'fa': 'نزدیک بود'},
    'review_explanations': {'en': 'Review the explanations below.', 'fa': 'توضیحات زیر را مرور کنید.'},
    'needs_work': {'en': 'Needs Work', 'fa': 'نیاز به تلاش بیشتر'},
    'study_try_again': {'en': 'Study the topics and try again.', 'fa': 'موضوعات را مطالعه کنید و دوباره تلاش کنید.'},
    'review_and_explanations': {'en': 'Review & Explanations', 'fa': 'مرور و توضیحات'},
    'try_again': {'en': 'Try Again', 'fa': 'دوباره تلاش کن'},

    // ── Progress Screen ───────────────────────────────────────────────────────
    'level': {'en': 'Level', 'fa': 'سطح'},
    'total': {'en': 'Total', 'fa': 'کل'},
    'credits_earned_title': {'en': 'Credits Earned', 'fa': 'امتیاز کسب شده'},
    'max_level': {'en': 'Maximum Level Reached!', 'fa': 'بالاترین سطح رسیدی!'},
    'your_milestones': {'en': 'Your Milestones', 'fa': 'نقاط عطف شما'},
    'credit_goal': {'en': 'Credit Goal', 'fa': 'هدف امتیاز'},
    'quiz_master': {'en': 'Quiz Master', 'fa': 'استاد کوییز'},
    'solve_100': {'en': 'Solve 100 Questions', 'fa': 'حل ۱۰۰ سوال'},
    'streak_hunter': {'en': 'Streak Hunter', 'fa': 'شکارچی رشته'},
    'complete_7': {'en': 'Complete 7 Daily Challenges', 'fa': 'تکمیل ۷ چالش روزانه'},
    'unlocked_rewards': {'en': 'Unlocked Rewards', 'fa': 'جوایز باز شده'},
    'early_bird': {'en': 'Early Bird', 'fa': 'پرنده سحرخیز'},
    'quick_thinker': {'en': 'Quick Thinker', 'fa': 'متفکر سریع'},
    'perfect_score': {'en': 'Perfect Score', 'fa': 'نمره کامل'},
    'night_owl': {'en': 'Night Owl', 'fa': 'جغد شب'},
    'grand_master': {'en': 'Grand Master', 'fa': 'استاد بزرگ'},
    'globetrotter': {'en': 'Globetrotter', 'fa': 'جهانگرد'},
  };

  String _t(String key) {
    return _strings[key]?[locale.languageCode] ??
        _strings[key]?['en'] ??
        key;
  }

  // ── Accessors ─────────────────────────────────────────────────────────────

  String get navHome => _t('nav_home');
  String get catScience => _t('cat_science');
  String get catHistory => _t('cat_history');
  String get catProgramming => _t('cat_programming');
  String get catDevOps => _t('cat_devops');
  String get catGeneral => _t('cat_general');
  String get dailyChallengeCategory => _t('daily_challenge_category');

  /// Translates an API category key to the display name in the current locale.
  String categoryName(String apiKey) {
    switch (apiKey) {
      case 'Science': return catScience;
      case 'History': return catHistory;
      case 'Programming': return catProgramming;
      case 'DevOps & Cloud': return catDevOps;
      case 'General Knowledge': return catGeneral;
      default: return apiKey;
    }
  }
  String get navProgress => _t('nav_progress');
  String get changeLanguage => _t('change_language');
  String get saveProgress => _t('save_progress');
  String get dailyChallenge => _t('daily_challenge');
  String get done => _t('done');
  String get completed => _t('completed');
  String get progress => _t('progress');
  String get quizCategories => _t('quiz_categories');
  String get moreGames => _t('more_games');
  String get play => _t('play');
  String get couldNotLoad => _t('could_not_load');
  String get retry => _t('retry');
  String get fastMode => _t('fast_mode');
  String get fastModeSub => _t('fast_mode_sub');
  String get timeAttack => _t('time_attack');
  String get timeAttackSub => _t('time_attack_sub');
  String get powerUp => _t('power_up');
  String get powerUpSub => _t('power_up_sub');
  String get examMode => _t('exam_mode');
  String get examModeSub => _t('exam_mode_sub');
  String get time => _t('time');
  String get fiftyFifty => _t('fifty_fifty');
  String get answers => _t('answers');
  String get audience => _t('audience');
  String get poll => _t('poll');
  String get addTime => _t('add_time');
  String get plus15s => _t('plus_15s');
  String get skip => _t('skip');
  String get questionLabel => _t('question_label');
  String get nextQuestion => _t('next_question');
  String get seeResults => _t('see_results');
  String get quitQuiz => _t('quit_quiz');
  String get progressLost => _t('progress_lost');
  String get cancel => _t('cancel');
  String get quit => _t('quit');
  String get tapAnswer => _t('tap_answer');
  String get quitFast => _t('quit_fast');
  String get answered => _t('answered');
  String get correct => _t('correct');
  String get wrong => _t('wrong');
  String get answerFast => _t('answer_fast');
  String get nextComing => _t('next_coming');
  String get quitTimeAttack => _t('quit_time_attack');
  String get eliminate => _t('eliminate');
  String get twoWrong => _t('two_wrong');
  String get plus5s => _t('plus_5s');
  String get extraTime => _t('extra_time');
  String get quitPowerUp => _t('quit_power_up');
  String get timesUp => _t('times_up');
  String get learnFrom => _t('learn_from');
  String get quitExam => _t('quit_exam');
  String get excellent => _t('excellent');
  String get trueExpert => _t('true_expert');
  String get goodJob => _t('good_job');
  String get keepPracticing => _t('keep_practicing');
  String get notBad => _t('not_bad');
  String get canDoBetter => _t('can_do_better');
  String get keepTrying => _t('keep_trying');
  String get practicePerfect => _t('practice_perfect');
  String get skipped => _t('skipped');
  String get creditsEarned => _t('credits_earned');
  String get playAgain => _t('play_again');
  String get backToHome => _t('back_to_home');
  String get answerReview => _t('answer_review');
  String get incredible => _t('incredible');
  String get greatRun => _t('great_run');
  String get notBadExcl => _t('not_bad_excl');
  String get keepGoing => _t('keep_going');
  String get accuracy => _t('accuracy');
  String get timedOut => _t('timed_out');
  String get poweredUp => _t('powered_up');
  String get goodPower => _t('good_power');
  String get keepCharging => _t('keep_charging');
  String get needMorePower => _t('need_more_power');
  String get noMercy => _t('no_mercy');
  String get examPassed => _t('exam_passed');
  String get outstanding => _t('outstanding');
  String get goodScore => _t('good_score');
  String get keepStudying => _t('keep_studying');
  String get almostThere => _t('almost_there');
  String get reviewExplanations => _t('review_explanations');
  String get needsWork => _t('needs_work');
  String get studyTryAgain => _t('study_try_again');
  String get reviewAndExplanations => _t('review_and_explanations');
  String get tryAgain => _t('try_again');
  String get level => _t('level');
  String get yourMilestones => _t('your_milestones');
  String get creditGoal => _t('credit_goal');
  String get quizMaster => _t('quiz_master');
  String get solve100 => _t('solve_100');
  String get streakHunter => _t('streak_hunter');
  String get complete7 => _t('complete_7');
  String get unlockedRewards => _t('unlocked_rewards');
  String get earlyBird => _t('early_bird');
  String get quickThinker => _t('quick_thinker');
  String get perfectScore => _t('perfect_score');
  String get nightOwl => _t('night_owl');
  String get grandMaster => _t('grand_master');
  String get globetrotter => _t('globetrotter');
  String get maxLevel => _t('max_level');

  // ── Parameterized strings ─────────────────────────────────────────────────

  String questionOf(int current, int total) => locale.languageCode == 'fa'
      ? 'سوال $current از $total'
      : 'Question $current/$total';

  String nextInSeconds(int s) => locale.languageCode == 'fa'
      ? 'سوال بعدی در ${s}s…'
      : 'Next question in ${s}s…';

  String answeredQuestionsIn60(int n) => locale.languageCode == 'fa'
      ? 'شما $n سوال را در ۶۰ ثانیه پاسخ دادید'
      : 'You answered $n questions in 60 seconds';

  String creditsToNextLevel(int credits, int level) =>
      locale.languageCode == 'fa'
          ? 'فقط $credits امتیاز تا سطح $level'
          : 'Only $credits credits to Level $level';

  String reachCredits(int n) => locale.languageCode == 'fa'
      ? 'رسیدن به $n امتیاز'
      : 'Reach $n Credits';

  String creditsEarnedCount(int n) => locale.languageCode == 'fa'
      ? '$n امتیاز کسب شده'
      : '$n Credits Earned';

  String dailyQuestionsXp(int n) => locale.languageCode == 'fa'
      ? '$n سوال • ۵۰ امتیاز'
      : '$n Questions • 50 XP';

  String correctAnswer(String answer) => locale.languageCode == 'fa'
      ? 'صحیح: $answer'
      : 'Correct: $answer';
}

// ── Delegate ──────────────────────────────────────────────────────────────────

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'fa'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
