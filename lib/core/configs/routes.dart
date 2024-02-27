import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:status_app/core/datas/shared_preferences.dart';
import 'package:status_app/pages/auth.dart';
import 'package:status_app/pages/home.dart';

class AppRoutes {
  static const splash = "splash";
  static const auth = "auth";
  static const home = "home";

  static final goRouter = GoRouter(
    initialLocation: "/splash",
    routes: [
      GoRoute(name: splash, path: "/splash", pageBuilder: _splashPageBuilder,),
      GoRoute(
        name: auth,
        path: '/auth',
        pageBuilder: _authPageBuilder,
        redirect: (context, state) async {
          final token = await LocalPrefsRepository().getToken();
          if (token != null) {
            return "/home";
          }
          return null;
        },
      ),
      GoRoute(
        name: home,
        path: "/home",
        pageBuilder: _homePageBuilder,
      )
    ],
  );

  void clearAndNavigate(String name) {
    while (goRouter.canPop() == true) {
      goRouter.pop();
    }
    goRouter.pushReplacementNamed(name);
  }

  static Page _splashPageBuilder(context, state) {
    return transition(
      child: const AuthPage(),
    );
  }

  static Page _authPageBuilder(context, state) {
    return transition(
      child: const AuthPage(),
    );
  }

  static Page _homePageBuilder(context, state) {
    return transition(
      child: const HomePage(),
    );
  }

  static transition({required Widget child}) {
    return CustomTransitionPage(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: child,
    );
  }
}
