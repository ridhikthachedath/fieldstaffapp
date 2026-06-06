import 'package:flutter/material.dart';
import 'package:field_staff_app/core/routes/app_routes.dart';
import 'package:field_staff_app/core/theme/app_colors.dart';
import 'package:field_staff_app/core/theme/app_text_styles.dart';

class AppScreenHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  const AppScreenHeader({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(11, 4, 16, 0),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: onBack != null ? 0 : 22),
              child: Text(title, style: AppTextStyles.screenTitle),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class ProfileAvatarButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;

  const ProfileAvatarButton({super.key, this.onTap, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.pushNamed(context, AppRoutes.profile),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Icon(Icons.person, size: size * 0.6, color: AppColors.primaryDark),
      ),
    );
  }
}
