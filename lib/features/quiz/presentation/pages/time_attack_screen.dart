import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/locale/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/time_attack_bloc.dart';
import '../widgets/answer_option.dart';
import 'time_attack_result_screen.dart';

class TimeAttackScreen extends StatelessWidget {
  const TimeAttackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimeAttackBloc, TimeAttackState>(
      listener: (context, state) {
        if (state is TimeAttackFinished) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<TimeAttackBloc>(),
                child: const TimeAttackResultScreen(),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final l = AppLocalizations.of(context);
        if (state is! TimeAttackInProgress) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final q = state.currentQuestion;
        final optionLabels = ['A', 'B', 'C', 'D'];
        final timerProgress = state.timeRemaining / kTimeAttackDuration;
        final isUrgent = state.timeRemaining <= 10;
        final timerColor =
            isUrgent ? AppColors.accent : AppColors.accentOrange;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Container(
            decoration: const BoxDecoration(gradient: AppColors.mainGradient),
            child: SafeArea(
              child: Column(
                children: [
                  // ── Header ───────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        _CircleButton(
                          icon: Icons.close_rounded,
                          onTap: () => _showExitDialog(context),
                        ),
                        const SizedBox(width: 12),
                        // Global timer bar
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l.timeAttack,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.timer_rounded,
                                          color: timerColor, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${state.timeRemaining}s',
                                        style: TextStyle(
                                          color: timerColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  child: LinearProgressIndicator(
                                    value: timerProgress,
                                    backgroundColor:
                                        AppColors.surface,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                            timerColor),
                                    minHeight: 7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Score pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.secondary.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.bolt_rounded,
                                  color: AppColors.secondary, size: 15),
                              const SizedBox(width: 3),
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

                  const SizedBox(height: 16),

                  // ── Stats row ────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _StatPill(
                          label: l.answered,
                          value: '${state.answeredCount}',
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        _StatPill(
                          label: l.correct,
                          value: '${state.correctCount}',
                          color: const Color(0xFF34D399),
                        ),
                        const SizedBox(width: 10),
                        _StatPill(
                          label: l.wrong,
                          value:
                              '${state.answeredCount - state.correctCount}',
                          color: AppColors.accent,
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
                          color: AppColors.secondary.withOpacity(0.12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.timer_rounded,
                                    color: AppColors.secondary, size: 13),
                                const SizedBox(width: 5),
                                Text(
                                  l.timeAttack,
                                  style: const TextStyle(
                                    color: AppColors.secondary,
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

                  const SizedBox(height: 14),

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
                                      .read<TimeAttackBloc>()
                                      .add(TimeAttackAnswerSelected(i)),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    child: Text(
                      state.answered
                          ? l.nextComing
                          : l.answerFast,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
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

  AnswerOptionState _optionState(TimeAttackInProgress state, int index) {
    if (!state.answered) return AnswerOptionState.idle;
    if (index == state.currentQuestion.correctIndex) {
      return AnswerOptionState.correct;
    }
    if (index == state.selectedAnswer) return AnswerOptionState.wrong;
    return AnswerOptionState.idle;
  }

  void _showExitDialog(BuildContext context) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          l.quitTimeAttack,
          style: const TextStyle(
              color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Text(
          l.progressLost,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel,
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(l.quit,
                style: const TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }
}

// ── Supporting widgets ────────────────────────────────────────────────────────

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

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatPill(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
