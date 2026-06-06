import 'package:flutter/material.dart';
import 'package:field_staff_app/core/theme/app_colors.dart';

class LeaveStatusStepper extends StatelessWidget {
  final String status;

  const LeaveStatusStepper({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final isApproved = normalized.contains('approve');
    final isRejected = normalized.contains('reject');
    final isPending = !isApproved && !isRejected;

    return Row(
      children: [
        _Step(label: 'Create', completed: true),
        _connector(),
        _Step(label: 'Review', completed: true),
        _connector(),
        _Step(
          label: isApproved
              ? 'Approved'
              : isRejected
                  ? 'Rejected'
                  : 'Pending',
          completed: isApproved,
          pending: isPending,
          rejected: isRejected,
        ),
      ],
    );
  }

  Widget _connector() {
    return Expanded(
      child: Container(
        height: 1,
        margin: const EdgeInsets.only(bottom: 12),
        color: AppColors.border,
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String label;
  final bool completed;
  final bool pending;
  final bool rejected;

  const _Step({
    required this.label,
    this.completed = false,
    this.pending = false,
    this.rejected = false,
  });

  @override
  Widget build(BuildContext context) {
    Color circleColor = AppColors.border;
    Widget icon = const SizedBox.shrink();

    if (completed) {
      circleColor = AppColors.approved;
      icon = const Icon(Icons.check, size: 10, color: AppColors.white);
    } else if (pending) {
      circleColor = AppColors.pending;
      icon = const Icon(Icons.remove, size: 10, color: AppColors.white);
    } else if (rejected) {
      circleColor = AppColors.rejected;
      icon = const Icon(Icons.close, size: 10, color: AppColors.white);
    }

    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          child: Center(child: icon),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class FilterChipBar extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const FilterChipBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final selected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  gradient: selected ? AppColors.primaryGradient : null,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Text(
                  _capitalize(labels[index]),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  String _capitalize(String value) {
    if (value == 'all') return 'All';
    if (value == 'rejected') return 'Reject';
    return value[0].toUpperCase() + value.substring(1);
  }
}

class LeaveModeToggle extends StatelessWidget {
  final bool isFullDay;
  final ValueChanged<bool> onChanged;

  const LeaveModeToggle({
    super.key,
    required this.isFullDay,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 306,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            alignment: isFullDay ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(true),
                  child: Center(
                    child: Text(
                      'Full Day',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isFullDay ? AppColors.white : AppColors.primaryDark,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(false),
                  child: Center(
                    child: Text(
                      'Half Day',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: !isFullDay ? AppColors.white : AppColors.primaryDark,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
