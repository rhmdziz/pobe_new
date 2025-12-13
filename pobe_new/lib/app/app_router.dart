import 'package:flutter/material.dart';
import 'package:pobe_new/features/auth/login/login_page.dart';

class AppRouter {
  static const String login = '/login';
  static const String signup = '/signup';

  static String get initialRoute => login;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
