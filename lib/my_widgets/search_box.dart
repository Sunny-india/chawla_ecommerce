import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchBoxAppBar extends StatefulWidget {
  const SearchBoxAppBar({
    super.key,
  });

  @override
  State<SearchBoxAppBar> createState() => _SearchBoxAppBarState();
}

class _SearchBoxAppBarState extends State<SearchBoxAppBar> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      //controller: searchText,
      onChanged: (value) {
        setState(() {
          searchText = value.trim();
          print(searchText);
        });
      },

      placeholder: 'What\'re you looking for..?',

      cursorColor: CupertinoColors.activeGreen,

      dragStartBehavior: DragStartBehavior.down,

      decoration: BoxDecoration(
        // defines background color//
        color: CupertinoColors.systemGrey6,
        border: Border.all(color: Colors.teal),
        borderRadius: BorderRadius.circular(15),
      ),

      suffix: CupertinoButton(
          padding: const EdgeInsets.all(0),
          child: const Icon(
            Icons.search,
            size: 35,
          ),
          onPressed: () {
            if (searchText != null) {
              print(searchText);
            }
          }),
    );

    Container(
      height: 40,
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        border: Border.all(color: CupertinoColors.systemYellow, width: 1.4),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'What\'re you looking for..?',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: CupertinoColors.systemGrey),
            ),
            // const Icon(FontAwesomeIcons.search),
            CupertinoButton(
                child: const Icon(FontAwesomeIcons.search), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
