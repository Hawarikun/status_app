import 'package:flutter/material.dart';
import 'package:status_app/core/configs/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      showSemanticsDebugger: false,
      title: 'Status App',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('id', ''),
        Locale('en', ''),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      routeInformationParser: AppRoutes.goRouter.routeInformationParser,
      routeInformationProvider: AppRoutes.goRouter.routeInformationProvider,
      routerDelegate: AppRoutes.goRouter.routerDelegate,
    );
  }
}
