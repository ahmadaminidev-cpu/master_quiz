import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../daily_challenge/presentation/bloc/daily_challenge_bloc.dart';
import '../../../quiz/data/quiz_data.dart';
import '../../../quiz/models/quiz_mode.dart';
import '../../../quiz/presentation/bloc/quiz_bloc.dart';
import '../../../quiz/presentation/pages/fast_mode_screen.dart';
import '../../../quiz/presentation/pages/quiz_screen.dart';
import '../bloc/home_bloc.dart';
import '../widgets/home_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 360;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading || state is HomeInitial) {
          return const HomeSkeleton();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Profile Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.secondary, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: isSmallScreen ? 22 : 26,
                          backgroundColor: AppColors.surface,
                          backgroundImage: const NetworkImage(
                              'https://i.pravatar.cc/150?u=roxane'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Roxane Harley',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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
              const SizedBox(height: 32),

              // Daily Challenge Card
              BlocBuilder<DailyChallengeBloc, DailyChallengeState>(
                builder: (context, dcState) {
                  final bool completed =
                      dcState is DailyChallengeCompleted;
                  final int answered = dcState is DailyChallengeAvailable
                      ? dcState.answeredCount
                      : dcState is DailyChallengeCompleted
                          ? dcState.totalQuestions
                          : 0;
                  const int total = DailyChallengeBloc.totalQuestions;
                  final double progress = answered / total;

                  return GestureDetector(
                    onTap: completed
                        ? null
                        : () {
                            final questions = QuizData.dailyQuestions;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (_) => QuizBloc()
                                        ..add(StartQuiz(
                                          category: 'Daily Challenge',
                                          questions: questions,
                                        )),
                                    ),
                                  ],
                                  child: QuizScreen(
                                    category: 'Daily Challenge',
                                    categoryIcon: Icons.anchor_rounded,
                                    categoryColor: AppColors.primary,
                                    isDailyChallenge: true,
                                  ),
                                ),
                              ),
                            ).then((_) {
                              // Refresh daily challenge state after returning
                              context
                                  .read<DailyChallengeBloc>()
                                  .add(LoadDailyChallenge());
                            });
                          },
                    child: Container(
                      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: completed
                              ? [
                                  const Color(0xFF34D399).withOpacity(0.15),
                                  const Color(0xFF34D399).withOpacity(0.05),
                                ]
                              : [
                                  AppColors.primary.withOpacity(0.2),
                                  AppColors.primary.withOpacity(0.05),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: completed
                              ? const Color(0xFF34D399).withOpacity(0.25)
                              : AppColors.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding:
                                EdgeInsets.all(isSmallScreen ? 12 : 16),
                            decoration: BoxDecoration(
                              color: completed
                                  ? const Color(0xFF34D399).withOpacity(0.15)
                                  : AppColors.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              completed
                                  ? Icons.check_circle_rounded
                                  : Icons.anchor_rounded,
                              size: isSmallScreen ? 36 : 48,
                              color: completed
                                  ? const Color(0xFF34D399)
                                  : AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Daily Challenge',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: isSmallScreen ? 18 : 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (completed) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF34D399)
                                              .withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'Done',
                                          style: TextStyle(
                                            color: Color(0xFF34D399),
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  '$total Questions • 50 XP',
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13),
                                ),
                                const SizedBox(height: 14),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor:
                                        AppColors.primary.withOpacity(0.1),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      completed
                                          ? const Color(0xFF34D399)
                                          : AppColors.accentOrange,
                                    ),
                                    minHeight: 8,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      completed ? 'Completed!' : 'Progress',
                                      style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      '$answered/$total',
                                      style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 36),

              // Quiz Categories
              const Text(
                'Quiz Categories',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    const CategoryItem(
                        label: 'Football',
                        icon: Icons.sports_soccer_rounded,
                        color: AppColors.accentOrange),
                    const CategoryItem(
                        label: 'Science',
                        icon: Icons.biotech_rounded,
                        color: AppColors.secondary),
                    const CategoryItem(
                        label: 'Fashion',
                        icon: Icons.checkroom_rounded,
                        color: AppColors.accent),
                    CategoryItem(
                        label: 'Movie',
                        icon: Icons.movie_filter_rounded,
                        color: Colors.purpleAccent),
                    CategoryItem(
                        label: 'Music',
                        icon: Icons.music_note_rounded,
                        color: Colors.tealAccent),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Games Mode Section
              const Text(
                'More Games',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final double aspectRatio = isSmallScreen ? 0.75 : 0.85;

                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: aspectRatio,
                    children: [
                      GameModeCard(
                          title: 'Fast Mode',
                          subtitle: '10 Qs • 5s each',
                          icon: Icons.speed_rounded,
                          players: '24.7K',
                          color: AppColors.primary,
                          onTap: () {
                            Navigator.of(context).push(
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
                          }),
                      const GameModeCard(
                          title: 'Time Attack',
                          subtitle: 'Infinite • 1 min',
                          icon: Icons.timer_rounded,
                          players: '12.5K',
                          color: AppColors.secondary),
                      const GameModeCard(
                          title: 'Power Up',
                          subtitle: '10 Qs • Hard',
                          icon: Icons.bolt_rounded,
                          players: '18.2K',
                          color: AppColors.accent),
                      const GameModeCard(
                          title: 'Exam Mode',
                          subtitle: '50 Qs • Pro',
                          icon: Icons.menu_book_rounded,
                          players: '5.1K',
                          color: AppColors.accentOrange),
                    ],
                  );
                },
              ),
              const SizedBox(height: 120),
            ],
          ),
        );
      },
    );
  }
}
