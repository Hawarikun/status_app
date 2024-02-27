import 'package:flutter/material.dart';
import 'package:status_app/core/configs/routes.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Future.delayed(
      const Duration(
        seconds: 4,
      ),
      () {
        AppRoutes().clearAndNavigate(AppRoutes.auth);
      },
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.height * 0.13,
              width: size.height * 0.13,
              child: Image.asset("assets/logoAPP.jpg"),
            ),
          ],
        ),
      ),
    );
  }
}
