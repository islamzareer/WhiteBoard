import 'dart:async';

import 'package:flutter/material.dart';
import 'package:white_board/board.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(seconds: 4),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const Board())));
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Board()),
          ),
          child: Container(
            height: 800,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/splash.gif"),
                fit: BoxFit.cover,
              ),
            ),
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
