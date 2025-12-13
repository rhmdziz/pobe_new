import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pobe_new/features/auth/login/login_viewmodel.dart';
import 'package:pobe_new/features/auth/login/widgets/login_button.dart';
import 'package:pobe_new/features/auth/login/widgets/password_field.dart';
import 'package:pobe_new/features/auth/login/widgets/username_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Consumer<LoginViewModel>(
          builder: (context, vm, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
