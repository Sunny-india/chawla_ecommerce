import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../main_screens/welcome_screen.dart';

/// The class below are all created for the purpose of
/// modelling
class AuthHeaderLabel extends StatelessWidget {
  final String label;
  const AuthHeaderLabel({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 35,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            /**To take customer from here back to WelcomeScreen*/
            Navigator.pushReplacementNamed(context, WelcomeScreen.screenName);
          },
          icon: Icon(
            CupertinoIcons.house_alt,
            color: MyConstants.buttonTextColor,
            size: 35,
          ),
        ),
      ],
    );
  }
}

var myTextFormFieldDecoration = InputDecoration(
  labelText: 'Enter your full Name, kindly',
  labelStyle: TextStyle(color: MyConstants.buttonTextColor),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.yellow),
    borderRadius: BorderRadius.circular(30),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
  ),
);

class HaveOrHaveNotAccountRow extends StatelessWidget {
  final String askForAccount;
  final String textButtonLabel;
  final Function() onPressed;
  const HaveOrHaveNotAccountRow(
      {super.key,
      required this.askForAccount,
      required this.textButtonLabel,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          askForAccount,
          style: TextStyle(
            fontSize: 14,
            color: MyConstants.buttonTextColor,
          ),
        ),
        const SizedBox(width: 4),
        // Material(
        //   borderRadius: BorderRadius.circular(15),
        //   color: MyConstants.buttonTextColor,
        //   child: MaterialButton(
        //     onPressed: onPressed,
        //     child: Text(
        //       textButtonLabel,
        //       style: const TextStyle(
        //         color: Colors.white,
        //         fontSize: 16,
        //         fontWeight: FontWeight.w700,
        //       ),
        //     ),
        //   ),
        // ),

        Align(
          alignment: Alignment.topCenter,
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              textButtonLabel,
              style: TextStyle(
                color: MyConstants.buttonTextColor,
                fontSize: 22,
                fontWeight: FontWeight.w500,
                fontFamily: 'FontTwo',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AuthMainButton extends StatelessWidget {
  final String mainButtonlabel;
  final Function() onPreseed;
  const AuthMainButton(
      {super.key, required this.mainButtonlabel, required this.onPreseed});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      color: MyConstants.buttonTextColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * .85,
        onPressed: onPreseed,
        child: Text(
          mainButtonlabel,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

extension EmailValidator on String {
  /// because as per the app's design we're checking a bool on our value in textFormField
  /// we created that type of method here and used hasMatch() method from RegExp class
  /// It reruns a bool value. and it would be used as extension on String class to be
  /// used on any String
  bool isValidEmail() {
    /**RegExp ka source constructor ek value as source leta hai, aur this se match krne ke baad
     * boolean value return krta hai. */
    return RegExp(
            r'^([a-zA-Z0-9]+)([\-_.!]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.])([a-zA-Z]{2,5})$')
        .hasMatch(this);
  }
}
