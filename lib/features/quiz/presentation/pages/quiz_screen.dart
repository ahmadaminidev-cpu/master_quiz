import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/auth/auth_bloc.dart';
import '../../../../core/locale/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../daily_challenge/presentation/bloc/daily_challenge_bloc.dart';
import '../../../progress/presentation/bloc/progress_bloc.dart';
import '../../models/quiz_mode.dart';
import '../bloc/quiz_bloc.dart';
import '../widgets/answer_option.dart';
import '../widgets/quiz_lifeline_button.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatelessWidget {
  final String category;
  final IconData categoryIcon;
  final Color categoryColor;
  final bool isDailyChallenge;

  const QuizScreen({
    super.key,
    required this.category,
    required this.categoryIcon,
    required this.categoryColor,
    this.isDailyChallenge = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {
        if (state is QuizFinished) {
          // Add credits only if signed in
          final authState = context.read<AuthBloc>().state;
          if (authState is AuthAuthenticated) {
            context.read<ProgressBloc>().add(AddCredits(state.score));
            context.read<ProgressBloc>().add(RecordQuizCompletion());
          }

          if (isDailyChallenge) {
            context
                .read<DailyChallengeBloc>()
                .add(CompleteDailyChallenge(state.score));
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<QuizBloc>(),
                child: QuizResultScreen(
                  category: category,
                  categoryIcon: categoryIcon,
                  categoryColor: categoryColor,
                  isDailyChallenge: isDailyChallenge,
                ),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final l = AppLocalizations.of(context);
        if (state is! QuizInProgress) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final q = state.currentQuestion;
        final optionLabels = ['A', 'B', 'C', 'D'];
        final halfUsed = state.halfAnswersUsed[state.currentIndex];

        // Determine which options to hide when 50/50 is used
        final hiddenOptions = <int>{};
        if (halfUsed && !state.answered) {
          // Hide 2 wrong answers
          int hidden = 0;
          for (int i = 0; i < q.options.length && hidden < 2; i++) {
            if (i != q.correctIndex) {
              hiddenOptions.add(i);
              hidden++;
            }
          }
        }

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
          backgroundColor: AppColors.background,
          body: Container(
            decoration: const BoxDecoration(gradient: AppColors.mainGradient),
            child: SafeArea(
              child: Column(
                children: [
                  // ── App Bar ──────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        _CircleButton(
                          icon: Icons.arrow_back_rounded,
                          onTap: () => _showExitDialog(context),
                        ),
                        Expanded(
                          child: Text(
                            l.questionOf(state.currentIndex + 1, state.totalQuestions),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _CircleButton(
                          icon: Icons.bookmark_border_rounded,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // ── Question Card ────────────────────────────────
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.08),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category chip
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: categoryColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(categoryIcon,
                                          color: categoryColor, size: 13),
                                      const SizedBox(width: 5),
                                      Text(
                                        category,
                                        style: TextStyle(
                                          color: categoryColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  q.question,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ── Timer Bar ────────────────────────────────────
                          _TimerBar(
                            timeRemaining: state.timeRemaining,
                            totalTime: state.mode.questionDuration,
                            timeLabel: l.time,
                          ),

                          const SizedBox(height: 20),

                          // ── Answer Options ───────────────────────────────
                          ...List.generate(q.options.length, (i) {
                            if (hiddenOptions.contains(i)) {
                              return const SizedBox(height: 12);
                            }
                            return Padding(
                              key: ValueKey('q${state.currentIndex}_opt$i'),
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AnswerOption(
                                label: optionLabels[i],
                                text: q.options[i],
                                state: _optionState(state, i),
                                onTap: state.answered
                                    ? null
                                    : () => context.read<QuizBloc>().add(SelectAnswer(i)),
                              ),
                            );
                          }),

                          const SizedBox(height: 16),

                          // ── Next / Continue Button ───────────────────────
                          if (state.answered)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () =>
                                    context.read<QuizBloc>().add(NextQuestion()),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  state.isLastQuestion ? l.seeResults : l.nextQuestion,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // ── Lifeline Bar ─────────────────────────────────────────
                  _LifelineBar(
                    halfUsed: halfUsed,
                    onHalfAnswers: state.answered
                        ? null
                        : () => context.read<QuizBloc>().add(UseHalfAnswers()),
                    onSkip: state.answered
                        ? null
                        : () => context.read<QuizBloc>().add(SkipQuestion()),
                    labelFiftyFifty: l.fiftyFifty,
                    labelAnswers: l.answers,
                    labelAudience: l.audience,
                    labelPoll: l.poll,
                    labelAddTime: l.addTime,
                    labelPlus15s: l.plus15s,
                    labelSkip: l.skip,
                    labelQuestion: l.questionLabel,
                  ),
                ],
              ),
            ),
          ),
        ),
        );
      },
    );
  }

  AnswerOptionState _optionState(QuizInProgress state, int index) {
    if (!state.answered) return AnswerOptionState.idle;
    if (index == state.currentQuestion.correctIndex) return AnswerOptionState.correct;
    if (index == state.selectedAnswer) return AnswerOptionState.wrong;
    return AnswerOptionState.idle;
  }

  void _showExitDialog(BuildContext context) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          l.quitQuiz,
          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Text(
          l.progressLost,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(l.quit, style: const TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }
}

// ── Supporting Widgets ────────────────────────────────────────────────────────

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.textSecondary.withOpacity(0.1)),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    );
  }
}

