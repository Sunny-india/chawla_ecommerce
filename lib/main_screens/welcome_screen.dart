import 'package:chawla_trial_udemy/auth/supplier_signup.dart';
import 'package:chawla_trial_udemy/constants.dart';
import 'package:chawla_trial_udemy/my_widgets/yellow_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/customer_login.dart';
import '../auth/customer_signup.dart';
import '../auth/supplier_login.dart';
import 'customer_home.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);
  //
  static String screenName = '/welcome_screen';
//
  final CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  /// initiated and have its usage changed in the last SignUp button
  /// to interchange that with a CircularIndicator, lest the user may
  /// tap that button repeatedly.
  bool isProcessing = false;
  late String _uid;
  //
  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        //   backgroundColor: Colors.transparent,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/login.png',
                ),
                fit: BoxFit.cover),
          ),
          constraints: const BoxConstraints.expand(),
          child: SafeArea(
            child: SingleChildScrollView(
              /**Padding provided to keep all the children of this column into horizontally aligned.
               * down the line provided each child of this column a particular width for the same as
               * above symmetrical purpose*/
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 40),

                    /**Welcome Note Container*/
                    Container(
                      constraints: const BoxConstraints(minHeight: 50),
                      width: MediaQuery.of(context).size.width * .95,
                      decoration: BoxDecoration(
                        color: MyConstants.buttonTextColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: const Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Welcome',
                          style:
                              TextStyle(fontSize: 30, color: Colors.tealAccent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    /**basket image placed here for decoration purpose only*/
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .95,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: const Image(
                          image: AssetImage('assets/images/basket.avif'),
                          fit: BoxFit.cover,
                          // width: MediaQuery.of(context).size.width * .7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Suppliers Only',
                      style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 28,
                          color: MyConstants.buttonTextColor),
                      //Color(0xff4c505b)
                    ),

                    /**1st container holding Suppliers login, signup buttons here*/
                    Container(
                      width: MediaQuery.of(context).size.width * .95,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: const DecorationImage(
                            image: AssetImage('assets/images/basket.avif'),
                            fit: BoxFit.cover),
                      ),
                      /**Supplier's login and signup button in this row*/
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /**Suppliers' login button in this container*/
                          Expanded(
                            child: YellowButton(
                              label: 'Login',
                              onPressed: () {
                                //todo: for suppliers login logic here.
                                //todo: and later to attach with FirebaseAuth too.
                                Navigator.pushReplacementNamed(
                                    context, SupplierLogin.screenName);
                              },
                            ),
                          ),
                          const SizedBox(width: 6),

                          /**Suppliers' SignUp button in this container*/
                          Expanded(
                            child: YellowButton(
                              label: 'Sign Up',
                              onPressed: () {
                                //todo: Suppliers' signup logic here.//
                                // Navigator.pop(context);
                                Navigator.pushReplacementNamed(
                                    context, SupplierRegister.screenName);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Customers Only',
                      style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 28,
                          color: MyConstants.buttonTextColor),
                    ),

                    /**2nd container holding Customers login, signup buttons here*/
                    Container(
                      width: MediaQuery.of(context).size.width * .95,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: const DecorationImage(
                            image: AssetImage('assets/images/basket.avif'),
                            fit: BoxFit.cover),
                      ),

                      /**Customer's login and signup button in this row*/
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /**Customers' login button in this container*/
                          Expanded(
                            child: YellowButton(
                              label: 'Login',
                              onPressed: () {
                                //todo: for customers login from Firebase or Supabase logic here.//
                                //todo: and after login take them to CustomerHomeScreen
                                Navigator.pushReplacementNamed(
                                    context, CustomerLogin.screenName);
                              },
                            ),
                          ),
                          const SizedBox(width: 6),

                          /**Suppliers' SignUp button in this container*/
                          Expanded(
                            child: YellowButton(
                              label: 'Sign Up',
                              onPressed: () {
                                //todo: Customers' signup logic here.//
                                Navigator.pushReplacementNamed(
                                    context, CustomerRegister.screenName);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    /**Container holding all three buttons for login from different social media
                     * accounts*/
                    Container(
                      width: MediaQuery.of(context).size.width * .95,
                      decoration: BoxDecoration(
                          color: MyConstants.buttonTextColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          /**about to repeat, so created its model and applied here and down
                           * 1st button for Google login at the bottom of this page*/
                          GoogleFacebookLogin(
                            label: 'Google',
                            childWidget: const Image(
                                image:
                                    AssetImage('assets/images/googleLogo.png')),
                            onPressed: () {
                              //todo: for login through Google id here.
                              print('Google pressed here.');
                            },
                          ),

                          /**2nd button for Facebook login at the bottom of this page*/
                          GoogleFacebookLogin(
                            label: 'Facebook',
                            childWidget: const Image(
                                image: AssetImage(
                                    'assets/images/facebookLogo.png')),
                            onPressed: () {
                              //todo: for login through Facebook id here.
                              print('Facebook pressed here.');
                            },
                          ),

                          /**3rd button for anonymous login at the bottom of this page*/
                          isProcessing == true
                              ? const CircularProgressIndicator()
                              : GoogleFacebookLogin(
                                  label: 'Anonymous',
                                  childWidget: const Image(
                                      image: AssetImage(
                                          'assets/images/womanLogo.jpeg')),
                                  onPressed: () async {
                                    setState(() {
                                      isProcessing = true;
                                    });
                                    //todo: for login through Google id here.
                                    //todo: before have the user login anonymously, main app must be
                                    // initialize with WidgetsFlutterBinding and Firebase
                                    print('Anonymous pressed here.');

                                    // will create a collection and unique userId for anonymous user
                                    // and pass that userId to that collcetion of anonymous.
                                    //but instead of fetching only its userId, we need to send it
                                    // to the ProfilePage too, so used whenComplete() method ahead
                                    // and used the same fields for this user as they are set for
                                    // a registered user at our Firebase project. from video 88-89
                                    await FirebaseAuth.instance
                                        .signInAnonymously()
                                        .whenComplete(() async {
                                      // create a _uid for this anonymous user here.
                                      _uid = FirebaseAuth
                                          .instance.currentUser!.uid;
                                      // and send that to the doc in firebase.
                                      await anonymous.doc(_uid).set({
                                        // hence picked this part of code from
                                        // CustomerRegistrationScreen here.
                                        'name': '',
                                        'email': '',
                                        'profileimage': '',
                                        'phone': '',
                                        'address': '',
                                        'cid': _uid,
                                      });
                                    });
                                    // print(
                                    //     '${FirebaseAuth.instance.currentUser!.uid} is your unique user id');
                                    Navigator.pushReplacementNamed(
                                        context, CustomerHomeScreen.screenName);
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GoogleFacebookLogin extends StatelessWidget {
  final Function() onPressed;
  final Widget childWidget;
  final String label;
  const GoogleFacebookLogin(
      {super.key,
      required this.onPressed,
      required this.childWidget,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15), child: childWidget),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
