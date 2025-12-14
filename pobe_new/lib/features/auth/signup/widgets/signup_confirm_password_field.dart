import 'package:flutter/material.dart';
import 'package:pobe_new/features/auth/widgets/auth_text_field.dart';

class ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;

  const ConfirmPasswordField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      controller: controller,
      hintText: 'Confirm Password',
      obscurable: true,
    );
  }
}
