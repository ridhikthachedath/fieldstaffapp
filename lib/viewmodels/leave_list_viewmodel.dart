import 'package:field_staff_app/core/constants/app_constants.dart';
import 'package:field_staff_app/models/leave_model.dart';
import 'package:field_staff_app/repositories/leave_repository.dart';
import 'package:field_staff_app/services/local_storage_service.dart';
import 'package:field_staff_app/utils/date_formatter.dart';
import 'package:field_staff_app/viewmodels/base_viewmodel.dart';

class LeaveListViewModel extends BaseViewModel {
  final LeaveRepository _leaveRepository;
  final LocalStorageService _storage;

  List<LeaveModel> _leaves = [];
  String _selectedFilter = 'all';
  DateTime _selectedMonth = DateTime.now();

  LeaveListViewModel(this._leaveRepository, this._storage);

  List<LeaveModel> get leaves => _leaves;
  String get selectedFilter => _selectedFilter;
  DateTime get selectedMonth => _selectedMonth;
  String get monthLabel => DateFormatter.formatMonth(_selectedMonth);
  int get leaveCount => _leaves.length;
  List<String> get filterTabs => AppConstants.leaveFilterTabs;

  Future<void> loadLeaves() async {
    final employeeId = _storage.employeeId ?? _storage.userId;
    if (employeeId == null) {
      setError('User session not found');
      return;
    }

    setLoading();
    try {
      _leaves = await _leaveRepository.fetchLeaves(
        employeeId: employeeId,
        leaveType: _selectedFilter,
        month: DateFormatter.formatMonth(_selectedMonth).toLowerCase(),
      );
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }

  void setFilter(String filter) {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    notifyListeners();
    loadLeaves();
  }

  void setMonth(DateTime month) {
    _selectedMonth = month;
    notifyListeners();
    loadLeaves();
  }
}
