import 'package:field_staff_app/core/constants/app_constants.dart';
import 'package:field_staff_app/repositories/leave_repository.dart';
import 'package:field_staff_app/services/local_storage_service.dart';
import 'package:field_staff_app/utils/date_formatter.dart';
import 'package:field_staff_app/viewmodels/base_viewmodel.dart';

class ApplyLeaveViewModel extends BaseViewModel {
  final LeaveRepository _leaveRepository;
  final LocalStorageService _storage;

  bool isFullDay = true;
  String? selectedLeaveType;
  DateTime? startDate;
  DateTime? endDate;
  String reason = '';

  ApplyLeaveViewModel(this._leaveRepository, this._storage);

  List<String> get leaveTypes => AppConstants.leaveTypes;

  void setLeaveMode(bool fullDay) {
    isFullDay = fullDay;
    notifyListeners();
  }

  void setLeaveType(String? type) {
    selectedLeaveType = type;
    notifyListeners();
  }

  void setStartDate(DateTime date) {
    startDate = date;
    if (isFullDay && endDate == null) endDate = date;
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    endDate = date;
    notifyListeners();
  }

  void setReason(String value) {
    reason = value;
  }

  Future<bool> submitLeave() async {
    final userId = _storage.userId;
    if (userId == null) {
      setError('User session not found. Please login again.');
      return false;
    }
    if (selectedLeaveType == null) {
      setError('Please select a leave type');
      return false;
    }
    if (startDate == null) {
      setError('Please select start date');
      return false;
    }
    if (!isFullDay && endDate == null) {
      endDate = startDate;
    }
    if (endDate == null) {
      setError('Please select end date');
      return false;
    }
    if (reason.trim().isEmpty) {
      setError('Please enter leave reason');
      return false;
    }

    setLoading();
    try {
      await _leaveRepository.applyLeave(
        leaveMode: isFullDay ? 'full_day' : 'half_day',
        leaveType: selectedLeaveType!,
        startDate: DateFormatter.formatApi(startDate!),
        endDate: DateFormatter.formatApi(endDate!),
        reason: reason.trim(),
        userId: userId,
      );
      setSuccess();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }
}
