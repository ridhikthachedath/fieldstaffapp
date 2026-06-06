import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:field_staff_app/core/routes/app_routes.dart';
import 'package:field_staff_app/core/theme/app_colors.dart';
import 'package:field_staff_app/viewmodels/splash_viewmodel.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigate());
  }

  Future<void> _navigate() async {
    final vm = context.read<SplashViewModel>();
    final loggedIn = await vm.checkAuth();
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      loggedIn ? AppRoutes.dashboard : AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Image.asset(
              'assets/images/logo.png',
              width: 235,
              fit: BoxFit.contain,
            )
              ],
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(color: AppColors.primaryGreen),
          ],
        ),
      ),
    );
  }
}
