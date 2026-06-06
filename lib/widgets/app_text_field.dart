import 'package:flutter/material.dart';
import 'package:field_staff_app/core/theme/app_colors.dart';
import 'package:field_staff_app/core/theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final int maxLines;
  final Widget? suffix;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.suffix,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          style: AppTextStyles.bodyMedium.copyWith(
            color: readOnly && (controller?.text.isEmpty ?? true)
                ? AppColors.fieldBorder
                : AppColors.textPrimary,
            fontWeight: readOnly ? FontWeight.w700 : FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.fieldHint,
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            suffixIcon: suffix,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(maxLines > 1 ? 7 : 7),
              borderSide: const BorderSide(color: AppColors.fieldBorder, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: AppColors.rejected),
            ),
          ),
        ),
      ],
    );
  }
}

class AppLoginTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;

  const AppLoginTextField({
    super.key,
    required this.hint,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.placeholder),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.primaryDark),
        ),
      ),
    );
  }
}
