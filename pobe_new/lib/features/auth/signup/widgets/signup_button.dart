import 'package:flutter/material.dart';
import 'package:pobe_new/features/auth/widgets/auth_primary_button.dart';

class SignupButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const SignupButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AuthPrimaryButton(
      label: 'Sign Up',
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}
