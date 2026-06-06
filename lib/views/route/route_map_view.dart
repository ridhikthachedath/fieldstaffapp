import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:provider/provider.dart';
import 'package:field_staff_app/core/config/maps_config.dart';
import 'package:field_staff_app/core/theme/app_colors.dart';
import 'package:field_staff_app/core/theme/app_text_styles.dart';
import 'package:field_staff_app/models/route_model.dart';
import 'package:field_staff_app/viewmodels/route_map_viewmodel.dart';
class RouteMapView extends StatefulWidget {
  const RouteMapView({super.key});

  @override
  State<RouteMapView> createState() => _RouteMapViewState();
}

class _RouteMapViewState extends State<RouteMapView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context)?.settings.arguments as RouteModel?;
    context.read<RouteMapViewModel>().init(route);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RouteMapViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          MapsConfig.hasGoogleMapsKey
              ? _GoogleMapBody(viewModel: vm)
              : _FlutterMapBody(viewModel: vm),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                      Text('My Route', style: AppTextStyles.screenTitle.copyWith(fontSize: 20)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 13,
            right: 13,
            bottom: 24,
            child: _RouteSummaryCard(viewModel: vm),
          ),
        ],
      ),
    );
  }
}

class _GoogleMapBody extends StatelessWidget {
  final RouteMapViewModel viewModel;

  const _GoogleMapBody({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final start = viewModel.markInPoint;
    final end = viewModel.markOutPoint;
    if (start == null || end == null) {
      return const Center(child: Text('Location data unavailable'));
    }

    final startG = gmaps.LatLng(start.latitude, start.longitude);
    final endG = gmaps.LatLng(end.latitude, end.longitude);

    return gmaps.GoogleMap(
      initialCameraPosition: gmaps.CameraPosition(target: startG, zoom: 13),
      markers: {
        gmaps.Marker(
          markerId: const gmaps.MarkerId('mark_in'),
          position: startG,
          infoWindow: const gmaps.InfoWindow(title: 'Mark In'),
        ),
        gmaps.Marker(
          markerId: const gmaps.MarkerId('mark_out'),
          position: endG,
          infoWindow: const gmaps.InfoWindow(title: 'Mark Out'),
        ),
      },
      polylines: {
        gmaps.Polyline(
          polylineId: const gmaps.PolylineId('route'),
          points: viewModel.polylinePoints
              .map((p) => gmaps.LatLng(p.latitude, p.longitude))
              .toList(),
          color: AppColors.primaryGreen,
          width: 4,
        ),
      },
      myLocationEnabled: true,
      onMapCreated: (c) {},
    );
  }
}

class _FlutterMapBody extends StatelessWidget {
  final RouteMapViewModel viewModel;

  const _FlutterMapBody({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final points = viewModel.polylinePoints;
    if (points.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No map coordinates available'),
              if (!MapsConfig.hasGoogleMapsKey) ...[
                const SizedBox(height: 16),
                Text(
                  MapsConfig.googleMapsSetupInstructions,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption,
                ),
              ],
            ],
          ),
        ),
      );
    }

    final center = points.first;

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 13,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.zyromate.field_staff_app',
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: points,
              color: AppColors.primaryGreen,
              strokeWidth: 4,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            if (viewModel.markInPoint != null)
              Marker(
                point: viewModel.markInPoint!,
                width: 40,
                height: 40,
                child: const Icon(Icons.location_on, color: Colors.green, size: 36),
              ),
            if (viewModel.markOutPoint != null)
              Marker(
                point: viewModel.markOutPoint!,
                width: 40,
                height: 40,
                child: const Icon(Icons.location_on, color: Colors.red, size: 36),
              ),
          ],
        ),
      ],
    );
  }
}

class _RouteSummaryCard extends StatelessWidget {
  final RouteMapViewModel viewModel;

  const _RouteSummaryCard({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(viewModel.userName, style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                )),
                Text('Online/Offline', style: AppTextStyles.caption),
                Row(
                  children: [
                    const Icon(Icons.battery_full, size: 14),
                    Text('100%', style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          Text(
            viewModel.distance,
            style: AppTextStyles.greeting.copyWith(fontSize: 20),
          ),
          const SizedBox(width: 8),
          Container(
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.navigation, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
