import 'package:chawla_trial_udemy/constants.dart';
import 'package:chawla_trial_udemy/main_screens/customer_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../my_widgets/auth_widgets.dart';
import '../my_widgets/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'customer_login.dart';

class CustomerRegister extends StatefulWidget {
  const CustomerRegister({Key? key}) : super(key: key);
  static String screenName = '/customer_register';
  @override
  State<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister> {
  // The work of fetching the users' below detail could be done through creating the
  // TextEditingControllers for all the fields below respectively. But I chose to do it
  // through onChanged method in TextFormFields. Hence created below String type objects,
  // to initialise them late.
  late String _name;
  late String _email;
  late String _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  bool passwordHidingType = true;

  // created this XFile type object for storing the images, to be captured from different sources
  // later, and used for other if else conditions in signup button.
  XFile? _imageFile;

  // for storing any possible error while picking the images type file
  dynamic _pickedImageError;

  // for storing images downloaded from firebase_storage reference.
  late String profileImage;

  //for storing customer's detail in FirebaseFirestore's  particular Reference.
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  //for storing FirebaseAuth.instance.currentuser!.uid from FirebaseAuth
  late String _uid;

  // for disabling Signup button when processing
  // and would change its value at multiple possible failures in Signup method
  bool isSignUpProcessing = false;

  // created the functionality for the purpose of picking images from Gallery
  // and have it used on Gallery button down
  void _pickImageFromGallery() async {
    try {
      final imagePicked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        _imageFile = imagePicked;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  // recreated the same functionality for the purpose of clicking images from Camera
  // and have it used on Camera button down
  void _pickImageFromCamera() async {
    try {
      final imagePicked = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        _imageFile = imagePicked;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  //made it async, because it is about to send the details to Firebase await type usage.
  void signUp() async {
    if (_imageFile != null) {
      // TextFormField validator will be checked here
      // through the _formKey of GlobalKey*/
      if (_formKey.currentState!.validate()) {
        setState(() => isSignUpProcessing = true);
        //Because Firebase might throw an FirebaseAuthException type error,
        // we bound this part of code in a try catch block.
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _email, password: _password);

          //1. In order to  upload customer image in firebase_storage under the
          // name of his/her email id, we would create the reference
          // (where we need to store those images.)
          firebase_storage.Reference storeRef = firebase_storage
              .FirebaseStorage.instance
              .ref('customer-images/$_email.jpg');

          // after creating that reference, we upload our selected
          // file's path to that place.
          await storeRef.putFile(File(_imageFile!.path));

          // 2. The same image would be used at other places,so would make it downloadable.
          profileImage = await storeRef.getDownloadURL();

          //3. will create customer details in FirebaseFirestore. For that,
          // we would already created that CollectionReference above.
          // but we need to create its document. So that we would create
          // under the same name as FirebaseAuth.instance.currentUser.uid, to keep that
          // document unique. Further we would save both the same reference as above along
          // with other details.
          _uid = FirebaseAuth.instance.currentUser!.uid;
          await customers.doc(_uid).set({
            'name': _name,
            'email': _email,
            'profileimage': profileImage,
            'phone': '',
            'address': '',
            'cid': _uid,
          });

          //After validation all the fields would be empty.//
          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });

          // and when everything is done, route the user to...
          // wherever the app needs.
          Navigator.pushReplacementNamed(
              context, CustomerHomeScreen.screenName);
        } on FirebaseAuthException catch (e) {
          //All the other error codes might get from
          // https://firebase.google.com/docs/auth/flutter/password-auth
          if (e.code == 'weak-password') {
            setState(() => isSignUpProcessing = false);
            MyMessageHandler.showSnackBar(
                _scaffoldKey, 'The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            setState(() => isSignUpProcessing = false);
            MyMessageHandler.showSnackBar(
                _scaffoldKey, 'The account already exists for that email.');
          }
        } // catch(e) ended
      } else {
        setState(() => isSignUpProcessing = false);
        // When any of the above fields are not validated. We'd show a SnackBar
        // here. Hence it is repeatable, we create a model method for it and
        // first used it here.
        MyMessageHandler.showSnackBar(
            _scaffoldKey, 'Please Enter Valid Values');
      }
    } else {
      setState(() => isSignUpProcessing = false);
      MyMessageHandler.showSnackBar(
          _scaffoldKey, 'Please provide us an image first..!');
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
                  /*This form key comes from GlobalKey, so in order to use it, create
                   and initiate the GlobalKey object*/
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // This header is to be repeated at many places, at least four, in app, so
                      // created its model class here.*/
                      const AuthHeaderLabel(label: 'Sign Up'),
                      const SizedBox(height: 16),

                      //1st row containing all the containers for profile pic, image fetching
                      // from camera or gallery*/
                      Row(
                        children: [
                          /**Container containing CircleAvatar for the purpose of showing profile photos*/
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                            ),
                            decoration: BoxDecoration(
                                gradient: MyConstants.myGradient,
                                shape: BoxShape.circle),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.transparent,
                              backgroundImage: _imageFile == null
                                  ? null
                                  : FileImage(
                                      File(_imageFile!.path),
                                    ),
                            ),
                          ),

                          /**Both containers carrying image from gallery, and image from camera
                           * in this column*/
                          Column(
                            children: [
                              /**Container carrying Capturing images from camera functionality in it*/
                              Container(
                                decoration: BoxDecoration(
                                  gradient: MyConstants.myGradient,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                ),
                                child: CupertinoButton(
                                  onPressed: () {
                                    //todo: to pick images from camera
                                    _pickImageFromCamera();
                                    /** for the purpose of Capturing images from Camera.
                                     * it requires Camera Sourcing later*/
                                    print('Pick Images from Camera');
                                  },
                                  child: Icon(
                                    CupertinoIcons.camera_on_rectangle,
                                    color: MyConstants.buttonTextColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),

                              /**Container carrying sourcing  images from Gallery functionality in it*/
                              Container(
                                decoration: BoxDecoration(
                                  gradient: MyConstants.myGradient,
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                ),
                                child: CupertinoButton(
                                  onPressed: () {
                                    //todo: to pick images from the gallery
                                    /** for the purpose of fetching images from gallery.
                                     * it requires Image Sourcing later*/
                                    _pickImageFromGallery();
                                    print('Pick Images from Gallery');
                                  },
                                  child: Icon(
                                    CupertinoIcons.photo,
                                    color: MyConstants.buttonTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      //1st TextFormField for asking user their names, because it too is repetiative , created its model
                      // class too*/
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          // validator is ready but can be used once this is called through
                          // the formKey, so in order to use all the validators, wrap them all
                          // in Form Widget. So wrapped the main Column in Form*/
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Some Valid Value';
                            } else {
                              return null;
                            }
                          },

                          // This onChanged method would be called
                          // only after the validator.
                          onChanged: (value) {
                            setState(() {
                              _name = value;
                            });
                          },

                          // Now when everything is ready. This function will check when calling
                          // and its calling is done in the bottom Sign Up button*/
                          decoration: myTextFormFieldDecoration.copyWith(
                              labelText: 'Enter your name'),
                        ),
                      ),

                      // 2nd TextFormField for asking user their email
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

                      // 3rd TextFormField for asking user their related passwords.
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
                      const SizedBox(height: 6),

                      // created model class for the account have line below the password
                      // text form field and first used here
                      HaveOrHaveNotAccountRow(
                        askForAccount: 'Already Have an Account?',
                        textButtonLabel: 'Login',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            CustomerLogin.screenName,
                          );
                        },
                      ),
                      const SizedBox(height: 6),

                      // Created model class for the button here,
                      // will be used at many places
                      isSignUpProcessing
                          ? const CircularProgressIndicator()
                          : AuthMainButton(
                              mainButtonlabel: 'Sign Up',
                              onPreseed: () {
                                signUp();
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
