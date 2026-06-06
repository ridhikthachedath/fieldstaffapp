import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:field_staff_app/core/routes/app_routes.dart';
import 'package:field_staff_app/core/theme/app_colors.dart';
import 'package:field_staff_app/utils/date_formatter.dart';
import 'package:field_staff_app/viewmodels/apply_leave_viewmodel.dart';
import 'package:field_staff_app/viewmodels/leave_list_viewmodel.dart';
import 'package:field_staff_app/widgets/app_app_bar.dart';
import 'package:field_staff_app/widgets/app_button.dart';
import 'package:field_staff_app/widgets/app_text_field.dart';
import 'package:field_staff_app/widgets/loading_error_widgets.dart';
import 'package:field_staff_app/widgets/status_badge.dart';

class ApplyLeaveView extends StatefulWidget {
  const ApplyLeaveView({super.key});

  @override
  State<ApplyLeaveView> createState() => _ApplyLeaveViewState();
}

class _ApplyLeaveViewState extends State<ApplyLeaveView> {
  final _reasonController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _leaveTypeController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _leaveTypeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final vm = context.read<ApplyLeaveViewModel>();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        vm.setStartDate(picked);
        _fromController.text = DateFormatter.formatInput(picked);
        if (vm.isFullDay) {
          vm.setEndDate(picked);
          _toController.text = DateFormatter.formatInput(picked);
        }
      } else {
        vm.setEndDate(picked);
        _toController.text = DateFormatter.formatInput(picked);
      }
    });
  }

  Future<void> _selectLeaveType() async {
    final vm = context.read<ApplyLeaveViewModel>();
    final type = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: vm.leaveTypes
              .map(
                (t) => ListTile(
                  title: Text(t),
                  onTap: () => Navigator.pop(context, t),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (type != null) {
      vm.setLeaveType(type);
      _leaveTypeController.text = type;
    }
  }

  Future<void> _submit() async {
    final vm = context.read<ApplyLeaveViewModel>();
    vm.setReason(_reasonController.text);
    final success = await vm.submitLeave();
    if (!mounted) return;
    if (success) {
      context.read<LeaveListViewModel>().loadLeaves();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leave applied successfully')),
      );
      Navigator.pop(context);
    } else if (vm.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ApplyLeaveViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppScreenHeader(
                  title: 'Apply Leave',
                  onBack: () => Navigator.pop(context),
                  trailing: const ProfileAvatarButton(),
                ),
                const SizedBox(height: 8),
                Center(
                  child: LeaveModeToggle(
                    isFullDay: vm.isFullDay,
                    onChanged: vm.setLeaveMode,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        children: [
                          AppTextField(
                            label: 'From',
                            hint: 'DD/MM/YYYY',
                            controller: _fromController,
                            readOnly: true,
                            onTap: () => _pickDate(isStart: true),
                            suffix: const Icon(Icons.calendar_today, size: 15),
                          ),
                          const SizedBox(height: 24),
                          if (vm.isFullDay)
                            AppTextField(
                              label: 'To',
                              hint: 'DD/MM/YYYY',
                              controller: _toController,
                              readOnly: true,
                              onTap: () => _pickDate(isStart: false),
                              suffix: const Icon(Icons.calendar_today, size: 15),
                            ),
                          const SizedBox(height: 24),
                          AppTextField(
                            label: 'Reason',
                            hint: 'Enter Leave reason',
                            controller: _reasonController,
                            maxLines: 3,
                            onChanged: vm.setReason,
                          ),
                          const SizedBox(height: 24),
                          AppTextField(
                            label: 'Leave Type',
                            hint: 'Select your Leave type',
                            controller: _leaveTypeController,
                            readOnly: true,
                            onTap: _selectLeaveType,
                            suffix: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      AppButton(
                        label: 'Apply',
                        isLoading: vm.isLoading,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 10),
                      AppButton(
                        label: 'Leave List',
                        variant: AppButtonVariant.outline,
                        onPressed: () async {
                          await context.read<LeaveListViewModel>().loadLeaves();
                          if (!context.mounted) return;
                          await Navigator.pushNamed(context, AppRoutes.leaveList);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppLoadingOverlay(isLoading: vm.isLoading),
          ],
        ),
      ),
    );
  }
}
