import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscurable = false,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscurable;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscure = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscurable;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromRGBO(80, 137, 198, 0.22),
        hintStyle: const TextStyle(
          color: Color.fromRGBO(31, 54, 113, 1),
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.5)),
          borderSide: BorderSide.none,
        ),
        suffixIcon: widget.obscurable
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility : Icons.visibility_off,
                  color: const Color.fromRGBO(31, 54, 113, 1),
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
      ),
    );
  }
}
