import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/quiz_bloc.dart';
import '../../data/quiz_data.dart';

class QuizResultScreen extends StatelessWidget {
  final String category;
  final IconData categoryIcon;
  final Color categoryColor;

  const QuizResultScreen({
    super.key,
    required this.category,
    required this.categoryIcon,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizBloc, QuizState>(
      builder: (context, state) {
        if (state is! QuizFinished) {
          return const Scaffold(backgroundColor: AppColors.background);
        }

        final correct = state.answerResults.where((r) => r == true).length;
        final skipped = state.answerResults.where((r) => r == null).length;
        final wrong = state.answerResults.where((r) => r == false).length;
        final percentage = (correct / state.totalQuestions * 100).round();

        final String resultTitle;
        final String resultSubtitle;
        final Color resultColor;

        if (percentage >= 80) {
          resultTitle = 'Excellent!';
          resultSubtitle = 'You\'re a true expert!';
          resultColor = const Color(0xFF34D399);
        } else if (percentage >= 60) {
          resultTitle = 'Good Job!';
          resultSubtitle = 'Keep practicing to improve!';
          resultColor = AppColors.secondary;
        } else if (percentage >= 40) {
          resultTitle = 'Not Bad';
          resultSubtitle = 'You can do better next time!';
          resultColor = AppColors.accentOrange;
        } else {
          resultTitle = 'Keep Trying!';
          resultSubtitle = 'Practice makes perfect!';
          resultColor = AppColors.accent;
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Container(
            decoration: const BoxDecoration(gradient: AppColors.mainGradient),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 32),

                    // ── Score Circle ─────────────────────────────────────
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: CircularProgressIndicator(
                            value: correct / state.totalQuestions,
                            strokeWidth: 10,
                            backgroundColor: AppColors.surface,
                            valueColor: AlwaysStoppedAnimation<Color>(resultColor),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$percentage%',
                              style: TextStyle(
                                color: resultColor,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$correct/${state.totalQuestions}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text(
                      resultTitle,
                      style: TextStyle(
                        color: resultColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      resultSubtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Stats Row ────────────────────────────────────────
                    Row(
                      children: [
                        _StatCard(
                          label: 'Correct',
                          value: '$correct',
                          color: const Color(0xFF34D399),
                          icon: Icons.check_circle_rounded,
                        ),
                        const SizedBox(width: 12),
                        _StatCard(
                          label: 'Wrong',
                          value: '$wrong',
                          color: AppColors.accent,
                          icon: Icons.cancel_rounded,
                        ),
                        const SizedBox(width: 12),
                        _StatCard(
                          label: 'Skipped',
                          value: '$skipped',
                          color: AppColors.textSecondary,
                          icon: Icons.skip_next_rounded,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Score Earned ─────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.stars_rounded,
                              color: AppColors.accentOrange, size: 28),
                          const SizedBox(width: 12),
                          Text(
                            '+${state.score} Credits Earned',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Answer Review ────────────────────────────────────
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Answer Review',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(state.totalQuestions, (i) {
                      final result = state.answerResults[i];
                      final Color dotColor = result == true
                          ? const Color(0xFF34D399)
                          : result == false
                              ? AppColors.accent
                              : AppColors.textSecondary;
                      final IconData dotIcon = result == true
                          ? Icons.check_circle_rounded
                          : result == false
                              ? Icons.cancel_rounded
                              : Icons.remove_circle_rounded;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: dotColor.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(dotIcon, color: dotColor, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              'Q${i + 1}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                QuizData.questionsByCategory[category]![i].question,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 32),

                    // ── Action Buttons ───────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<QuizBloc>().add(StartQuiz(
                                category: category,
                                questions:
                                    QuizData.questionsByCategory[category]!,
                              ));
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Play Again',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<QuizBloc>().add(RestartQuiz());
                          Navigator.of(context)
                            ..pop()
                            ..pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: BorderSide(
                              color: AppColors.textSecondary.withOpacity(0.3)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Back to Home',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
