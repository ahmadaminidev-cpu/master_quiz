import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/locale/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/quiz_bloc.dart';
import '../../data/quiz_data.dart';
import '../../models/quiz_mode.dart';
import 'fast_mode_screen.dart';
import 'quiz_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final String category;
  final IconData categoryIcon;
  final Color categoryColor;
  final bool isDailyChallenge;
  final bool isFastMode;

  const QuizResultScreen({
    super.key,
    required this.category,
    required this.categoryIcon,
    required this.categoryColor,
    this.isDailyChallenge = false,
    this.isFastMode = false,
  });

  @override
  Widget build(BuildContext context) {
    // Read the finished state directly — no BlocBuilder needed since the
    // result screen is only ever pushed after QuizFinished is emitted.
    final bloc = context.read<QuizBloc>();
    final state = bloc.state;

    if (state is! QuizFinished) {
      return const Scaffold(backgroundColor: AppColors.background);
    }

    final l = AppLocalizations.of(context);
    final correct = state.answerResults.where((r) => r == true).length;
    final skipped = state.answerResults.where((r) => r == null).length;
    final wrong = state.answerResults.where((r) => r == false).length;
    final percentage = (correct / state.totalQuestions * 100).round();

    final String resultTitle;
    final String resultSubtitle;
    final Color resultColor;

    if (percentage >= 80) {
      resultTitle = l.excellent;
      resultSubtitle = l.trueExpert;
      resultColor = const Color(0xFF34D399);
    } else if (percentage >= 60) {
      resultTitle = l.goodJob;
      resultSubtitle = l.keepPracticing;
      resultColor = AppColors.secondary;
    } else if (percentage >= 40) {
      resultTitle = l.notBad;
      resultSubtitle = l.canDoBetter;
      resultColor = AppColors.accentOrange;
    } else {
      resultTitle = l.keepTrying;
      resultSubtitle = l.practicePerfect;
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

                // ── Score Circle ───────────────────────────────────────
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
                      color: AppColors.textSecondary, fontSize: 16),
                ),

                const SizedBox(height: 32),

                // ── Stats Row ──────────────────────────────────────────
                Row(
                  children: [
                    _StatCard(
                      label: l.correct,
                      value: '$correct',
                      color: const Color(0xFF34D399),
                      icon: Icons.check_circle_rounded,
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      label: l.wrong,
                      value: '$wrong',
                      color: AppColors.accent,
                      icon: Icons.cancel_rounded,
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      label: l.skipped,
                      value: '$skipped',
                      color: AppColors.textSecondary,
                      icon: Icons.skip_next_rounded,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Score Earned ───────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.stars_rounded,
                          color: AppColors.accentOrange, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        l.creditsEarnedCount(state.score),
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

                // ── Action Buttons ─────────────────────────────────────
                if (!isDailyChallenge)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isFastMode) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => QuizBloc()
                                  ..add(StartQuiz(
                                    category: 'Fast Mode',
                                    questions: QuizData.fastModeQuestions,
                                    mode: QuizMode.fast,
                                  )),
                                child: const FastModeScreen(),
                              ),
                            ),
                          );
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => QuizBloc()
                                  ..add(StartQuiz(
                                    category: category,
                                    questions: state.questions,
                                  )),
                                child: QuizScreen(
                                  category: category,
                                  categoryIcon: categoryIcon,
                                  categoryColor: categoryColor,
                                ),
                              ),
                            ),
                          );
                        }
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
                      child: Text(
                        l.playAgain,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                if (!isDailyChallenge) const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: BorderSide(
                          color: AppColors.textSecondary.withOpacity(0.3)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      l.backToHome,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Answer Review ──────────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l.answerReview,
                    style: const TextStyle(
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

                  // Questions come directly from state — no static lookup needed
                  final questionText = state.questions[i].question;

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
                            questionText,
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

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
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
