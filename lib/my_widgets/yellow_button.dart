import 'package:flutter/material.dart';

import '../constants.dart';

class YellowButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Color buttonColor;
  final double? myMinWidth;
  final double? myContainerHeight;
  const YellowButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.myContainerHeight = 40,
      this.buttonColor = Colors.yellow,
      this.myMinWidth = .4});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: myContainerHeight,
      // width: MediaQuery.of(context).size.width * .45,
      decoration: BoxDecoration(
        border: Border.all(color: MyConstants.buttonTextColor),
        borderRadius: BorderRadius.circular(15),
        color: buttonColor,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: MediaQuery.of(context).size.width * myMinWidth!,
        child: Text(
          label,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
