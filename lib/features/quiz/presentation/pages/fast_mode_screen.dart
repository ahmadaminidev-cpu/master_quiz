import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/quiz_mode.dart';
import '../bloc/quiz_bloc.dart';
import '../widgets/answer_option.dart';
import 'quiz_result_screen.dart';

class FastModeScreen extends StatelessWidget {
  const FastModeScreen({super.key});

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
                  category: 'Fast Mode',
                  categoryIcon: Icons.speed_rounded,
                  categoryColor: AppColors.primary,
                  isFastMode: true,
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
        final progress = state.timeRemaining / QuizMode.fast.questionDuration;
        final isUrgent = state.timeRemaining <= 2;

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
                                'Fast Mode',
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
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.bolt_rounded,
                                  color: AppColors.primary, size: 16),
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
                              : AppColors.accent;
                        } else if (i == state.currentIndex) {
                          dotColor = AppColors.primary;
                        } else {
                          dotColor =
                              AppColors.textSecondary.withOpacity(0.2);
                        }
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
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

                  const SizedBox(height: 16),

                  // ── Countdown ring ───────────────────────────────────────
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 72,
                    height: 72,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 72,
                          height: 72,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 5,
                            backgroundColor:
                                AppColors.surface,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isUrgent
                                  ? AppColors.accent
                                  : AppColors.accentOrange,
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Text(
                          '${state.timeRemaining}',
                          style: TextStyle(
                            color: isUrgent
                                ? AppColors.accent
                                : AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Question Card ────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.speed_rounded,
                                    color: AppColors.primary, size: 13),
                                SizedBox(width: 5),
                                Text(
                                  'Fast Mode',
                                  style: TextStyle(
                                    color: AppColors.primary,
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
                  ),

                  const SizedBox(height: 16),

                  // ── Answer Options ───────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: List.generate(q.options.length, (i) {
                          return Padding(
                            key: ValueKey('q${state.currentIndex}_opt$i'),
                            padding: const EdgeInsets.only(bottom: 10),
                            child: AnswerOption(
                              label: optionLabels[i],
                              text: q.options[i],
                              state: _optionState(state, i),
                              onTap: state.answered
                                  ? null
                                  : () => context
                                      .read<QuizBloc>()
                                      .add(SelectAnswer(i)),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  // ── Bottom hint ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Text(
                      state.answered
                          ? 'Next question in ${state.timeRemaining}s…'
                          : 'Tap an answer before time runs out!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: state.answered
                            ? AppColors.textSecondary
                            : AppColors.textSecondary.withOpacity(0.6),
                        fontSize: 13,
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

  AnswerOptionState _optionState(QuizInProgress state, int index) {
    if (!state.answered) return AnswerOptionState.idle;
    if (index == state.currentQuestion.correctIndex) {
      return AnswerOptionState.correct;
    }
    if (index == state.selectedAnswer) return AnswerOptionState.wrong;
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
          'Quit Fast Mode?',
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
            child:
                const Text('Quit', style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }
}

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
          border:
              Border.all(color: AppColors.textSecondary.withOpacity(0.1)),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    );
  }
}
