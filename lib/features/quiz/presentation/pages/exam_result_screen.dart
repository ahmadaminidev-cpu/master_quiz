import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/quiz_data.dart';
import '../bloc/exam_bloc.dart';
import 'exam_screen.dart';

class ExamResultScreen extends StatelessWidget {
  const ExamResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamBloc, ExamState>(
      builder: (context, state) {
        if (state is! ExamFinished) {
          return const Scaffold(backgroundColor: AppColors.background);
        }

        final correct = state.answerResults.where((r) => r == true).length;
        final wrong = state.answerResults.where((r) => r == false).length;
        final timedOut = state.answerResults.where((r) => r == null).length;
        final percentage = (correct / state.totalQuestions * 100).round();

        final String title;
        final String subtitle;
        final Color resultColor;

        if (percentage >= 80) {
          title = 'Exam Passed!';
          subtitle = 'Outstanding knowledge!';
          resultColor = const Color(0xFF34D399);
        } else if (percentage >= 60) {
          title = 'Good Score!';
          subtitle = 'Keep studying to improve.';
          resultColor = AppColors.secondary;
        } else if (percentage >= 40) {
          title = 'Almost There';
          subtitle = 'Review the explanations below.';
          resultColor = AppColors.accentOrange;
        } else {
          title = 'Needs Work';
          subtitle = 'Study the topics and try again.';
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

                    // ── Score circle ─────────────────────────────────────
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(resultColor),
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

                    Text(title,
                        style: TextStyle(
                          color: resultColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 6),
                    Text(subtitle,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 15)),

                    const SizedBox(height: 28),

                    // ── Stats ────────────────────────────────────────────
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
                          label: 'Timed Out',
                          value: '$timedOut',
                          color: AppColors.textSecondary,
                          icon: Icons.timer_off_rounded,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Credits ──────────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: AppColors.accentOrange.withOpacity(0.15)),
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

                    const SizedBox(height: 28),

                    // ── Full review with explanations ────────────────────
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Review & Explanations',
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
                      final q = state.questions[i];
                      final bool isCorrect = result == true;
                      final bool isTimedOut = result == null;
                      final Color dotColor = isCorrect
                          ? const Color(0xFF34D399)
                          : isTimedOut
                              ? AppColors.textSecondary
                              : AppColors.accent;
                      final IconData dotIcon = isCorrect
                          ? Icons.check_circle_rounded
                          : isTimedOut
                              ? Icons.timer_off_rounded
                              : Icons.cancel_rounded;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: dotColor.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Question row
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16, 14, 16, 10),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Icon(dotIcon,
                                      color: dotColor, size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Q${i + 1}. ${q.question}',
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Correct answer chip
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16, 0, 16, 0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF34D399)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '✓  ${q.options[q.correctIndex]}',
                                  style: const TextStyle(
                                    color: Color(0xFF34D399),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            // Explanation — always shown in result
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16, 10, 16, 14),
                              child: Text(
                                q.explanation,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 28),

                    // ── Actions ──────────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => ExamBloc(
                                  questions: QuizData.examQuestions,
                                )..add(StartExam()),
                                child: const ExamScreen(),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentOrange,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Try Again',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: BorderSide(
                              color:
                                  AppColors.textSecondary.withOpacity(0.3)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text('Back to Home',
                            style: TextStyle(fontSize: 16)),
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
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
