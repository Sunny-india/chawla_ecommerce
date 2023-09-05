import 'dart:math';

import 'package:chawla_trial_udemy/my_widgets/appbar_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SupplierStatics extends StatefulWidget {
  const SupplierStatics({Key? key}) : super(key: key);

  @override
  State<SupplierStatics> createState() => _SupplierStaticsState();
}

class _SupplierStaticsState extends State<SupplierStatics> {
  bool showDataOne = true;
  late Stream<QuerySnapshot> _dataStats;
  @override
  void initState() {
    _dataStats = FirebaseFirestore.instance
        .collection('order')
        .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Scaffold(
        appBar: AppBar(
          title: const AppBarTitle(
            title: 'Supplier Statics',
          ),
          leading: const AppBarBackButton(),
        ),
        body: StreamBuilder(
          stream: _dataStats,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Material(
                  child: Center(child: CircularProgressIndicator()));
            }

            num unitsSold = 0;
            for (var item in snapshot.data!.docs) {
              unitsSold += item['orderqty'];
            }
            double totalSale = 0;
            for (var item in snapshot.data!.docs) {
              totalSale += item['orderqty'] * item['orderprice'];
            }
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildDataColumn(context, 'Items Sold',
                        snapshot.data!.docs.length.toString()),
                    buildDataColumn(
                        context, 'No of Units Sold', unitsSold.toString()),
                    buildDataColumn(
                        context, 'Total Sale', totalSale.toString()),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: MaterialButton(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.blue.shade200,
            onPressed: () {
              setState(() {
                showDataOne = !showDataOne;
              });
            },
            child: const Text('Show Data'),
          ),
        ),
      ),
    );
  }

  Column buildDataColumn(
      BuildContext context, String firstContainer, String databaseData) {
    return Column(children: [
      const SizedBox(
        height: 40,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 6),
            alignment: Alignment.center,
            height: 150,
            width: MediaQuery.sizeOf(context).width * .40,
            decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    topLeft: Radius.circular(12)),
                border: Border.all(color: Colors.black)),
            child: Transform.rotate(
                angle: pi / -9,
                child: Text(firstContainer)
                    .animate()
                    .fadeIn(delay: showDataOne ? .7.seconds : .3.seconds)),
          ),
          showDataOne
              ? Container(
                  alignment: Alignment.center,
                  width: MediaQuery.sizeOf(context).width * .55,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade200,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Text(
                    databaseData,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ).animate().rotate(delay: 1.3.seconds, begin: 1, end: 25),
                ).animate(delay: .6.seconds).scaleX(
                  duration: .6.seconds,
                  begin: -1.08405,
                  alignment: Alignment.bottomRight)
              : Container(),
          // Stack(
          //   children: [
          //     Container(
          //       alignment: Alignment.topCenter,
          //       height: 150,
          //       width: MediaQuery.sizeOf(context).width * .45,
          //       decoration: BoxDecoration(
          //           color: Colors.grey.shade200,
          //           borderRadius: const BorderRadius.only(
          //               topRight: Radius.circular(12),
          //               bottomRight: Radius.circular(12)),
          //           border: Border.all(color: Colors.black)),
          //
          //       //  child: Text('Upper Container One'),
          //     ),
          //     showDataOne
          //         ? Positioned(
          //             top: 80,
          //             left: 10,
          //             bottom: 0,
          //             right: 0,
          //             child: Container(
          //               alignment: Alignment.center,
          //               height: 40,
          //               width: MediaQuery.sizeOf(context).width * .40,
          //               decoration: BoxDecoration(
          //                   color: Colors.blue.shade200,
          //                   borderRadius: const BorderRadius.only(
          //                       bottomLeft: Radius.circular(12),
          //                       bottomRight: Radius.circular(12)),
          //                   border: Border.all(color: Colors.black)),
          //               child: const Text('Upper Container One')
          //                   .animate(delay: 1.seconds)
          //                   .scale(),
          //             ).animate().scaleXY().rotate(
          //                 delay: .5.seconds,
          //                 begin: 1,
          //                 end: 2,
          //                 alignment: Alignment.bottomRight),
          //           )
          //         : Container(),
          //   ],
          // ),
        ],
      )
    ]);
  }
}
