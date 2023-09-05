/// page totally for suppliers
/// because many of its functionally and features match the CustomerHomeScreen,
/// Most of its parts are copied from there.

import 'package:chawla_trial_udemy/main_screens/category.dart';
import 'package:chawla_trial_udemy/main_screens/stores.dart';
import 'package:chawla_trial_udemy/main_screens/upload_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'home.dart';

class SupplierHomeScreen extends StatefulWidget {
  const SupplierHomeScreen({Key? key}) : super(key: key);
  static String screenName = '/supplier_home_screen';
  @override
  State<SupplierHomeScreen> createState() => _SupplierHomeScreenState();
}

class _SupplierHomeScreenState extends State<SupplierHomeScreen> {
  // list of pages to be displayed through Bottom Navigation Bar//
  List<Widget> pages = [
    const HomeScreen(),
    const CategoryScreen(),
    const StoresScreen(),
    DashboardScreen(),
    const UploadProduct(),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(CupertinoIcons.home),
          ),
          BottomNavigationBarItem(
            label: 'Category',
            icon: Icon(CupertinoIcons.search),
          ),
          BottomNavigationBarItem(
            label: 'Stores',
            icon: Icon(CupertinoIcons.building_2_fill),
          ),
          BottomNavigationBarItem(
            label: 'Dashboard',
            icon: Icon(Icons.dashboard),
          ),
          BottomNavigationBarItem(
            label: 'Upload',
            icon: Icon(CupertinoIcons.cloud_upload),
          )
        ],

        //****ends ***//
      ),

      // body depends upon the page we tapped from the bottom navigation//
      body: SafeArea(child: pages[_currentIndex]),
    );
  }
}
