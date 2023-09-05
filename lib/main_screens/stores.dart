import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../minor_screens/visit_store.dart';
import '../my_widgets/appbar_widgets.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({Key? key}) : super(key: key);

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  late Stream<QuerySnapshot> _suppliers;
  @override
  void initState() {
    _suppliers = FirebaseFirestore.instance.collection('suppliers').snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const AppBarTitle(title: 'Stores'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _suppliers,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 25, crossAxisSpacing: 5, crossAxisCount: 2),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                /// on tapping sending users from stores to
                /// a page uploaded with the items only by that tapped store.
                /// so would pass the data from firebase to the next page.
                /// In this case it is snapshot.data!.docs[index].['sid'].

                return GestureDetector(
                  onTap: () {
                    //   Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return VisitStore(
                        supplierId:
                            snapshot.data!.docs[index]['sid'].toString(),
                      );
                    }));
                  },
                  child: Column(children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.orange,
                                strokeAlign: BorderSide.strokeAlignInside,
                                width: 1.3)),
                        width: 150,
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data!.docs[index]['storelogo']
                                .toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      snapshot.data!.docs[index]['storename'].toString(),
                      style: const TextStyle(
                          fontFamily: 'FontThree', fontSize: 18),
                    ),
                    const SizedBox(height: 6),
                  ]),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Text('Something Went Wrong...!');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Text('No Store onboarded yet..!');
          }
        },
      ),
    );
  }
}
