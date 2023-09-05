import 'dart:async';
import 'dart:math';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:chawla_trial_udemy/main_screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static String screenName = '/splash_screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startMe();
  }

  void startMe() {
    Timer(const Duration(seconds: 3), () {
      takeMeToWelcomeScreen();
    });
  }

  void takeMeToWelcomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return Material(
          color: Colors.red.shade900,
          child: WelcomeScreen()
              .animate()
              .scale(duration: 1.11.seconds, curve: Curves.easeInExpo),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: SafeArea(
          child: Transform.rotate(
            angle: pi / 12,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.shade100,
                    Colors.teal.shade100,
                    Colors.red.shade100,
                    Colors.teal.shade100,
                    Colors.red.shade100
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                "Latuni",
                style: TextStyle(fontSize: 50, color: Colors.purple.shade500),
              ).animate().scale(duration: 1.1.seconds),
            ),
          ),
        ),
      ),
    );
  }
}
