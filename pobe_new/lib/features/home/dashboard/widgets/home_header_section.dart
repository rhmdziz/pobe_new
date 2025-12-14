import 'package:flutter/material.dart';
import 'package:pobe_new/app/app_router.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.profile);
          },
          icon: const Icon(
            Icons.account_circle_outlined,
            color: Color.fromRGBO(31, 54, 113, 1),
            size: 35,
          ),
        ),
        Image.asset(
          'assets/logo/logo.png',
          height: 50,
        ),
        Stack(
          children: [
            IconButton(
              onPressed: () {
                
              },
              icon: const Icon(
                Icons.notifications_outlined,
                color: Color.fromRGBO(31, 54, 113, 1),
                size: 35,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
