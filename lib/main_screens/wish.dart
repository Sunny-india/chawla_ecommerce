import 'package:chawla_trial_udemy/main_screens/cart.dart';
import 'package:chawla_trial_udemy/providers/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../my_widgets/appbar_widgets.dart';
import '../my_widgets/my_alert_dialog.dart';
import '../providers/cart_provider.dart';
import 'package:collection/collection.dart';

class WishScreen extends StatefulWidget {
  static String screenName = '/wish_screen';
  const WishScreen({super.key, this.backButton});
  final Widget? backButton;
  @override
  State<WishScreen> createState() => _WishScreenState();
}

class _WishScreenState extends State<WishScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarBackButton(),
        centerTitle: true,
        title: const AppBarTitle(title: 'WishList'),
        actions: [
          context.read<WishList>().getWishList.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    MyAlertDialog.myShowDialog(
                        context: context,
                        myTitle: 'Delete Wish List?',
                        myContent:
                            'Are you sure, you want to delete your wish-list items? ',
                        onTapYes: () {
                          context.read<WishList>().removeWishList();
                          Navigator.pop(context);
                        },
                        noText: 'Delete',
                        onTapNo: () {
                          Navigator.pop(context);
                        });
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.black,
                  ),
                )
              : const SizedBox()
        ],
      ),
      body: SafeArea(
        child: context.watch<WishList>().getWishList.isNotEmpty
            ? myLoadedWishList()
            : const EmptyWishlist(),
      ),
    );
  }

  Consumer<WishList> myLoadedWishList() {
    return Consumer<WishList>(
      builder: (context, wishlist, child) {
        return ListView.builder(
          itemCount: wishlist.count,
          itemBuilder: (context, index) {
            var product = wishlist.getWishList[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Card(
                child: SizedBox(
                  height: 160,
                  child: Row(
                    children: [
                      /// product image in wishlist
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 140,
                          width: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.imagesUrl[0],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                        color: Colors.orangeAccent,
                      ),

                      /// a column for other things in wishlist
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                /// product name
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      product.name.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),

                                /// DELETE Icon if want to delete it from the list?
                                context.read<WishList>().getWishList.isNotEmpty
                                    ? Expanded(
                                        flex: 2,
                                        child: IconButton(
                                          onPressed: () {
                                            /// alert dialog to stop accidental removal from the list
                                            MyAlertDialog.myShowDialog(
                                                context: context,
                                                myTitle: 'Remove Item?',
                                                myContent:
                                                    'Want to remove item from your wishlist?',
                                                onTapYes: () {
                                                  wishlist.removeFromWishList(
                                                      product.documentId);
                                                  Navigator.pop(context);
                                                },
                                                noText: 'Remove',
                                                onTapNo: () {
                                                  Navigator.pop(context);
                                                });
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red.shade600,
                                            size: 30,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            const SizedBox(height: 35),
                            Row(
                              children: [
                                /// product price
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    color: Colors.white,
                                    width: 10,
                                    child: Text(
                                      product.price.toString(),
                                      style: TextStyle(
                                        color: Colors.green.shade800,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),

                                /// add to cart  button
                                Expanded(
                                  flex: 5,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      /// Before passing the values fetched from
                                      /// firebase to CartProvider; we check if that
                                      /// item is already added in that list or not.
                                      /// So that it may not duplicate itself.
                                      /// also if that item is available in stock in firebase
                                      /// or not
                                      /// provider usage starts here.
                                      /// would call Cart provider add item function here.
                                      /// and pass those relatable parameters from here
                                      /// directly fetched from the database and
                                      /// being passed to the cart_provider.

                                      // this check returns a boolean value;
                                      // if it is equal to null, it means false;

                                      product.qntty == 0 ||
                                              context
                                                      .read<Cart>()
                                                      .getProductList
                                                      .firstWhereOrNull(
                                                          (element) =>
                                                              element
                                                                  .documentId ==
                                                              product
                                                                  .documentId) !=
                                                  null
                                          ? print('in cart')
                                          : context.read<Cart>().addItem(
                                              product.name,
                                              product.price.toDouble(),
                                              1,
                                              product.qntty.toDouble(),
                                              product.imagesUrl,
                                              product.documentId,
                                              product.supplierId);

                                      /// after successfully sending the item from Wishlist to
                                      /// the cart list, we would remove that item from the Wishlist
                                      /// as well. Below done that.
                                      context
                                          .read<WishList>()
                                          .removeFromWishList(
                                              product.documentId);

                                      /// and for trial of page_transition
                                      /// will send user from here to the CartScreen
                                      /// but on condition if this is the last item in wishlist
                                      /// the user is going to remove

                                      context
                                              .read<WishList>()
                                              .getWishList
                                              .isEmpty
                                          ? Navigator.push(
                                              context,
                                              PageTransition(
                                                duration:
                                                    const Duration(seconds: 1),
                                                type: PageTransitionType
                                                    .bottomToTop,
                                                child: const CartScreen(),
                                              ))
                                          : null;

                                      //   if (context
                                      //       .read<WishList>()
                                      //       .getWishList
                                      //       .isEmpty) {
                                      //     Navigator.push(
                                      //         context,
                                      //         PageTransition(
                                      //           duration:
                                      //               const Duration(seconds: 1),
                                      //           type: PageTransitionType
                                      //               .bottomToTop,
                                      //           child: const CartScreen(),
                                      //         ));
                                      //   }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(3),
                                      backgroundColor: Colors.yellow,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(
                                              color: Colors.yellow.shade700)),
                                    ),
                                    child: const Text(
                                      'ADD TO CART',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            //   Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Card(
            //     child: SizedBox(
            //       height: 120,
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Container(
            //             height: 120,
            //             width: 130,
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(12),
            //                 border: Border.all(color: Colors.black)),
            //             child: ClipRRect(
            //               borderRadius: BorderRadius.circular(12),
            //               child: Image.network(
            //                 product.imagesUrl[0],
            //                 fit: BoxFit.cover,
            //               ),
            //             ),
            //           ),
            //           Flexible(
            //             child: Container(
            //               margin: const EdgeInsets.only(left: 8),
            //               padding: const EdgeInsets.only(left: 4, bottom: 4),
            //               // decoration: BoxDecoration(
            //               //   border: Border.all(color: Colors.black),
            //               //   borderRadius: BorderRadius.circular(12),
            //               // ),
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Text(
            //                     product.name.toString(),
            //                     overflow: TextOverflow.ellipsis,
            //                     maxLines: 2,
            //                     style: const TextStyle(fontSize: 20),
            //                   ),
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       Text(
            //                         product.price.toString(),
            //                         style: TextStyle(
            //                           color: Colors.green.shade800,
            //                           fontSize: 16,
            //                         ),
            //                       ),
            //                       IconButton(
            //                         onPressed: () {
            //                           MyAlertDialog.myShowDialog(
            //                               context: context,
            //                               myTitle: 'Remove Item?',
            //                               myContent:
            //                                   'Want to remove item from your wishlist?',
            //                               onTapYes: () {
            //                                 wishlist.removeFromWishList(
            //                                     product.documentId);
            //                                 Navigator.pop(context);
            //                               },
            //                               onTapNo: () {
            //                                 Navigator.pop(context);
            //                               });
            //                         },
            //                         icon: Icon(
            //                           Icons.delete,
            //                           color: Colors.red.shade600,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   Expanded(
            //                     child: YellowButton(
            //                         onPressed: () {}, label: 'Move to cart?'),
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // );
          },
        );
      },
    );
  }
}

class EmptyWishlist extends StatelessWidget {
  const EmptyWishlist({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'your Wishlist is Empty',
          style: TextStyle(fontSize: 20),
        ),
      ]),
    );
  }
}
