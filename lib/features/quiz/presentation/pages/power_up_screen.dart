import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/auth/auth_bloc.dart';
import '../../../../core/locale/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../progress/presentation/bloc/progress_bloc.dart';
import '../bloc/power_up_bloc.dart';
import '../widgets/answer_option.dart';
import 'power_up_result_screen.dart';

class PowerUpScreen extends StatelessWidget {
  const PowerUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PowerUpBloc, PowerUpState>(
      listener: (context, state) {
        if (state is PowerUpFinished) {
          // Add credits only if signed in
          final authState = context.read<AuthBloc>().state;
          if (authState is AuthAuthenticated) {
            context.read<ProgressBloc>().add(AddCredits(state.score));
          }

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<PowerUpBloc>(),
                child: const PowerUpResultScreen(),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final l = AppLocalizations.of(context);
        if (state is! PowerUpInProgress) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final q = state.currentQuestion;
        final optionLabels = ['A', 'B', 'C', 'D'];
        final timerProgress =
            state.timeRemaining / kPowerUpQuestionDuration;
        final isUrgent = state.timeRemaining <= 3;
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
                              Text(
                                l.powerUp,
                                style: const TextStyle(
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
                            color: AppColors.accent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.accent.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.bolt_rounded,
                                  color: AppColors.accent, size: 16),
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
                                  : AppColors.textSecondary.withOpacity(0.3);
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

                  const SizedBox(height: 16),

                  // ── Countdown ring ───────────────────────────────────────
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 72,
                        height: 72,
                        child: CircularProgressIndicator(
                          value: timerProgress.clamp(0.0, 1.0),
                          strokeWidth: 5,
                          backgroundColor: AppColors.surface,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(timerColor),
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
                          color: AppColors.accent.withOpacity(0.12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.bolt_rounded,
                                    color: AppColors.accent, size: 13),
                                const SizedBox(width: 5),
                                Text(
                                  l.powerUp,
                                  style: const TextStyle(
                                    color: AppColors.accent,
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

                  const SizedBox(height: 12),

                  // ── Answer Options ───────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: List.generate(q.options.length, (i) {
                          final isEliminated =
                              state.hiddenOptions.contains(i) &&
                                  !state.answered;
                          return Padding(
                            key: ValueKey('q${state.currentIndex}_opt$i'),
                            padding: const EdgeInsets.only(bottom: 10),
                            child: AnswerOption(
                              label: optionLabels[i],
                              text: q.options[i],
                              state: isEliminated
                                  ? AnswerOptionState.eliminated
                                  : _optionState(state, i),
                              onTap: (state.answered || isEliminated)
                                  ? null
                                  : () => context
                                      .read<PowerUpBloc>()
                                      .add(PowerUpAnswerSelected(i)),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  // ── Next button (after answering) ────────────────────────
                  if (state.answered)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context
                              .read<PowerUpBloc>()
                              .add(PowerUpNextQuestion()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
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
                                ? l.seeResults
                                : l.nextQuestion,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                  // ── Power-up bar ─────────────────────────────────────────
                  _PowerUpBar(
                    eliminateUsed: state.eliminateUsed,
                    addTimeUsesLeft: state.addTimeUsesLeft,
                    answered: state.answered,
                    onEliminate: () =>
                        context.read<PowerUpBloc>().add(UseEliminate()),
                    onAddTime: () =>
                        context.read<PowerUpBloc>().add(UseAddTime()),
                    labelEliminate: l.eliminate,
                    labelTwoWrong: l.twoWrong,
                    labelPlus5s: l.plus5s,
                    labelExtraTime: l.extraTime,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AnswerOptionState _optionState(PowerUpInProgress state, int index) {
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
          l.quitPowerUp,
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

// ── Power-up bar ──────────────────────────────────────────────────────────────

class _PowerUpBar extends StatelessWidget {
  final bool eliminateUsed;
  final int addTimeUsesLeft;
  final bool answered;
  final VoidCallback onEliminate;
  final VoidCallback onAddTime;
  final String labelEliminate;
  final String labelTwoWrong;
  final String labelPlus5s;
  final String labelExtraTime;

  const _PowerUpBar({
    required this.eliminateUsed,
    required this.addTimeUsesLeft,
    required this.answered,
    required this.onEliminate,
    required this.onAddTime,
    required this.labelEliminate,
    required this.labelTwoWrong,
    required this.labelPlus5s,
    required this.labelExtraTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.6),
        border: Border(
          top: BorderSide(
              color: AppColors.textSecondary.withOpacity(0.08)),
        ),
      ),
      child: Row(
        children: [
          // Eliminate 2 wrong — 1 use
          Expanded(
            child: _PowerUpButton(
              icon: Icons.filter_2_rounded,
              label: labelEliminate,
              sublabel: labelTwoWrong,
              color: const Color(0xFF34D399),
              usesLeft: eliminateUsed ? 0 : 1,
              maxUses: 1,
              disabled: eliminateUsed || answered,
              onTap: onEliminate,
            ),
          ),
          const SizedBox(width: 14),
          // Add time — 2 uses
          Expanded(
            child: _PowerUpButton(
              icon: Icons.add_circle_outline_rounded,
              label: labelPlus5s,
              sublabel: labelExtraTime,
              color: AppColors.secondary,
              usesLeft: addTimeUsesLeft,
              maxUses: kMaxAddTimeUses,
              disabled: addTimeUsesLeft <= 0 || answered,
              onTap: onAddTime,
            ),
          ),
        ],
      ),
    );
  }
}

class _PowerUpButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final int usesLeft;
  final int maxUses;
  final bool disabled;
  final VoidCallback onTap;

  const _PowerUpButton({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.usesLeft,
    required this.maxUses,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: disabled ? 0.35 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      sublabel,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              // Use-count dots
              Column(
                children: List.generate(maxUses, (i) {
                  final filled = i < usesLeft;
                  return Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.only(bottom: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled
                          ? color
                          : color.withOpacity(0.2),
                    ),
                  );
                }),
              ),
            ],
          ),
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
