import 'package:flutter/material.dart';
import 'package:pobe_new/features/auth/login/login_page.dart';
import 'package:pobe_new/features/auth/signup/signup_page.dart';
import 'package:pobe_new/features/auth/signup/signup_splash.dart';
import 'package:pobe_new/features/splash/splash_page.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String signupSplash = '/signup_splash';

  static String get initialRoute => splash;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreenWelcome());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case signup:
        return MaterialPageRoute(builder: (_) => SignupPage());
      case signupSplash:
        return MaterialPageRoute(builder: (_) => const SignupSplash());
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
