import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pobe_new/app/app_router.dart';
import 'package:lottie/lottie.dart';

class SignupSplash extends StatefulWidget {
  const SignupSplash({super.key});

  @override
  State<SignupSplash> createState() => _SignupSplashState();
}

class _SignupSplashState extends State<SignupSplash>
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/success.json',
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Your Account Has Been Registered',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(31, 54, 113, 1),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
