import 'dart:math';

import 'package:chawla_trial_udemy/my_widgets/appbar_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SupplierBalance extends StatefulWidget {
  const SupplierBalance({Key? key}) : super(key: key);

  @override
  State<SupplierBalance> createState() => _SupplierBalanceState();
}

class _SupplierBalanceState extends State<SupplierBalance> {
  late Stream<QuerySnapshot> _balanceStream;

  @override
  void initState() {
    _balanceStream = FirebaseFirestore.instance
        .collection('order')
        .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _balanceStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        num totalSale = 0;
        for (var item in snapshot.data!.docs) {
          totalSale += item['orderqty'] * item['orderprice'];
        }
        return Scaffold(
          appBar: AppBar(
            title: const AppBarTitle(
              title: 'Supplier Balance',
            ),
            leading: const AppBarBackButton(),
          ),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 6),
                      alignment: Alignment.center,
                      height: 150,
                      width: MediaQuery.sizeOf(context).width * .40,
                      decoration: BoxDecoration(
                        color: Colors.purple.shade600,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            topLeft: Radius.circular(12)),
                        border: Border.all(
                            color: Colors.purpleAccent.shade100,
                            strokeAlign: BorderSide.strokeAlignInside),
                      ),
                      child: Transform.rotate(
                          angle: pi / -9,
                          child: Text(
                            '   TOTAL BALANCE',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.purpleAccent.shade100,
                                fontWeight: FontWeight.w500),
                          ).animate().fadeIn(delay: .7.seconds)),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.sizeOf(context).width * .55,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent.shade100.withOpacity(.2),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        border: Border.all(
                            width: 1.5405,
                            color: Colors.purple.shade600,
                            strokeAlign: BorderSide.strokeAlignInside),
                      ),
                      child: Text(
                        totalSale.toString(),
                        style: TextStyle(
                            color: Colors.purple.shade600,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ).animate().rotate(delay: 1.3.seconds, begin: 1, end: 25),
                    ).animate(delay: .6.seconds).scaleX(
                        duration: .6.seconds,
                        begin: -1.08405,
                        alignment: Alignment.bottomRight)
                  ],
                )
              ]),
        );
      },
    );
  }
}
