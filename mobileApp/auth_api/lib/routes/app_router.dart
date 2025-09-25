// import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/account_setup/screens/welcome_screen.dart';
//import '../features/login/screens/login_result_screen.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
      /*GoRoute(
        path: '/login-request',
        builder: (context, state) => const LoginRequestScreen(),
      ),*/
    ],
  );
}
