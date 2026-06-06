import 'package:field_staff_app/models/route_model.dart';
import 'package:field_staff_app/services/local_storage_service.dart';
import 'package:field_staff_app/viewmodels/base_viewmodel.dart';
import 'package:latlong2/latlong.dart';

class RouteMapViewModel extends BaseViewModel {
  final LocalStorageService _storage;

  RouteMapViewModel(this._storage);

  RouteModel? route;
  bool useGoogleMaps = false;

  LatLng? get markInPoint {
    if (route?.markInLat != null && route?.markInLng != null) {
      return LatLng(route!.markInLat!, route!.markInLng!);
    }
    if (_storage.markInLat != null && _storage.markInLng != null) {
      return LatLng(_storage.markInLat!, _storage.markInLng!);
    }
    return null;
  }

  LatLng? get markOutPoint {
    if (route?.markOutLat != null && route?.markOutLng != null) {
      return LatLng(route!.markOutLat!, route!.markOutLng!);
    }
    if (_storage.markOutLat != null && _storage.markOutLng != null) {
      return LatLng(_storage.markOutLat!, _storage.markOutLng!);
    }
    return null;
  }

  List<LatLng> get polylinePoints {
    if (route != null && route!.history.isNotEmpty) {
      return route!.history
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();
    }
    final points = <LatLng>[];
    final start = markInPoint;
    final end = markOutPoint;
    if (start != null) points.add(start);
    if (end != null) points.add(end);
    return points;
  }

  String get userName => _storage.userName ?? 'User';
  String get distance => route?.distance ?? '0.0 Km';

  void init(RouteModel? selectedRoute) {
    route = selectedRoute;
    notifyListeners();
  }
}
