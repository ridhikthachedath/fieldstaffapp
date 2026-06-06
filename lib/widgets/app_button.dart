import 'package:flutter/material.dart';
import 'package:field_staff_app/core/theme/app_colors.dart';
import 'package:field_staff_app/core/theme/app_text_styles.dart';

enum AppButtonVariant { primary, outline, login }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final double? height;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final h = height ?? (variant == AppButtonVariant.login ? 37 : 40);

    if (variant == AppButtonVariant.primary) {
      return SizedBox(
        width: double.infinity,
        height: h,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: _child(),
          ),
        ),
      );
    }

    if (variant == AppButtonVariant.login) {
      return SizedBox(
        width: double.infinity,
        height: h,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.loginButton,
            foregroundColor: AppColors.white,
            side: const BorderSide(color: AppColors.textPrimary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: _child(color: AppColors.white),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: h,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          side: const BorderSide(color: AppColors.primaryDark, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: _child(
          style: variant == AppButtonVariant.outline
              ? AppTextStyles.buttonOutline.copyWith(fontSize: 12)
              : AppTextStyles.buttonOutline,
        ),
      ),
    );
  }

  Widget _child({Color? color, TextStyle? style}) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: color ?? AppColors.white,
        ),
      );
    }
    return Text(
      label,
      style: style ??
          AppTextStyles.buttonPrimary.copyWith(
            color: color ?? AppColors.white,
          ),
    );
  }
}
