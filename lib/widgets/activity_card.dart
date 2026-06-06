import 'package:flutter/material.dart';
import 'package:field_staff_app/core/theme/app_colors.dart';
import 'package:field_staff_app/core/theme/app_text_styles.dart';

class ActivityCard extends StatelessWidget {
  final String date;
  final String subtitle;
  final VoidCallback? onTap;

  const ActivityCard({
    super.key,
    required this.date,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(7),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.person_outline, size: 18),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date,
                      style: AppTextStyles.bodyRegular.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      )),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 98,
          decoration: BoxDecoration(
            gradient: isPrimary ? AppColors.cardGradient : null,
            color: isPrimary ? null : AppColors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: isPrimary ? null : AppColors.cardShadow,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isPrimary
                      ? Colors.white.withValues(alpha: 0.2)
                      : AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isPrimary ? AppColors.white : AppColors.primaryDark,
                  size: 20,
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: isPrimary ? AppColors.white : AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AttendanceBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback? onMark;
  final bool isLoading;
  final bool showButton;
  final bool isActive;
  final bool isCompleted;

  const AttendanceBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    this.onMark,
    this.isLoading = false,
    this.showButton = true,
    this.isActive = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final textAlignment =
        isCompleted ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = isCompleted ? TextAlign.center : TextAlign.start;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.fromLTRB(20, 13, 13, 13),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(60),
        border: isActive
            ? Border.all(color: AppColors.attendanceActiveBorder, width: 4)
            : null,
      ),
      child: Row(
        mainAxisAlignment:
            isCompleted ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Flexible(
            fit: isCompleted ? FlexFit.loose : FlexFit.tight,
            child: Column(
              crossAxisAlignment: textAlignment,
              children: [
                Text(
                  title,
                  textAlign: textAlign,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  textAlign: textAlign,
                  style: AppTextStyles.bodyRegular
                      .copyWith(color: AppColors.white),
                ),
              ],
            ),
          ),
          if (showButton)
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: isLoading ? null : onMark,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            buttonLabel.contains('Out')
                                ? Icons.logout
                                : Icons.login,
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            buttonLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
