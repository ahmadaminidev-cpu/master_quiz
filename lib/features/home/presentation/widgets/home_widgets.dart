import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../quiz/models/quiz_question.dart';
import '../../../quiz/presentation/bloc/quiz_bloc.dart';
import '../../../quiz/presentation/pages/quiz_screen.dart';

class CategoryItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final List<QuizQuestion> questions;

  const CategoryItem({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (questions.isEmpty) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => QuizBloc()
                ..add(StartQuiz(category: label, questions: questions)),
              child: QuizScreen(
                category: label,
                categoryIcon: icon,
                categoryColor: color,
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? imagePath;
  final Color color;
  final VoidCallback? onTap;

  const GameModeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imagePath != null && imagePath!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: color.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / icon badge
            Container(
              width: 60,
              height: 60,
              padding: hasImage
                  ? const EdgeInsets.all(6)
                  : const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: hasImage
                  ? Image.asset(imagePath!, fit: BoxFit.contain)
                  : Icon(icon, size: 26, color: color),
            ),
            const Spacer(),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Play',
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.play_arrow_rounded,
                      color: color, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
