import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  static const String route = "/intro";
  
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Hello"),
    );
  }
}