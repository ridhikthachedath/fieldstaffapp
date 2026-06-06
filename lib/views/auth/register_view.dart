import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:field_staff_app/core/theme/app_colors.dart';
import 'package:field_staff_app/utils/date_formatter.dart';
import 'package:field_staff_app/utils/validators.dart';
import 'package:field_staff_app/viewmodels/register_viewmodel.dart';
import 'package:field_staff_app/widgets/app_app_bar.dart';
import 'package:field_staff_app/widgets/app_button.dart';
import 'package:field_staff_app/widgets/app_text_field.dart';
import 'package:field_staff_app/widgets/loading_error_widgets.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _locationController = TextEditingController();
  final _passwordController = TextEditingController();

  DateTime? _dob;
  DateTime? _doj;
  final _dobController = TextEditingController();
  final _dojController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _mobileController.dispose();
    _locationController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    _dojController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isDob}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isDob) {
          _dob = picked;
          _dobController.text = DateFormatter.formatInput(picked);
        } else {
          _doj = picked;
          _dojController.text = DateFormatter.formatInput(picked);
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dob == null || _doj == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select DOB and DOJ')),
      );
      return;
    }

    final vm = context.read<RegisterViewModel>();
    final success = await vm.register(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      address: _addressController.text,
      dob: _dob!,
      mobileNumber: _mobileController.text,
      doj: _doj!,
      location: _locationController.text,
    );

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful. Please login.')),
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
    final vm = context.watch<RegisterViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppScreenHeader(
                  title: 'Create Account',
                  onBack: () => Navigator.pop(context),
                  trailing: const ProfileAvatarButton(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(13, 8, 13, 24),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(7),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AppTextField(
                              label: 'First Name',
                              hint: 'Enter First Name',
                              controller: _firstNameController,
                              validator: (v) => Validators.required(v, field: 'First name'),
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              label: 'Last Name',
                              hint: 'Enter Last Name',
                              controller: _lastNameController,
                              validator: (v) => Validators.required(v, field: 'Last name'),
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              label: 'Email',
                              hint: 'Enter Email',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.email,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              label: 'Address',
                              hint: 'Enter Address',
                              controller: _addressController,
                              maxLines: 3,
                              validator: (v) => Validators.required(v, field: 'Address'),
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              label: 'DOB',
                              hint: 'Enter DOB',
                              controller: _dobController,
                              readOnly: true,
                              onTap: () => _pickDate(isDob: true),
                              validator: (_) => Validators.dateRequired(_dob, field: 'DOB'),
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              label: 'Mobile Number',
                              hint: 'Enter Number',
                              controller: _mobileController,
                              keyboardType: TextInputType.phone,
                              validator: Validators.mobile,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              label: 'Location',
                              hint: 'Enter location',
                              controller: _locationController,
                              validator: (v) => Validators.required(v, field: 'Location'),
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              label: 'DOJ',
                              hint: 'Enter Date Of Joining',
                              controller: _dojController,
                              readOnly: true,
                              onTap: () => _pickDate(isDob: false),
                              validator: (_) => Validators.dateRequired(_doj, field: 'DOJ'),
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              label: 'Password',
                              hint: 'Enter Password',
                              controller: _passwordController,
                              obscureText: true,
                              validator: Validators.password,
                            ),
                            const SizedBox(height: 24),
                            AppButton(
                              label: 'Save',
                              isLoading: vm.isLoading,
                              onPressed: _submit,
                            ),
                          ],
                        ),
                      ),
                    ),
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
