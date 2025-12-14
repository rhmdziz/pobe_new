import 'package:flutter/material.dart';
import 'package:pobe_new/app/app_provider.dart';
import 'package:pobe_new/app/app_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        title: 'PoBe',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(31, 54, 113, 1)),
          useMaterial3: true,
          textTheme: GoogleFonts.lexendTextTheme(),
        ),
        initialRoute: AppRouter.initialRoute,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
