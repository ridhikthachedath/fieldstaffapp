import 'package:flutter/material.dart';
import 'package:field_staff_app/core/theme/app_colors.dart';

class AppTextStyles {
  static const String fontFamily = 'Inter';

  static TextStyle screenTitle = const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle greeting = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle sectionTitle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDark,
    height: 1.4,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle bodyRegular = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle caption = const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle buttonPrimary = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
    height: 1.4,
  );

  static TextStyle buttonOutline = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryDark,
    height: 1.4,
  );

  static TextStyle fieldLabel = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle fieldHint = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.fieldBorder,
    height: 1.4,
  );
}
