import 'package:flutter/material.dart';
import 'package:status_app/core/configs/routes.dart';
import 'package:status_app/core/configs/text_size.dart';
import 'package:status_app/core/datas/shared_preferences.dart';

class SettingsFragment extends StatelessWidget {
  const SettingsFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      child: Column(
        children: [
          SizedBox(
            width: size.width,
            child: ElevatedButton.icon(
              onPressed: () async {
                await LocalPrefsRepository().deleteToken();
                AppRoutes().clearAndNavigate(
                  AppRoutes.auth,
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              icon: const Icon(
                Icons.exit_to_app_outlined,
                color: Colors.white,
              ),
              label: Text(
                "Keluar",
                style: TextStyle(
                  fontSize: size.height * p1,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
