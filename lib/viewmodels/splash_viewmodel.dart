import 'package:field_staff_app/repositories/auth_repository.dart';
import 'package:field_staff_app/viewmodels/base_viewmodel.dart';

class SplashViewModel extends BaseViewModel {
  final AuthRepository _authRepository;

  SplashViewModel(this._authRepository);

  Future<bool> checkAuth() async {
    setLoading();
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    final loggedIn = _authRepository.isLoggedIn;
    setSuccess();
    return loggedIn;
  }
}
