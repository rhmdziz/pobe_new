import 'package:flutter/material.dart';
import 'package:pobe_new/features/auth/widgets/auth_text_field.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  const PasswordField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      controller: controller,
      hintText: 'Password',
      obscurable: true,
    );
  }
}
