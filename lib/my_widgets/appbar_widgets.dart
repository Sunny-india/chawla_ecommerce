import 'package:chawla_trial_udemy/constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          fontFamily: 'FontTwo', color: Colors.black, letterSpacing: 1.5),
    );
  }
}

class AppBarBackButton extends StatelessWidget {
  final Color? buttonColor;

  const AppBarBackButton({super.key, this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: buttonColor ?? Colors.black,
      ),
      onPressed: () => Navigator.pop(context),
    );
  }
}
