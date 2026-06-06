import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:field_staff_app/core/routes/app_routes.dart';
import 'package:field_staff_app/core/theme/app_colors.dart';
import 'package:field_staff_app/core/theme/app_text_styles.dart';
import 'package:field_staff_app/viewmodels/dashboard_viewmodel.dart';
import 'package:field_staff_app/widgets/activity_card.dart';
import 'package:field_staff_app/widgets/loading_error_widgets.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewModel>().loadDashboard();
    });
  }

  Future<void> _markAttendance(DashboardViewModel vm) async {
    final success = await vm.markAttendance();
    if (!mounted) return;
    if (success && vm.successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.successMessage!)),
      );
      vm.clearSuccessMessage();
    } else if (vm.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage!)),
      );
    }
  }

  void _openRoute(DashboardViewModel vm) {
    if (!vm.canViewRoute) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete Mark In and Mark Out to view your route.'),
        ),
      );
      return;
    }
    Navigator.pushNamed(context, AppRoutes.routeList);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: vm.loadDashboard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildProfile(vm),
                    const SizedBox(height: 24),
                    AttendanceBanner(
                      title: vm.attendanceCardTitle,
                      subtitle: vm.attendanceCardSubtitle,
                      buttonLabel: vm.markButtonLabel,
                      isLoading: vm.isLoading,
                      showButton: !vm.isMarkedOut,
                      isActive: vm.isMarkedIn && !vm.isMarkedOut,
                      isCompleted: vm.isMarkedOut,
                      onMark: vm.isMarkedOut ? null : () => _markAttendance(vm),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.5),
                      child: Row(
                        children: [
                          QuickActionCard(
                            title: 'Route',
                            icon: Icons.route,
                            isPrimary: true,
                            onTap: () => _openRoute(vm),
                          ),
                          const SizedBox(width: 12),
                          QuickActionCard(
                            title: 'Apply Leave',
                            icon: Icons.calendar_month_outlined,
                            isPrimary: false,
                            onTap: () => Navigator.pushNamed(
                                context, AppRoutes.applyLeave),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildRecentActivity(vm),
                  ],
                ),
              ),
            ),
            if (vm.isLoading && vm.recentActivities.isEmpty)
              const AppLoadingOverlay(isLoading: true),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(DashboardViewModel vm) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
              border: Border.all(color: AppColors.primaryGreen, width: 2),
            ),
            child:
                const Icon(Icons.person, size: 36, color: AppColors.primaryDark),
          ),
        ),
        const SizedBox(height: 8),
        Text('Hi ${vm.userName}', style: AppTextStyles.greeting),
        Text(vm.userRole, style: AppTextStyles.bodyRegular),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on,
                size: 12, color: AppColors.primaryDark),
            const SizedBox(width: 2),
            Text(
              vm.userLocation,
              style: AppTextStyles.bodyRegular
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity(DashboardViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Activity', style: AppTextStyles.sectionTitle),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.routeList),
                child: Row(
                  children: [
                    Text('View All', style: AppTextStyles.sectionTitle),
                    const Icon(Icons.chevron_right, size: 18),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (vm.recentActivities.isEmpty && !vm.isLoading)
            const EmptyStateWidget(message: 'No recent activity yet.')
          else
            ...vm.recentActivities.map(
              (a) => ActivityCard(
                date: a.date,
                subtitle: a.subtitle,
                onTap: () {
                  if (a.originalRoute != null) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.routeMap,
                      arguments: a.originalRoute,
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
