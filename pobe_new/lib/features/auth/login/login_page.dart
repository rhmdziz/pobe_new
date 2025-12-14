import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pobe_new/features/auth/widgets/auth_google_button.dart';
import 'package:provider/provider.dart';
import 'package:pobe_new/features/auth/login/login_viewmodel.dart';
import 'package:pobe_new/features/auth/login/widgets/login_button.dart';
import 'package:pobe_new/app/app_router.dart';
import 'package:pobe_new/features/auth/widgets/auth_password_field.dart';
import 'package:pobe_new/features/auth/widgets/auth_username_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Consumer<LoginViewModel>(
          builder: (context, vm, child) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo/logo.png'),
                  const SizedBox(
                    height: 40,
                  ),
                  UsernameField(controller: usernameCtrl),
                  const SizedBox(height: 16),
                  PasswordField(controller: passwordCtrl),
                  const SizedBox(height: 24),
                  LoginButton(
                    isLoading: vm.isLoading,
                    onPressed: () async {
                      final success = await vm.login(
                        usernameCtrl.text,
                        passwordCtrl.text,
                      );

                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(vm.error ?? 'Login failed'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, AppRouter.home);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  const LoginGoogle(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRouter.signup);
                        },
                        child: const Text(
                          'Create a new account',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]);
          },
        ),
      ),
    );
  }
}
