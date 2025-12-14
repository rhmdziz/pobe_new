import 'package:flutter/material.dart';
import 'package:pobe_new/features/home/dashboard/viewmodels/aqi_viewmodel.dart';
import 'package:pobe_new/features/home/dashboard/widgets/aqi_section.dart';
import 'package:pobe_new/features/home/dashboard/widgets/carousle_section.dart';
import 'package:pobe_new/features/home/dashboard/widgets/category_section.dart';
import 'package:pobe_new/features/home/dashboard/widgets/get_destiny_section.dart';
import 'package:pobe_new/features/home/dashboard/widgets/home_header_section.dart';
import 'package:pobe_new/features/home/dashboard/widgets/news_section.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<void> _onRefresh() async {
    await context.read<AqiViewModel>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              Positioned(
                left: -150,
                top: -150,
                child: Image.asset('assets/stack/stack_elemen.png'),
              ),
              Positioned(
                right: -200,
                top: 500,
                child: Image.asset('assets/stack/stack_elemen.png'),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    HomeHeaderSection(),
                    SizedBox(height: 16),
                    CarousleSection(),
                    SizedBox(height: 16),
                    GetDestinySection(),
                    SizedBox(height: 16),
                    CategoriesSection(),
                    SizedBox(height: 16),
                    NewsSection(),
                    SizedBox(height: 16),
                    AirPolutionSection(),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
