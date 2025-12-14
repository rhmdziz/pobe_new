import 'package:flutter/material.dart';
import 'package:pobe_new/app/app_router.dart';
import 'package:pobe_new/features/auth/signup/widgets/signup_confirm_password_field.dart';
import 'package:pobe_new/features/auth/signup/widgets/signup_email_field.dart';
import 'package:pobe_new/features/auth/signup/widgets/signup_button.dart';
import 'package:provider/provider.dart';
import 'package:pobe_new/features/auth/signup/signup_viewmodel.dart';
import 'package:pobe_new/features/auth/widgets/auth_username_field.dart';
import 'package:pobe_new/features/auth/widgets/auth_password_field.dart';
import 'package:pobe_new/features/auth/widgets/auth_google_button.dart';
import 'package:pobe_new/features/auth/signup/widgets/signup_back_button.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Consumer<SignupViewModel>(
            builder: (context, vm, child) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const HeaderBackButton(),
                    const SizedBox(height: 40),
                    Image.asset('assets/logo/logo.png'),
                    const SizedBox(height: 40),
                    UsernameField(controller: usernameCtrl),
                    const SizedBox(height: 16),
                    EmailField(controller: emailCtrl),
                    const SizedBox(height: 16),
                    PasswordField(controller: passwordCtrl),
                    const SizedBox(height: 16),
                    ConfirmPasswordField(controller: confirmPasswordCtrl),
                    const SizedBox(height: 16),
                    SignupButton(
                      isLoading: vm.isLoading,
                      onPressed: () async {
                        final success = await vm.signup(
                          username: usernameCtrl.text,
                          password: passwordCtrl.text,
                          email: emailCtrl.text,
                        );

                        if (success) {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRouter.signupSplash,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(vm.error ?? 'Signup failed'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    const LoginGoogle(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, AppRouter.login);
                          },
                          child: const Text(
                            'Log in',
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
      ),
    );
  }
}
