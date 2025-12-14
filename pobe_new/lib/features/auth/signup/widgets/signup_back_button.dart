import 'package:flutter/material.dart';
import 'package:pobe_new/app/app_router.dart';

class HeaderBackButton extends StatelessWidget {
  const HeaderBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRouter.login);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  color: const Color.fromRGBO(31, 54, 113, 1),
                ),
                const Text(
                  'Back',
                  style: TextStyle(
                    color: Color.fromRGBO(31, 54, 113, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
