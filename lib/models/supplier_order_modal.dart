import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class SupplierOrderModel extends StatelessWidget {
  /// Just because we are fetching dynamic type data directly here from
  /// our previous page. And that data is nothing but a DocumentSnapshot type
  /// We have the liberty to use it directly as it runs on it.
  final dynamic singleItem;
  const SupplierOrderModel({super.key, required this.singleItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Colors.yellow, strokeAlign: BorderSide.strokeAlignInside),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            /// for showing ordered-item image
            Container(
              constraints: const BoxConstraints(
                  minWidth: 100, minHeight: 100, maxHeight: 100, maxWidth: 100),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: singleItem['orderimage'],
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// a divider
            Container(
              margin: const EdgeInsets.only(left: 2, right: 2),
              width: 3,
              height: 80,
              color: Colors.orangeAccent,
            ),

            /// for other detailing.
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 6, bottom: 5),
                width: double.infinity,
                // margin: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Ordered-item's name
                    Text(
                      singleItem['ordername'].toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),

                    /// Ordered-item's price and quantity
                    Container(
                      padding: const EdgeInsets.only(left: 5, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Ordered-item's price
                          Text(
                            singleItem['orderprice'].toString(),
                            style: TextStyle(color: Colors.teal.shade900),
                          ),

                          /// Ordered-item's quantity
                          Text(singleItem['orderqty'].toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('see more..'),
            Text(singleItem['deliverystatus']),
          ],
        ),
        children: [
          /// All other supplier related things refined and created here.
          Container(
            padding: const EdgeInsets.only(top: 6),
            margin: const EdgeInsets.only(left: 2, right: 2),
            // height: 200, if we pass this height, column gets RenderFlex problem. So leave it blank/
            decoration: BoxDecoration(
                color: Colors.teal.shade100.withOpacity(.9),
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Customer name
                Row(
                  children: [Text('Name:  '), Text(singleItem['customername'])],
                ),

                /// Customer phone number
                Row(
                  children: [
                    Text('Phone Number:  '),
                    Text(singleItem['customerphone']),
                  ],
                ),

                ///Customer email
                Row(
                  children: [
                    Text('Email:  '),
                    Text(singleItem['customeremail'] ?? 'Not Provided'),
                  ],
                ),

                /// Customer address
                Row(
                  children: [
                    Text('Address:  '),
                    Text(singleItem['customeraddress'] != ''
                        ? singleItem['customeraddress']
                        : 'Not Provided'),
                  ],
                ),

                /// Payment status
                Row(
                  children: [
                    const Text('Payment Status:  '),
                    Text(singleItem['paymentstatus'],
                        style: TextStyle(
                          color: singleItem['paymentstatus'] == 'COD'
                              ? Colors.red.shade700
                              : Colors.green.shade600,
                          fontSize: 18,
                        )),
                  ],
                ),

                /// Delivery status
                Row(
                  children: [
                    const Text('Delivery Status:  '),
                    Text(singleItem['deliverystatus']),
                  ],
                ),

                const SizedBox(height: 8),

                /// Order date showing. used intl package and DateFormat method
                Row(
                  children: [
                    const Text('Order date:  '),
                    Text(DateFormat('dd-MM-yyyy')
                            .format(singleItem['orderdate'].toDate())
                            .toString())
                        .animate()
                        .scale(
                          delay: 1.5.seconds,
                        ),
                  ],
                ),
                const SizedBox(height: 8),

                /// TextButton to update the delivery status
                singleItem['deliverystatus'] == 'delivered'
                    ? const Text(
                            'This item is delivered.\nThank-you for shopping with us.')
                        .animate()
                        .slide(duration: 1.5.seconds)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('Order received'),

                              //----divider----//
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                height: 14,
                                width: 3,
                                color: Colors.teal.shade700,
                              ),
                              //----Duration fetched. and applied animation---//
                              Text(
                                '${DateTime.now().difference(singleItem['orderdate'].toDate()).inDays.toString()} days',
                                style: TextStyle(
                                  color: Colors.purple.shade600,
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 600.ms)
                                  .then(delay: 1.5.seconds)
                                  .slide(),
                              //----divider----//
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                height: 14,
                                width: 3,
                                color: Colors.teal.shade700,
                              ),
                              const Text('before'),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Change delivery status to:  '),
                              singleItem['deliverystatus'] == 'preparing'

                                  //--to send preparing status to shipping---//
                                  ? TextButton(
                                      onPressed: () {
                                        DatePicker.showDatePicker(
                                          context,
                                          currentTime: DateTime.now(),
                                          minTime: DateTime.now(),
                                          // It leaves a flaw to supplier to have the delivery date before the actual one
                                          // singleItem['orderdate'].toDate(),
                                          maxTime: DateTime.now()
                                              .add(const Duration(days: 12)),
                                          onConfirm: (preparingDate) async {
                                            /// will update the firebase as per the app's need
                                            /// Please remember that data being updated from here to
                                            /// firebase is String type in stead of a DateTime type
                                            /// because of format method.
                                            /// It eases the customer refinery
                                            await FirebaseFirestore.instance
                                                .collection('order')
                                                .doc(singleItem['orderid'])
                                                .update({
                                              'deliverystatus': 'shipping',
                                              'deliverydate': preparingDate,
                                            });

                                            // print(time.runtimeType);
                                            //
                                            // // checked runtimetype
                                            // print(DateTime.now().difference(
                                            //     singleItem['orderdate']
                                            //         .toDate()));
                                            // print(singleItem['orderdate']
                                            //     .toDate()
                                            //     .difference(DateTime.now())
                                            //     .inHours
                                            //     .runtimeType);
                                          },
                                        );
                                      },
                                      child: const Text(
                                        'shipping',
                                      ),
                                    )
                                  //--- to send order from preparing to delivered--//
                                  : TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('order')
                                            .doc(singleItem['orderid'])
                                            .update({
                                          'deliverystatus': 'delivered'
                                        });
                                        //TODo: to change delivery status on firebase from here later.
                                        print('delivered  pressed here');
                                      },
                                      child: const Text('shipping'),
                                    ),
                            ],
                          ),
                        ],
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
