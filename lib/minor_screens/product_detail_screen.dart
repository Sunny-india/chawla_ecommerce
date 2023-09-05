import 'package:cached_network_image/cached_network_image.dart';
import 'package:chawla_trial_udemy/main_screens/wish.dart';
import 'package:chawla_trial_udemy/minor_screens/visit_store.dart';
import 'package:chawla_trial_udemy/my_widgets/appbar_widgets.dart';
import 'package:chawla_trial_udemy/my_widgets/yellow_button.dart';
import 'package:chawla_trial_udemy/providers/wish_list_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../main_screens/cart.dart';
import '../main_screens/profile.dart';
import '../models/product_model.dart';
import '../my_widgets/snackbar.dart';
import '../providers/cart_provider.dart';
import 'full_page_screen.dart';
import 'package:collection/collection.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic proList;
  const ProductDetailScreen({super.key, required this.proList});
  static String screenName = '/product_detail_screen';
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    /// created variable of bool type, in order to re-use
    /// it anywhere in app
    // this check returns a boolean value;
    // if it is equal to null, it means false;
    var doesItemExistInCart =
        context.read<Cart>().getProductList.firstWhereOrNull(
              (product) => product.documentId == widget.proList['productid'],
            );

    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('maincateg', isEqualTo: widget.proList['maincateg'].toString())
        .where('subcateg', isEqualTo: widget.proList['subcateg'].toString())
        .snapshots();

    /// for storing list of images from firebase here.  Created is as late, because the
    /// data would be fetched on later basis.
    late List<dynamic> imagesFromDB = widget.proList['productimages'];
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// for showing images from firebase here.
                Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return FullPageScreen(
                            imagesFromProductDetailPage: imagesFromDB,
                          );
                        }));
                      },
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * .45,
                        child: Swiper(
                          pagination: const SwiperPagination(
                            builder: SwiperPagination.dots,
                          ),
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              /// explanation on FullPageScreen
                              imageUrl: imagesFromDB[index],
                              fit: BoxFit.cover,
                            );
                          },
                          itemCount: imagesFromDB.length,
                          autoplay: true,
                          autoplayDelay: 2300,
                        ),
                      ),
                    ),
                  ),

                  /// back button to go to the back page from here.
                  Positioned(
                    top: 8,
                    // left: -16,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.tealAccent,
                      child: IconButton(
                        icon: const Icon(
                          Icons.west_outlined,
                          color: Colors.black,
                          size: 14,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),

                  /// share button here.
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.tealAccent,
                      radius: 16,
                      child: IconButton(
                        onPressed: () {
                          // todo: to add a share with others functionality  //
                        },
                        icon: const Icon(
                          Icons.share_sharp,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                    ),
                  )
                ]),

                ///Because we've fetched the whole data as snapshot, we don't need
                /// to refine it anywhere on this page. so used it directly.
