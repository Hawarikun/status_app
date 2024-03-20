import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:status_app/core/configs/color.dart';
import 'package:status_app/core/configs/routes.dart';
import 'package:status_app/core/configs/text_size.dart';
import 'package:status_app/features/register/persentation/controller/register.dart';
import 'package:status_app/pages/auth.dart';
import 'package:status_app/widgets/custom_textformfiel.dart';

final nameControllerProvider = StateProvider.autoDispose<TextEditingController>(
    (ref) => TextEditingController());

final emailControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
        (ref) => TextEditingController());

final passwordControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
        (ref) => TextEditingController());

final passwordConfirmationControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
        (ref) => TextEditingController());

final isObsecureProvider = StateProvider.autoDispose<bool>((ref) => true);
final isObsecureConfirmationProvider =
    StateProvider.autoDispose<bool>((ref) => true);

class RegisterForm extends ConsumerWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final formKey = GlobalKey<FormState>();
    final nameController = ref.watch(nameControllerProvider);
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
    final passwordConfirmationController =
        ref.watch(passwordConfirmationControllerProvider);
    final isObsecure = ref.watch(isObsecureProvider);
    final isObsecureConfirmation = ref.watch(isObsecureConfirmationProvider);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              AppLocalizations.of(context)!.registerTitle,
              style: TextStyle(
                fontSize: size.height * h1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Gap(size.height * 0.01),
          Center(
            child: Text(
              AppLocalizations.of(context)!.descriptionRegister,
              style: TextStyle(
                fontSize: size.height * h3,
                color: Colors.grey,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Gap(size.height * 0.05),

          /// name
          Text(
            AppLocalizations.of(context)!.name,
            style: TextStyle(
              fontSize: size.height * h2,
            ),
          ),
          Gap(size.height * 0.01),
          CustomTextFormField(
            nameController: nameController,
            type: TextInputType.text,
            hintText: "Email@example.com",
            callBack: (value) {
              if (value == null || value == "") {
                return AppLocalizations.of(context)!.validationEmail;
              }

              return null;
            },
          ),

          /// email
          Gap(size.height * 0.03),
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

          /// password
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

          /// confirm password
          Gap(size.height * 0.03),
          Text(
            AppLocalizations.of(context)!.confirmPassword,
            style: TextStyle(
              fontSize: size.height * h2,
            ),
          ),
          Gap(size.height * 0.01),
          CustomTextFormField(
            nameController: passwordConfirmationController,
            type: TextInputType.visiblePassword,
            iconButton: IconButton(
              icon: Icon(
                isObsecureConfirmation == true
                    ? Icons.remove_red_eye_outlined
                    : Icons.remove_red_eye_rounded,
                size: size.width * 0.05,
              ),
              onPressed: () {
                ref.read(isObsecureConfirmationProvider.notifier).state =
                    !isObsecureConfirmation;
              },
            ),
            isObsecure: isObsecureConfirmation,
            hintText: AppLocalizations.of(context)!.confirmPassword,
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

          /// button
          Gap(size.height * 0.05),
          SizedBox(
            width: size.width,
            height: size.height * 0.065,
            child: TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return PopScope(
                        onPopInvoked: (didPop) => false,
                        child: Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(size.width * 0.03),
                            child: Consumer(
                              builder: (context, ref, _) {
                                final response = ref.watch(
                                  registerControllerProv(
                                    RegisterParams(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password:
                                          passwordConfirmationController.text,
                                    ),
                                  ),
                                );
                                return response.when(

                                  /// jika berhasil
                                  data: (data) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Daftar Berhasil",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: size.height * h1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                        Gap(size.height * 0.02),
                                        Text(
                                          "Akun anda berhasil dibuat",
                                          style: TextStyle(
                                            fontSize: size.height * p1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                        Gap(size.height * 0.02),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {
                                              AppRoutes.goRouter.pop();
                                              ref
                                                  .read(authPageTypeProvider
                                                      .notifier)
                                                  .state = "login";
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              "Kembali",
                                              style: TextStyle(
                                                fontSize: size.height * p1,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },

                                  /// jika gagal
                                  error: (error, stackTrace) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Gagal Daftar",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: size.height * h1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                        Gap(size.height * 0.02),
                                        Text(
                                          error.toString(),
                                          style: TextStyle(
                                            fontSize: size.height * p1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                        Gap(size.height * 0.02),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {
                                              AppRoutes.goRouter.pop();
                                              // ref
                                              //     .read(authPageTypeProvider
                                              //         .notifier)
                                              //     .state = "login";
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              "Kembali",
                                              style: TextStyle(
                                                fontSize: size.height * p1,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },

                                  /// ketika loading
                                  loading: () {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Sedang Daftar",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: size.height * h1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                        const CircularProgressIndicator(),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
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
                AppLocalizations.of(context)!.registerTitle,
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
              Text(
                AppLocalizations.of(context)!.questionLogin,
                style: TextStyle(fontSize: size.height * p1),
              ),
              TextButton(
                onPressed: () {
                  ref.read(authPageTypeProvider.notifier).state = "login";
                },
                child: Text(
                  AppLocalizations.of(context)!.loginTitle,
                  style: TextStyle(
                    fontSize: size.height * p1,
                    fontWeight: FontWeight.bold,
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
