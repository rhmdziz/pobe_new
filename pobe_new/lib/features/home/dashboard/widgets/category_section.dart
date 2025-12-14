import 'package:flutter/material.dart';
import 'package:pobe_new/app/app_router.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  static const _categories = [
    _Category('Food', 'assets/icons/food.png'),
    _Category('Shopping', 'assets/icons/shopping.png'),
    _Category('Mall', 'assets/icons/mall.png'),
    _Category('Hospital', 'assets/icons/hospital.png'),
    _Category('Sport', 'assets/icons/sport.png'),
    _Category('Entertain', 'assets/icons/entertain.png'),
  ];

  void _navigateToCategory(BuildContext context, String category) {
    Navigator.pushNamed(context, AppRouter.category, arguments: category);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "l Category",
          style: TextStyle(
            color: Color.fromRGBO(31, 54, 113, 1),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _categories.length,
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final category = _categories[index];
            return CategoryCard(
              title: category.title,
              imagePath: category.assetPath,
              onTap: () => _navigateToCategory(context, category.title),
            );
          },
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
    super.key,
  });

  final String title;
  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(140, 201, 246, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(209, 235, 254, 1),
                borderRadius: BorderRadius.circular(7.5),
              ),
              child: Image.asset(imagePath),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Color.fromRGBO(31, 54, 113, 1),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Category {
  const _Category(this.title, this.assetPath);

  final String title;
  final String assetPath;
}
