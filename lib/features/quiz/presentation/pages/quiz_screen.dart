import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/quiz_bloc.dart';
import '../widgets/answer_option.dart';
import '../widgets/quiz_lifeline_button.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatelessWidget {
  final String category;
  final IconData categoryIcon;
  final Color categoryColor;

  const QuizScreen({
    super.key,
    required this.category,
    required this.categoryIcon,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {
        if (state is QuizFinished) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<QuizBloc>(),
                child: QuizResultScreen(
                  category: category,
                  categoryIcon: categoryIcon,
                  categoryColor: categoryColor,
                ),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
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

        return Scaffold(
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
                            'Question ${state.currentIndex + 1}/${state.totalQuestions}',
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
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  categoryColor.withOpacity(0.25),
                                  AppColors.primary.withOpacity(0.15),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: categoryColor.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: categoryColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(categoryIcon, color: categoryColor, size: 28),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  q.question,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ── Timer Bar ────────────────────────────────────
                          _TimerBar(
                            timeRemaining: state.timeRemaining,
                            totalTime: QuizBloc.questionDuration,
                          ),

                          const SizedBox(height: 20),

                          // ── Answer Options ───────────────────────────────
                          ...List.generate(q.options.length, (i) {
                            if (hiddenOptions.contains(i)) {
                              return const SizedBox(height: 12);
                            }
                            return Padding(
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
                                  state.isLastQuestion ? 'See Results' : 'Next Question',
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
                  ),
                ],
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
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Quit Quiz?',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Your progress will be lost.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Quit', style: TextStyle(color: AppColors.accent)),
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

  const _TimerBar({required this.timeRemaining, required this.totalTime});

  @override
  Widget build(BuildContext context) {
    final progress = timeRemaining / totalTime;
    final isUrgent = timeRemaining <= 10;
    final barColor = isUrgent ? AppColors.accent : AppColors.accentOrange;
    final mm = (timeRemaining ~/ 60).toString().padLeft(2, '0');
    final ss = (timeRemaining % 60).toString().padLeft(2, '0');

    return Row(
      children: [
        const Text(
          'Time',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
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

  const _LifelineBar({
    required this.halfUsed,
    required this.onHalfAnswers,
    required this.onSkip,
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
              label: '50/50',
              sublabel: 'Answers',
              color: AppColors.accentOrange,
              isUsed: halfUsed,
              onTap: onHalfAnswers,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: QuizLifelineButton(
              icon: Icons.people_alt_rounded,
              label: 'Audience',
              sublabel: 'Poll',
              color: AppColors.accentOrange,
              onTap: null, // future feature
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: QuizLifelineButton(
              icon: Icons.add_circle_outline_rounded,
              label: 'Add time',
              sublabel: '+15s',
              color: AppColors.accentOrange,
              onTap: null, // future feature
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: QuizLifelineButton(
              icon: Icons.skip_next_rounded,
              label: 'Skip',
              sublabel: 'Question',
              color: AppColors.accentOrange,
              onTap: onSkip,
            ),
          ),
        ],
      ),
    );
  }
}
