/// The whole code is copied from the supplier_order,
/// becuase it behaves the same. Only the difference is at refining its
/// streams. watch carefully

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';
import '../models/supplier_order_modal.dart';

class Shipping extends StatefulWidget {
  const Shipping({super.key});

  @override
  State<Shipping> createState() => _ShippingState();
}

class _ShippingState extends State<Shipping> {
  late final Stream<QuerySnapshot> _ordersPreparing;

  @override
  void initState() {
    _ordersPreparing = FirebaseFirestore.instance
        .collection('order')
        .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('deliverystatus', isEqualTo: 'shipping')
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
                  'You\'ve no orders to ship. Go to your dashboard and upload something exciting, something catchy :)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyConstants.buttonTextColor, fontSize: 25),
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
