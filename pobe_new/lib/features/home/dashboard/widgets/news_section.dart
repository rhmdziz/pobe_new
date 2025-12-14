import 'package:flutter/material.dart';
import 'package:pobe_new/app/app_router.dart';

class NewsSection extends StatelessWidget {
  const NewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "l News and Report",
          style: TextStyle(
            color: Color.fromRGBO(31, 54, 113, 1),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.news);
                },
                child: FractionallySizedBox(
                  child: SizedBox(
                    height: 100,
                    child: Image.asset(
                      'assets/icons/news.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.report);
                },
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.5, horizontal: 17.5),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(209, 235, 254, 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(
                    'assets/icons/report.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
