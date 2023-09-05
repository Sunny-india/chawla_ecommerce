// The Whole class is turned to stateful in order to use StreamBuilder
// The whole body property  is copied from men_gallery class.
// But with an extra  filtration over FirebaseFireStore, where we applied
// more than one conditions. Look Below.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';
import '../models/product_model.dart';
import '../my_widgets/appbar_widgets.dart';

class SubCategProducts extends StatefulWidget {
  final String mainCategName;
  final String subCategName;
  const SubCategProducts(
      {Key? key, required this.mainCategName, required this.subCategName})
      : super(key: key);

  @override
  State<SubCategProducts> createState() => _SubCategProductsState();
}

class _SubCategProductsState extends State<SubCategProducts> {
  // Why did it not happen here. See below.
  /*final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg', isEqualTo: widget.mainCategName)
      .where('subcateg', isEqualTo: widget.subCategName)
      .snapshots();*/
  @override
  Widget build(BuildContext context) {
    //initiated inside build method, because parent's class data can't
    // be initiated before override.
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('maincateg', isEqualTo: widget.mainCategName)
        .where('subcateg', isEqualTo: widget.subCategName)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        // made a model for this backbutton, coz it is going to be used at many places in
        // app.
        leading: AppBarBackButton(),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,

        // did the same as above for the title in an appbar too.
        title: AppBarTitle(title: widget.subCategName),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
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
                    'This Category\nis not Available Right Now.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: MyConstants.buttonTextColor,
                        fontSize: 30,
                        letterSpacing: 1.5),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4),
                itemBuilder: (context, index) {
                  return ProductModel(
                    products: snapShot.data!.docs[index],
                  );
                }),
          );

          // return ListView(
          //   children: snapShot.data!.docs.map((DocumentSnapshot document) {
          //     Map<String, dynamic> innerData =
          //         document.data()! as Map<String, dynamic>;
          //     return ListTile(
          //       contentPadding: const EdgeInsets.only(left: 8, top: 4, right: 8),
          //       leading: CachedNetworkImage(
          //         fit: BoxFit.cover,
          //         width: 80,
          //         height: 100,
          //         imageUrl: innerData['productimages'][0],
          //       ),
          //       title: Text(innerData['maincateg'].toString()),
          //       subtitle: Text(
          //         innerData['price'].toString(),
          //       ),
          //       trailing: Material(
          //         color: Colors.yellow,
          //         borderRadius: BorderRadius.circular(15),
          //         child: MaterialButton(
          //           child: const Text('Add to cart'),
          //           onPressed: () {},
          //         ),
          //       ),
          //     );
          //   }).toList(),
          // );
        },
      ),
    );
  }
}
