import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/auth/auth_bloc.dart';
import '../../../../core/locale/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_loading.dart';
import '../bloc/progress_bloc.dart';
import '../widgets/progress_widgets.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return BlocListener<ProgressBloc, ProgressState>(
      listener: (context, state) {
        if (state is ProgressSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Progress saved to cloud ☁️'),
              backgroundColor: AppColors.secondary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
        if (state is ProgressError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Save failed: ${state.message}'),
              backgroundColor: AppColors.accent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      child: BlocBuilder<ProgressBloc, ProgressState>(
      builder: (context, state) {
        if (state is ProgressLoading || state is ProgressInitial) {
          return const ProgressSkeleton();
        }

        if (state is ProgressLoaded) {
          final int nextLevelCredits = state.currentLevel * 200;
          final int currentLevelStart = (state.currentLevel - 1) * 200;
          final double levelProgress =
              (state.currentCredits - currentLevelStart) / 200;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Row(
                  children: [
                    // Signed-in user chip
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, authState) {
                        if (authState is AuthAuthenticated) {
                          return Row(
                            children: [
                              if (authState.user.photoURL != null)
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(authState.user.photoURL!),
                                  radius: 16,
                                ),
                              const SizedBox(width: 8),
                              Text(
                                authState.user.displayName ?? authState.user.email ?? '',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),

                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: CircularProgressIndicator(
                              value: levelProgress,
                              strokeWidth: 12,
                              backgroundColor:
                                  AppColors.primary.withOpacity(0.1),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.secondary),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(l.level,
                                    style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 14)),
                                Text(
                                  '${state.currentLevel}',
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 52,
                                    height: 1.1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${state.currentCredits} / ${state.maxCredits} ${l.level}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.secondary.withOpacity(0.8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l.creditsEarnedCount(state.currentCredits),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.currentLevel < state.maxLevel
                            ? l.creditsToNextLevel(
                                nextLevelCredits - state.currentCredits,
                                state.currentLevel + 1)
                            : l.maxLevel,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                Text(l.yourMilestones,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 16),
                MilestoneCard(
                  title: l.creditGoal,
                  subtitle: l.reachCredits(state.maxCredits),
                  progress: (state.milestones['credit_goal'] ?? 0.0).clamp(0.0, 1.0),
                  icon: Icons.stars_rounded,
                  color: AppColors.accentOrange,
                ),
                MilestoneCard(
                  title: l.quizMaster,
                  subtitle: l.solve100,
                  progress: (state.milestones['quiz_master'] ?? 0.0).clamp(0.0, 1.0),
                  icon: Icons.lightbulb_rounded,
                  color: AppColors.secondary,
                ),
                MilestoneCard(
                  title: l.streakHunter,
                  subtitle: l.complete7,
                  progress: (state.milestones['streak_hunter'] ?? 0.0).clamp(0.0, 1.0),
                  icon: Icons.local_fire_department_rounded,
                  color: AppColors.accent,
                ),

                const SizedBox(height: 40),

                Text(l.unlockedRewards,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    RewardBadge(
                      title: l.earlyBird,
                      icon: Icons.wb_sunny_rounded,
                      color: Colors.amber,
                      isUnlocked: state.achievements.contains('Early Bird'),
                    ),
                    RewardBadge(
                      title: l.quickThinker,
                      icon: Icons.bolt_rounded,
                      color: Colors.cyan,
                      isUnlocked: state.achievements.contains('Quick Thinker'),
                    ),
                    RewardBadge(
                      title: l.perfectScore,
                      icon: Icons.emoji_events_rounded,
                      color: Colors.orange,
                      isUnlocked: state.achievements.contains('Perfect Score'),
                    ),
                    RewardBadge(
                      title: l.nightOwl,
                      icon: Icons.dark_mode_rounded,
                      color: Colors.indigoAccent,
                      isUnlocked: state.achievements.contains('Night Owl'),
                    ),
                    RewardBadge(
                      title: l.grandMaster,
                      icon: Icons.workspace_premium_rounded,
                      color: Colors.purpleAccent,
                      isUnlocked: state.achievements.contains('Grand Master'),
                    ),
                    RewardBadge(
                      title: l.globetrotter,
                      icon: Icons.public_rounded,
                      color: Colors.greenAccent,
                      isUnlocked: state.achievements.contains('Globetrotter'),
                    ),
                  ],
                ),
                const SizedBox(height: 120),
              ],
            ),
          );
        }

        return const Center(child: Text('Error loading progress'));
      },
      ),
    );
  }
}
