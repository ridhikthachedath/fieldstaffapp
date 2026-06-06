import 'package:field_staff_app/repositories/auth_repository.dart';
import 'package:field_staff_app/viewmodels/base_viewmodel.dart';

class LoginViewModel extends BaseViewModel {
  final AuthRepository _authRepository;

  LoginViewModel(this._authRepository);

  Future<bool> login(String mobile, String password) async {
    setLoading();
    try {
      await _authRepository.login(
        mobileNumber: mobile.trim(),
        password: password,
      );
      setSuccess();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }
}
