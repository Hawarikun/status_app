import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final emailControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
        (ref) => TextEditingController());

final passwordControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
        (ref) => TextEditingController());

final isObsecureProvider = StateProvider.autoDispose<bool>((ref) => true);

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: const Column(
        children: [
          
        ],
      ),
    );
  }
}
