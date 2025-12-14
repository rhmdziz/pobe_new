import 'package:flutter/material.dart';
import 'package:pobe_new/app/app_router.dart';

class GetDestinySection extends StatelessWidget {
  const GetDestinySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRouter.destinationSet,
                arguments: {'startPoint': '', 'endPoint': ''},
              );
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(14, 47, 98, 1), // Dark blue color
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/bus.png'),
                  const SizedBox(width: 20),
                  const Text(
                    "Find Your Transport With Us",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.destinationSet,
                        arguments: {'startPoint': '', 'endPoint': ''},
                      );
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Text(
                          "add a destination",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.destinationSet,
                        arguments: {
                          'startPoint': 'INTERMODA',
                          'endPoint': 'THE BREEZE',
                        },
                      );
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Text(
                          "Intermoda - The Breeze",
                          style: TextStyle(
                            color: Color.fromRGBO(31, 54, 113, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
