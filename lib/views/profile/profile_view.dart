import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:field_staff_app/core/routes/app_routes.dart';
import 'package:field_staff_app/core/theme/app_colors.dart';
import 'package:field_staff_app/core/theme/app_text_styles.dart';
import 'package:field_staff_app/repositories/auth_repository.dart';
import 'package:field_staff_app/services/local_storage_service.dart';
import 'package:field_staff_app/widgets/app_app_bar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text('Log Out', style: AppTextStyles.greeting),
        content: const Text('Are you sure you want to log out from the application?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rejected,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final authRepo = context.read<AuthRepository>();
        await authRepo.logout();

        if (context.mounted) {
          // Close loading dialog
          Navigator.pop(context);

          // Navigate to login page and clear the navigation stack
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        }
      } catch (e) {
        if (context.mounted) {
          // Close loading dialog
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logout failed: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<LocalStorageService>();
    final employeeId = storage.employeeId?.toString() ?? 'N/A';
    final email = storage.userEmail ?? 'Not Provided';
    final mobile = storage.userMobile ?? 'Not Provided';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppScreenHeader(
              title: 'Profile',
              onBack: () => Navigator.pop(context),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Avatar and user header details
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primaryGradient,
                              boxShadow: AppColors.cardShadow,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            storage.userName ?? 'User Name',
                            style: AppTextStyles.greeting,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            storage.userRole ?? 'Role',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 16,
                                color: AppColors.primaryGreen,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                storage.userLocation ?? 'Location',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Information details
                    _buildInfoSection(
                      title: 'Personal Information',
                      items: [
                        _InfoItem(
                          icon: Icons.badge_outlined,
                          label: 'Employee ID',
                          value: employeeId,
                        ),
                        _InfoItem(
                          icon: Icons.phone_android_outlined,
                          label: 'Mobile Number',
                          value: mobile,
                        ),
                        _InfoItem(
                          icon: Icons.mail_outline_rounded,
                          label: 'Email Address',
                          value: email,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    GestureDetector(
                      onTap: () => _handleLogout(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.rejected.withValues(alpha: 0.2)),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout_rounded,
                              color: AppColors.rejected,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Log Out',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.rejected,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<_InfoItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 13),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: AppColors.cardShadow,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              indent: 56,
              endIndent: 16,
              color: AppColors.border,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.icon,
                        color: AppColors.primaryGreen,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: AppTextStyles.caption.copyWith(fontSize: 11),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.value,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}
