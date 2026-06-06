import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:field_staff_app/core/network/api_client.dart';
import 'package:field_staff_app/core/routes/app_routes.dart';
import 'package:field_staff_app/core/theme/app_theme.dart';
import 'package:field_staff_app/repositories/attendance_repository.dart';
import 'package:field_staff_app/repositories/auth_repository.dart';
import 'package:field_staff_app/repositories/leave_repository.dart';
import 'package:field_staff_app/repositories/route_repository.dart';
import 'package:field_staff_app/services/local_storage_service.dart';
import 'package:field_staff_app/services/location_service.dart';
import 'package:field_staff_app/viewmodels/apply_leave_viewmodel.dart';
import 'package:field_staff_app/viewmodels/dashboard_viewmodel.dart';
import 'package:field_staff_app/viewmodels/leave_list_viewmodel.dart';
import 'package:field_staff_app/viewmodels/login_viewmodel.dart';
import 'package:field_staff_app/viewmodels/register_viewmodel.dart';
import 'package:field_staff_app/viewmodels/route_list_viewmodel.dart';
import 'package:field_staff_app/viewmodels/route_map_viewmodel.dart';
import 'package:field_staff_app/viewmodels/splash_viewmodel.dart';
import 'package:field_staff_app/views/auth/login_view.dart';
import 'package:field_staff_app/views/auth/register_view.dart';
import 'package:field_staff_app/views/dashboard/dashboard_view.dart';
import 'package:field_staff_app/views/leave/apply_leave_view.dart';
import 'package:field_staff_app/views/leave/leave_list_view.dart';
import 'package:field_staff_app/views/route/route_list_view.dart';
import 'package:field_staff_app/views/route/route_map_view.dart';
import 'package:field_staff_app/views/splash/splash_view.dart';
import 'package:field_staff_app/views/profile/profile_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();
  final storage = LocalStorageService(prefs);
  final apiClient = ApiClient(storage: storage);

  final authRepository = AuthRepository(apiClient, storage);
  final attendanceRepository = AttendanceRepository(apiClient, storage);
  final leaveRepository = LeaveRepository(apiClient);
  final routeRepository = RouteRepository(apiClient);
  final locationService = LocationService();

  runApp(
    FieldStaffApp(
      storage: storage,
      authRepository: authRepository,
      attendanceRepository: attendanceRepository,
      leaveRepository: leaveRepository,
      routeRepository: routeRepository,
      locationService: locationService,
    ),
  );
}

class FieldStaffApp extends StatelessWidget {
  final LocalStorageService storage;
  final AuthRepository authRepository;
  final AttendanceRepository attendanceRepository;
  final LeaveRepository leaveRepository;
  final RouteRepository routeRepository;
  final LocationService locationService;

  const FieldStaffApp({
    super.key,
    required this.storage,
    required this.authRepository,
    required this.attendanceRepository,
    required this.leaveRepository,
    required this.routeRepository,
    required this.locationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: storage),
        Provider.value(value: authRepository),
        ChangeNotifierProvider(
          create: (_) => SplashViewModel(authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => RegisterViewModel(authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(
            attendanceRepository,
            routeRepository,
            locationService,
            storage,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ApplyLeaveViewModel(leaveRepository, storage),
        ),
        ChangeNotifierProvider(
          create: (_) => LeaveListViewModel(leaveRepository, storage),
        ),
        ChangeNotifierProvider(
          create: (_) => RouteListViewModel(routeRepository, storage),
        ),
        ChangeNotifierProvider(
          create: (_) => RouteMapViewModel(storage),
        ),
      ],
      child: MaterialApp(
        title: 'Zyromate Field Staff',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (_) => const SplashView(),
          AppRoutes.login: (_) => const LoginView(),
          AppRoutes.register: (_) => const RegisterView(),
          AppRoutes.dashboard: (_) => const DashboardView(),
          AppRoutes.applyLeave: (_) => const ApplyLeaveView(),
          AppRoutes.leaveList: (_) => const LeaveListView(),
          AppRoutes.routeList: (_) => const RouteListView(),
          AppRoutes.routeMap: (_) => const RouteMapView(),
          AppRoutes.profile: (_) => const ProfileView(),
        },
      ),
    );
  }
}
