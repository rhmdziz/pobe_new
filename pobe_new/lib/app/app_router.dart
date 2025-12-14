import 'package:flutter/material.dart';
import 'package:pobe_new/features/auth/login/login_page.dart';
import 'package:pobe_new/features/auth/signup/signup_page.dart';
import 'package:pobe_new/features/auth/signup/signup_splash.dart';
import 'package:pobe_new/features/help/help.dart';
import 'package:pobe_new/features/help/term_and_condition_page.dart';
import 'package:pobe_new/features/home/dashboard/dashboard_page.dart';
import 'package:pobe_new/features/home/category/to_go_page.dart';
import 'package:pobe_new/features/home/category/to_go_viewmodel.dart';
import 'package:pobe_new/features/home/category/to_go_detail_page.dart';
import 'package:pobe_new/features/home/category/to_go_detail_viewmodel.dart';
import 'package:pobe_new/features/news/news_detail_page.dart';
import 'package:pobe_new/features/news/news_page.dart';
import 'package:pobe_new/features/news/viewmodels/news_detail_viewmodel.dart';
import 'package:pobe_new/features/profile/profile_page.dart';
import 'package:pobe_new/features/profile/profile_viewmodel.dart';
import 'package:pobe_new/features/splash/splash_page.dart';
import 'package:pobe_new/core/services/news/news_comment_service.dart';
import 'package:pobe_new/data/models/news.dart';
import 'package:pobe_new/features/home/bus/destination_set.dart';
import 'package:pobe_new/core/services/bus/halte_service.dart';
import 'package:pobe_new/features/home/bus/viewmodels/destination_viewmodel.dart';
import 'package:pobe_new/features/home/report/report_page.dart';
import 'package:pobe_new/features/home/report/report_viewmodel.dart';
import 'package:pobe_new/core/services/report/report_service.dart';
import 'package:pobe_new/core/services/profile/profile_service.dart';
import 'package:pobe_new/core/services/category/to_go_service.dart';
import 'package:pobe_new/core/storage/auth_storage.dart';
import 'package:pobe_new/data/models/to_go_item.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String signupSplash = '/signup_splash';

  static const String home = '/home';
  static const String news = '/news';
  static const String newsDetail = '/news/detail';
  static const String report = '/report';
  static const String category = '/category';
  static const String categoryDetail = '/category/detail';
  static const String profile = '/profile';

  static const String help = '/help';
  static const String termsAndConditions = '/help/terms_and_conditions';

  static const String bus = '/bus';
  static const String destinationSet = '/bus/destination_set';

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
      case report:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => ReportViewModel(ReportService()),
            child: const ReportPage(),
          ),
        );
      case category:
        final args = settings.arguments;
        if (args is! String || args.isEmpty) {
          return _unknownRoute();
        }
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => ToGoViewModel(
              ToGoService(storage: _.read<AuthStorage>()),
              category: args,
            ),
            child: ToGoPage(category: args),
          ),
        );
      case categoryDetail:
        final args = settings.arguments;
        if (args is! ToGoItem) {
          return _unknownRoute();
        }
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (context) => ToGoDetailViewModel(
              ToGoService(storage: context.read<AuthStorage>()),
              item: args,
            ),
            child: const ToGoDetailPage(),
          ),
        );
      case profile:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (context) => ProfileViewModel(
              ProfileService(storage: context.read<AuthStorage>()),
              context.read<AuthStorage>(),
            ),
            child: const ProfilePage(),
          ),
        );

      case destinationSet:
        final args = settings.arguments;
        if (args is! Map<String, String>) {
          return _unknownRoute();
        }
        final startPoint = args['startPoint'] ?? '';
        final endPoint = args['endPoint'] ?? '';
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => DestinationViewModel(HalteService()),
            child: DestinationSet(startPoint: startPoint, endPoint: endPoint),
          ),
        );

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
