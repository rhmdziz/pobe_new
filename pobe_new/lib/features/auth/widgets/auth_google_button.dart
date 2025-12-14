import 'package:flutter/material.dart';

class LoginGoogle extends StatelessWidget {
  const LoginGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.black,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'or',
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: null,
          style: ButtonStyle(
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              minimumSize:
                  const WidgetStatePropertyAll(Size(double.infinity, 50)),
              backgroundColor:
                  const WidgetStatePropertyAll(Color.fromRGBO(0, 0, 0, 0.09))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo/logo_google.png',
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 8),
              const Text(
                'Continue with Google Account',
                style: TextStyle(
                    color: Colors.black,fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
