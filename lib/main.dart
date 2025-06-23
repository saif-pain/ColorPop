import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(ColorMatchApp());
}

class ColorMatchApp extends StatelessWidget {
  const ColorMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ColorPop',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
