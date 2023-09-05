import 'package:chawla_trial_udemy/main_screens/category.dart';
import 'package:chawla_trial_udemy/main_screens/profile.dart';
import 'package:chawla_trial_udemy/main_screens/stores.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'cart.dart';
import 'home.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);
  static String screenName = '/customer_home_screen';
  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  // list of pages to be displayed through Bottom Navigation Bar//
  List<Widget> pages = [
    const HomeScreen(),
    const CategoryScreen(),
    const StoresScreen(),
    /**Neumorphic package mein problem aa rahi thi
     * isliye usko totally disabled kr diya, from the dependecies too. */
    // PageThree(),
    const CartScreen(),
    // Why did we pass a parameter to ProfileScreen? Reason is
    // explained on ProfileScreeen in detail.
    ProfileScreen(
      documentId: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        //****starts***//
        elevation: 0,
        type: BottomNavigationBarType.fixed,

        selectedItemColor: CupertinoColors.systemOrange,

        unselectedItemColor: CupertinoColors.systemGrey,

        // works only when type is fixed. See above.//
        backgroundColor: Colors.white,

        currentIndex: _currentIndex,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        //must be as many in numbers as our upper list is.//
        items: [
          const BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(CupertinoIcons.home),
          ),
          const BottomNavigationBarItem(
            label: 'Category',
            icon: Icon(CupertinoIcons.search),
          ),
          const BottomNavigationBarItem(
            label: 'Stores',
            icon: Icon(CupertinoIcons.building_2_fill),
          ),
          BottomNavigationBarItem(
            label: 'Shopping Cart',
            // Badge added in order to prompt customer to see their cart.
            icon: Badge(
                isLabelVisible: context.watch<Cart>().getProductList.isNotEmpty
                    ? true
                    : false,
                label: Text(
                    (context.watch<Cart>().getProductList.length.toString())),
                child: const Icon(CupertinoIcons.shopping_cart)),
          ),
          const BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(CupertinoIcons.person),
          )
        ],

        //****ends ***//
      ),

      // body depends upon the page we tapped from the bottom navigation//
    );
  }
}
