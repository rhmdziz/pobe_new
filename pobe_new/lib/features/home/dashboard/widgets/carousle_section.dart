import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarousleSection extends StatefulWidget {
  const CarousleSection({super.key});

  @override
  State<CarousleSection> createState() => _CarousleSectionState();
}

class _CarousleSectionState extends State<CarousleSection> {
  final PageController _controller = PageController();
  final List<String> _images = const [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.png',
  ];

  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _controller,
            itemCount: _images.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final imagePath = _images[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imagePath,
                    width: MediaQuery.of(context).size.width * 0.84,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Discover BSD',
              style: TextStyle(
                color: Color.fromRGBO(31, 54, 113, 1),
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            SmoothPageIndicator(
              controller: _controller,
              count: _images.length,
              effect: const ExpandingDotsEffect(
                activeDotColor: Color.fromRGBO(31, 54, 113, 1),
                dotColor: Color.fromRGBO(31, 54, 111, 0.42),
                dotHeight: 7,
                dotWidth: 7,
                expansionFactor: 4,
              ),
              onDotClicked: (index) {
                _controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
