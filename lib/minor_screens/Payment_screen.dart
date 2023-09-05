import 'package:chawla_trial_udemy/my_widgets/appbar_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../my_widgets/yellow_button.dart';
import '../providers/cart_provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  ///1 create collectionReference for customers,
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  ///2. for checking if the current user is signed in or not?
  String userId = FirebaseAuth.instance.currentUser!.uid;

  ///3. DocumentSnapshot type future variable, just in order to send the future from
  ///here to the FutureBuilder. created late, bcoz it would initiate only in future
  late Future<DocumentSnapshot> _future;

  /// for selecting  a value from the RadioListTile
  int selectedValue = 1;

  /// for each order id
  late String orderId;

  @override
  void initState() {
    ///4  before sending the future directly to the FutureBuilder, initiated it in
    ///initState. otherwise it rebuilds itself each and everytime if directly called in FB.
    _future = customers.doc(userId).get();
    super.initState();
  }

  /// a progress indicator while cash on delivery button is pressed
  /// IMP. To send user from here to somewhere else become necessary otherwise
  ///  this indicator keeps circling
  void showProgress() {
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(
        max: 100,
        msg: 'Please Wait...!',
        progressValueColor: Colors.orangeAccent);
  }

  @override
  Widget build(BuildContext context) {
    ///5
    double totalPrice = context.watch<Cart>().totalPrice;

    ///6
    double shippingCost = 10.22;

    ///7
    double totalAmountToBePaid = totalPrice + shippingCost;

    return FutureBuilder<DocumentSnapshot>(
      future: _future,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something Went Wrong');
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text('Document does not exist');
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> innerData =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              centerTitle: false,
              elevation: 0,
              // automaticallyImplyLeading: false,
              backgroundColor: Colors.grey.shade200,
              leading: AppBarBackButton(),
              title: const AppBarTitle(
                title: '    Payment page',
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, top: 6, bottom: 8),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    height: MediaQuery.sizeOf(context).height * .22,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Price'),
                            Text(totalPrice.toStringAsFixed(2)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Shipping Cost'),
                            Text(shippingCost.toStringAsFixed(2)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Expanded(
                          child: Divider(
                            thickness: 2,
                            color: Colors.black87,
                            indent: 4,
                            endIndent: 4,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Grand Total',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepPurple),
                            ),
                            Text(totalAmountToBePaid.toStringAsFixed(2)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 8,
                        bottom: 60,
                      ),
                      child: Column(
                        children: [
                          RadioListTile(
                            value: 1,
                            groupValue: selectedValue,
                            onChanged: (nextValue) {
                              setState(() {
                                selectedValue = nextValue!;
                              });
                            },
                            activeColor: Colors.deepOrangeAccent,
                            title: const Text("Cash On delivery"),
                            subtitle:
                                const Text('Pay after receiving the goods.'),
                          ),
                          RadioListTile(
                            value: 2,
                            groupValue: selectedValue,
                            onChanged: (nextValue) {
                              setState(() {
                                selectedValue = nextValue!;
                              });
                            },
                            activeColor: Colors.deepOrangeAccent,
                            title: const Text("Pay via Visa / Master Card"),
                            subtitle: const Row(
                              children: [
                                Icon(
                                  Icons.payment,
                                  color: Colors.blue,
                                  size: 32,
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  FontAwesomeIcons.ccMastercard,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  FontAwesomeIcons.ccVisa,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                          ),
                          RadioListTile(
                            value: 3,
                            groupValue: selectedValue,
                            onChanged: (newValue) {
                              setState(() {
                                selectedValue = newValue!;
                              });
                            },
                            activeColor: Colors.deepOrangeAccent,
                            title: const Text('Google Pay'),
                            subtitle: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.googlePay,
                                  color: Colors.blue.shade700,
                                  size: 32,
                                ),
                              ],
                            ),
                          ),
                        ],
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
                  /// for showing the total amount including shipping cost
                  YellowButton(
                    myMinWidth: .9,
                    myContainerHeight: 50,
                    onPressed: () {
                      if (selectedValue == 1) {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: MediaQuery.sizeOf(context).height * .3,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      totalAmountToBePaid.toStringAsFixed(2),
                                      style: const TextStyle(fontSize: 24),
                                    ),

                                    ///10.
                                    //
                                    ///This is when we press this button,
                                    /// we create a function which traverse through
                                    /// the whole cart list. and for each item,
                                    /// it creates a new collection reference along with
                                    /// its id/or unique name and here we pass all the
                                    /// important information and set the whole data
                                    /// accordingly. Please see carefully.
                                    /// Thanks 9810050460
                                    YellowButton(
                                        label: 'Cash On Delivery',
                                        onPressed: () async {
                                          showProgress();

                                          for (var item in context
                                              .read<Cart>()
                                              .getProductList) {
                                            /// create a new collectionReference for each single item. get handy later.

                                            CollectionReference order =
                                                FirebaseFirestore.instance
                                                    .collection('order');

                                            /// name that order
                                            orderId = Uuid().v4();
                                            DateTime? shippingDate;
                                            // This above variable too can be used to save deliverydate as DateTime type null//

                                            /// assign that name to each order and fill-in/set
                                            /// other important details

                                            await order.doc(orderId).set({
                                              // the id of this particular customer who placed this order.
                                              // Fetched it from FutureBuilder
                                              // other details of this customer for
                                              // shipping purpose

                                              'cid': innerData['cid'],

                                              'customername': innerData['name'],

                                              'customerphone':
                                                  innerData['phone'],

                                              'customeremail':
                                                  innerData['email'],

                                              'customeraddress':
                                                  innerData['address'],

                                              'customerimage':
                                                  innerData['profileimage'],

                                              // after fetching and filling the customer's detail
                                              // we fill-in that supplier's detail whose item is sold here

                                              'sid': item.supplierId,

                                              // now we fill-in this particular item's detail for this order collection
                                              // quantity refers to the quantity of each single item
                                              'orderid': orderId,
                                              'ordername': item.name,
                                              'productid': item.documentId,
                                              'productname': item.name,
                                              'orderimage':
                                                  item.imagesUrl.first,
                                              'orderqty': item.qty,
                                              'orderprice':
                                                  item.qty * item.price,

                                              // now fill-in the shipping details
                                              'deliverystatus': 'preparing',
                                              'orderdate': DateTime.now(),
                                              'deliverydate': shippingDate,
                                              'paymentstatus': 'COD',
                                              'orderreview':
                                                  false, // once the user adds reviews this item, this field turns true, it means the customer can not add another review.
                                            }).whenComplete(() async {
                                              /// used transaction method here whenComplete.
                                              await FirebaseFirestore.instance
                                                  .runTransaction(
                                                      (transaction) async {
                                                // step 1. fetch that document reference where we want our updation
                                                DocumentReference
                                                    productDocumentReference =
                                                    FirebaseFirestore.instance
                                                        .collection('products')
                                                        .doc(item.documentId);
                                                // step 2. use that document reference to get its document snapshot through transaction method
                                                DocumentSnapshot innerSnapshot =
                                                    await transaction.get(
                                                        productDocumentReference);
                                                // step 3. update that value based on our operation. and set.
                                                transaction.update(
                                                    productDocumentReference, {
                                                  'instock':
                                                      innerSnapshot['instock'] -
                                                          item.qty
                                                });
                                              });
                                            });
                                          }

                                          /// after finishing the whole computation, empty the cart,
                                          /// and take user back to the home page.
                                          context.read<Cart>().removeAllItems();
                                          Navigator.popUntil(
                                              context,
                                              ModalRoute.withName(
                                                  '/customer_home_screen'));
                                        }),
                                  ],
                                ),
                              );
                            });
                      } else if (selectedValue == 2) {
                        print('Pay via Card');
                      } else if (selectedValue == 3) {
                        print('Google Pay');
                      }
                    },
                    label: '$totalAmountToBePaid',
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
      },
    );
  }
}
