import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/exam_bloc.dart';
import '../widgets/answer_option.dart';
import 'exam_result_screen.dart';

class ExamScreen extends StatelessWidget {
  const ExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamBloc, ExamState>(
      listener: (context, state) {
        if (state is ExamFinished) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<ExamBloc>(),
                child: const ExamResultScreen(),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is! ExamInProgress) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final q = state.currentQuestion;
        final optionLabels = ['A', 'B', 'C', 'D'];
        final timerProgress =
            state.timeRemaining / kExamQuestionDuration;
        final isUrgent = state.timeRemaining <= 5;
        final timerColor =
            isUrgent ? AppColors.accent : AppColors.accentOrange;
        final bool locked = state.answered || state.timedOut;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Container(
            decoration: const BoxDecoration(gradient: AppColors.mainGradient),
            child: SafeArea(
              child: Column(
                children: [
                  // ── Header ───────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        _CircleButton(
                          icon: Icons.close_rounded,
                          onTap: () => _showExitDialog(context),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Exam Mode',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${state.currentIndex + 1} / ${state.totalQuestions}',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Score pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.accentOrange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                    AppColors.accentOrange.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.menu_book_rounded,
                                  color: AppColors.accentOrange, size: 15),
                              const SizedBox(width: 4),
                              Text(
                                '${state.score}',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Progress dots ────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: List.generate(state.totalQuestions, (i) {
                        final result = state.answerResults[i];
                        Color dotColor;
                        if (i < state.currentIndex) {
                          dotColor = result == true
                              ? const Color(0xFF34D399)
                              : result == false
                                  ? AppColors.accent
                                  : AppColors.textSecondary
                                      .withOpacity(0.3);
                        } else if (i == state.currentIndex) {
                          dotColor = AppColors.accentOrange;
                        } else {
                          dotColor =
                              AppColors.textSecondary.withOpacity(0.2);
                        }
                        return Expanded(
                          child: Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 2),
                            height: 4,
                            decoration: BoxDecoration(
                              color: dotColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Timer bar ────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Text('Time',
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: timerProgress.clamp(0.0, 1.0),
                              backgroundColor: AppColors.surface,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  timerColor),
                              minHeight: 7,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${state.timeRemaining}s',
                          style: TextStyle(
                            color: timerColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Question Card ────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.accentOrange.withOpacity(0.12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.accentOrange.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.menu_book_rounded,
                                    color: AppColors.accentOrange, size: 13),
                                SizedBox(width: 5),
                                Text(
                                  'Exam Mode',
                                  style: TextStyle(
                                    color: AppColors.accentOrange,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            q.question,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Answer Options ───────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          ...List.generate(q.options.length, (i) {
                            return Padding(
                              key: ValueKey('q${state.currentIndex}_opt$i'),
                              padding: const EdgeInsets.only(bottom: 10),
                              child: AnswerOption(
                                label: optionLabels[i],
                                text: q.options[i],
                                state: _optionState(state, i),
                                onTap: locked
                                    ? null
                                    : () => context
                                        .read<ExamBloc>()
                                        .add(ExamAnswerSelected(i)),
                              ),
                            );
                          }),

                          // ── Explanation panel ──────────────────────────
                          if (state.showExplanation)
                            _ExplanationPanel(
                              explanation: q.explanation,
                              timedOut: state.timedOut,
                              correctAnswer:
                                  q.options[q.correctIndex],
                            ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  // ── Next button ──────────────────────────────────────────
                  if (locked)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context
                              .read<ExamBloc>()
                              .add(ExamNextQuestion()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentOrange,
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            state.isLastQuestion
                                ? 'See Results'
                                : 'Next Question',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AnswerOptionState _optionState(ExamInProgress state, int index) {
    // Always reveal correct answer once locked
    if (state.answered || state.timedOut) {
      if (index == state.currentQuestion.correctIndex) {
        return AnswerOptionState.correct;
      }
      if (index == state.selectedAnswer) return AnswerOptionState.wrong;
    }
    return AnswerOptionState.idle;
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Quit Exam?',
          style: TextStyle(
              color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Your progress will be lost.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Quit',
                style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }
}

// ── Explanation Panel ─────────────────────────────────────────────────────────

class _ExplanationPanel extends StatelessWidget {
  final String explanation;
  final bool timedOut;
  final String correctAnswer;

  const _ExplanationPanel({
    required this.explanation,
    required this.timedOut,
    required this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.accentOrange.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: AppColors.accentOrange.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  timedOut
                      ? Icons.timer_off_rounded
                      : Icons.lightbulb_rounded,
                  color: AppColors.accentOrange,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  timedOut ? 'Time\'s up! Here\'s the answer' : 'Learn from this',
                  style: const TextStyle(
                    color: AppColors.accentOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Correct answer highlight
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF34D399).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color(0xFF34D399).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: Color(0xFF34D399), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Correct: $correctAnswer',
                      style: const TextStyle(
                        color: Color(0xFF34D399),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              explanation,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Circle button ─────────────────────────────────────────────────────────────

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
          border: Border.all(
              color: AppColors.textSecondary.withOpacity(0.1)),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    );
  }
}
