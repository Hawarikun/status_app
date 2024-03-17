import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:status_app/core/configs/color.dart';
import 'package:status_app/core/configs/routes.dart';
import 'package:status_app/core/configs/text_size.dart';
import 'package:status_app/features/login/persentation/controller/login_controller.dart';

class LoginApplication {
  login({
    required BuildContext context,
    required Size size,
    required String email,
    required String password,
  }) {
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
            child: Container(
              height: size.height * 0.3,
              padding: EdgeInsets.all(size.width * 0.03),
              child: Consumer(
                builder: (context, ref, _) {
                  final response = ref.watch(
                    loginControllerProv(
                      LoginParams(
                        email: email,
                        password: password,
                      ),
                    ),
                  );
                  return response.when(
                    data: (data) {
                      Future.delayed(
                        const Duration(milliseconds: 300),
                        () {
                          AppRoutes.goRouter.pop();
                          Future.delayed(
                            const Duration(milliseconds: 300),
                            () {
                              AppRoutes.goRouter
                                  .pushReplacementNamed(AppRoutes.home);
                            },
                          );
                        },
                      );
                      return Center(
                        child: Text(
                          "Login Berhasil",
                          style: TextStyle(
                            fontSize: size.height * h1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    error: (error, stackTrace) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Gagal Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * h1,
                            ),
                          ),
                          Gap(size.height * 0.02),
                          Text(
                            error.toString(),
                            style: TextStyle(
                              fontSize: size.height * p1,
                            ),
                          ),
                          Gap(size.height * 0.02),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                AppRoutes.goRouter.pop();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: ColorApp.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "Kembali",
                                style: TextStyle(
                                  fontSize: size.height * p1,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Sedang Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.height * h1,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            Gap(size.height * 0.05),
                            const CircularProgressIndicator(),
                          ],
                        ),
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
}
