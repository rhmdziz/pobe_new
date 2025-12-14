import 'package:pobe_new/app/auth_viewmodel.dart';
import 'package:pobe_new/core/storage/auth_storage.dart';
import 'package:pobe_new/core/services/auth/auth_service.dart';
import 'package:pobe_new/features/auth/login/login_viewmodel.dart';
import 'package:pobe_new/features/auth/signup/signup_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> appProviders = [
  Provider<AuthStorage>(
    create: (_) => AuthStorage(),
  ),
  Provider<AuthService>(
    create: (_) => AuthService(),
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
];
