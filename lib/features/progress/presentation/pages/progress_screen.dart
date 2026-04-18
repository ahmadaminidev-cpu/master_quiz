import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_loading.dart';
import '../bloc/progress_bloc.dart';
import '../widgets/progress_widgets.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressBloc, ProgressState>(
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
                // Progress Header with Menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: AppColors.textPrimary,
                      ),
                      color: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      onSelected: (value) {
                        // Logic will be added later
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'language',
                          child: Row(
                            children: [
                              Icon(Icons.translate_rounded, size: 20),
                              SizedBox(width: 12),
                              Text('Change Language'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'save_progress',
                          child: Row(
                            children: [
                              Icon(Icons.cloud_upload_rounded, size: 20),
                              SizedBox(width: 12),
                              Text('Save Progress'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Level and Main Progress Header
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
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.secondary),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Level',
                                  style: TextStyle(
                                      color: AppColors.textSecondary, fontSize: 14),
                                ),
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
                                  '${state.currentCredits} / ${state.maxCredits} Total',
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
                        '${state.currentCredits} Credits Earned',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.currentLevel < state.maxLevel
                            ? 'Only ${nextLevelCredits - state.currentCredits} credits to Level ${state.currentLevel + 1}'
                            : 'Maximum Level Reached!',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Milestone Section
                const Text(
                  'Your Milestones',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                MilestoneCard(
                  title: 'Credit Goal',
                  subtitle: 'Reach ${state.maxCredits} Credits',
                  progress: state.currentCredits / state.maxCredits,
                  icon: Icons.stars_rounded,
                  color: AppColors.accentOrange,
                ),
                const MilestoneCard(
                  title: 'Quiz Master',
                  subtitle: 'Solve 100 Questions',
                  progress: 0.62,
                  icon: Icons.lightbulb_rounded,
                  color: AppColors.secondary,
                ),
                const MilestoneCard(
                  title: 'Streak Hunter',
                  subtitle: 'Complete 7 Daily Challenges',
                  progress: 0.71,
                  icon: Icons.local_fire_department_rounded,
                  color: AppColors.accent,
                ),

                const SizedBox(height: 40),

                // Rewards/Achievements Section
                const Text(
                  'Unlocked Rewards',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: const [
                    RewardBadge(
                      title: 'Early Bird',
                      icon: Icons.wb_sunny_rounded,
                      color: Colors.amber,
                      isUnlocked: true,
                    ),
                    RewardBadge(
                      title: 'Quick Thinker',
                      icon: Icons.bolt_rounded,
                      color: Colors.cyan,
                      isUnlocked: true,
                    ),
                    RewardBadge(
                      title: 'Perfect Score',
                      icon: Icons.emoji_events_rounded,
                      color: Colors.orange,
                      isUnlocked: true,
                    ),
                    RewardBadge(
                      title: 'Night Owl',
                      icon: Icons.dark_mode_rounded,
                      color: Colors.indigoAccent,
                      isUnlocked: false,
                    ),
                    RewardBadge(
                      title: 'Grand Master',
                      icon: Icons.workspace_premium_rounded,
                      color: Colors.purpleAccent,
                      isUnlocked: false,
                    ),
                    RewardBadge(
                      title: 'Globetrotter',
                      icon: Icons.public_rounded,
                      color: Colors.greenAccent,
                      isUnlocked: false,
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
    );
  }
}
