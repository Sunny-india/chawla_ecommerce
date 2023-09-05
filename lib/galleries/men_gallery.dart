import 'package:chawla_trial_udemy/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/product_model.dart';

class MenGalleryScreen extends StatefulWidget {
  const MenGalleryScreen({super.key});
  static String screenName = '/men_gallery_screen';
  @override
  State<MenGalleryScreen> createState() => _MenGalleryScreenState();
}

class _MenGalleryScreenState extends State<MenGalleryScreen> {
  /**Most Important*/
  //The whole Stream has been filtered on the basis of the maincateg field
  // mentioned in FirebaseFirestore.
  final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg', isEqualTo: 'men')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    /*The official documentation of StreamBuilder can be reat at
    https://firebase.google.com/docs/firestore/query-data/listen page.
     Its modal code copied here.*/

    //class UserInformation extends StatefulWidget {
    //   @override
    //   _UserInformationState createState() => _UserInformationState();
    // }
    //
    // class _UserInformationState extends State<UserInformation> {
    //   final Stream<QuerySnapshot> _usersStream =
    //       FirebaseFirestore.instance.collection('users').snapshots();
    //
    //   @override
    //   Widget build(BuildContext context) {
    //     return StreamBuilder<QuerySnapshot>(
    //       stream: _usersStream,
    //       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //         if (snapshot.hasError) {
    //           return const Text('Something went wrong');
    //         }
    //
    //         if (snapshot.connectionState == ConnectionState.waiting) {
    //           return const Text("Loading");
    //         }
    //
    //         return ListView(
    //           children: snapshot.data!.docs
    //               .map((DocumentSnapshot document) {
    //                 Map<String, dynamic> data =
    //                     document.data()! as Map<String, dynamic>;
    //                 return ListTile(
    //                   title: Text(data['full_name']),
    //                   subtitle: Text(data['company']),
    //                 );
    //               })
    //               .toList()
    //               .cast(),
    //         );
    //       },
    //     );
    //   }
    // }
    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
        ///* This is useful during testing when firebase overrides
        /// its date-rules. Then this happens. *///
        if (snapShot.hasError) {
          return const Text('Something Went Wrong..!');
        }
        if (snapShot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: MediaQuery.sizeOf(context).height * 5,
            child: Center(
              child: CircularProgressIndicator(
                color: MyConstants.buttonTextColor,
              ),
            ),
          );
        }

        // One extra if check applied, when our filtered data is still not available on Database
        if (snapShot.data!.docs.isEmpty) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 300,
                  width: MediaQuery.sizeOf(context).width * .95,
                  child: SvgPicture.asset(
                    'assets/images/elephant.svg',
                    fit: BoxFit.fill,
                  )),
              Container(
                width: MediaQuery.sizeOf(context).width * .95,
                alignment: Alignment.center,
                child: Text(
                  'This Category\nis not Available Right Now.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyConstants.buttonTextColor, fontSize: 30),
                ),
              ),
            ],
          ));
        }
        // Requires learning how to take ListTile in ListView children Or GridView.builder//
        return SingleChildScrollView(
          child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 4, right: 4),
              itemCount: snapShot.data!.docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4),
              itemBuilder: (context, index) {
                return ProductModel(
                  products: snapShot.data!.docs[index],
                );
              }),
        );

        // return ListView(
        //   children: snapShot.data!.docs.map((DocumentSnapshot document) {
        //     Map<String, dynamic> innerData =
        //         document.data()! as Map<String, dynamic>;
        //     return ListTile(
        //       contentPadding: const EdgeInsets.only(left: 8, top: 4, right: 8),
        //       leading: CachedNetworkImage(
        //         fit: BoxFit.cover,
        //         width: 80,
        //         height: 100,
        //         imageUrl: innerData['productimages'][0],
        //       ),
        //       title: Text(innerData['maincateg'].toString()),
        //       subtitle: Text(
        //         innerData['price'].toString(),
        //       ),
        //       trailing: Material(
        //         color: Colors.yellow,
        //         borderRadius: BorderRadius.circular(15),
        //         child: MaterialButton(
        //           child: const Text('Add to cart'),
        //           onPressed: () {},
        //         ),
        //       ),
        //     );
        //   }).toList(),
        // );
      },
    );
  }
}
