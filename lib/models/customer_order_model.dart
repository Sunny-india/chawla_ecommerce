import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class CustomerOrderModel extends StatelessWidget {
  final dynamic singleItem;
  const CustomerOrderModel({super.key, required this.singleItem});

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
                padding: const EdgeInsets.only(top: 6, bottom: 5),
                width: double.infinity, height: 100,

                // margin: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
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
                  children: [
                    const Text('Name:  '),
                    Text(singleItem['customername'])
                  ],
                ),

                /// Customer phone number
                Row(
                  children: [
                    Text('Phone Number:  '),

                    /// Typo in firebase, to be corrected at payment page last button.
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
                    const Text('Address:  '),
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
                            ))
                        .animate(delay: .7.seconds)
                        .fadeIn(duration: 1.3.seconds),
                  ],
                ),
                Row(
                  children: [
                    const Text('Delivery Status:  '),
                    Text(singleItem['deliverystatus']),
                  ],
                ),
                singleItem['deliverystatus'] != 'delivered'
                    ? Row(
                        children: [
                          const Text('Estimated Delivery time:  '),
                          Text(DateFormat('dd-MM-yyyy')
                                  .format(singleItem['deliverydate'].toDate()))
                              .animate(delay: .3.seconds)
                              .scale(duration: 1.seconds),
                        ],
                      )
                    : const Text(''),

                ///Write a review button for later use.
                ///When we create Review Collection in Firebase
                singleItem['deliverystatus'] == 'delivered' &&
                        singleItem['orderreview'] == false
                    ? TextButton(
                        onPressed: () {
                          //Todo: to have client written a review.
                        },
                        child: Text(
                          'Write a review',
                          style: TextStyle(color: Colors.teal.shade600),
                        ),
                      )
                    : const Text(''),

                singleItem['deliverystatus'] == 'delivered' &&
                        singleItem['orderreview'] == true
                    ? Row(
                        children: [
                          /// Its dependable text.
                          Icon(
                            Icons.check,
                            color: Colors.teal.shade600,
                          ),

                          /// for decoration only..
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.teal.shade600,
                                borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            height: 18,
                            width: 4,
                          ),
                          const Text('Review added'),
                        ],
                      )
                    : const Text(''),
              ],
            ),
          )
        ],
      ),
    );
  }
}
