import 'package:flutter/material.dart';
import 'package:pobe_new/features/auth/widgets/auth_text_field.dart';

class FullnameField extends StatelessWidget {
  final TextEditingController controller;

  const FullnameField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      controller: controller,
      hintText: 'Full Name',
    );
  }
}
