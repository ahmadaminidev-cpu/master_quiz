import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

enum AnswerOptionState { idle, correct, wrong }

class AnswerOption extends StatelessWidget {
  final String label;
  final String text;
  final AnswerOptionState state;
  final VoidCallback? onTap;

  const AnswerOption({
    super.key,
    required this.label,
    required this.text,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor;
    final Color bgColor;
    final Color labelBg;
    final Color textColor;
    final Widget? trailingIcon;

    switch (state) {
      case AnswerOptionState.correct:
        borderColor = const Color(0xFF34D399); // emerald
        bgColor = const Color(0xFF34D399).withOpacity(0.12);
        labelBg = const Color(0xFF34D399).withOpacity(0.2);
        textColor = AppColors.textPrimary;
        trailingIcon = const Icon(Icons.check_circle_rounded,
            color: Color(0xFF34D399), size: 22);
        break;
      case AnswerOptionState.wrong:
        borderColor = AppColors.accent;
        bgColor = AppColors.accent.withOpacity(0.12);
        labelBg = AppColors.accent.withOpacity(0.2);
        textColor = AppColors.textPrimary;
        trailingIcon = const Icon(Icons.cancel_rounded,
            color: AppColors.accent, size: 22);
        break;
      case AnswerOptionState.idle:
        borderColor = AppColors.textSecondary.withOpacity(0.15);
        bgColor = AppColors.surface;
        labelBg = AppColors.primary.withOpacity(0.1);
        textColor = AppColors.textPrimary;
        trailingIcon = Icon(Icons.circle_outlined,
            color: AppColors.textSecondary.withOpacity(0.4), size: 22);
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: labelBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: state == AnswerOptionState.idle
                      ? AppColors.primary
                      : textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailingIcon,
          ],
        ),
      ),
    );
  }
}
