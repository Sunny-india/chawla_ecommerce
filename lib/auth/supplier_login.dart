// Much of this page's code is copied from customer_signup page, due to
// the same functionality, but with some slight changes made here.

import 'package:chawla_trial_udemy/auth/supplier_signup.dart';
import 'package:chawla_trial_udemy/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main_screens/supplier_home.dart';
import '../my_widgets/auth_widgets.dart';
import '../my_widgets/snackbar.dart';

class SupplierLogin extends StatefulWidget {
  const SupplierLogin({Key? key}) : super(key: key);
  static String screenName = '/supplier_login';
  @override
  State<SupplierLogin> createState() => _SupplierLoginState();
}

class _SupplierLoginState extends State<SupplierLogin> {
  // The work of fetching the users' below detail could be done through creating the
  // TextEditingControllers for all the fields below respectively. But I chose to do it
  // through onChanged method in TextFormFields. Hence created below String type objects,
  // to initialise them late.

  late String _email;
  late String _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  // for hiding the password while entering that in TextFormField
  bool passwordHidingType = true;

  // for disabling Login button when processing
  // and would change its value at multiple possible failures in Signup method
  bool isSignUpProcessing = false;

  //made it async, because it is about to send the details to Firebase await type usage.
  void logIn() async {
    // TextFormField validator will be checked here
    // through the _formKey of GlobalKey
    if (_formKey.currentState!.validate()) {
      setState(() => isSignUpProcessing = true);

      //Because Firebase might throw an FirebaseAuthException type error,
      // we bound this part of code in a try catch block.
      try {
        // to fetch user's detail from FirebaseAuth
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);

        //After validation all the fields would be empty.//
        _formKey.currentState!.reset();

        /** and when everything is done, route the user to..wherever the app needs.*/
        Navigator.pushReplacementNamed(context, SupplierHomeScreen.screenName);
      } on FirebaseAuthException catch (e) {
        //All the other error codes might get from
        //   // https://firebase.google.com/docs/auth/flutter/password-auth
        if (e.code == 'user-not-found') {
          setState(() => isSignUpProcessing = false);
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          setState(() => isSignUpProcessing = false);
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'Wrong password provided for that user.');
        }
      }
    } else {
      setState(() => isSignUpProcessing = false);
      // When any of the above fields are not validated. We'd show a SnackBar
      // here. Hence it is repeatable, we create a model method for it and
      // first used it here.
      MyMessageHandler.showSnackBar(_scaffoldKey, 'Please Enter Valid Values');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              reverse: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  // This form key comes from GlobalKey, so in order to use it, create
                  // and initiate the GlobalKey object
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthHeaderLabel(label: 'Suppliers\' Login'),
                      const SizedBox(height: 46),

                      // 1st TextFormField for asking user their email
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: myTextFormFieldDecoration.copyWith(
                              labelText: 'Email here'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Valid Email here';
                            } else if (value.isValidEmail() == false) {
                              return 'Please Enter only a valid email';
                            } else if (value.isValidEmail() == true) {
                              return null; // means the purpose of this else is complete, and proceed
                            } else {
                              return null; // means the purpose of this else is complete, and proceed
                            }
                          },

                          // This onChanged method would be called only after the validator.
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                            });
                          },
                        ),
                      ),

                      // 2nd TextFormField for asking user their related passwords.
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: passwordHidingType,
                          decoration: InputDecoration(
                            suffixIcon: CupertinoButton(
                                child: Icon(passwordHidingType
                                    ? CupertinoIcons.lock_open
                                    : CupertinoIcons.lock),
                                onPressed: () {
                                  setState(() {
                                    passwordHidingType = !passwordHidingType;
                                  });
                                }),
                            labelText: 'password',
                            labelStyle:
                                TextStyle(color: MyConstants.buttonTextColor),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.yellow),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Some Valid Value';
                            } else {
                              return null;
                            }
                          },

                          //This onChanged method would be called
                          // only after the validator.
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                        ),
                      ),

                      // Forgot password Button //
                      TextButton(
                        onPressed: () {
                          //todo: sending some password forgetting link
                        },
                        child: const Text('Forgot Password'),
                      ),
                      const SizedBox(height: 16),

                      HaveOrHaveNotAccountRow(
                        askForAccount: 'Don\'t  Have an Account?',
                        textButtonLabel: 'Sign Up',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, SupplierRegister.screenName);
                        },
                      ),
                      const SizedBox(height: 16),

                      isSignUpProcessing
                          ? const Center(child: CircularProgressIndicator())
                          : AuthMainButton(
                              mainButtonlabel: 'Login',
                              onPreseed: () {
                                logIn();
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
