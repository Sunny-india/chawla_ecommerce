import 'package:cached_network_image/cached_network_image.dart';
import 'package:chawla_trial_udemy/minor_screens/product_detail_screen.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main_screens/wish.dart';
import '../providers/wish_list_provider.dart';

class ProductModel extends StatefulWidget {
  // created this dynamic type variable to store data fetched from FirebaseFireStore
  // As a matter of nature of the app, it would behave like each document in
  // 'products' collection there. Each document means, it recognizes the indexing too.
  // How is it used? For that, see to where it exactly has been implemented.
  // In short it is representing a Stream
  // Stream<QuerySnapshot> productStream=
  // FirebaseFireStore.instance.collection('products').where('maincateg',isEqualTo: 'mainCateg')
  // .where('subcateg', isEqualTo: 'subCateg').snapShots();

  // where the builder is=
  // builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

  ///after many if checks, we set (snapshot.data!.docs[index]) as a dynamic products
  ///value here.
  // }
  /// and would be passed to ProductDetailScreen from here.
  // Thanks.
  final dynamic products;

  const ProductModel({super.key, required this.products});
  static String screenName = '/product_model';

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductDetailScreen(
                proList: widget.products,
              );
            },
          ),
        );
        //  Navigator.pop(context);
      },
      child: Container(
        // alignment: Alignment.center,
        //height: 300,
        // width: 300,
        padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          children: [
            /// The first image from the list of images in database here.
            Expanded(
              child: Container(
                  // alignment: Alignment.center,
                  constraints:
                      const BoxConstraints(minHeight: 150, maxHeight: 350),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: widget.products['productimages'][0],
                      width: 300,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Column(
                children: [
                  /// Name of the product fetched from database here.
                  Text(
                    widget.products['productname'].toString(),
                    maxLines: 1,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Price of the product fetched from database here.

                      Text(
                        widget.products['price'].toStringAsFixed(2) + (' \$'),
                        style: const TextStyle(color: Colors.red),
                      ),

                      /// This check is applied to see whether the supplier is
                      /// looking their own profile or not. So that this page may
                      /// behave accordingly. This check came from visit_store.dart page.
                      widget.products['sid'] ==
                              FirebaseAuth.instance.currentUser!.uid
                          ? IconButton(
                              color: Colors.red,
                              icon: const Icon(Icons.edit),
                              onPressed: () {},
                            )
                          : IconButton(
                              onPressed: () {
                                /// this is where the data fetched from database
                                /// is sent to the stateManagement system e.g. Provider

                                context
                                            .watch<WishList>()
                                            .getWishList
                                            .firstWhereOrNull((product) =>
                                                product.documentId ==
                                                widget.products['productid']) !=
                                        null
                                    ? showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: const Text(
                                                'Remove from wishlist?'),
                                            content: const Text(
                                              'press "Remove" to remove item from wishlist.\n\n press "Wishlist" and to go to your wishlist.',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            actions: <CupertinoDialogAction>[
                                              CupertinoDialogAction(
                                                child: Text(
                                                  'Remove',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.red.shade800),
                                                ),
                                                onPressed: () {
                                                  context
                                                      .read<WishList>()
                                                      .removeFromWishList(
                                                          widget.products[
                                                              'productid']);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              CupertinoDialogAction(
                                                child: Text(
                                                  'Wishlist',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .green.shade800),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pushNamed(context,
                                                      WishScreen.screenName);
                                                },
                                              ),
                                            ],
                                          );
                                        })
                                    : context.read<WishList>().addToWishList(
                                        widget.products['productname'],
                                        widget.products['price'].toDouble(),
                                        1,
                                        widget.products['instock'].toDouble(),
                                        widget.products['productimages'],
                                        widget.products['productid'],
                                        widget.products['sid']);
                              },

                              /// instead of read, we would use watch to see some change happening.
                              icon: Icon(
                                context
                                            .watch<WishList>()
                                            .getWishList
                                            .firstWhereOrNull((product) =>
                                                product.documentId ==
                                                widget.products['productid']) !=
                                        null
                                    ? Icons.favorite
                                    : Icons.favorite_outline_outlined,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
            //   const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
