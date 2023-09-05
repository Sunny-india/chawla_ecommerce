import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';
import '../models/supplier_order_modal.dart';

class Preparing extends StatefulWidget {
  const Preparing({super.key});

  @override
  State<Preparing> createState() => _PreparingState();
}

class _PreparingState extends State<Preparing> {
  late final Stream<QuerySnapshot> _ordersPreparing;

  @override
  void initState() {
    /// Refined our data from firebase, as per the requirement of the app,
    /// and streamed it to the page.

    _ordersPreparing = FirebaseFirestore.instance
        .collection('order')
        .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('deliverystatus', isEqualTo: 'preparing')
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _ordersPreparing,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            /// Below DocumentSnapshot passed as dynamic type data to the
            /// model class from here.
            /// DocumentSnapshot orderToSupplier = snapshot.data!.docs[index];
            return SupplierOrderModel(
              singleItem: snapshot.data!.docs[index],
            );
          },
        );
      },
    );
  }
}
