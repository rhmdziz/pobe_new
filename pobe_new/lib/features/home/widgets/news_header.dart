import 'package:flutter/material.dart';
import 'package:pobe_new/app/app_router.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    this.title = 'News',
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios),
                color: const Color.fromRGBO(31, 54, 113, 1),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Color.fromRGBO(31, 54, 113, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (title != 'User Guide' && title != 'Terms & Conditions')
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.help);
              },
              icon: const Icon(
                Icons.help_rounded,
                color: Color.fromRGBO(31, 54, 113, 1),
              ),
            ),
        ],
      ),
    );
  }
}
