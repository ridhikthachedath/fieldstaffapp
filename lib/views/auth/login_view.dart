import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:field_staff_app/core/routes/app_routes.dart';
import 'package:field_staff_app/core/theme/app_colors.dart';
import 'package:field_staff_app/utils/validators.dart';
import 'package:field_staff_app/viewmodels/login_viewmodel.dart';
import 'package:field_staff_app/widgets/app_button.dart';
import 'package:field_staff_app/widgets/app_text_field.dart';
import 'package:field_staff_app/widgets/loading_error_widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final vm = context.read<LoginViewModel>();
    final success = await vm.login(
      _mobileController.text,
      _passwordController.text,
    );
    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } else if (vm.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                     _buildLogo(),
                    const SizedBox(height: 60),
                    AppLoginTextField(
                      hint: 'Mobile Number',
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      validator: Validators.mobile,
                    ),
                    const SizedBox(height: 16),
                    AppLoginTextField(
                      hint: 'Password',
                      controller: _passwordController,
                      obscureText: true,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      label: 'Login',
                      variant: AppButtonVariant.login,
                      isLoading: vm.isLoading,
                      onPressed: _login,
                    ),
                    const SizedBox(height: 8),
                    AppButton(
                      label: 'Create Account',
                      variant: AppButtonVariant.outline,
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.register),
                    ),
                  ],
                ),
              ),
            ),
            AppLoadingOverlay(isLoading: vm.isLoading),
          ],
        ),
      ),
    );
  }
  Widget _buildLogo() {
    return Image.asset(
      'assets/images/logo.png',
      width: 235,
      fit: BoxFit.contain,
    );
  }

}
