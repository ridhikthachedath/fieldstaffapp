import 'package:flutter/material.dart';
import 'package:field_staff_app/core/theme/app_colors.dart';
import 'package:field_staff_app/core/theme/app_text_styles.dart';
import 'package:field_staff_app/widgets/app_button.dart';

class AppLoadingOverlay extends StatelessWidget {
  final bool isLoading;

  const AppLoadingOverlay({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();
    return Container(
      color: Colors.black26,
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primaryGreen),
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              AppButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorStateWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.rejected),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              AppButton(label: 'Retry', onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
