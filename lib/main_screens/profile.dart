import 'package:chawla_trial_udemy/constants.dart';
import 'package:chawla_trial_udemy/main_screens/welcome_screen.dart';
import 'package:chawla_trial_udemy/main_screens/wish.dart';
import 'package:chawla_trial_udemy/my_widgets/appbar_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../my_widgets/my_alert_dialog.dart';
import 'cart.dart';
import 'orders_screen.dart';

// Because the whole page is getting prepared with the help of
// database variables, we created it in a FutureBuilder state
// to fetch data from its connected database.

class ProfileScreen extends StatefulWidget {
  // Because we need documentId from FirebaseAuth to fetch the
  // users' detail on this page and login through Anonymous
  // function does not have any. So login through anonymous will
  // produce either an error from the given-below type at
  // FutureBuilding. To fix it, when we receive our anonymous user
  // here, from the WelcomeScreen, we need to bring his uid
  // along with him too. That logic is applied in
  // that block of code at WelcomeScreen. and the whole data
  // value is handled for both the registered and anonymous
  // users' point of view down.
  final String documentId;
  const ProfileScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Will create two CollectionReferences and passed them conditionally to the
  // future of FutureBuilder. That condition depends if the user is anonymous or not.

  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  //
  String aRandomPhoto =
      'https://static.vecteezy.com/system/resources/thumbnails/008/259/265/small/young-smiling-man-cartoon-character-keeping-arms-crossed-businessman-standing-with-folded-arms-pose-flat-illustration-isolated-on-white-background-free-vector.jpg';
  @override
  Widget build(BuildContext context) {
    // customers.get().then((value) => null);
    // The only purpose of calling FutureBuilder here is
    // we need to access the image path from FirebaseFirestore's data
    // to the profile pic here. That's why we need to fetch
    //FirebaseAuth.instance.currentUser!.uid from CustomerHomeScreen
    // and pass here in parent class to child class.

    //The whole FutureBuilder code is picked from
    //https://firebase.flutter.dev/docs/firestore/usage/#one-time-read
    // page.
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser!.isAnonymous
          ? anonymous.doc(widget.documentId).get()
          : customers.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong..!');
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          // todo: Anonymous login page is getting stuck here.
          //  todo: Fixed it at WelcomeScreen. Go and see the login explained over there.
          return const Text('Snapshot exists but Document does not exist.');
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: CustomScrollView(slivers: [
              SliverAppBar(
                expandedHeight: 140,
                pinned: true,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    return FlexibleSpaceBar(
                      centerTitle: true,
                      title: AnimatedOpacity(
                        opacity: constraints.biggest.height <= 120 ? 1 : 0,
                        duration: const Duration(microseconds: 300),
                        child: const Text(
                          'Accounts',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.yellow, Colors.brown],
                          ),
                        ),
                        /**Row added as a child for adding profile image in CircleAvatar*/
                        child: Padding(
                          padding: const EdgeInsets.only(left: 11.0, top: 8),
                          child: Row(
                            children: [
                              data['profileimage'] != ''
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          NetworkImage(data['profileimage']),
                                    )
                                  : const CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          AssetImage('assets/images/verna.jpg'),
                                    ),
                              const SizedBox(width: 20),
                              Text(
                                data['name'] != ''
                                    ? data['name']
                                    : 'guest'.toUpperCase(),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    /**Outer Container holding all three buttons in it*/
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          /** First container holding the Cart button to carry
                           * user to CartScreen.*/
                          Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width * .23,
                            decoration: const BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                )),
                            child: TextButton(
                              onPressed: () {
                                /**Why did we apply two different methods of Navigator.
                                 * Its logic is explained on CartScreen's comments up.
                                 * */
                                Navigator.canPop(context)
                                    ? Navigator.pop(context)
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CartScreen(
                                                  backButton:
                                                      AppBarBackButton(),
                                                )));
                              },
                              child: const Text(
                                'Cart',
                                style: TextStyle(
                                    color: Colors.yellow, fontSize: 20),
                              ),
                            ),
                          ),

                          /// 2nd Container holding the Orders button to carry user
                          /// to the OrderScreen
                          Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width * .23,
                            decoration: const BoxDecoration(
                              color: Colors.yellow,
                            ),
                            child: TextButton(
                              // to carry user from here... to OrderScreen //
                              onPressed: () {
                                /**Why did we apply two different methods of Navigator.
                                   * Its logic is explained on CartScreen's comments up.
                                   * */
                                Navigator.canPop(context)
                                    ? Navigator.pop(context)
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrderScreen(
                                            backButton: AppBarBackButton(),
                                          ),
                                        ),
                                      );
                              },
                              child: const Text(
                                'Orders',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 16.5),
                              ),
                            ),
                          ),

                          /// The 3rd container holding the button to carry user
                          /// to the WishListScreen
                          Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width * .23,
                            decoration: const BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                )),
                            child: SizedBox(
                              child: TextButton(
                                onPressed: () {
                                  // to carry user from here... to WishlistScreen //
                                  Navigator.canPop(context)
                                      ? Navigator.pop(context)
                                      : Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                          return WishScreen();
                                        }));
                                },
                                child: const Text(
                                  'Wishlist',
                                  style: TextStyle(
                                      color: Colors.yellow, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    /**SizedBox user to hold a static image here. Would be replaed with Company logo later*/
                    SizedBox(
                      width: 150,
                      height: MediaQuery.of(context).size.height * .25,
                      child: Image.network(
                        'https://m.media-amazon.com/images/I/61it6tDMqKL.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),

                    /** To show the account info text here only.
                     * It is going to be repeated twice or more,
                     * So created model of it. */
                    const ProfileHeaderLabel(headerLabel: '  Account Info  '),

                    /// Container holding the Account Info here. ///
                    Container(
                      height: 260,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          //ListTile lekar usko repeat krna tha, aur usko tappable bhi
                          //banana tha, isliye uska model create krke use kiya.
                          //will use the actual email address here, when connected with Firebase Auth
                          TappableListTile(
                            leading: Icons.email_outlined,
                            title: 'Email Address',
                            subTitle: data['email'] == ''
                                ? 'example@email.com'
                                : data['email'],
                          ),

                          //ye bhi repeat hona tha, iska bhi model banaya//
                          const YellowDivider(),

                          //will use the actual phone number here, when connected with Firebase Auth//
                          TappableListTile(
                            leading: CupertinoIcons.phone,
                            title: 'Phone Number',
                            subTitle: data['phone'] == ''
                                ? '98989898'
                                : data['phone'],
                          ),
                          const YellowDivider(),

                          /**will use the actual address here, when use the GoogleMap class for
                           * this purpose.*/
                          TappableListTile(
                            leading: Icons.location_on_outlined,
                            title: 'Address',
                            subTitle: data['address'] == ''
                                ? 'Trial'
                                : data['address'],
                          ),
                        ],
                      ),
                    ),

                    //To show the account settings text here only.//
                    const ProfileHeaderLabel(
                        headerLabel: '  Account Settings  '),

                    // Container holding the Account Settings here. //
                    Container(
                      height: 260,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          /** For updating user's data from here to Firebase Auth */
                          TappableListTile(
                            leading: Icons.edit,
                            title: 'Edit Profile',
                            onPressed: () {
                              // TODO: For updating user's info from here to Firebase Auth
                            },
                          ),
                          const YellowDivider(),

                          //For updating user's password from here to Firebase Auth//
                          TappableListTile(
                            leading: CupertinoIcons.lock,
                            title: 'Change Password',
                            onPressed: () {
                              // TODO: For updating user's info from here to Firebase Auth
                            },
                          ),
                          const YellowDivider(),
                          TappableListTile(
                            leading: Icons.logout,
                            title: 'LogOut',
                            // parent function made async. Why? Look Down at await point. //
                            onPressed: () async {
                              // instead of direct logout, gave user an alert dialog choice. //
                              // Hence this could be repetitive, created a model class for this
                              // AlertDialog and first used it here.
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          );
        }
        // this happens when the data first loads....
        return Center(
            child: CircularProgressIndicator(
          color: MyConstants.buttonTextColor,
        ));
      },
    );
  }
}

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Divider(
        color: Colors.yellow,
        thickness: 1,
      ),
    );
  }
}

class TappableListTile extends StatelessWidget {
  final IconData leading;
  final String title;
  final String subTitle;
  final Function()? onPressed;
  const TappableListTile(
      {super.key,
      required this.leading,
      required this.title,
      this.subTitle = '',
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        leading: Icon(leading),
        title: Text(title),
        subtitle: Text(subTitle),
      ),
    );
  }
}

class ProfileHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const ProfileHeaderLabel({super.key, required this.headerLabel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 60,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(headerLabel),
          const SizedBox(
            height: 40,
            width: 60,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
