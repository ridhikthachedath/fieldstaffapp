import 'package:field_staff_app/repositories/auth_repository.dart';
import 'package:field_staff_app/utils/date_formatter.dart';
import 'package:field_staff_app/viewmodels/base_viewmodel.dart';

class RegisterViewModel extends BaseViewModel {
  final AuthRepository _authRepository;

  RegisterViewModel(this._authRepository);

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String address,
    required DateTime dob,
    required String mobileNumber,
    required DateTime doj,
    required String location,
  }) async {
    setLoading();
    try {
      await _authRepository.register(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        email: email.trim(),
        password: password,
        address: address.trim(),
        dob: DateFormatter.formatApi(dob),
        mobileNumber: mobileNumber.trim(),
        doj: DateFormatter.formatApi(doj),
        location: location.trim(),
      );
      setSuccess();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }
}
