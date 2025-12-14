import 'package:flutter/material.dart';
import 'package:pobe_new/features/auth/login/login_page.dart';
import 'package:pobe_new/features/auth/signup/signup_page.dart';
import 'package:pobe_new/features/auth/signup/signup_splash.dart';
import 'package:pobe_new/features/help/help.dart';
import 'package:pobe_new/features/help/term_and_condition_page.dart';
import 'package:pobe_new/features/home/dashboard/dashboard_page.dart';
import 'package:pobe_new/features/home/news/news_detail_page.dart';
import 'package:pobe_new/features/home/news/news_page.dart';
import 'package:pobe_new/features/home/news/viewmodels/news_detail_viewmodel.dart';
import 'package:pobe_new/features/splash/splash_page.dart';
import 'package:pobe_new/core/services/news/news_comment_service.dart';
import 'package:pobe_new/data/models/news.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String signupSplash = '/signup_splash';

  static const String home = '/home';
  static const String news = '/news';
  static const String newsDetail = '/news/detail';

  static const String help = '/help';
  static const String termsAndConditions = '/help/terms_and_conditions';

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

      case home:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case news:
        return MaterialPageRoute(builder: (_) => const NewsListPage());
      case newsDetail:
        final args = settings.arguments;
        if (args is! News) {
          return _unknownRoute();
        }
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => NewsDetailViewModel(NewsCommentService()),
            child: NewsDetailPage(news: args),
          ),
        );


      case help:
        return MaterialPageRoute(builder: (_) => const HelpPage());
      case termsAndConditions:
        return MaterialPageRoute(
            builder: (_) => const TermPage());


      default:
        return _unknownRoute();
      
    }
  }

  static Route<dynamic> _unknownRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Route not found')),
      ),
    );
  }
}
