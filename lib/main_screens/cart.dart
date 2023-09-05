import 'package:chawla_trial_udemy/main_screens/customer_home.dart';
import 'package:chawla_trial_udemy/my_widgets/my_alert_dialog.dart';
import 'package:chawla_trial_udemy/providers/wish_list_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../minor_screens/place_order_screen.dart';
import '../my_widgets/appbar_widgets.dart';
import '../providers/cart_provider.dart';
import 'package:collection/collection.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key, this.backButton}) : super(key: key);
  static String screenName = '/cart_screen';

  /// is widget ko optional banake, isko appbar ke leading widget mein fix kiya
  /// kyonki CartScreeen pe backbutton ki appearance depend krti hai,ki hum uspe kaun se
  /// page se aayenge. agar direct homepage se aayenge,to humko backbutton ki need nahi rahegi
  /// aur agar profile page se aayenge, to wahan se yahan back and forth ki need rehegi. isliye is
  /// widget ko appbar ka widget na banake class ka widget declare kiya. aur jahan jahan cart page
  /// call hoga, humko agar cart page se vapis wahin jana hoga,to Navigator ka method bhi accordingly
  /// change hoga. like push, or pushReplacementNamed..
  /// aur jahan pe koi bhi push method call karenge, usse pehle pop method call kr lenge
  /// push ka back impact start hone se pehle hi kill krne ke liye. isse push to hoga, lekin fir pop nahi hoga.
  /// Thanks for your patience.
  final Widget? backButton;
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    // just becuase it listens to the changes, it needs initializing in buildcontext
    // otherwise it won't update the event handling results.
    late double totalAmount = context.watch<Cart>().totalPrice;
    return Scaffold(
      appBar: AppBar(
        leading: widget.backButton,
        centerTitle: true,
        title: const AppBarTitle(title: 'Cart'),
        actions: [
          context.watch<Cart>().getProductList.isEmpty
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    /// call custom AlertDialog in order to save
                    /// user accidentally delete cart items.
                    MyAlertDialog.myShowDialog(
                        context: context,
                        myTitle: 'Clear Cart',
                        myContent: 'Are you sure, you want to empty your cart?',
                        onTapYes: () {
                          /// called the clear list method from the cart_provider here.
                          /// We could not call cart.removeAllItems() here.
                          /// Because this code is being written above the Consumer
                          /// So would use context.read<Cart>().removeAllItems here.
                          /// or Provider.of<Cart>(context, listen:false).removeAllItems();
                          /// would do the same thing. for more, go to the official documentation of this
                          /// package.
                          context.read<Cart>().removeAllItems();
                          Navigator.pop(context);
                        },
                        noText: 'Clear',
                        onTapNo: () {
                          Navigator.pop(context);
                        });
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.black,
                  ))
        ],
      ),

      /// would start using Consumer of Cart type here. Watch carefully.
      /// with the if condition. If the list of items at cart_provider page is
      /// empty then something else would appear on screen otherwise the below Consumer type.
      body: SafeArea(
        child: Provider.of<Cart>(context).getProductList.isNotEmpty
            ? loadedCart()
            : const EmptyCart(),
      ),

      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text('Total ₹ '),
                Text(
                  /// called method from cart_provider
                  totalAmount.toStringAsFixed(1),
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                //  SizedBox(width: 10),
              ],
            ),

            /// CHECKOUT button wrapped in Container, for padding purpose only.
            Container(
              padding: EdgeInsets.zero,
              margin: const EdgeInsets.only(right: 10),
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(12),
                color: Colors.yellow,
                padding:
                    const EdgeInsets.only(left: 5, top: 4, right: 5, bottom: 4),
                onPressed: totalAmount == 0.0
                    ? null
                    : () {
                        print('checkout pressed');

                        Navigator.push(
                            context,
                            PageTransition(
                                duration: const Duration(seconds: 1),
                                child: const PlaceOrderScreen(),
                                type: PageTransitionType.bottomToTop));
                      },
                child: Text(
                  ' CHECKOUT ',
                  style: TextStyle(
                      color: Colors.brown.shade900,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'FontThree'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Consumer<Cart> loadedCart() {
    return Consumer<Cart>(
      builder: (BuildContext context, cart, Widget? child) {
        return ListView.builder(
          itemCount: cart.count,
          itemBuilder: (context, index) {
            final product = cart.getProductList[index];

            /// create a modal to return here. Carrying all the information and data
            /// of products/ items the user adds to his/her cart.
            return Padding(
              padding: const EdgeInsets.only(left: 6.0, top: 6, right: 6),
              child: Card(
                child: SizedBox(
                  height: 100,
                  //   width: double.infinity,
                  child: Row(
                    children: [
                      /// image of the selected item
                      SizedBox(
                        height: 100,
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imagesUrl.first,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // const SizedBox(width: 10),

                      /// other data in tree
                      /// Not supposed to wrap a Flexible or an Expanded to the Padding widget
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 6.0, right: 4, bottom: 3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// item name
                              Text(
                                product.name.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(fontSize: 20),
                              ),

                              /// Row inside the column
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ///item price from firebase to a fitted box
                                  /// to check whether it increases its size
                                  /// in ratio of the length of data or not
                                  FittedBox(
                                    child: Text(
                                      product.price.toStringAsFixed(2),
                                      style: TextStyle(
                                        color: Colors.green.shade800,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),

                                  /// desired quantity container
                                  Container(
                                    alignment: Alignment.topCenter,
                                    height: 45,
                                    // width: 100,
                                    decoration: BoxDecoration(
                                        //border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey.shade200),
                                    child: Row(
                                      children: [
                                        /// button to reduce the number of the same item from the cart.
                                        /// applied check  if there is only one quantity of that item remaining in the cart?
                                        product.qty == 1
                                            ? IconButton(
                                                onPressed: () {
                                                  showCupertinoModalPopup<void>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        CupertinoActionSheet(
                                                      title: const Text(
                                                        'Remove this item?',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      message: const Text(
                                                          '''Are you sure, you want to remove this item from the cart, or send it to your wishlist?''',
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 16,
                                                          )),
                                                      actions: <CupertinoActionSheetAction>[
                                                        /// for removing that item from the cart
                                                        CupertinoActionSheetAction(
                                                          /// Remove that single item from the list
                                                          onPressed: () {
                                                            cart.removeItem(
                                                                product);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            'Remove',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .red
                                                                    .shade600),
                                                          ),
                                                        ),

                                                        /// for sending that item to the wishlist///

                                                        /// What below function did is, before sending that item
                                                        /// straightaway to the WishList, it first checked if that item
                                                        /// is aleady added in WishList or not, if not, it added that item
                                                        /// to the WishList and remove from the Cart, if already in WishList
                                                        /// it simply remove that item from the Cart. In both conditions, it
                                                        /// is removing the item from the cart.
                                                        CupertinoActionSheetAction(
                                                          onPressed: () async {
                                                            context
                                                                        .read<
                                                                            WishList>()
                                                                        .getWishList
                                                                        .firstWhereOrNull((element) =>
                                                                            element.documentId ==
                                                                            product
                                                                                .documentId) !=
                                                                    null
                                                                ? context
                                                                    .read<
                                                                        Cart>()
                                                                    .removeItem(
                                                                        product)
                                                                : await context
                                                                    .read<
                                                                        WishList>()
                                                                    .addToWishList(
                                                                        product
                                                                            .name,
                                                                        product
                                                                            .price
                                                                            .toDouble(),
                                                                        1,
                                                                        product
                                                                            .qntty
                                                                            .toDouble(),
                                                                        product
                                                                            .imagesUrl,
                                                                        product
                                                                            .documentId,
                                                                        product
                                                                            .supplierId);
                                                            context
                                                                .read<Cart>()
                                                                .removeItem(
                                                                    product);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            'Send to Wishlist',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green
                                                                    .shade600),
                                                          ),
                                                        ),
                                                      ],

                                                      /// to cancel your choice
                                                      cancelButton: TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  size: 20,
                                                  color: Colors.red.shade600,
                                                ),
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  cart.reduceQuantity(product);
                                                },
                                                icon: const Icon(
                                                  FontAwesomeIcons.minusCircle,
                                                  size: 20,
                                                ),
                                              ),
                                        //   const SizedBox(width: 4),
                                        const SizedBox(width: 8),

                                        /// number of that particular items added in the cart.
                                        Text(
                                          product.qty.toStringAsFixed(0),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  product.qty == product.qntty
                                                      ? Colors.red
                                                      : Colors.green.shade600),
                                        ),
                                        const SizedBox(width: 8),

                                        /// button to enhance the number of the same item into the cart.
                                        IconButton(
                                          onPressed:
                                              product.qty == product.qntty
                                                  ? null
                                                  : () {
                                                      /// called that function from cart.provider
                                                      /// and passed the desired parameter,
                                                      cart.increaseQuantity(
                                                          product);
                                                    },
                                          icon: Icon(
                                              FontAwesomeIcons.circlePlus,
                                              size: 20,
                                              color:
                                                  product.qty != product.qntty
                                                      ? Colors.green.shade600
                                                      : Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text(
          'your Cart is Empty',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 50),
        Material(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(15),
          child: MaterialButton(
            onPressed: () {
              //to prompt customer to shop anything, only when the cart is empty.//
              Navigator.canPop(context)
                  ? Navigator.pop(context)
                  : Navigator.pushReplacementNamed(
                      context, CustomerHomeScreen.screenName);
            },
            minWidth: MediaQuery.of(context).size.width * .55,
            child: const Text(
              'Continue Shopping',
              style: TextStyle(color: Colors.white, fontSize: 19),
            ),
          ),
        ),
      ]),
    );
  }
}
