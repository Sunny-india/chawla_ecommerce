import 'package:chawla_trial_udemy/my_widgets/appbar_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';
import '../models/product_model.dart';

class ManageProducts extends StatefulWidget {
  const ManageProducts({Key? key}) : super(key: key);

  @override
  State<ManageProducts> createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  late Stream<QuerySnapshot> _manageProducts;
  @override
  void initState() {
    _manageProducts = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    // TODO: implement initState
    //TODo: what we need to do is create a function for suppliers to manage their uploaded
    //todo: products. We'll do that later. For the time being, we just used the ProductModel
    // todo: class here.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Manage Products'),
        leading: const AppBarBackButton(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _manageProducts,
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
                    'Please make a way\nThis page is arriving soon..!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: MyConstants.buttonTextColor, fontSize: 22),
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
