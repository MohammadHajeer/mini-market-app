import 'package:flutter/material.dart';
import 'package:mini_market_app/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ar'), // Arabic language code
      theme: ThemeData(
        primaryColor: Colors.teal,
        fontFamily: 'Janna LT Bold',
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.teal,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: Home(),
      ),
    );
  }
}
