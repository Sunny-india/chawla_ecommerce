import 'package:chawla_trial_udemy/my_widgets/appbar_widgets.dart';
import 'package:chawla_trial_udemy/my_widgets/yellow_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'Payment_screen.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  ///1 create collectionReference for customers,
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  ///2. for checking if the current user is signed in or not?
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  ///3. DocumentSnapshot type future variable, just in order to send the future from
  ///here to the FutureBuilder. created late, bcoz it would initiate only in future
  late final Future<DocumentSnapshot> _future;
  @override
  void initState() {
    ///4  before sending the future directly to the FutureBuilder, initiated it in
    ///initState. otherwise it rebuilds itself each and everytime if called in FB.
    _future = customers.doc(userId).get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: _future,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text('Document Not Found');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            /// 5.  change data to map
            Map<String, dynamic> singleDocumentData =
                snapshot.data!.data() as Map<String, dynamic>;
            //todo: do your logics here.
            return Scaffold(
              backgroundColor: Colors.grey.shade200,
              appBar: AppBar(
                backgroundColor: Colors.grey.shade200,
                leading: AppBarBackButton(),
                title: const AppBarTitle(title: 'Place Order'),
              ),
              body: Padding(
                padding: const EdgeInsets.only(
                    left: 16, top: 16.0, right: 16, bottom: 60),
                child: Column(
                  children: [
                    /// Container containing name, email, and phone number.
                    Container(
                      padding: const EdgeInsets.only(left: 6),
                      height: 90,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// name fetched from database
                          Text(
                              'Name : ${singleDocumentData['name'].toString()}'),

                          /// email fetched from database
                          Text(
                              'Email : ${singleDocumentData['email'].toString()}'),

                          /// phone number fetched from database
                          Text(
                              'Phone Number : ${singleDocumentData['phone'].toString()}')
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    //const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Align(
                          alignment: Alignment.center,
                          child:
                              Consumer<Cart>(builder: (builder, cart, child) {
                            return ListView.builder(
                                itemCount: cart.getProductList.length,
                                itemBuilder: (context, index) {
                                  var everyProductInCart =
                                      cart.getProductList[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black12),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Row(
                                        children: [
                                          /// image for the product listed in cart
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              bottomLeft: Radius.circular(12),
                                            ),
                                            child: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Image.network(
                                                everyProductInCart
                                                    .imagesUrl.first,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          ///other details
                                          Flexible(
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4,
                                                  left: 12,
                                                  right: 4),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  /// name of the product listed on cart
                                                  Text(
                                                    everyProductInCart.name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Row(
                                                    children: [
                                                      /// price of the product listed on cart
                                                      Text(
                                                        everyProductInCart.price
                                                            .toStringAsFixed(2),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .green.shade600,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      const Text(' X '),

                                                      /// desired quantity of the product listed on cart
                                                      Text(
                                                          everyProductInCart.qty
                                                              .toStringAsFixed(
                                                                  1),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .green
                                                                  .shade600,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                    ],
                                                  ),
                                                  //    Text(everyProductInCart.name),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottomSheet: Container(
                padding: const EdgeInsets.only(bottom: 4),
                color: Colors.grey.shade200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ///
                    Badge(
                      largeSize: 32,
                      offset: const Offset(-4, -5),
                      label: Text(
                          context.watch<Cart>().totalPrice.toStringAsFixed(0)),
                      child: YellowButton(
                        myMinWidth: .9,
                        myContainerHeight: 50,
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: const PaymentScreen(),
                                  duration: const Duration(seconds: 1),
                                  type: PageTransitionType.bottomToTop));
                        },
                        label: 'Confirm ${context.watch<Cart>().totalPrice}',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
    //
  }
}
