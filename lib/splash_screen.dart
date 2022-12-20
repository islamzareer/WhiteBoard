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
    String text = "Here's your wide space,\n            let's go...";
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Board()),
          ),
          child: Container(
            height: 800,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/splash.gif"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TweenAnimationBuilder<int>(
                  duration: const Duration(seconds: 3),
                  tween: IntTween(begin: 0, end: text.length),
                  builder: (context, value, child) {
                    return Text(text.substring(0, value),
                        style: const TextStyle(
                            fontFamily: 'IslandMoments',
                            fontSize: 50,
                            fontWeight: FontWeight.bold));
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
