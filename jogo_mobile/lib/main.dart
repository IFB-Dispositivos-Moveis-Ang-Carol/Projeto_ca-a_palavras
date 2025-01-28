import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(WordSearchGame());
}

class WordSearchGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
