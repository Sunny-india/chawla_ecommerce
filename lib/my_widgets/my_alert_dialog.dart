import 'package:flutter/cupertino.dart';

// Because our use case depends upon a reusable AlertDialog,
// which is a function behaviour type, we would pass all the
// parameters to a function, instead of creating them as class field.

class MyAlertDialog {
  static void myShowDialog({
    required BuildContext context,
    required String myTitle,
    required String myContent,
    required Function() onTapYes,
    required Function() onTapNo,
    required String noText,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(myTitle),
          content: Text(myContent),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: onTapNo,
              child: Text(noText),
            ),
            CupertinoDialogAction(
              onPressed: onTapYes,
              // isDestructiveAction: true,
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
