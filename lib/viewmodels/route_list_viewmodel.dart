import 'package:field_staff_app/models/route_model.dart';
import 'package:field_staff_app/repositories/route_repository.dart';
import 'package:field_staff_app/services/local_storage_service.dart';
import 'package:field_staff_app/viewmodels/base_viewmodel.dart';

class RouteListViewModel extends BaseViewModel {
  final RouteRepository _routeRepository;
  final LocalStorageService _storage;

  List<RouteModel> _routes = [];
  String _searchQuery = '';

  RouteListViewModel(this._routeRepository, this._storage);

  List<RouteModel> get routes {
    if (_searchQuery.isEmpty) return _routes;
    return _routes
        .where((r) => r.date.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  bool get canAccessRoutes => _storage.canViewRoute;

  Future<void> loadRoutes() async {
    if (!canAccessRoutes) {
      setError('Complete Mark In and Mark Out to view your route.');
      return;
    }

    setLoading();
    try {
      _routes = await _routeRepository.fetchRouteList();
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