//
                /// product name fetched from firebase
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    widget.proList['productname'].toString(),
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600),
                  ),
                ),

                /// product price fetched from firebase in it.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          '\$ ',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.w400),
                        ),

                        /// product price fetched from firebase in it.
                        Text(
                          widget.proList['price'].toStringAsFixed(2),
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        /// this is where the data fetched from database
                        /// is sent to the stateManagement system e.g. Provider

                        context.read<WishList>().getWishList.firstWhereOrNull(
                                    (product) =>
                                        product.documentId ==
                                        widget.proList['productid']) !=
                                null
                            ? showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: const Text('Remove from wishlist?'),
                                    content: const Text(
                                      'press "Remove" to remove item from wishlist.\n\n press "Wishlist" and to go to your wishlist.',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    actions: <CupertinoDialogAction>[
                                      CupertinoDialogAction(
                                        child: Text(
                                          'Remove',
                                          style: TextStyle(
                                              color: Colors.red.shade800),
                                        ),
                                        onPressed: () {
                                          context
                                              .read<WishList>()
                                              .removeFromWishList(
                                                  widget.proList['productid']);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: Text(
                                          'Wishlist',
                                          style: TextStyle(
                                              color: Colors.green.shade800),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                              context, WishScreen.screenName);
                                        },
                                      ),
                                    ],
                                  );
                                })
                            : context.read<WishList>().addToWishList(
                                widget.proList['productname'],
                                widget.proList['price'].toDouble(),
                                1,
                                widget.proList['instock'].toDouble(),
                                widget.proList['productimages'],
                                widget.proList['productid'],
                                widget.proList['sid']);
                      },

                      /// instead of read, we would use watch to see some change happening.
                      icon: Icon(
                        context.watch<WishList>().getWishList.firstWhereOrNull(
                                    (product) =>
                                        product.documentId ==
                                        widget.proList['productid']) !=
                                null
                            ? Icons.favorite
                            : Icons.favorite_outline_outlined,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ],
                ),

                /// stock quantity fetched from firebase
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.proList['instock'] == 0
                          ? 'Item Sold'
                          : (widget.proList['instock'].toString()) +
                              (' pieces are in stock'),
                      style:
                          const TextStyle(color: Colors.blueGrey, fontSize: 16),
                    ),
                  ],
                ),
                const ProfileHeaderLabel(
                  headerLabel: '  Item Description  ',
                ),

                /// product desription fetched from firebase
                Text(
                  widget.proList['productdescription'].toString(),
                  // overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.5,
                  style: TextStyle(
                      color: Colors.blueGrey.shade800,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                const ProfileHeaderLabel(
                  headerLabel: '  Similar Items  ',
                ),

                /// data fecthed from firestore for the sake of similar items ///
                SizedBox(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _productsStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapShot) {
                      ///* This is useful during testing when firebase overrides
                      /// its date-rules. Then this happens. *///
                      if (snapShot.hasError) {
                        return const Text('Something Went Wrong..!');
                      }
                      if (snapShot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: MediaQuery.sizeOf(context).height * 5,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: MyConstants.buttonTextColor,
                            ),
                          ),
                        );
                      }

                      // One extra if check applied, when our filtered data is still not available on Database
                      if (snapShot.data!.docs.isEmpty) {
                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
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
                                'This Category\nis not Available Right Now.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: MyConstants.buttonTextColor,
                                    fontSize: 30),
                              ),
                            ),
                          ],
                        ));
                      }
                      // Requires learning how to take ListTile in ListView children Or GridView.builder//
                      return SingleChildScrollView(
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            itemCount: snapShot.data!.docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 4,
                                    mainAxisSpacing: 4),
                            itemBuilder: (context, index) {
                              return ProductModel(
                                products: snapShot.data!.docs[index],
                              );
                            }),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 70,
                )
              ].map((e) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
                  child: e,
                );
              }).toList(),
            ),
          ),
        ),
        bottomSheet: Container(
          alignment: Alignment.center,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// to take user from here to the store which sells this above item ///
                  IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return VisitStore(
                          supplierId: widget.proList['sid'].toString(),
                        );
                      }));
                    },
                    icon: const Icon(Icons.store_mall_directory_outlined),
                  ),

                  /// cart icon button to take user to their cart

                  Badge(
                    isLabelVisible:
                        context.watch<Cart>().getProductList.isNotEmpty
                            ? true
                            : false,
                    label: Text(
                        context.watch<Cart>().getProductList.length.toString()),
                    child: IconButton(
                      onPressed: () {
                        ///''' Because we are using push method from Navigator class
                        /// and want to optionally come back from CartScreen() .
                        /// That's why we are filling its backButton parameter.
                        /// For detail look into CartScreen() blueprint.
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CartScreen(
                            backButton: AppBarBackButton(),
                          );
                        }));
                      },
                      icon: const Icon(Icons.shopping_cart),
                    ),
                  ),
                ],
              ),

              /// ADD TO CART button here or if the item is out of stock notify me button here
              Expanded(
                child: FractionallySizedBox(
                  widthFactor: .8,
                  child: widget.proList['instock'] == 0
                      ? CupertinoButton(
                          padding: EdgeInsets.zero,
                          color: Colors.orangeAccent,
                          child: const Text('Notify me'),
                          onPressed: () {
                            // Todo: to have the user updated once the item is in stock
                          })
                      : YellowButton(
                          label: doesItemExistInCart != null
                              ? 'added to cart'
                              : 'ADD TO CART',

                          /// If the item is out of stock, press a button to notify me.
                          onPressed: () {
                            /// Applied the first check if the item is out of stock.
                            /// Then second chekc if the item is already added in cart list or not.
                            if (widget.proList['instock'] == 0) {
                              MyMessageHandler.showSnackBar(
                                  _scaffoldKey, 'This item is sold');
                            } else if (doesItemExistInCart != null) {
                              /// Below method worked later before that
                              /// used the above one, for checking.
                              MyMessageHandler.showSnackBar(_scaffoldKey,
                                  'Item is already added in cart.');
                            } else {
                              context.read<Cart>().addItem(
                                  widget.proList['productname'],
                                  widget.proList['price'].toDouble(),
                                  1,
                                  widget.proList['instock'].toDouble(),
                                  widget.proList['productimages'],
                                  widget.proList['productid'],
                                  widget.proList['sid']);
                            }

                            /// Before passing the values fetched from
                            /// firebase to CartProvider; we check if that
                            /// item is already added in that list or not.
                            /// So that it may not duplicate itself.

                            /// provider usage starts here.
                            /// would call Cart provider add item function here.
                            /// and pass those relatable parameters from here
                            /// directly fetched from the database and
                            /// being passed to the cart_provider.
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
