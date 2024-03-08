import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:status_app/core/configs/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            Image.asset(
              "assets/images/dicoding_logo.png",
              height: size.width * 0.35,
              width: size.width * 0.35,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.warning);
              },
            ),
            Gap(size.height * 0.02),
            Text(
              AppLocalizations.of(context)!.splashDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
