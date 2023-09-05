import 'package:chawla_trial_udemy/dashboard_components/supplier_statics.dart';
import 'package:chawla_trial_udemy/main_screens/welcome_screen.dart';
import 'package:chawla_trial_udemy/minor_screens/visit_store.dart';
import 'package:chawla_trial_udemy/my_widgets/appbar_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../dashboard_components/manage_products.dart';
import '../dashboard_components/supplier_balance.dart';
import '../dashboard_components/supplier_edit_profile.dart';
import '../dashboard_components/supplier_orders.dart';
import '../my_widgets/my_alert_dialog.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);

  /// created this list of Strings, Icondata, and Widgets for adding the labels, and icons to the cards provided
  /// and sending the user to that particular page when tap on that particular card..
  /// Length of all the lists must stay equal to that of Card.
  final List<String> label = [
    'My Store',
    'Orders',
    'Edit Profile',
    'Manage Products',
    'Balance',
    'Statics'
  ];

  final List<IconData> icons = [
    Icons.store,
    Icons.shop_2_outlined,
    Icons.edit_outlined,
    Icons.settings,
    Icons.attach_money_outlined,
    Icons.show_chart_outlined
  ];

  List<Widget> pages = [
    VisitStore(supplierId: FirebaseAuth.instance.currentUser!.uid),
    const SupplierOrders(),
    const SupplierEditProfile(),
    const ManageProducts(),
    const SupplierBalance(),
    const SupplierStatics()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(
          title: 'Dashboard',
        ),
        actions: [
          IconButton(
            onPressed: () async {
              MyAlertDialog.myShowDialog(
                context: context,
                myTitle: 'Logout?',
                myContent: 'Do you really want to logout?',
                noText: 'Stay here',
                onTapNo: () {
                  Navigator.pop(context);
                },

                //in order to make this async work, you will have to
                // make its parent function async too.
                onTapYes: () async {
                  await FirebaseAuth.instance.signOut();

                  //this function works well, but in combination with
                  //anonymous login, with each logout tapping, it is creating
                  //a new user id in Firebase Authentication for the same user.

                  // todo: How to overcome it?
                  //todo: and take customer from here to WelcomeScreen
                  // toDo: without giving him a back button option.

                  //Because CupertinoAlertDialog bring extra back button with it.//
                  //That's why we used pop button first and pushReplacementNamed method here.//
                  // Otherwise Customer Login Screen brings unnecessary back button.
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(
                      context, WelcomeScreen.screenName);
                },
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            crossAxisCount: 2,
            children: List.generate(
              label.length,
              // AND icons.length //
              //AND pages.length//
              (index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => pages[index],
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadowColor: Colors.blueGrey,
                    color: Colors.grey.shade300,
                    elevation: 20,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            icons[index],
                            size: 50,
                            color: Colors.blue.shade800,
                          ),
                          Text(
                            label[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.orange.shade800,
                                fontSize: 21,
                                letterSpacing: 1.5),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
