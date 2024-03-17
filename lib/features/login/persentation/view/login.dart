import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:status_app/core/configs/color.dart';
import 'package:status_app/core/configs/text_size.dart';
import 'package:status_app/features/login/application/login.dart';
import 'package:status_app/pages/auth.dart';
import 'package:status_app/widgets/custom_textformfiel.dart';

final emailControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
        (ref) => TextEditingController());

final passwordControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
        (ref) => TextEditingController());

final isObsecureProvider = StateProvider.autoDispose<bool>((ref) => true);

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
    final isObsecure = ref.watch(isObsecureProvider);
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              AppLocalizations.of(context)!.loginTitle,
              style: TextStyle(
                fontSize: size.height * h1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Gap(size.height * 0.01),
          Center(
            child: Text(
              AppLocalizations.of(context)!.descriptionLogin,
              style: TextStyle(
                fontSize: size.height * h3,
                color: Colors.grey,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Gap(size.height * 0.05),
          Text(
            "Email",
            style: TextStyle(
              fontSize: size.height * h2,
            ),
          ),
          Gap(size.height * 0.01),
          CustomTextFormField(
            nameController: emailController,
            type: TextInputType.emailAddress,
            hintText: "Email@example.com",
            callBack: (value) {
              if (value == null || value == "") {
                return AppLocalizations.of(context)!.validationEmail;
              }

              return null;
            },
          ),
          Gap(size.height * 0.03),
          Text(
            "Password",
            style: TextStyle(
              fontSize: size.height * h2,
            ),
          ),
          Gap(size.height * 0.01),
          CustomTextFormField(
            nameController: passwordController,
            type: TextInputType.visiblePassword,
            iconButton: IconButton(
              icon: Icon(
                isObsecure == true
                    ? Icons.remove_red_eye_outlined
                    : Icons.remove_red_eye_rounded,
                size: size.width * 0.05,
              ),
              onPressed: () {
                ref.read(isObsecureProvider.notifier).state = !isObsecure;
              },
            ),
            isObsecure: isObsecure,
            hintText: "Password",
            callBack: (value) {
              if (value == null || value == "") {
                return AppLocalizations.of(context)!.validationPassword;
              }
              if (value.length < 8) {
                return AppLocalizations.of(context)!.validationPassword2;
              }

              return null;
            },
          ),
          Gap(size.height * 0.05),
          SizedBox(
            width: size.width,
            height: size.height * 0.055,
            child: TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  LoginApplication().login(
                    context: context,
                    size: size,
                    email: emailController.text,
                    password: passwordController.text,
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: ColorApp.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.loginTitle,
                style: TextStyle(
                  fontSize: size.height * h2,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Gap(size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.questionRegister),
              TextButton(
                onPressed: () {
                  ref.read(authPageTypeProvider.notifier).state = "register";
                },
                child: Text(
                  AppLocalizations.of(context)!.registerTitle,
                  style: const TextStyle(
                    color: ColorApp.primary,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
