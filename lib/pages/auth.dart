import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:status_app/features/login/persentation/view/login.dart';
import 'package:status_app/features/register/persentation/view/register.dart';

final authPageTypeProvider = StateProvider.autoDispose<String>(
  (ref) => "login",
);

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final authPageType = ref.watch(authPageTypeProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/dicoding_logo.png",
                    height: size.width * 0.2,
                    width: size.width * 0.2,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.warning);
                    },
                  ),
                ),
                Gap(size.height * 0.02),
                authPageType == "login"
                    ?

                    /// form login
                    const LoginForm()
                    :

                    // form register
                    const RegisterForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
