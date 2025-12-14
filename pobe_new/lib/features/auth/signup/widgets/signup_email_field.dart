import 'package:flutter/material.dart';
import 'package:pobe_new/features/auth/widgets/auth_text_field.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      controller: controller,
      hintText: 'Email',
    );
  }
}
