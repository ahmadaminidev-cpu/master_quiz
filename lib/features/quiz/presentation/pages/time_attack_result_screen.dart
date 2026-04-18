import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/quiz_data.dart';
import '../bloc/time_attack_bloc.dart';
import 'time_attack_screen.dart';

class TimeAttackResultScreen extends StatelessWidget {
  const TimeAttackResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeAttackBloc, TimeAttackState>(
      builder: (context, state) {
        if (state is! TimeAttackFinished) {
          return const Scaffold(backgroundColor: AppColors.background);
        }

        final accuracy = state.totalAnswered == 0
            ? 0
            : (state.correctCount / state.totalAnswered * 100).round();

        final String title;
        final Color resultColor;

        if (accuracy >= 80) {
          title = 'Incredible!';
          resultColor = const Color(0xFF34D399);
        } else if (accuracy >= 60) {
          title = 'Great Run!';
          resultColor = AppColors.secondary;
        } else if (accuracy >= 40) {
          title = 'Not Bad!';
          resultColor = AppColors.accentOrange;
        } else {
          title = 'Keep Going!';
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
                            value: state.totalAnswered == 0
                                ? 0
                                : state.correctCount / state.totalAnswered,
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
                              '$accuracy%',
                              style: TextStyle(
                                color: resultColor,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Accuracy',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text(
                      title,
                      style: TextStyle(
                        color: resultColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'You answered ${state.totalAnswered} questions in 60 seconds',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Stats ────────────────────────────────────────────
                    Row(
                      children: [
                        _StatCard(
                          label: 'Answered',
                          value: '${state.totalAnswered}',
                          color: AppColors.primary,
                          icon: Icons.quiz_rounded,
                        ),
                        const SizedBox(width: 12),
                        _StatCard(
                          label: 'Correct',
                          value: '${state.correctCount}',
                          color: const Color(0xFF34D399),
                          icon: Icons.check_circle_rounded,
                        ),
                        const SizedBox(width: 12),
                        _StatCard(
                          label: 'Wrong',
                          value:
                              '${state.totalAnswered - state.correctCount}',
                          color: AppColors.accent,
                          icon: Icons.cancel_rounded,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Credits earned ───────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: AppColors.secondary.withOpacity(0.15)),
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

                    // ── Answer review ────────────────────────────────────
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
                    ...List.generate(state.totalAnswered, (i) {
                      final result = state.answerResults[i];
                      final Color dotColor = result == true
                          ? const Color(0xFF34D399)
                          : AppColors.accent;
                      final IconData dotIcon = result == true
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded;

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
                                state.questions[i].question,
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

                    // ── Actions ──────────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => TimeAttackBloc(
                                  questions: QuizData.timeAttackQuestions,
                                )..add(StartTimeAttack()),
                                child: const TimeAttackScreen(),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
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
