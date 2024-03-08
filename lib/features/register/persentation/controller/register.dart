import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:status_app/features/register/data/register_repository.dart';

class RegisterController extends StateNotifier<AsyncValue> {
  RegisterController(this.repository, {required this.params})
      : super(const AsyncValue.loading()) {
    register();
  }

  final RegisterRepository repository;
  final RegisterParams params;

  register() async {
    state = const AsyncValue.loading();
    try {
      final response = await repository.register(
        name: params.name,
        email: params.email,
        password: params.password,
      );
      state = AsyncValue.data(response);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;

  @override
  List<Object?> get props => [
        name,
        email,
        password,
      ];
}

final registerControllerProv = AutoDisposeStateNotifierProviderFamily<
    RegisterController, AsyncValue, RegisterParams>((ref, params) {
  final repository = ref.read(registerRepoProv);
  return RegisterController(
    repository,
    params: params,
  );
});
