import 'package:flutter/material.dart';
import 'package:pobe_new/features/auth/widgets/auth_text_field.dart';

class UsernameField extends StatelessWidget {
  final TextEditingController controller;

  const UsernameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      controller: controller,
      hintText: 'Username',
    );
  }
}
