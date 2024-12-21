import 'package:flutter/material.dart';
import 'package:coffee_shop_app/screens/start_screen.dart';

void main() {
  runApp(const NakamaApp());
}

class NakamaApp extends StatelessWidget {
  const NakamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(),
    );  
  }
}
