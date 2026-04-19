import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/auth/auth_bloc.dart';
import '../../../../core/locale/app_localizations.dart';
import '../../../../core/locale/language_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../daily_challenge/presentation/bloc/daily_challenge_bloc.dart';
import '../../../quiz/data/quiz_data.dart';
import '../../../quiz/data/quiz_repository.dart';
import '../../../quiz/models/quiz_mode.dart';
import '../../../quiz/presentation/bloc/quiz_bloc.dart';
import '../../../quiz/presentation/bloc/exam_bloc.dart';
import '../../../quiz/presentation/bloc/power_up_bloc.dart';
import '../../../quiz/presentation/bloc/time_attack_bloc.dart';
import '../../../quiz/presentation/pages/fast_mode_screen.dart';
import '../../../quiz/presentation/pages/quiz_screen.dart';
import '../../../quiz/presentation/pages/exam_screen.dart';
import '../../../quiz/presentation/pages/power_up_screen.dart';
import '../../../quiz/presentation/pages/time_attack_screen.dart';
import '../bloc/category_bloc.dart';
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
                          border: Border.all(
                            color: AppColors.secondary,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: isSmallScreen ? 22 : 26,
                          backgroundColor: AppColors.surface,
                          backgroundImage: const NetworkImage(
                            'https://i.pravatar.cc/150?u=roxane',
                          ),
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
                      if (value == 'language') {
                        showLanguagePicker(context);
                      } else if (value == 'sign_in') {
                        context.read<AuthBloc>().add(AuthSignInRequested());
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      final isSignedIn =
                          context.read<AuthBloc>().state is AuthAuthenticated;
                      return [
                        PopupMenuItem<String>(
                          value: 'language',
                          child: Row(
                            children: [
                              const Icon(Icons.translate_rounded, size: 20),
                              const SizedBox(width: 12),
                              Text(AppLocalizations.of(context).changeLanguage),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: isSignedIn ? null : 'sign_in',
                          enabled: !isSignedIn,
                          child: Row(
                            children: [
                              Icon(
                                isSignedIn
                                    ? Icons.check_circle_rounded
                                    : Icons.cloud_upload_rounded,
                                size: 20,
                                color: isSignedIn
                                    ? AppColors.secondary
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                isSignedIn
                                    ? 'Already Logged In'
                                    : AppLocalizations.of(context).saveProgress,
                                style: TextStyle(
                                  color: isSignedIn
                                      ? AppColors.textSecondary
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Daily Challenge Card
              BlocBuilder<DailyChallengeBloc, DailyChallengeState>(
                builder: (context, dcState) {
                  final bool completed = dcState is DailyChallengeCompleted;
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
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (_) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (_) => QuizBloc()
                                            ..add(
                                              StartQuiz(
                                                category: 'Daily Challenge',
                                                questions: questions,
                                              ),
                                            ),
                                        ),
                                      ],
                                      child: QuizScreen(
                                        category: AppLocalizations.of(
                                          context,
                                        ).dailyChallengeCategory,
                                        categoryIcon: Icons.anchor_rounded,
                                        categoryColor: AppColors.primary,
                                        isDailyChallenge: true,
                                      ),
                                    ),
                                  ),
                                )
                                .then((_) {
                                  // Refresh daily challenge state after returning
                                  context.read<DailyChallengeBloc>().add(
                                    LoadDailyChallenge(),
                                  );
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
                            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
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
                                      AppLocalizations.of(
                                        context,
                                      ).dailyChallenge,
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
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF34D399,
                                          ).withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context).done,
                                          style: const TextStyle(
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
                                  AppLocalizations.of(
                                    context,
                                  ).dailyQuestionsXp(total),
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: AppColors.primary
                                        .withOpacity(0.1),
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
                                      completed
                                          ? AppLocalizations.of(
                                              context,
                                            ).completed
                                          : AppLocalizations.of(
                                              context,
                                            ).progress,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '$answered/$total',
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
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
              Text(
                AppLocalizations.of(context).quizCategories,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, catState) {
                  if (catState is CategoryLoading ||
                      catState is CategoryInitial) {
                    return _CategoryShimmer();
                  }
                  if (catState is CategoryError) {
                    return _CategoryError(
                      onRetry: () => context.read<CategoryBloc>().add(
                        RetryLoadCategories(),
                      ),
                    );
                  }
                  if (catState is CategoryLoaded) {
                    return _CategoryRow(
                      questionsByCategory: catState.questionsByCategory,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 36),

              // Games Mode Section
              Text(
                AppLocalizations.of(context).moreGames,
                style: const TextStyle(
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
                        title: AppLocalizations.of(context).fastMode,
                        subtitle: AppLocalizations.of(context).fastModeSub,
                        imagePath: 'assets/logo/fast_mode.png',
                        color: AppColors.primary,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => QuizBloc()
                                  ..add(
                                    StartQuiz(
                                      category: 'Fast Mode',
                                      questions: QuizData.fastModeQuestions,
                                      mode: QuizMode.fast,
                                    ),
                                  ),
                                child: const FastModeScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                      GameModeCard(
                        title: AppLocalizations.of(context).timeAttack,
                        subtitle: AppLocalizations.of(context).timeAttackSub,
                        imagePath: "assets/logo/time_attack.png",
                        color: AppColors.secondary,
                        onTap: () {
                          Navigator.of(context).push(
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
                      ),
                      GameModeCard(
                        title: AppLocalizations.of(context).powerUp,
                        subtitle: AppLocalizations.of(context).powerUpSub,
                        imagePath: "assets/logo/power_up.png",
                        color: AppColors.accent,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => PowerUpBloc(
                                  questions: QuizData.powerUpQuestions,
                                )..add(StartPowerUp()),
                                child: const PowerUpScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                      GameModeCard(
                        title: AppLocalizations.of(context).examMode,
                        subtitle: AppLocalizations.of(context).examModeSub,
                        imagePath: "assets/logo/exam_mode.png",
                        color: AppColors.accentOrange,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) =>
                                    ExamBloc(questions: QuizData.examQuestions)
                                      ..add(StartExam()),
                                child: const ExamScreen(),
                              ),
                            ),
                          );
                        },
                      ),
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

// ── Category metadata ─────────────────────────────────────────────────────────

const _categoryMeta = {
  'Science': (icon: Icons.biotech_rounded, color: AppColors.secondary),
  'History': (icon: Icons.history_edu_rounded, color: AppColors.accentOrange),
  'Programming': (icon: Icons.code_rounded, color: AppColors.primary),
  'DevOps ': (icon: Icons.cloud_rounded, color: Colors.tealAccent),
  'General Knowledge': (
    icon: Icons.lightbulb_rounded,
    color: Colors.purpleAccent,
  ),
};

// ── Category row (loaded) ─────────────────────────────────────────────────────

class _CategoryRow extends StatelessWidget {
  final Map<String, List<dynamic>> questionsByCategory;
  const _CategoryRow({required this.questionsByCategory});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final categories = QuizRepository.categoryNames;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categories.map((apiKey) {
          final meta =
              _categoryMeta[apiKey] ??
              (icon: Icons.quiz_rounded, color: AppColors.primary);
          final questions = questionsByCategory[apiKey] ?? [];
          return CategoryItem(
            label: l.categoryName(apiKey),
            icon: meta.icon,
            color: meta.color,
            questions: questions.cast(),
          );
        }).toList(),
      ),
    );
  }
}

// ── Shimmer placeholder ───────────────────────────────────────────────────────

class _CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: List.generate(5, (i) {
          return Container(
            margin: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                ShimmerEffect(
                  child: Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ShimmerEffect(
                  child: Container(
                    width: 56,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── Error state ───────────────────────────────────────────────────────────────

class _CategoryError extends StatelessWidget {
  final VoidCallback onRetry;
  const _CategoryError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            color: AppColors.textSecondary,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context).couldNotLoad,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              AppLocalizations.of(context).retry,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
