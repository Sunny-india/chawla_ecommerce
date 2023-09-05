import 'package:flutter/material.dart';

import '../constants.dart';

class MyMessageHandler {
  static void showSnackBar(var _scaffoldKey, String messageToDisplay) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: MyConstants.buttonTextColor,
        content: Text(
          messageToDisplay,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