class _TimerBar extends StatelessWidget {
  final int timeRemaining;
  final int totalTime;
  final String timeLabel;

  const _TimerBar({required this.timeRemaining, required this.totalTime, required this.timeLabel});

  @override
  Widget build(BuildContext context) {
    final progress = timeRemaining / totalTime;
    final isUrgent = timeRemaining <= 10;
    final barColor = isUrgent ? AppColors.accent : AppColors.accentOrange;
    final mm = (timeRemaining ~/ 60).toString().padLeft(2, '0');
    final ss = (timeRemaining % 60).toString().padLeft(2, '0');

    return Row(
      children: [
        Text(
          timeLabel,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$mm:$ss',
          style: TextStyle(
            color: barColor,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _LifelineBar extends StatelessWidget {
  final bool halfUsed;
  final VoidCallback? onHalfAnswers;
  final VoidCallback? onSkip;
  final String labelFiftyFifty;
  final String labelAnswers;
  final String labelAudience;
  final String labelPoll;
  final String labelAddTime;
  final String labelPlus15s;
  final String labelSkip;
  final String labelQuestion;

  const _LifelineBar({
    required this.halfUsed,
    required this.onHalfAnswers,
    required this.onSkip,
    required this.labelFiftyFifty,
    required this.labelAnswers,
    required this.labelAudience,
    required this.labelPoll,
    required this.labelAddTime,
    required this.labelPlus15s,
    required this.labelSkip,
    required this.labelQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.8),
        border: Border(
          top: BorderSide(color: AppColors.textSecondary.withOpacity(0.08)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: QuizLifelineButton(
              icon: Icons.filter_2_rounded,
              label: labelFiftyFifty,
              sublabel: labelAnswers,
              color: AppColors.accentOrange,
              isUsed: halfUsed,
              onTap: onHalfAnswers,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: QuizLifelineButton(
              icon: Icons.people_alt_rounded,
              label: labelAudience,
              sublabel: labelPoll,
              color: AppColors.accentOrange,
              onTap: null, // future feature
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: QuizLifelineButton(
              icon: Icons.add_circle_outline_rounded,
              label: labelAddTime,
              sublabel: labelPlus15s,
              color: AppColors.accentOrange,
              onTap: null, // future feature
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: QuizLifelineButton(
              icon: Icons.skip_next_rounded,
              label: labelSkip,
              sublabel: labelQuestion,
              color: AppColors.accentOrange,
              onTap: onSkip,
            ),
          ),
        ],
      ),
    );
  }
}
