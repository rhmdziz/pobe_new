import 'package:pobe_new/app/auth_viewmodel.dart';
import 'package:pobe_new/core/storage/auth_storage.dart';
import 'package:pobe_new/core/services/auth/auth_service.dart';
import 'package:pobe_new/core/services/aqi/aqi_service.dart';
import 'package:pobe_new/core/services/news/news_service.dart';
import 'package:pobe_new/features/auth/login/login_viewmodel.dart';
import 'package:pobe_new/features/auth/signup/signup_viewmodel.dart';
import 'package:pobe_new/features/home/dashboard/viewmodels/aqi_viewmodel.dart';
import 'package:pobe_new/features/news/viewmodels/news_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> appProviders = [
  Provider<AuthStorage>(
    create: (_) => AuthStorage(),
  ),
  Provider<AuthService>(
    create: (_) => AuthService(),
  ),
  Provider<AqiService>(
    create: (_) => AqiService(),
  ),
  Provider<NewsService>(
    create: (_) => NewsService(),
  ),
  ChangeNotifierProvider<AuthViewModel>(
    create: (context) => AuthViewModel(
      context.read<AuthService>(),
      context.read<AuthStorage>(),
    ),
  ),
  ChangeNotifierProvider<LoginViewModel>(
    create: (context) => LoginViewModel(
      context.read<AuthService>(),
      context.read<AuthStorage>(),
    ),
  ),
  ChangeNotifierProvider<SignupViewModel>(
    create: (context) => SignupViewModel(
      context.read<AuthService>(),
    ),
  ),
  ChangeNotifierProvider<AqiViewModel>(
    create: (context) => AqiViewModel(
      context.read<AqiService>(),
    )..load(),
  ),
  ChangeNotifierProvider<NewsViewModel>(
    create: (context) => NewsViewModel(
      context.read<NewsService>(),
    )..load(),
  ),
];
