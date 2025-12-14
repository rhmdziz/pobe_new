import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pobe_new/app/app_router.dart';

class SplashScreenWelcome extends StatefulWidget {
  const SplashScreenWelcome({super.key});

  @override
  State<SplashScreenWelcome> createState() => _SplashScreenWelcomeState();
}

class _SplashScreenWelcomeState extends State<SplashScreenWelcome>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRouter.login);
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo/logo.png'),
      ),
    );
  }
}
