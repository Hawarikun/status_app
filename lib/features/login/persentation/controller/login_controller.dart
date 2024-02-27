import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:status_app/features/login/data/login_repository.dart';

class LoginController extends StateNotifier<AsyncValue> {
  LoginController(this.loginRepository, {required this.params})
      : super(const AsyncValue.loading()) {
    login();
  }

  final LoginRepository loginRepository;
  final LoginParams params;

  Future login() async {
    state = const AsyncValue.loading();
    try {
      final response = await loginRepository.login(
        email: params.email,
        password: params.password,
      );
      state = AsyncValue.data(response);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

class LoginParams extends Equatable {
  const LoginParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
  @override
  List<Object?> get props => [email, password];
}

final loginControllerProv = AutoDisposeStateNotifierProviderFamily<
    LoginController, AsyncValue, LoginParams>(
  (
    ref,
    params,
  ) {
    final loginRepository = ref.read(loginRepoProv);
    return LoginController(
      loginRepository,
      params: params,
    );
  },
);
