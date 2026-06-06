import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:field_staff_app/core/theme/app_colors.dart';
import 'package:field_staff_app/core/theme/app_text_styles.dart';
import 'package:field_staff_app/models/leave_model.dart';
import 'package:field_staff_app/viewmodels/leave_list_viewmodel.dart';
import 'package:field_staff_app/widgets/app_app_bar.dart';
import 'package:field_staff_app/widgets/loading_error_widgets.dart';
import 'package:field_staff_app/widgets/status_badge.dart';

class LeaveListView extends StatefulWidget {
  const LeaveListView({super.key});

  @override
  State<LeaveListView> createState() => _LeaveListViewState();
}

class _LeaveListViewState extends State<LeaveListView> {
  @override
  void initState() {
    super.initState();
    _loadLeaves();
  }

  void _loadLeaves() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<LeaveListViewModel>().loadLeaves();
    });
  }

  Future<void> _pickMonth() async {
    final vm = context.read<LeaveListViewModel>();
    final picked = await showDatePicker(
      context: context,
      initialDate: vm.selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Select Month',
    );
    if (picked != null) vm.setMonth(picked);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LeaveListViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppScreenHeader(
              title: 'Leave List',
              onBack: () => Navigator.pop(context),
              trailing: const ProfileAvatarButton(),
            ),
            const SizedBox(height: 8),
            FilterChipBar(
              labels: vm.filterTabs,
              selectedIndex: vm.filterTabs.indexOf(vm.selectedFilter),
              onSelected: (i) => vm.setFilter(vm.filterTabs[i]),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _FilterButton(
                      label: vm.monthLabel,
                      icon: Icons.keyboard_arrow_down,
                      onTap: _pickMonth,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _FilterButton(
                      label: 'Your Leave  ${vm.leaveCount.toString().padLeft(2, '0')}',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: _buildBody(vm)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LeaveListViewModel vm) {
    if (vm.isLoading && vm.leaves.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.errorMessage != null && vm.leaves.isEmpty) {
      return ErrorStateWidget(message: vm.errorMessage!, onRetry: vm.loadLeaves);
    }
    if (vm.leaves.isEmpty) {
      return const EmptyStateWidget(message: 'No leave records found.');
    }

    return RefreshIndicator(
      onRefresh: vm.loadLeaves,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        itemCount: vm.leaves.length,
        itemBuilder: (context, index) => _LeaveCard(leave: vm.leaves[index]),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 29,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.primaryDark, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.w700)),
            if (icon != null) Icon(icon, size: 14),
          ],
        ),
      ),
    );
  }
}

class _LeaveCard extends StatelessWidget {
  final LeaveModel leave;

  const _LeaveCard({required this.leave});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            leave.applicationLabel,
            style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            leave.displayDate ?? leave.startDate,
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            leave.leaveType,
            style: AppTextStyles.bodyRegular.copyWith(color: AppColors.leaveTypeAccent),
          ),
          const SizedBox(height: 12),
          LeaveStatusStepper(status: leave.status),
        ],
      ),
    );
  }
}
