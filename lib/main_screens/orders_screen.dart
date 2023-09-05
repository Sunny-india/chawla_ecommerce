import 'package:cached_network_image/cached_network_image.dart';
import 'package:chawla_trial_udemy/my_widgets/appbar_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';
import '../models/customer_order_model.dart';

class OrderScreen extends StatefulWidget {
  final Widget? backButton;
  const OrderScreen({super.key, this.backButton});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  /// Generate and filter stream based on what we require
  /// Filter is applied based on the customer id.
  /// Sent this stream to the StreamBuilder down.

  late final Stream<QuerySnapshot> _orderStream;
  @override
  void initState() {
    _orderStream = FirebaseFirestore.instance
        .collection('order')
        .where('cid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50.withOpacity(.99),
      appBar: AppBar(
        leading: widget.backButton,
        title: const AppBarTitle(
          title: 'Orders',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _orderStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.none) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Text('Some Error Found..!');
            }

            if (!snapshot.hasData) {
              return const Text('No Data Found');
            }

            if (snapshot.data!.docs.isEmpty) {
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
                      'You\'ve no pending orders till now.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyConstants.buttonTextColor, fontSize: 30),
                    ),
                  ),
                ],
              ));

              // Text('You\'ve no pending orders till now.');
            }

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  /// DocumentSnapshot below can be passed as a variable
                  /// to the model class constructor too.
                  //  DocumentSnapshot singleItem = snapshot.data!.docs[index];
                  /// Created CustomerOrderModel and passed the data to that.
                  return CustomerOrderModel(
                    singleItem: snapshot.data!.docs[index],
                  );
                });
          }),
    );
  }
}
