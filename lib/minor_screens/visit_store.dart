import 'package:cached_network_image/cached_network_image.dart';
import 'package:chawla_trial_udemy/my_widgets/appbar_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import '../models/product_model.dart';

class VisitStore extends StatefulWidget {
  final String supplierId;
  const VisitStore({super.key, required this.supplierId});

  @override
  State<VisitStore> createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  CollectionReference suppliers =
      FirebaseFirestore.instance.collection('suppliers');
  bool isFollowing = false;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: widget.supplierId)
        .snapshots();

    /// for learning purpose that how different type of data can be fetched from Firebase
    //  DocumentReference allDocumentsFromSuppliers = suppliers.doc();
    //   Future<DocumentSnapshot> singleSupplier = FirebaseFirestore.instance
    //      .collection('suppliers')
    //      .doc(widget.supplierId)
    //      .get();
    //  Future<QuerySnapshot> yoyoData =
    //      FirebaseFirestore.instance.collection('suppliers').get();
    Size mSize = MediaQuery.sizeOf(context);
    return FutureBuilder(
        future: suppliers.doc(widget.supplierId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const SafeArea(child: Text('Document does not exist..!'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            /// to avoid the background black screen to be appeared during proces..
            return const Material(
                child: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> innerData =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              appBar: AppBar(
                leading: AppBarBackButton(),
                toolbarHeight: 130,
                // flexibleSpace: CachedNetworkImage(
                //   imageUrl: innerData['storelogo'].toString(),
                //   fit: BoxFit.cover,
                // ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: CachedNetworkImage(
                          imageUrl: innerData['storelogo'].toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 130, // equivalent to that of the toolbarHeight//
                      width: mSize.width * .3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            innerData['storename'].toString(),
                            style: const TextStyle(color: Colors.black),
                          ),

                          /// When the owner sees his/her self store. With Edit button
                          ///  This impacts on product_model page. Go and see there.
                          innerData['sid'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Container(
                                  alignment: Alignment.center,
                                  height: 35,
                                  width: MediaQuery.sizeOf(context).width * .3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.black87),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Edit'),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                )

                              /// When the customer sees their store. With Follow button
                              : Container(
                                  alignment: Alignment.center,
                                  height: 35,
                                  width: MediaQuery.sizeOf(context).width * .3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.black87),
                                  child: MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        isFollowing = !isFollowing;
                                      });
                                    },
                                    child: Text(
                                      isFollowing ? 'following' : 'FOLLOW',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              body: SafeArea(
                child: StreamBuilder<QuerySnapshot>(
                  stream: productsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapShot) {
                    ///* This is useful during testing when firebase overrides
                    /// its date-rules. Then this happens. *///
                    if (snapShot.hasError) {
                      return const Text('Something Went Wrong..!');
                    }
                    if (snapShot.connectionState == ConnectionState.waiting) {
                      return Material(
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height * 5,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: MyConstants.buttonTextColor,
                            ),
                          ),
                        ),
                      );
                    }

                    // One extra if check applied, when our filtered data is still not available on Database
                    if (snapShot.data!.docs.isEmpty) {
                      return Material(
                        child: Center(
                            child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 300,
                                width: MediaQuery.sizeOf(context).width * .95,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SvgPicture.asset(
                                    'assets/images/elephant.svg',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: .8,
                                child: Text(
                                  'This store is not available Right Now.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: MyConstants.buttonTextColor,
                                      fontSize: 30),
                                ),
                              ),
                            ],
                          ),
                        )),
                      );
                    }
                    // Requires learning how to take ListTile in ListView children Or GridView.builder//
                    return SingleChildScrollView(
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          itemCount: snapShot.data!.docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4),
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
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: const Color(0xff00a884),
                onPressed: () {
                  print('Whatsapp API hit here.');
                },
                child: const Icon(
                  FontAwesomeIcons.whatsapp,
                  size: 36,
                ),
              ),
              // const Text('OYYYiiiiaay'),
              // StreamBuilder<QuerySnapshot>(
              //   stream: productsStream,
              //   builder: (BuildContext context,
              //       AsyncSnapshot<QuerySnapshot> snapShot) {
              //     ///* This is useful during testing when firebase overrides
              //     /// its date-rules. Then this happens. *///
              //     if (snapShot.hasError) {
              //       return const Text('Something Went Wrong..!');
              //     }
              //     if (snapShot.connectionState == ConnectionState.waiting) {
              //       return SizedBox(
              //         height: MediaQuery.sizeOf(context).height * 5,
              //         child: Center(
              //           child: CircularProgressIndicator(
              //             color: MyConstants.buttonTextColor,
              //           ),
              //         ),
              //       );
              //     }
              //
              //     // One extra if check applied, when our filtered data is still not available on Database
              //     if (snapShot.data!.docs.isEmpty) {
              //       return Center(
              //           child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Container(
              //               height: 300,
              //               width: MediaQuery.sizeOf(context).width * .95,
              //               child: SvgPicture.asset(
              //                 'assets/images/elephant.svg',
              //                 fit: BoxFit.fill,
              //               )),
              //           Container(
              //             width: MediaQuery.sizeOf(context).width * .95,
              //             alignment: Alignment.center,
              //             child: Text(
              //               'This Category\nis not Available Right Now.',
              //               textAlign: TextAlign.center,
              //               style: TextStyle(
              //                   color: MyConstants.buttonTextColor,
              //                   fontSize: 30),
              //             ),
              //           ),
              //         ],
              //       ));
              //     }
              //     // Requires learning how to take ListTile in ListView children Or GridView.builder//
              //     return SingleChildScrollView(
              //       child: GridView.builder(
              //           shrinkWrap: true,
              //           physics: const NeverScrollableScrollPhysics(),
              //           padding: const EdgeInsets.only(left: 4, right: 4),
              //           itemCount: snapShot.data!.docs.length,
              //           gridDelegate:
              //               const SliverGridDelegateWithFixedCrossAxisCount(
              //                   crossAxisCount: 2,
              //                   crossAxisSpacing: 4,
              //                   mainAxisSpacing: 4),
              //           itemBuilder: (context, index) {
              //             return ProductModel(
              //               products: snapShot.data!.docs[index],
              //             );
              //           }),
              //     );
              //
              //     // return ListView(
              //     //   children: snapShot.data!.docs.map((DocumentSnapshot document) {
              //     //     Map<String, dynamic> innerData =
              //     //         document.data()! as Map<String, dynamic>;
              //     //     return ListTile(
              //     //       contentPadding: const EdgeInsets.only(left: 8, top: 4, right: 8),
              //     //       leading: CachedNetworkImage(
              //     //         fit: BoxFit.cover,
              //     //         width: 80,
              //     //         height: 100,
              //     //         imageUrl: innerData['productimages'][0],
              //     //       ),
              //     //       title: Text(innerData['maincateg'].toString()),
              //     //       subtitle: Text(
              //     //         innerData['price'].toString(),
              //     //       ),
              //     //       trailing: Material(
              //     //         color: Colors.yellow,
              //     //         borderRadius: BorderRadius.circular(15),
              //     //         child: MaterialButton(
              //     //           child: const Text('Add to cart'),
              //     //           onPressed: () {},
              //     //         ),
              //     //       ),
              //     //     );
              //     //   }).toList(),
              //     // );
              //   },
              // ),
              // );
            );
          }
          return Container(
            decoration: BoxDecoration(
                color: Colors.red.withOpacity(.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black)),
            constraints: BoxConstraints(
                minHeight: mSize.height * .4, minWidth: mSize.width * .4),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.red.shade800,
                ),
                const SizedBox(height: 20),
                const Text('Loading, Podding..!'),
              ],
            )),
          );
          //   Container(
          //   decoration: BoxDecoration(
          //       color: Colors.red,
          //       borderRadius: BorderRadius.circular(12),
          //       border: Border.all(color: Colors.black)),
          //   constraints: BoxConstraints(
          //       minHeight: mSize.height * .8, minWidth: mSize.width * .9),
          //   child: const Center(
          //       child: Column(
          //     children: [
          //       CircularProgressIndicator(),
          //       SizedBox(height: 20),
          //       Text('Loading..!'),
          //     ],
          //   )),
          // );

          // if (snapshot.hasData &&
          //     snapshot.connectionState == ConnectionState.done) {
          //   Map<String, dynamic> wow =
          //       snapshot.data!.data() as Map<String, dynamic>;
          //   return ListView.builder();
          // } else {
          //   return const Text('Problem');
          // }
        });
  }
}
