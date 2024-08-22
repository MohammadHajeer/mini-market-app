import 'package:flutter/material.dart';
import 'package:mini_market_app/pages/home.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ar'), // Arabic language code
      theme: ThemeData(fontFamily: 'Janna LT Bold'),
      debugShowCheckedModeBanner: false,
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: Home(),
      ),
    );
  }
}


